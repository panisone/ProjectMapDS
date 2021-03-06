//
//  OfflinePositionViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/22/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OfflinePositionViewController.h"
#import "OfflineTabBarStoreViewController.h"    //use Global variable: storeID, storeFloor

@interface OfflinePositionViewController ()

@end

@implementation OfflinePositionViewController
{
    NSString *titleRightButton;
    UIImage *image;
}
@synthesize scroll,floorImage;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Position Store";
    //self.navigationController.navigationBar.topItem.title = @"back";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:titleRightButton
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)];
    self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
    //[self.parentViewController.navigationItem setRightBarButtonItem:rightButton animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set Scroll view
    [scroll setDelegate:self];
    [scroll setMinimumZoomScale:1.0];
    [scroll setMaximumZoomScale:4.0];
    
    scroll.contentSize = floorImage.frame.size;
    
    //call method for Database
    [self initDatabase];
    [self showFloorPlan:storeFloor[0]];
    
    //set title Right Button
    titleRightButton = [NSString stringWithFormat:@"Floor: %@",storeFloor[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return floorImage;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)initDatabase
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    if (success) {
        return;
    }
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
}

-(void)getFloorPlan:(NSString *) floor
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT mapFloor FROM Floor,LinkFloorStore WHERE Floor.idFloor=LinkFloorStore.idFloor and LinkFloorStore.idStore=%@ and Floor.floor LIKE '%@'",storeID,floor] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                image = [UIImage imageNamed:@"No-icon.png"];
                if ((char*)sqlite3_column_text(searchStament, 0) != NULL)
                {
                    NSData *plan = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 0) length:sqlite3_column_bytes(searchStament, 0)];
                    
                    if ([plan length] != 0)
                    {
                        image = [UIImage imageWithData:plan];
                    }
                }
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

//method for Right Button
-(void)rightFuntion
{
    UIActionSheet *func = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
    for (NSString *title in storeFloor) {
        [func addButtonWithTitle:title];
    }
    func.cancelButtonIndex = [func addButtonWithTitle:@"Cancel"];
    
    if ([storeFloor count] != 1) {
        [func showInView:self.view];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [storeFloor count])
    {
        //change title of Right Button
        titleRightButton = [NSString stringWithFormat:@"Floor: %@",storeFloor[buttonIndex]];
        [self.parentViewController.navigationItem.rightBarButtonItem setTitle:titleRightButton];
        
        //remove Button of page before
        for (UIView *subview in [floorImage subviews])
        {
            if (subview.tag == 1) {
                [subview removeFromSuperview];
            }
        }
        
        [self showFloorPlan:storeFloor[buttonIndex]];
        /*
        //change image
        [self getFloorPlan:storeFloor[buttonIndex]];
        floorImage.image = image;
        
        //call method create Button connect to Store
        [self createPoint:storeFloor[buttonIndex]];
         */
    }
}

//call mathod for SHOW FloorPlan
-(void)showFloorPlan:(NSString *) floor
{
    [scroll setMinimumZoomScale:1.0];
    scroll.zoomScale = 1.0;
    
    //call method for Database
    [self getFloorPlan:floor];
    
    //set image to Show
    floorImage.image = image;
    
    //create Button on FloorPlan
    [self createPoint:floor];
    
    //set Scroll zoom Scale
    float min = 1.0;
    float scaleW = self.view.frame.size.width/floorImage.frame.size.width;
    float scaleH = (self.view.frame.size.height-64-49)/floorImage.frame.size.height;
    if (MIN(scaleW, scaleH) > 1)
    {
        min = MIN(scaleW, scaleH);
    }
    [scroll setMinimumZoomScale:min];
    scroll.zoomScale = min;
}

//create SUBVIEW for SHOW
-(void)createPoint:(NSString *) floor
{
    sqlite3 *db;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &db) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT Store.idStore,Store.logoStore,LinkFloorStore.pointX,LinkFloorStore.pointY,LinkFloorStore.width,LinkFloorStore.height FROM Floor,LinkFloorStore,Store WHERE Floor.idFloor=LinkFloorStore.idFloor and LinkFloorStore.idStore=Store.idStore and Store.idStore=%@ and Floor.floor LIKE '%@'",storeID,floor] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(db, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                /*
                 NSString *idStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                 
                 UIImage *imageButton = [UIImage imageNamed:@"Logo.png"];
                 if ((char*)sqlite3_column_text(searchStament, 1) != NULL)
                 {
                 NSData *dataImage = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 1) length:sqlite3_column_bytes(searchStament, 1)];
                 
                 if ([dataImage length] != 0)
                 {
                 imageButton = [UIImage imageWithData:dataImage];
                 }
                 }
                 */
                NSString *pointX = @"-";
                if ((char*)sqlite3_column_text(searchStament, 2) != NULL) {
                    pointX = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 2)];
                    if ([pointX isEqual: @""]) {
                        pointX = @"-";
                    }
                }
                NSString *pointY = @"-";
                if ((char*)sqlite3_column_text(searchStament, 3) != NULL) {
                    pointY = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 3)];
                    if ([pointY isEqual: @""]) {
                        pointY = @"-";
                    }
                }
                
                NSString *width = @"-";
                if ((char*)sqlite3_column_text(searchStament, 4) != NULL) {
                    width = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 4)];
                    if ([width isEqual: @""]) {
                        width = @"-";
                    }
                }
                NSString *height = @"-";
                if ((char*)sqlite3_column_text(searchStament, 5) != NULL) {
                    height = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 5)];
                    if ([height isEqual: @""]) {
                        height = @"-";
                    }
                }
                
                if (![pointX isEqual:@"-"] && ![pointY isEqual:@"-"])
                {
                    /* //set X & Y & SizeIcon
                    int sizeIcon = MAX([width intValue], [height intValue]);
                    int x = [pointX intValue]+([width intValue]/2)-(sizeIcon/2);
                    int y = [pointY intValue]-(sizeIcon/2);
                    if (x>320-sizeIcon && y<0) {
                        y = [pointY intValue];
                        sizeIcon = MIN([width intValue], [height intValue]);
                    }
                    else if (x>320-sizeIcon) {
                        sizeIcon = [width intValue];
                    }
                    else if (y<0) {
                        y = [pointY intValue];
                        sizeIcon = [height intValue];
                    }
                    
                    CGRect imageFrame = CGRectMake(x, y, sizeIcon, sizeIcon);
                    */
                    float frameX;
                    float frameY;
                    float diffX = 0;
                    float diffY = 0;
                    
                    if (floorImage.frame.size.height > image.size.height*floorImage.frame.size.width/image.size.width)
                    {
                        frameX = floorImage.frame.size.width;
                        frameY = floorImage.frame.size.width*image.size.height/image.size.width;
                        diffY = (floorImage.frame.size.height-frameY)/2;
                    }
                    else
                    {
                        frameX = floorImage.frame.size.height*image.size.width/image.size.height;
                        frameY = floorImage.frame.size.height;
                        diffX = (floorImage.frame.size.width-frameX)/2;
                    }
                    
                    float pX = ([pointX floatValue]*frameX)+diffX;
                    float pY = ([pointY floatValue]*frameY)+diffY;
                    float bWidth = [width floatValue]*frameX;
                    float bHeight = [height floatValue]*frameY;
                    
                    CGRect imageFrame = CGRectMake(pX, pY, bWidth, bHeight);
                    
                    UIImage *imagePoint = [UIImage imageNamed:@"Point3-icon.png"];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:imagePoint];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    imageView.frame = imageFrame;
                    
                    //set TAG is "1"
                    imageView.tag = 1;
                    
                    [floorImage addSubview:imageView];
                }
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(db);
}

@end

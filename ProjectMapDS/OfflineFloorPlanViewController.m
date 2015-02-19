//
//  OfflineFloorPlanViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/9/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OfflineFloorPlanViewController.h"
#import "OfflineTabBarDSViewController.h"       //use Global variable: dataID, dataFloor

@interface OfflineFloorPlanViewController ()

@end

@implementation OfflineFloorPlanViewController
{
    NSString *titleRightButton;
    UIImage *image;
}
@synthesize scroll,floorImage;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Map DS";
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
    //call method for Database
    [self initDatabase];
    [self showFloorPlan:dataFloor[0]];
    //set title Right Button
    titleRightButton = [NSString stringWithFormat:@"Floor: %@",dataFloor[0]];
    //set Scroll view
    [scroll setDelegate:self];
    [scroll setMinimumZoomScale:1.0];
    [scroll setMaximumZoomScale:4.0];
    
    scroll.userInteractionEnabled = YES;        //Solution Problem zoom image with button
    scroll.exclusiveTouch = YES;                //Solution Problem zoom image with button
    
    [floorImage setUserInteractionEnabled:YES]; //Solution Problem zoom image with button
    [floorImage setExclusiveTouch:YES];         //Solution Problem zoom image with button
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
        const char *sql = [[NSString stringWithFormat:@"SELECT mapFloor FROM Floor WHERE idDS=%@ and floor LIKE '%@'",dataID,floor] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                image = [UIImage imageNamed:@"Info-icon.png"];
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
    for (NSString *title in dataFloor) {
        [func addButtonWithTitle:title];
    }
    func.cancelButtonIndex = [func addButtonWithTitle:@"Cancel"];
    [func showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [dataFloor count])
    {
        NSLog(@"count:%lu buttonIndex:%lu",(unsigned long)[dataFloor count],(unsigned long)buttonIndex);
        //change title of Right Button
        titleRightButton = [NSString stringWithFormat:@"Floor: %@",dataFloor[buttonIndex]];
        [self.parentViewController.navigationItem.rightBarButtonItem setTitle:titleRightButton];
        
        //remove Button of page before
        for (UIView *subview in [floorImage subviews])
        {
            if (subview.tag == 1) {
                [subview removeFromSuperview];
            }
        }
        
        [self showFloorPlan:dataFloor[buttonIndex]];
        /*
        //change image
        [self getFloorPlan:dataFloor[buttonIndex]];
        floorImage.image = image;
        
        //call method create Button connect to Store
        [self createButton:dataFloor[buttonIndex]];
         */
    }
}

//call mathod for SHOW FloorPlan
-(void)showFloorPlan:(NSString *) floor
{
    //call method for Database
    [self getFloorPlan:floor];
    //set image to Show
    floorImage.image = image;
    //create Button on FloorPlan
    [self createButton:floor];
}

//create SUBVIEW for SHOW
-(void)createButton:(NSString *) floor
{
    sqlite3 *db;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &db) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT Store.idStore,Store.logoStore,LinkFloorStore.pointX,LinkFloorStore.pointY,LinkFloorStore.width,LinkFloorStore.height FROM Floor,LinkFloorStore,Store WHERE Floor.idDS=%@ and Floor.idFloor=LinkFloorStore.idFloor and LinkFloorStore.idStore=Store.idStore and Floor.floor LIKE '%@'",dataID,floor] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(db, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, floorImage.frame.size.width, floorImage.frame.size.height)];
            //newView.backgroundColor = [UIColor redColor];
            newView.tag = 1;
            
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
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
                
                //NSLog(@"id:%@ x:%@ y:%@ w:%@ h:%@",idStore,pointX,pointY,width,height);
                
                if (![pointX isEqual:@"-"] && ![pointY isEqual:@"-"]) {
                    CGRect buttonFrame = CGRectMake([pointX intValue], [pointY intValue], [height intValue]*imageButton.size.width/imageButton.size.height, [height intValue]);
                    
                    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
                    
                    //set TAG is storeID
                    button.tag = [idStore intValue];
                    
                    //test
                    [button setTitle:idStore forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    
                    [button setBackgroundImage:imageButton forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(storeView:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [newView addSubview:button];
                }
            }
            //[self.view addSubview:newView];
            [floorImage addSubview:newView];
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(db);
}

-(void)storeView:(UIButton *) sender
{
    //NSLog(@"id: %ld",(long)sender.tag);
    OfflineTabBarStoreViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineTabBarStoreViewController"];
    storeID = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self.navigationController pushViewController:destView animated:YES];
}

@end

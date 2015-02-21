//
//  FavoriteDetailViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/15/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "FavoriteDetailViewController.h"
#import "FavoriteTabBarViewController.h"    //use Global variable: storeID, storeFloor

@interface FavoriteDetailViewController ()

@end

@implementation FavoriteDetailViewController
{
    NSString *name;
    NSString *branch;
    NSString *detail;
    UIImage *image;
    
    NSString *favorite;
}
@synthesize nameLabel,branchLabel,logoImage,detailTextView;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Detail Store";
    //self.navigationController.navigationBar.topItem.title = @"back";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:favorite]
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)];
    //set Color of Right Button
    if ([favorite isEqual:@"RemoveStar-icon.png"]) {
        rightButton.tintColor = [UIColor colorWithRed:(255/255.0) green:(72/255.0) blue:(118/255.0) alpha:1.0]; //#FF4876
    }
    else if ([favorite isEqual:@"AddStar-icon.png"]) {
        rightButton.tintColor = [UIColor colorWithRed:(48/255.0) green:(131/255.0) blue:(251/255.0) alpha:1.0]; //#3083FB
    }
    self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //call method for Database
    [self initDatabase];
    [self getDetailStore];
    [self getFavorite];
    //set text to Show
    nameLabel.text = name;
    branchLabel.text = [@"สาขา " stringByAppendingString:branch];
    logoImage.image = image;
    detailTextView.text = detail;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)getDetailStore
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT * FROM Store WHERE idStore=%@",storeID] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 1)];
                
                branch = @"-";
                if ((char*)sqlite3_column_text(searchStament, 2) != NULL) {
                    branch = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 2)];
                    if ([branch  isEqual: @""]) {
                        branch = @"-";
                    }
                }
                
                image = [UIImage imageNamed:@"Info-icon.png"];
                if ((char*)sqlite3_column_text(searchStament, 12) != NULL)
                {
                    NSData *logo = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 12) length:sqlite3_column_bytes(searchStament, 12)];
                    if ([logo length] != 0)
                    {
                        image = [UIImage imageWithData:logo];
                    }
                }
                
                detail = @"";
                NSString *category = @"-";
                if ((char*)sqlite3_column_text(searchStament, 4) != NULL) {
                    category = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 4)];
                    if ([category  isEqual: @""]) {
                        category = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"ประเภทของร้าน: \n"];
                detail = [detail stringByAppendingString:category];
                detail = [detail stringByAppendingString:@"\n\n"];
                
                detail = [detail stringByAppendingString:@"ตำแหน่งที่ตั้งร้าน: \n"];
                detail = [detail stringByAppendingString:[self getStringAddressNumber]];
                detail = [detail stringByAppendingString:@"\n\n"];
                
                NSString *openTime = @"-";
                if ((char*)sqlite3_column_text(searchStament, 5) != NULL) {
                    openTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 5)];
                    if ([openTime  isEqual: @""]) {
                        openTime = @"-";
                    }
                }
                NSString *closeTime = @"-";
                if ((char*)sqlite3_column_text(searchStament, 6) != NULL) {
                    closeTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 6)];
                    if ([closeTime  isEqual: @""]) {
                        closeTime = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"เวลาบริการ: \n"];
                if ([openTime  isEqual:@"-"] || [closeTime isEqual:@"-"])
                {
                    detail = [detail stringByAppendingString:@"-"];
                }
                else
                {
                    openTime = [openTime stringByAppendingString:@" - "];
                    openTime = [openTime stringByAppendingString:closeTime];
                    detail = [detail stringByAppendingString:openTime];
                }
                detail = [detail stringByAppendingString:@"\n\n"];
                
                NSString *tel = @"-";
                if ((char*)sqlite3_column_text(searchStament, 7) != NULL) {
                    tel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 7)];
                    if ([tel  isEqual: @""]) {
                        tel = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"Tel: \n"];
                detail = [detail stringByAppendingString:tel];
                detail = [detail stringByAppendingString:@"\n\n"];
                
                NSString *fax = @"-";
                if ((char*)sqlite3_column_text(searchStament, 8) != NULL) {
                    fax = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 8)];
                    if ([fax  isEqual: @""]) {
                        fax = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"Fax: \n"];
                detail = [detail stringByAppendingString:fax];
                detail = [detail stringByAppendingString:@"\n\n"];
                
                NSString *email = @"-";
                if ((char*)sqlite3_column_text(searchStament, 9) != NULL) {
                    email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 9)];
                    if ([email  isEqual: @""]) {
                        email = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"E-Mail: \n"];
                detail = [detail stringByAppendingString:email];
                detail = [detail stringByAppendingString:@"\n\n"];
                
                NSString *web = @"-";
                if ((char*)sqlite3_column_text(searchStament, 10) != NULL) {
                    web = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 10)];
                    if ([web  isEqual: @""]) {
                        web = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"E-Mail: \n"];
                detail = [detail stringByAppendingString:web];
                detail = [detail stringByAppendingString:@"\n\n"];
                
                NSString *detailStore = @"-";
                if ((char*)sqlite3_column_text(searchStament, 11) != NULL) {
                    detailStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 11)];
                    if ([detailStore  isEqual: @""]) {
                        detailStore = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"รายละเอียดร้าน: \n"];
                detail = [detail stringByAppendingString:detailStore];
                //detail = [detail stringByAppendingString:@"\n\n"];
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

-(void)getFavorite
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    favorite = @"AddStar-icon.png";
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT * FROM Favorite WHERE idStore=%@",storeID] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *idStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                
                if (idStore != nil) {
                    favorite = @"RemoveStar-icon.png";
                    //NSLog(@"store FAVORITE");
                }
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

-(void)addFavorite
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"INSERT INTO Favorite VALUES ('%@',CURRENT_TIMESTAMP)",storeID] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(searchStament) == SQLITE_DONE) {
                favorite = @"RemoveStar-icon.png";
                [self.parentViewController.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:favorite]];
                self.parentViewController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:(255/255.0) green:(72/255.0) blue:(118/255.0) alpha:1.0]; //#FF4876
                //NSLog(@"insert success");
            }/*
              else
              NSLog(@"insert NOT success");*/
        }
        
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

-(void)removeFavorite
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"DELETE FROM Favorite WHERE idStore=%@",storeID] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(searchStament) == SQLITE_DONE) {
                favorite = @"AddStar-icon.png";
                [self.parentViewController.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:favorite]];
                self.parentViewController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:(48/255.0) green:(131/255.0) blue:(251/255.0) alpha:1.0]; //#3083FB
                //NSLog(@"remove success");
            }
        }
        
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

-(NSString *)getStringAddressNumber
{
    sqlite3 *db;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    NSString *strFloor = @"";
    
    if (sqlite3_open([path UTF8String], &db) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT Floor.floor,LinkFloorStore.addressNumber FROM Floor,LinkFloorStore WHERE Floor.idFloor=LinkFloorStore.idFloor and LinkFloorStore.idStore=%@",storeID] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(db, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *nameFloor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                nameFloor = [@"ชั้น " stringByAppendingString:nameFloor];
                
                NSString *addNumber = @"";
                if ((char*)sqlite3_column_text(searchStament, 1) != NULL) {
                    addNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 1)];
                    if (![addNumber  isEqual: @""]) {
                        addNumber = [@"\tห้อง " stringByAppendingString:addNumber];
                    }
                }
                
                if ([strFloor isEqual:@""])
                {
                    strFloor = [strFloor stringByAppendingString:nameFloor];
                    strFloor = [strFloor stringByAppendingString:addNumber];
                }
                else
                {
                    strFloor = [strFloor stringByAppendingString:@"\n"];
                    strFloor = [strFloor stringByAppendingString:nameFloor];
                    strFloor = [strFloor stringByAppendingString:addNumber];
                }
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(db);
    
    return strFloor;
}

//method for Right Button
-(void)rightFuntion
{
    UIActionSheet *func = [[UIActionSheet alloc]
                           initWithTitle:@"Make Favorite?"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:@"Yes"
                           otherButtonTitles:nil];
    [func showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ([favorite isEqual:@"AddStar-icon.png"])
        {
            [self addFavorite];
            [self getFavorite];
        }
        else if ([favorite isEqual:@"RemoveStar-icon.png"])
        {
            [self removeFavorite];
            [self getFavorite];
        }
    }
}

@end

//
//  OfflineDetailDSViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/7/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OfflineDetailDSViewController.h"
#import "OfflineTabBarDSViewController.h"   //use Global variable: dataID, dataFloor

@interface OfflineDetailDSViewController ()

@end

@implementation OfflineDetailDSViewController
{
    NSString *name;
    NSString *branch;
    NSString *detail;
    NSString *floor;
    UIImage *image;
    
    // DELETE
    NSString *str_idDS;
    NSMutableArray *arrIDFloor;
    NSMutableArray *arrIDStore;
}
@synthesize nameLabel,branchLabel,logoImage,detailTextView;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Detail DS";
    self.parentViewController.navigationController.navigationBar.topItem.title = @"";
    
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"DELETE"
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)]; */
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"Remove-icon.png"]
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)];
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                    target:self action:@selector(rightFuntion)]; */
    rightButton.tintColor = [UIColor colorWithRed:(255/255.0) green:(72/255.0) blue:(118/255.0) alpha:1.0]; //#FF4876
    self.parentViewController.navigationItem.rightBarButtonItems = nil;
    self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //call method for Database
    [self initDatabase];
    [self getDetailDS];
    [self getFloorDS];
    //set text to Show
    nameLabel.text = name;
    branchLabel.text = [@"สาขา " stringByAppendingString:branch];
    logoImage.image = image;
    detailTextView.text = [detail stringByAppendingString:floor];
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

-(void)getDetailDS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT * FROM DepartmentStore WHERE idDS=%@",dataID] cStringUsingEncoding:NSUTF8StringEncoding];
        
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
                if ((char*)sqlite3_column_text(searchStament, 7) != NULL)
                {
                    NSData *logo = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 7) length:sqlite3_column_bytes(searchStament, 7)];
                    if ([logo length] != 0)
                    {
                        image = [UIImage imageWithData:logo];
                    }
                }
                
                detail = @"";
                NSString *address = @"-";
                if ((char*)sqlite3_column_text(searchStament, 3) != NULL) {
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 3)];
                    if ([address  isEqual: @""]) {
                        address = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"สถานที่ตั้ง: \n"];
                detail = [detail stringByAppendingString:address];
                detail = [detail stringByAppendingString:@"\n\n"];
                
                NSString *openTime = @"-";
                if ((char*)sqlite3_column_text(searchStament, 4) != NULL) {
                    openTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 4)];
                    if ([openTime  isEqual: @""]) {
                        openTime = @"-";
                    }
                }
                NSString *closeTime = @"-";
                if ((char*)sqlite3_column_text(searchStament, 5) != NULL) {
                    closeTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 5)];
                    if ([closeTime  isEqual: @""]) {
                        closeTime = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"เวลาทำการ: \n"];
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
                
                //NSLog(@"detail: %@",detail);
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

-(void)getFloorDS
{
    floor = @"";
    
    for (NSString *nameFloor in dataFloor)
    {
        if ([floor isEqual:@""])
        {
            floor = [floor stringByAppendingString:nameFloor];
        }
        else
        {
            floor = [floor stringByAppendingString:@", "];
            floor = [floor stringByAppendingString:nameFloor];
        }
    }
    
    if ([floor isEqual:@""])
    {
        floor = [@"ชั้น: \n" stringByAppendingString:@"-"];
    }
    else
    {
        floor = [@"ชั้น: \n" stringByAppendingString:floor];
    }
}

//
//
// DELETE
//
//
-(void)deleteData:(NSString *)idDS
{
    [self initDatabase];
    
    str_idDS = idDS;
    
    //
    //
    // DELETE SQLite
    arrIDFloor = [[NSMutableArray alloc] init];
    [self selectTableFloor:str_idDS];
    [self deleteTableDepartmentStore:str_idDS];
    [self deleteTableImageDS:str_idDS];
    [self deleteTableFloor:str_idDS];
    for (NSString *idFloor in arrIDFloor)
    {
        arrIDStore = [[NSMutableArray alloc] init];
        [self selectTableLinkFloorStore:idFloor];
        [self deleteTableLinkFloorStore:idFloor];
        for (NSString *idStore in arrIDStore)
        {
            [self deleteTableStore:idStore];
            [self deleteTableImageStore:idStore];
            [self deleteTableFavorite:idStore];
        }
    }
}

//
//
// SQLite
//
//
// GET Floor
-(void)selectTableFloor:(NSString *)idDS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    //NSLog(@"start arrIDFloor %lu",(unsigned long)[arrIDFloor count]);
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT idFloor FROM Floor WHERE idDS=%@",idDS] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *idFloor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                
                //NSLog(@"select-Floor => idFloor:%@",idFloor);
                
                [arrIDFloor addObject:idFloor];
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// GET LinkFloorStore
-(void)selectTableLinkFloorStore:(NSString *)idFloor
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    //NSLog(@"start arrIDStore %lu",(unsigned long)[arrIDStore count]);
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT idStore FROM LinkFloorStore WHERE idFloor=%@",idFloor] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *idStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                
                //NSLog(@"select-LinkFloorStore => idStore:%@",idStore);
                
                [arrIDStore addObject:idStore];
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
//
//
// DELETE DepartmentStore
-(void)deleteTableDepartmentStore:(NSString *)idDS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"DELETE FROM DepartmentStore WHERE idDS=%@",idDS] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             //NSLog(@"delete-DepartmentStore success");
             }
             else {
             //NSLog(@"delete-DepartmentStore NOT success");
             }*/
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// DELETE ImageDS
-(void)deleteTableImageDS:(NSString *)idDS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"DELETE FROM ImageDS WHERE idDS=%@",idDS] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             //NSLog(@"delete-ImageDS success");
             }
             else {
             //NSLog(@"delete-ImageDS NOT success");
             }*/
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// DELETE Floor
-(void)deleteTableFloor:(NSString *)idDS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"DELETE FROM Floor WHERE idDS=%@",idDS] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             //NSLog(@"delete-Floor success");
             }
             else {
             //NSLog(@"delete-Floor NOT success");
             }*/
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// DELETE LinkFloorStore
-(void)deleteTableLinkFloorStore:(NSString *)idFloor
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"DELETE FROM LinkFloorStore WHERE idFloor=%@",idFloor] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             //NSLog(@"delete-LinkFloorStore success");
             }
             else {
             //NSLog(@"delete-LinkFloorStore NOT success");
             }*/
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// DELETE Store
-(void)deleteTableStore:(NSString *)idStore
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"DELETE FROM Store WHERE idStore=%@",idStore] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             //NSLog(@"delete-Store success");
             }
             else {
             //NSLog(@"delete-Store NOT success");
             }*/
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// DELETE ImageStore
-(void)deleteTableImageStore:(NSString *)idStore
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"DELETE FROM ImageStore WHERE idStore=%@",idStore] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             //NSLog(@"delete-ImageStore success");
             }
             else {
             //NSLog(@"delete-ImageStore NOT success");
             }*/
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// DELETE Favorite
-(void)deleteTableFavorite:(NSString *)idStore
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"DELETE FROM Favorite WHERE idStore=%@",idStore] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             //NSLog(@"delete-Favorite success");
             }
             else {
             //NSLog(@"delete-Favorite NOT success");
             }*/
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

//method for Right Button
-(void)rightFuntion
{
    UIAlertView *alv = [[UIAlertView alloc]
                        initWithTitle:@"Delete Content"
                        message:@"\nDo you want to delete this content?"
                        delegate:self
                        cancelButtonTitle: @"Cencal"
                        otherButtonTitles: @"OK", nil];
    [alv show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIAlertView *alv = [[UIAlertView alloc]
                            initWithTitle:@""
                            message:@"Waiting"
                            delegate:self
                            cancelButtonTitle: nil
                            otherButtonTitles: nil];
        [alv show];
        [self performSelector:@selector(waitProcess:) withObject:alv afterDelay:1];
    }
}

-(void)waitProcess:(UIAlertView *)alv
{
    [self deleteData:dataID];
    
    [alv dismissWithClickedButtonIndex:-1 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

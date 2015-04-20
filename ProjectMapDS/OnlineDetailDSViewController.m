//
//  OnlineDetailDSViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineDetailDSViewController.h"
#import "OnlineTabBarDSViewController.h"   //use Global variable: dataID, dataFloor

@interface OnlineDetailDSViewController ()

@end

@implementation OnlineDetailDSViewController
{
    NSString *name;
    NSString *branch;
    NSString *detail;
    NSString *floor;
    UIImage *image;
    
    NSString *check;
    
    // CHECK-DOWNLOAD-UPDATE
    NSString *str_idDS;
    NSMutableArray *arrIDFloor;
    NSMutableArray *arrIDStore;
    
    NSMutableArray *arrDepartmentStore;
    NSMutableArray *arrImageDS;
    NSMutableArray *arrFloor;
    NSMutableArray *arrLinkFloorStore;
    NSMutableArray *arrStore;
    NSMutableArray *arrImageStore;
    
    NSMutableArray *arrCheck;
}
@synthesize nameLabel,branchLabel,logoImage,detailTextView;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Detail DS";
    //self.navigationController.navigationBar.topItem.title = @"back";
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:check
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)]; */
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"Download-icon.png"]
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)];
    rightButton.tintColor = [UIColor colorWithRed:(255/255.0) green:(72/255.0) blue:(118/255.0) alpha:1.0]; //#FF4876
    self.parentViewController.navigationItem.rightBarButtonItems = nil;
    self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
    if ([check isEqual:@"NONE"])
    {
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
    }
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //call method for Database
    [self getDetailDS];
    [self getFloorDS];
    //set text to Show
    nameLabel.text = name;
    branchLabel.text = [@"สาขา " stringByAppendingString:branch];
    logoImage.image = image;
    detailTextView.text = [detail stringByAppendingString:floor];
    
    // CHECK-DOWNLOAD-UPDATE
    check = [self checkData:dataID];
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

-(void)getDetailDS
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getDSDetail.php?idDS=%@",dataID];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getDSDetail.php?idDS=%@",dataID];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *nameDS_data = [dataDict objectForKey:@"nameDS"];
        name = nameDS_data;
        
        NSString *branchDS_data = [dataDict objectForKey:@"branchDS"];
        if ([branchDS_data length] == 0) {
            branchDS_data = @"-";
        }
        branch = [NSString stringWithFormat:@"%@",branchDS_data];
        
        NSString *addressDS_data = [dataDict objectForKey:@"addressDS"];
        if ([addressDS_data  isEqual: @""]) {
            addressDS_data = @"-";
        }
        detail = [NSString stringWithFormat:@"สถานที่ตั้ง: \n%@\n\n",addressDS_data];
        
        NSString *openTimeDS_data = [dataDict objectForKey:@"openTimeDS"];
        if ([openTimeDS_data  isEqual: @""]) {
            openTimeDS_data = @"-";
        }
        NSString *closeTimeDS_data = [dataDict objectForKey:@"closeTimeDS"];
        if ([closeTimeDS_data  isEqual: @""]) {
            closeTimeDS_data = @"-";
        }
        detail = [detail stringByAppendingString:@"เวลาทำการ: \n"];
        if ([openTimeDS_data  isEqual:@"-"] || [closeTimeDS_data isEqual:@"-"])
        {
            detail = [detail stringByAppendingString:@"-"];
        }
        else
        {
            detail = [NSString stringWithFormat:@"%@%@ - %@",detail,openTimeDS_data,closeTimeDS_data];
        }
        detail = [detail stringByAppendingString:@"\n\n"];
        
        NSString *logoDS_data = [dataDict objectForKey:@"logoDS"];
        image = [UIImage imageNamed:@"Info-icon.png"];
        if ([logoDS_data length] != 0) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:logoDS_data options:0];
            image = [UIImage imageWithData:imageData];
        }
    }
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
// INIT_Database
//
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

//
//
// CHECK
//
//
-(NSString *)checkData:(NSString *)idDS
{
    NSString *str_return = @"";
    
    str_idDS = idDS;
    
    arrDepartmentStore = [[NSMutableArray alloc] init];
    arrCheck = [[NSMutableArray alloc] init];
    
    [self initDatabase];
    
    [self selectTableDepartmentStore:str_idDS];
    if ([arrCheck count] == 0)
    {
        str_return = @"DOWNLOAD";
    }
    else
    {
        [self getTableDepartmentStore:str_idDS];
        
        NSString *dateSQLite = [arrCheck objectAtIndex:0];
        
        [arrCheck addObject:[[arrDepartmentStore objectAtIndex:0] objectAtIndex:8]];
        [arrCheck sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        if (![dateSQLite isEqualToString:[arrCheck objectAtIndex:1]])
        {
            str_return = @"UPDATE";
        }
        else
        {
            str_return = @"NONE";
        }
    }
    
    return str_return;
}

//
//
// DOWNLOAD
//
//
-(void)downloadData:(NSString *)idDS
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
    
    
    //
    //
    // GET SQL Server
    arrDepartmentStore = [[NSMutableArray alloc] init];
    arrImageDS = [[NSMutableArray alloc] init];
    arrFloor = [[NSMutableArray alloc] init];
    arrLinkFloorStore = [[NSMutableArray alloc] init];
    arrStore = [[NSMutableArray alloc] init];
    arrImageStore = [[NSMutableArray alloc] init];
    
    [self getTableDepartmentStore:str_idDS];
    [self getTableImageDS:str_idDS];
    arrIDFloor = [[NSMutableArray alloc] init];
    [self getTableFloor:str_idDS];
    for (NSString *idFloor in arrIDFloor)
    {
        arrIDStore = [[NSMutableArray alloc] init];
        [self getTableLinkFloorStore:idFloor];
        for (NSString *idStore in arrIDStore)
        {
            [self getTableStore:idStore];
            [self getTableImageStore:idStore];
        }
    }
    
    
    //
    //
    // INSERT SQLite
    for (NSMutableArray *arr in arrDepartmentStore)
    {
        [self insertTableDepartmentStore:arr];
    }
    for (NSMutableArray *arr in arrImageDS)
    {
        [self insertTableImageDS:arr];
    }
    for (NSMutableArray *arr in arrFloor)
    {
        [self insertTableFloor:arr];
    }
    for (NSMutableArray *arr in arrLinkFloorStore)
    {
        [self insertTableLinkFloorStore:arr];
    }
    for (NSMutableArray *arr in arrStore)
    {
        [self insertTableStore:arr];
    }
    for (NSMutableArray *arr in arrImageStore)
    {
        [self insertTableImageStore:arr];
    }
}

//
//
// SQLite
//
//
// GET DepartmentStore
-(void)selectTableDepartmentStore:(NSString *)idDS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    //NSLog(@"start arrCheck %lu",(unsigned long)[arrCheck count]);
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT latestUpdate FROM DepartmentStore WHERE idDS=%@",idDS] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *latestUpdate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                
                //NSLog(@"select-CHECK => latestUpdate:%@",latestUpdate);
                
                [arrCheck addObject:latestUpdate];
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
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
//
//
// INSERT DepartmentStore
-(void)insertTableDepartmentStore:(NSMutableArray *)arr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "INSERT INTO DepartmentStore VALUES (?,?,?,?,?,?,?,?,?)";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            NSString *str1 = [arr objectAtIndex:0];
            NSString *str2 = [arr objectAtIndex:1];
            NSString *str3 = [arr objectAtIndex:2];
            NSString *str4 = [arr objectAtIndex:3];
            NSString *str5 = [arr objectAtIndex:4];
            NSString *str6 = [arr objectAtIndex:5];
            NSString *str7 = [arr objectAtIndex:6];
            NSData *str8 = [arr objectAtIndex:7];
            NSString *str9 = [arr objectAtIndex:8];
            
            //sqlite3_bind_int(searchStament, 1, [str1 intValue]);
            sqlite3_bind_text(searchStament, 1, [str1 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 2, [str2 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 3, [str3 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 4, [str4 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 5, [str5 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 6, [str6 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 7, [str7 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            if ([str8 length] == 0) {
                sqlite3_bind_text(searchStament, 8, "", -1, SQLITE_TRANSIENT);
            }
            else {
                sqlite3_bind_blob(searchStament, 8, [str8 bytes], (int)[str8 length], SQLITE_TRANSIENT);
            }
            sqlite3_bind_text(searchStament, 9, [str9 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             NSLog(@"insert success");
             }
             else {
             NSLog(@"insert NOT success");
             }
             */
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// INSERT ImageDS
-(void)insertTableImageDS:(NSMutableArray *)arr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "INSERT INTO ImageDS VALUES (?,?,?)";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            NSString *str1 = [arr objectAtIndex:0];
            NSString *str2 = [arr objectAtIndex:1];
            NSData *str3 = [arr objectAtIndex:2];
            
            sqlite3_bind_text(searchStament, 1, [str1 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 2, [str2 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            if ([str3 length] == 0) {
                sqlite3_bind_text(searchStament, 3, "", -1, SQLITE_TRANSIENT);
            }
            else {
                sqlite3_bind_blob(searchStament, 3, [str3 bytes], (int)[str3 length], SQLITE_TRANSIENT);
            }
            
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             NSLog(@"insert success");
             }
             else {
             NSLog(@"insert NOT success");
             }
             */
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// INSERT Floor
-(void)insertTableFloor:(NSMutableArray *)arr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "INSERT INTO Floor VALUES (?,?,?,?)";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            NSString *str1 = [arr objectAtIndex:0];
            NSString *str2 = [arr objectAtIndex:1];
            NSString *str3 = [arr objectAtIndex:2];
            NSData *str4 = [arr objectAtIndex:3];
            
            sqlite3_bind_text(searchStament, 1, [str1 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 2, [str2 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 3, [str3 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            if ([str3 length] == 0) {
                sqlite3_bind_text(searchStament, 4, "", -1, SQLITE_TRANSIENT);
            }
            else {
                sqlite3_bind_blob(searchStament, 4, [str4 bytes], (int)[str4 length], SQLITE_TRANSIENT);
            }
            
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             NSLog(@"insert success");
             }
             else {
             NSLog(@"insert NOT success");
             }
             */
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// INSERT LinkFloorStore
-(void)insertTableLinkFloorStore:(NSMutableArray *)arr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "INSERT INTO LinkFloorStore VALUES (?,?,?,?,?,?,?)";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            NSString *str1 = [arr objectAtIndex:0];
            NSString *str2 = [arr objectAtIndex:1];
            NSString *str3 = [arr objectAtIndex:2];
            NSString *str4 = [arr objectAtIndex:3];
            NSString *str5 = [arr objectAtIndex:4];
            NSString *str6 = [arr objectAtIndex:5];
            NSString *str7 = [arr objectAtIndex:6];
            
            sqlite3_bind_text(searchStament, 1, [str1 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 2, [str2 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 3, [str3 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 4, [str4 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 5, [str5 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 6, [str6 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 7, [str7 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             NSLog(@"insert success");
             }
             else {
             NSLog(@"insert NOT success");
             }
             */
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// INSERT Store
-(void)insertTableStore:(NSMutableArray *)arr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "INSERT INTO Store VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            NSString *str1 = [arr objectAtIndex:0];
            NSString *str2 = [arr objectAtIndex:1];
            NSString *str3 = [arr objectAtIndex:2];
            NSString *str4 = [arr objectAtIndex:3];
            NSString *str5 = [arr objectAtIndex:4];
            NSString *str6 = [arr objectAtIndex:5];
            NSString *str7 = [arr objectAtIndex:6];
            NSString *str8 = [arr objectAtIndex:7];
            NSString *str9 = [arr objectAtIndex:8];
            NSString *str10 = [arr objectAtIndex:9];
            NSString *str11 = [arr objectAtIndex:10];
            NSString *str12 = [arr objectAtIndex:11];
            NSData *str13 = [arr objectAtIndex:12];
            
            sqlite3_bind_text(searchStament, 1, [str1 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 2, [str2 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 3, [str3 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 4, [str4 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 5, [str5 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 6, [str6 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 7, [str7 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 8, [str8 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 9, [str9 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 10, [str10 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 11, [str11 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 12, [str12 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            if ([str13 length] == 0) {
                sqlite3_bind_text(searchStament, 13, "", -1, SQLITE_TRANSIENT);
            }
            else {
                sqlite3_bind_blob(searchStament, 13, [str13 bytes], (int)[str13 length], SQLITE_TRANSIENT);
            }
            
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             NSLog(@"insert success");
             }
             else {
             NSLog(@"insert NOT success");
             }
             */
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}
// INSERT ImageStore
-(void)insertTableImageStore:(NSMutableArray *)arr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "INSERT INTO ImageStore VALUES (?,?,?)";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            NSString *str1 = [arr objectAtIndex:0];
            NSString *str2 = [arr objectAtIndex:1];
            NSData *str3 = [arr objectAtIndex:2];
            
            sqlite3_bind_text(searchStament, 1, [str1 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(searchStament, 2, [str2 cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            if ([str3 length] == 0) {
                sqlite3_bind_text(searchStament, 3, "", -1, SQLITE_TRANSIENT);
            }
            else {
                sqlite3_bind_blob(searchStament, 3, [str3 bytes], (int)[str3 length], SQLITE_TRANSIENT);
            }
            
            sqlite3_step(searchStament);
            /*
             if (sqlite3_step(searchStament) == SQLITE_DONE) {
             NSLog(@"insert success");
             }
             else {
             NSLog(@"insert NOT success");
             }
             */
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

//
//
// SQL Server
//
//
// GET DepartmentStore
-(void)getTableDepartmentStore:(NSString *)idDS
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getTableDepartmentStore.php?idDS=%@",idDS];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getTableDepartmentStore.php?idDS=%@",idDS];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"start arrDepartmentStore %lu",(unsigned long)[arrDepartmentStore count]);
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        [arr addObject:[dataDict objectForKey:@"idDS"]];
        [arr addObject:[dataDict objectForKey:@"nameDS"]];
        [arr addObject:[dataDict objectForKey:@"branchDS"]];
        [arr addObject:[dataDict objectForKey:@"addressDS"]];
        [arr addObject:[dataDict objectForKey:@"openTimeDS"]];
        [arr addObject:[dataDict objectForKey:@"closeTimeDS"]];
        [arr addObject:[dataDict objectForKey:@"numFloorDS"]];
        
        NSString *logoDS = [dataDict objectForKey:@"logoDS"];
        NSData *logoDS_data = [[NSData alloc] initWithBase64EncodedString:logoDS options:0];
        //NSString *logoDS_str = [[NSString alloc] initWithData:logoDS_data encoding:NSUTF8StringEncoding];
        [arr addObject:logoDS_data];
        
        [arr addObject:[dataDict objectForKey:@"latestUpdate"]];
        
        [arrDepartmentStore addObject:arr];
        //NSLog(@"get-DepartmentStore => idDS:%@",[dataDict objectForKey:@"idDS"]);
    }
}
// GET ImageDS
-(void)getTableImageDS:(NSString *)idDS
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getTableImageDS.php?idDS=%@",idDS];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getTableImageDS.php?idDS=%@",idDS];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"start arrImageDS %lu",(unsigned long)[arrImageDS count]);
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        [arr addObject:[dataDict objectForKey:@"idImageDS"]];
        [arr addObject:[dataDict objectForKey:@"idDS"]];
        
        NSString *imageDS = [dataDict objectForKey:@"imageDS"];
        NSData *imageDS_data = [[NSData alloc] initWithBase64EncodedString:imageDS options:0];
        [arr addObject:imageDS_data];
        
        [arrImageDS addObject:arr];
        //NSLog(@"get-arrImageDS => idImageDS:%@",[dataDict objectForKey:@"idImageDS"]);
    }
}
// GET Floor
-(void)getTableFloor:(NSString *)idDS
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getTableFloor.php?idDS=%@",idDS];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getTableFloor.php?idDS=%@",idDS];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"start arrFloor %lu",(unsigned long)[arrFloor count]);
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        [arr addObject:[dataDict objectForKey:@"idFloor"]];
        [arr addObject:[dataDict objectForKey:@"idDS"]];
        [arr addObject:[dataDict objectForKey:@"floor"]];
        
        NSString *mapFloor = [dataDict objectForKey:@"mapFloor"];
        NSData *mapFloor_data = [[NSData alloc] initWithBase64EncodedString:mapFloor options:0];
        [arr addObject:mapFloor_data];
        
        [arrFloor addObject:arr];
        [arrIDFloor addObject:[dataDict objectForKey:@"idFloor"]];
        //NSLog(@"get-arrFloor => idFloor:%@",[dataDict objectForKey:@"idFloor"]);
    }
}
// GET LinkFloorStore
-(void)getTableLinkFloorStore:(NSString *)idFloor
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getTableLinkFloorStore.php?idFloor=%@",idFloor];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getTableLinkFloorStore.php?idFloor=%@",idFloor];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"start arrLinkFloorStore %lu",(unsigned long)[arrLinkFloorStore count]);
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        [arr addObject:[dataDict objectForKey:@"idFloor"]];
        [arr addObject:[dataDict objectForKey:@"idStore"]];
        [arr addObject:[dataDict objectForKey:@"addressNumber"]];
        [arr addObject:[dataDict objectForKey:@"pointX"]];
        [arr addObject:[dataDict objectForKey:@"pointY"]];
        [arr addObject:[dataDict objectForKey:@"width"]];
        [arr addObject:[dataDict objectForKey:@"height"]];
        
        [arrLinkFloorStore addObject:arr];
        [arrIDStore addObject:[dataDict objectForKey:@"idStore"]];
        //NSLog(@"get-arrLinkFloorStore => idStore:%@",[dataDict objectForKey:@"idStore"]);
    }
}
// GET Store
-(void)getTableStore:(NSString *)idStore
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getTableStore.php?idStore=%@",idStore];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getTableStore.php?idStore=%@",idStore];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"start arrStore %lu",(unsigned long)[arrStore count]);
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        [arr addObject:[dataDict objectForKey:@"idStore"]];
        [arr addObject:[dataDict objectForKey:@"nameStore"]];
        [arr addObject:[dataDict objectForKey:@"branchStore"]];
        [arr addObject:[dataDict objectForKey:@"addressNumber"]];
        [arr addObject:[dataDict objectForKey:@"category"]];
        [arr addObject:[dataDict objectForKey:@"openTimeStore"]];
        [arr addObject:[dataDict objectForKey:@"closeTimeStore"]];
        [arr addObject:[dataDict objectForKey:@"telStore"]];
        [arr addObject:[dataDict objectForKey:@"faxStore"]];
        [arr addObject:[dataDict objectForKey:@"emailStore"]];
        [arr addObject:[dataDict objectForKey:@"webStore"]];
        [arr addObject:[dataDict objectForKey:@"detailStore"]];
        
        NSString *logoStore = [dataDict objectForKey:@"logoStore"];
        NSData *logoStore_data = [[NSData alloc] initWithBase64EncodedString:logoStore options:0];
        [arr addObject:logoStore_data];
        
        [arrStore addObject:arr];
        //NSLog(@"get-arrStore => idStore:%@",[dataDict objectForKey:@"idStore"]);
    }
}
// GET ImageStore
-(void)getTableImageStore:(NSString *)idStore
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getTableImageStore.php?idStore=%@",idStore];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getTableImageStore.php?idStore=%@",idStore];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"start arrImageStore %lu",(unsigned long)[arrImageStore count]);
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        [arr addObject:[dataDict objectForKey:@"idImageStore"]];
        [arr addObject:[dataDict objectForKey:@"idStore"]];
        
        NSString *imageStore = [dataDict objectForKey:@"imageStore"];
        NSData *imageStore_data = [[NSData alloc] initWithBase64EncodedString:imageStore options:0];
        [arr addObject:imageStore_data];
        
        [arrImageStore addObject:arr];
        //NSLog(@"get-arrImageStore => idImageStore:%@",[dataDict objectForKey:@"idImageStore"]);
    }
}

//method for Right Button
-(void)rightFuntion
{
    UIAlertView *alv = [[UIAlertView alloc]
                        initWithTitle:check
                        message:@"Alert View"
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
                            initWithTitle:@"WAIT"
                            message:@"Alert View"
                            delegate:self
                            cancelButtonTitle: nil
                            otherButtonTitles: nil];
        [alv show];
        [self performSelector:@selector(wait:) withObject:alv afterDelay:1];
    }
}

-(void)wait:(UIAlertView *)alv
{
    [self downloadData:dataID];
    
    [alv dismissWithClickedButtonIndex:-1 animated:YES];
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

@end

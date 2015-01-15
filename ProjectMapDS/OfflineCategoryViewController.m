//
//  OfflineCategoryViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/8/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OfflineCategoryViewController.h"
#import "OfflineTabBarDSViewController.h"   //use Global variable: dataID, dataFloor

@interface OfflineCategoryViewController ()

@end

@implementation OfflineCategoryViewController
{
    NSString *titleRightButton;
    NSMutableArray *category;
    NSDictionary *shopCategory;
    NSDictionary *idShopCategory;
    NSDictionary *floorShopCategory;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Category DS";
    //self.navigationController.navigationBar.topItem.title = @"back";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:titleRightButton
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)];
    self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //call method for Database
    [self initDatabase];
    [self showCategory:@"%"];
    //set title Right Button
    titleRightButton = @"All Floor";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [category count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [category objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [category objectAtIndex:section];
    NSArray *sectionShops = [shopCategory objectForKey:sectionTitle];
    return [sectionShops count];
    //return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *SimpleIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleIdentifier];
    }
    
    NSString *sectionTitle = [category objectAtIndex:indexPath.section];
    NSArray *sectionStores = [shopCategory objectForKey:sectionTitle];
    NSString *store = [sectionStores objectAtIndex:indexPath.row];
    cell.textLabel.text = store;
    //NSArray *sectionIDShops = [idShopCategory objectForKey:sectionTitle];
    //NSString *idStore = [sectionIDShops objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = idStore;
    NSArray *sectionFloorShops = [floorShopCategory objectForKey:sectionTitle];
    NSString *floorStore = [sectionFloorShops objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = floorStore;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = [category objectAtIndex:indexPath.section];
    NSArray *sectionIDStores = [idShopCategory objectForKey:sectionTitle];
    NSString *store = [sectionIDStores objectAtIndex:indexPath.row];
    
    OfflineTabBarStoreViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineTabBarStoreViewController"];
    storeID = store;
    [self.navigationController pushViewController:destView animated:YES];
}

//method
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

-(void)getCategory:(NSString *) floor //get array of Category Section Title
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        /*NSString *sqlFloor = @"";
        if (![floor  isEqual: @""])
        {
            sqlFloor = [NSString stringWithFormat:@"and Floor.floor LIKE '%@'",floor];
        }*/
        
        const char *sql = [[NSString stringWithFormat:@"SELECT Store.category FROM DepartmentStore,Floor,LinkFloorStore,Store WHERE DepartmentStore.idDS=Floor.idDS and Floor.idFloor=LinkFloorStore.idFloor and LinkFloorStore.idStore=Store.idStore and DepartmentStore.idDS=%@ and Floor.floor LIKE '%@' GROUP BY Store.category ORDER BY Store.category ASC",dataID,floor] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            category = [[NSMutableArray alloc] init];
            
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                [category addObject:name];
            }
        }
        sqlite3_finalize(searchStament);
    }
    //sqlite3_close(database);
}

-(void)getShopCategory:(NSString *) floor //get data Store
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        /*NSString *sqlFloor = @"";
        if (![floor  isEqual: @""])
        {
            sqlFloor = [NSString stringWithFormat:@"and Floor.floor LIKE '%@'",floor];
        }*/
        
        shopCategory = [[NSMutableDictionary alloc] init];
        idShopCategory = [[NSMutableDictionary alloc] init];
        floorShopCategory = [[NSMutableDictionary alloc] init];
        
        for (NSString *keyCategory in category)
        {
            const char *sql = [[NSString stringWithFormat:@"SELECT Store.idStore,Store.nameStore FROM DepartmentStore,Floor,LinkFloorStore,Store WHERE DepartmentStore.idDS=Floor.idDS and Floor.idFloor=LinkFloorStore.idFloor and LinkFloorStore.idStore=Store.idStore and DepartmentStore.idDS=%@ and Store.category='%@' and Floor.floor LIKE '%@' GROUP BY Store.nameStore ORDER BY Store.nameStore ASC",dataID,keyCategory,floor] cStringUsingEncoding:NSUTF8StringEncoding];
            
            sqlite3_stmt *searchStament;
            
            if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
            {
                NSMutableArray *arrName = [[NSMutableArray alloc] init];
                NSMutableArray *arrID = [[NSMutableArray alloc] init];
                NSMutableArray *arrFloor = [[NSMutableArray alloc] init];
                
                while (sqlite3_step(searchStament) == SQLITE_ROW)
                {
                    NSString *idStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                    
                    NSString *nameStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 1)];
                    
                    NSString *floorStore = @"";
                    if ([floor isEqual:@"%"])
                    {
                        floorStore = [self getStringFloor:idStore];
                    }
                    else
                    {
                        floorStore = floor;
                    }
                    
                    [arrID addObject:idStore];
                    [arrName addObject:nameStore];
                    [arrFloor addObject:floorStore];
                }
                //add Key:category and Value:shop in Dict.
                [shopCategory setValue:arrName forKey:keyCategory];
                [idShopCategory setValue:arrID forKey:keyCategory];
                [floorShopCategory setValue:arrFloor forKey:keyCategory];
            }
            sqlite3_finalize(searchStament);
        }
    }
    sqlite3_close(database);
}

-(NSString *)getStringFloor:(NSString *) shop
{
    sqlite3 *db;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    NSString *strFloor = @"";
    
    if (sqlite3_open([path UTF8String], &db) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT Floor.floor FROM Floor,LinkFloorStore WHERE Floor.idFloor=LinkFloorStore.idFloor and Floor.idDS=%@ and LinkFloorStore.idStore='%@' ORDER BY Floor.idFloor ASC",dataID,shop] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(db, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *nameFloor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                
                if ([strFloor isEqual:@""])
                {
                    strFloor = [strFloor stringByAppendingString:nameFloor];
                }
                else
                {
                    strFloor = [strFloor stringByAppendingString:@", "];
                    strFloor = [strFloor stringByAppendingString:nameFloor];
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
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:@"Show all"
                           otherButtonTitles:nil];
    //[func addButtonWithTitle:@"Show all"];
    /*
    if (![dataFloor[0] isEqual:@"%"]) {
        [func addButtonWithTitle:@"Show all"];
    }
    */
    for (NSString *title in dataFloor) {
        [func addButtonWithTitle:title];
    }
    func.cancelButtonIndex = [func addButtonWithTitle:@"Cancel"];
    [func showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        titleRightButton = @"All Floor";
        [self.parentViewController.navigationItem.rightBarButtonItem setTitle:titleRightButton];
        [self getCategory:@"%"];
        [self getShopCategory:@"%"];
        [self.offlineCategoryTable reloadData];
    }
    else if (buttonIndex != [dataFloor count]+1)
    {
        titleRightButton = [NSString stringWithFormat:@"%@ Floor",dataFloor[buttonIndex-1]];
        [self.parentViewController.navigationItem.rightBarButtonItem setTitle:titleRightButton];
        [self getCategory:dataFloor[buttonIndex-1]];
        [self getShopCategory:dataFloor[buttonIndex-1]];
        [self.offlineCategoryTable reloadData];
    }
}

//call mathod for SHOW FloorPlan
-(void)showCategory:(NSString *) floor
{
    //call method for Database
    [self getCategory:floor];
    [self getShopCategory:floor];
}

@end

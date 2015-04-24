//
//  SearchPageViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 4/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "SearchPageViewController.h"
#import "URL_GlobalVar.h"               //use Global variable: urlLocalhost

@interface SearchPageViewController ()
{
    NSString *type;
    
    NSMutableArray *arrType;
    NSMutableArray *arrCategory;
    
    NSMutableArray *listOfDS;
    NSDictionary *listOfStore;
    
    NSMutableArray *searchListOfDS;
    NSMutableArray *searchListOfCategory;
    NSDictionary *searchListOfStore;
}
@end

@implementation SearchPageViewController
@synthesize searchTextBar,searchType,searchCategory,searchTable;
@synthesize selectedIndexType,selectedIndexCategory;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"ค้นหา";
    self.navigationController.navigationBar.hidden = NO;
    
    //reload Table View
    [self.searchTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrType = [[NSMutableArray alloc] initWithObjects:@"ห้างสรรพสินค้า", @"ร้านค้า", nil];
    
    [self checkNetworkConnection];
    
    self.selectedIndexType = 0;
    self.selectedIndexCategory = 0;
    
    [self textFieldType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma SET TextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void)textFieldType
{
    if ([searchType.text isEqual:[arrType objectAtIndex:1]])
    {
        self.searchCategory.hidden = NO;
        
        if ([type isEqual:@"Offline"] && [arrCategory count]==0)
        {
            //NSLog(@"Category count:%lu type:%@",(unsigned long)[arrCategory count],type);
            [self selectCategory];
        }
        else if ([type isEqual:@"Online"] && [arrCategory count]==0)
        {
            //NSLog(@"Category count:%lu type:%@",(unsigned long)[arrCategory count],type);
            [self getCategory];
        }
    }
    else
    {
        self.searchCategory.hidden = YES;
        self.selectedIndexCategory = 0;
        self.searchCategory.text = [arrCategory objectAtIndex:selectedIndexCategory];
    }
    
    if ([searchTextBar.text isEqual:@""])
    {
        self.searchTable.hidden = YES;
    }
    else
    {
        self.searchTable.hidden = NO;
        
        
        if ([type isEqual:@"Offline"] && [listOfStore count]==0 && selectedIndexType==1)
        {
            //NSLog(@"Shop count:%lu type:%@",(unsigned long)[listOfStore count],type);
            [self selectStore];
        }
        else if ([type isEqual:@"Online"] && [listOfStore count]==0 && selectedIndexType==1)
        {
            //NSLog(@"Shop count:%lu type:%@",(unsigned long)[listOfStore count],type);
            [self getStore];
        }
    }
}

#pragma SET SearchBar
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchListOfDS = [[NSMutableArray alloc] init];
    searchListOfCategory = [[NSMutableArray alloc] init];
    searchListOfStore = [[NSMutableDictionary alloc] init];
    
    [self textFieldType];
    
    
    self.searchType.text = [arrType objectAtIndex:selectedIndexType];
    if ([searchType.text isEqual:[arrType objectAtIndex:1]])
    {
        self.searchCategory.text = [arrCategory objectAtIndex:selectedIndexCategory];
    }
    
    [self filterContentForSearchText:searchText];
    [self.searchTable reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
    [self textFieldType];
}
/*
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (![searchBar.text isEqual:@""]) {
        if ([searchType.text isEqual:@""]) {
            selectedIndexType = 0;
            searchType.text = [arrType objectAtIndex:selectedIndexType];
        }
        else if ([searchCategory.text isEqual:@""]) {
            selectedIndexCategory = 0;
            searchCategory.text = [arrCategory objectAtIndex:selectedIndexCategory];
        }
        [self textFieldType];
    }
}*/

#pragma Search
-(void)filterContentForSearchText:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    
    if (selectedIndexType == 0)
    {
        searchListOfDS = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in listOfDS)
        {
            NSString *searchDS = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"nameDS"],[dict objectForKey:@"branchDS"]];
            
            NSArray *arr = [[NSArray alloc] initWithObjects:searchDS, nil];
            
            NSArray *arrResult = [[NSArray alloc] init];
            arrResult = [arr filteredArrayUsingPredicate:predicate];
            
            if ([arrResult count] != 0)
            {
                NSDictionary *dictDS = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [dict objectForKey:@"idDS"], @"idDS",
                                        [dict objectForKey:@"nameDS"], @"nameDS",
                                        [dict objectForKey:@"branchDS"], @"branchDS",
                                        [dict objectForKey:@"logoDS"], @"logoDS",
                                        nil];
                [searchListOfDS addObject:dictDS];
            }
        }
    }
    else
    {
        searchListOfCategory = [[NSMutableArray alloc] init];
        searchListOfStore = [[NSMutableDictionary alloc] init];
        
        if (selectedIndexCategory == 0)
        {
            for (NSString *keyCategory in arrCategory)
            {
                if ([keyCategory isEqual:[arrCategory objectAtIndex:0]]) { continue; }
                
                NSMutableArray *arrListOfStore = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in [listOfStore objectForKey:keyCategory])
                {
                    NSArray *arr = [[NSArray alloc] initWithObjects:[dict objectForKey:@"nameStore"], nil];
                    
                    NSArray *arrResult = [[NSArray alloc] init];
                    arrResult = [arr filteredArrayUsingPredicate:predicate];
                    
                    if ([arrResult count] != 0)
                    {
                        NSDictionary *dictStore = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [dict objectForKey:@"idDS"], @"idDS",
                                                   [dict objectForKey:@"idStore"], @"idStore",
                                                   [dict objectForKey:@"nameStore"], @"nameStore",
                                                   [dict objectForKey:@"branchStore"], @"branchStore",
                                                   [dict objectForKey:@"logoStore"], @"logoStore",
                                                   nil];
                        [arrListOfStore addObject:dictStore];
                    }
                }
                
                if ([arrListOfStore count] != 0)
                {
                    [searchListOfCategory addObject:keyCategory];
                    [searchListOfStore setValue:arrListOfStore forKey:keyCategory];
                }
            }
        }
        else
        {
            NSString *keyCategory = [arrCategory objectAtIndex:selectedIndexCategory];
            NSMutableArray *arrListOfStore = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in [listOfStore objectForKey:keyCategory])
            {
                NSArray *arr = [[NSArray alloc] initWithObjects:[dict objectForKey:@"nameStore"], nil];
                
                NSArray *arrResult = [[NSArray alloc] init];
                arrResult = [arr filteredArrayUsingPredicate:predicate];
                
                if ([arrResult count] != 0)
                {
                    NSDictionary *dictStore = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [dict objectForKey:@"idDS"], @"idDS",
                                               [dict objectForKey:@"idStore"], @"idStore",
                                               [dict objectForKey:@"nameStore"], @"nameStore",
                                               [dict objectForKey:@"branchStore"], @"branchStore",
                                               [dict objectForKey:@"logoStore"], @"logoStore",
                                               nil];
                    [arrListOfStore addObject:dictStore];
                }
            }
            
            if ([arrListOfStore count] != 0)
            {
                [searchListOfCategory addObject:keyCategory];
                [searchListOfStore setValue:arrListOfStore forKey:keyCategory];
            }
        }
    }
}

#pragma Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([searchType.text isEqual:[arrType objectAtIndex:1]] && [searchCategory.text isEqual:[arrCategory objectAtIndex:0]])
    {
        return [searchListOfCategory count];
    }
    else
    {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([searchType.text isEqual:[arrType objectAtIndex:1]] && [searchCategory.text isEqual:[arrCategory objectAtIndex:0]])
    {
        return [searchListOfCategory objectAtIndex:section];
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([searchType.text isEqual:[arrType objectAtIndex:0]])
    {
        return [searchListOfDS count];
    }
    else
    {
        if ([searchListOfCategory count] == 0)
        {
            return 0;
        }
        else
        {
            NSString *key = [searchListOfCategory objectAtIndex:section];
            return [[searchListOfStore objectForKey:key] count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *SimpleIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleIdentifier];
    }
    
    if ([searchType.text isEqual:[arrType objectAtIndex:0]])
    {
        NSDictionary *tmpDict = [searchListOfDS objectAtIndex:indexPath.row];
        
        // Cell Label text = "nameDS"
        NSString *text = [tmpDict objectForKey:@"nameDS"];
        cell.textLabel.text = text;
        
        // Cell Detail text = "branchDS"
        NSString *detail = [tmpDict objectForKey:@"branchDS"];
        cell.detailTextLabel.text = [@"สาขา " stringByAppendingString:detail];;
        
        // Cell Image = "logoDS"
        cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cell.imageView.image = [tmpDict objectForKey:@"logoDS"];
    }
    else
    {
        NSString *sectionTitle = [searchListOfCategory objectAtIndex:indexPath.section];
        NSMutableArray *sectionStores = [searchListOfStore objectForKey:sectionTitle];
        NSDictionary *store = [sectionStores objectAtIndex:indexPath.row];
        
        // Cell Label text = "nameStore"
        cell.textLabel.text = [store objectForKey:@"nameStore"];
        
        // Cell Detail text = "branchStore"
        cell.detailTextLabel.text = [store objectForKey:@"branchStore"];
        
        // Cell Image = "logoStore"
        cell.imageView.image = [store objectForKey:@"logoStore"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqual:@"Online"])
    {
        if ([searchType.text isEqual:[arrType objectAtIndex:0]])
        {
            NSDictionary *tmpDict = [searchListOfDS objectAtIndex:indexPath.row];
            dataID = [tmpDict objectForKey:@"idDS"];
            
            OnlineTabBarDSViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineTabBarDSViewController"];
            [self.navigationController pushViewController:destView animated:YES];
        }
        else
        {
            NSString *sectionTitle = [searchListOfCategory objectAtIndex:indexPath.section];
            NSMutableArray *sectionStores = [searchListOfStore objectForKey:sectionTitle];
            NSDictionary *store = [sectionStores objectAtIndex:indexPath.row];
            //dataID = [store objectForKey:@"idDS"];
            storeID = [store objectForKey:@"idStore"];
            
            //OnlineTabBarDSViewController *destView1 = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineTabBarDSViewController"];
            //[self.navigationController pushViewController:destView1 animated:YES];
            
            OnlineTabBarStoreViewController *destView2 = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineTabBarStoreViewController"];
            [self.navigationController pushViewController:destView2 animated:YES];
        }
    }
    else
    {
        if ([searchType.text isEqual:[arrType objectAtIndex:0]])
        {
            NSDictionary *tmpDict = [searchListOfDS objectAtIndex:indexPath.row];
            dataID = [tmpDict objectForKey:@"idDS"];
            
            OfflineTabBarDSViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineTabBarDSViewController"];
            [self.navigationController pushViewController:destView animated:YES];
        }
        else
        {
            NSString *sectionTitle = [searchListOfCategory objectAtIndex:indexPath.section];
            NSMutableArray *sectionStores = [searchListOfStore objectForKey:sectionTitle];
            NSDictionary *store = [sectionStores objectAtIndex:indexPath.row];
            //dataID = [store objectForKey:@"idDS"];
            storeID = [store objectForKey:@"idStore"];
            
            //OfflineTabBarDSViewController *destView1 = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineTabBarDSViewController"];
            //[self.navigationController pushViewController:destView1 animated:YES];
            
            OfflineTabBarStoreViewController *destView2 = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineTabBarStoreViewController"];
            [self.navigationController pushViewController:destView2 animated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectType:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"เลือกประเภท" rows:arrType initialSelection:selectedIndexType target:self successAction:@selector(TypeWasSelected:element:) cancelAction:nil origin:sender];
}

- (void)TypeWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    selectedIndexType = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    searchType.text = (arrType)[(NSUInteger) selectedIndexType];
    
    self.searchTextBar.text = nil;
    [self textFieldType];
}

- (IBAction)selectCategory:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"เลือกประเภท" rows:arrCategory initialSelection:selectedIndexCategory target:self successAction:@selector(CategoryWasSelected:element:) cancelAction:nil origin:sender];
}

- (void)CategoryWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    selectedIndexCategory = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    searchCategory.text = (arrCategory)[(NSUInteger) selectedIndexCategory];
    
    self.searchTextBar.text = nil;
    [self textFieldType];
}

//method
-(void)checkNetworkConnection
{
    NSString *url = [NSString stringWithFormat:@"%@/getDSList.php",urlLocalhost];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    //Case connection error!!
    if (jsonSource == NULL)
    {
        type = @"Offline";
        //NSLog(@"SQLite");
        
        [self initDatabase];
        [self selectDepartmentStore];
        //[self selectCategory];
        //[self selectStore];
    }
    else
    {
        type = @"Online";
        //NSLog(@"SQL server");
        
        [self getDepartmentStore];
        //[self getCategory];
        //[self getStore];
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
// SQLite
//
-(void)selectDepartmentStore
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "SELECT idDS,nameDS,branchDS,logoDS FROM DepartmentStore";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            listOfDS = [[NSMutableArray alloc] init];
            
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *idDS = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 1)];
                
                NSString *branch = @"-";
                if ((char*)sqlite3_column_text(searchStament, 2) != NULL) {
                    branch = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 2)];
                    if ([branch  isEqual: @""]) {
                        branch = @"-";
                    }
                }
                
                UIImage *imageLogo = [UIImage imageNamed:@"Info-icon.png"];
                if ((char*)sqlite3_column_text(searchStament, 3) != NULL)
                {
                    NSData *logo = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 3) length:sqlite3_column_bytes(searchStament, 3)];
                    if ([logo length] != 0)
                    {
                        imageLogo = [UIImage imageWithData:logo];
                    }
                }
                
                NSDictionary *dictDS = [NSDictionary dictionaryWithObjectsAndKeys:
                                        idDS, @"idDS",
                                        name, @"nameDS",
                                        branch, @"branchDS",
                                        imageLogo, @"logoDS",
                                        nil];
                [listOfDS addObject:dictDS];
            }
        }
        sqlite3_finalize(searchStament);
    }
    //sqlite3_close(database);
}

-(void)selectCategory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "SELECT category FROM Store GROUP BY category ORDER BY category ASC";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            arrCategory = [[NSMutableArray alloc] init];
            [arrCategory addObject:@"All Category"];
            
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                [arrCategory addObject:name];
            }
        }
        sqlite3_finalize(searchStament);
    }
    //sqlite3_close(database);
}

-(void)selectStore
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        listOfStore = [[NSMutableDictionary alloc] init];
        
        for (NSString *keyCategory in arrCategory)
        {
            if ([keyCategory isEqual:[arrCategory objectAtIndex:0]]) { continue; }
            
            const char *sql = [[NSString stringWithFormat:@"SELECT DepartmentStore.idDS,Store.idStore,Store.nameStore,Store.branchStore,Store.logoStore FROM DepartmentStore,Floor,LinkFloorStore,Store WHERE DepartmentStore.idDS=Floor.idDS and Floor.idFloor=LinkFloorStore.idFloor and LinkFloorStore.idStore=Store.idStore and Store.category LIKE '%@' GROUP BY Store.nameStore ORDER BY Store.nameStore ASC",keyCategory] cStringUsingEncoding:NSUTF8StringEncoding];
            
            sqlite3_stmt *searchStament;
            
            if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
            {
                NSMutableArray *arrStore = [[NSMutableArray alloc] init];
                
                while (sqlite3_step(searchStament) == SQLITE_ROW)
                {
                    NSString *idDS = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                    
                    NSString *idStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 1)];
                    
                    NSString *nameStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 2)];
                    
                    NSString *branchStore = @"-";
                    if ((char*)sqlite3_column_text(searchStament, 3) != NULL) {
                        branchStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 3)];
                        if ([branchStore  isEqual: @""]) {
                            branchStore = @"-";
                        }
                    }
                    
                    UIImage *imageLogo = [UIImage imageNamed:@"Info-icon.png"];
                    if ((char*)sqlite3_column_text(searchStament, 4) != NULL)
                    {
                        NSData *logo = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 4) length:sqlite3_column_bytes(searchStament, 4)];
                        if ([logo length] != 0)
                        {
                            imageLogo = [UIImage imageWithData:logo];
                        }
                    }
                    
                    NSDictionary *dictDS = [NSDictionary dictionaryWithObjectsAndKeys:
                                            idDS, @"idDS",
                                            idStore, @"idStore",
                                            nameStore, @"nameStore",
                                            branchStore, @"branchStore",
                                            imageLogo, @"logoStore",
                                            nil];
                    [arrStore addObject:dictDS];
                }
                [listOfStore setValue:arrStore forKey:keyCategory];
            }
            sqlite3_finalize(searchStament);
        }
    }
    sqlite3_close(database);
}

//
// SQL Server
//
-(void)getDepartmentStore
{
    listOfDS = [[NSMutableArray alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/getDSList.php",urlLocalhost];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *idDS_data = [dataDict objectForKey:@"idDS"];
        
        NSString *nameDS_data = [dataDict objectForKey:@"nameDS"];
        
        NSString *branchDS_data = [dataDict objectForKey:@"branchDS"];
        if ([branchDS_data length] == 0) {
            branchDS_data = @"-";
        }
        
        NSString *logoDS_data = [dataDict objectForKey:@"logoDS"];
        UIImage *imageLogo = [UIImage imageNamed:@"Info-icon.png"];
        if ([logoDS_data length] != 0) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:logoDS_data options:0];
            imageLogo = [UIImage imageWithData:imageData];
        }
        
        NSDictionary *dictDS = [NSDictionary dictionaryWithObjectsAndKeys:
                                idDS_data, @"idDS",
                                nameDS_data, @"nameDS",
                                branchDS_data, @"branchDS",
                                imageLogo, @"logoDS",
                                nil];
        [listOfDS addObject:dictDS];
    }
}

-(void)getCategory
{
    arrCategory = [[NSMutableArray alloc] init];
    [arrCategory addObject:@"All Category"];
    
    NSString *url = [NSString stringWithFormat:@"%@/getCategoryList.php",urlLocalhost];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *category_data = [dataDict objectForKey:@"category"];
        [arrCategory addObject:category_data];
    }
}

-(void)getStore
{
    listOfStore = [[NSMutableDictionary alloc] init];
    
    for (NSString *keyCategory in arrCategory)
    {
        if ([keyCategory isEqual:[arrCategory objectAtIndex:0]]) { continue; }
              
        NSString *url_keyCategory = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)keyCategory, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        NSString *url = [NSString stringWithFormat:@"%@/getStoreList.php?category=%@",urlLocalhost,url_keyCategory];
        NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *arrStore = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dataDict in jsonObjects)
        {
            NSString *idDS_data = [dataDict objectForKey:@"idDS"];
            
            NSString *idStore_data = [dataDict objectForKey:@"idStore"];
            
            NSString *nameStore_data = [dataDict objectForKey:@"nameStore"];
            
            NSString *branchStore_data = [dataDict objectForKey:@"branchStore"];
            if ([branchStore_data length] == 0) {
                branchStore_data = @"-";
            }
            
            NSString *logoStore_data = [dataDict objectForKey:@"logoStore"];
            UIImage *imageLogo = [UIImage imageNamed:@"Info-icon.png"];
            if ([logoStore_data length] != 0) {
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:logoStore_data options:0];
                imageLogo = [UIImage imageWithData:imageData];
            }
            
            NSDictionary *dictDS = [NSDictionary dictionaryWithObjectsAndKeys:
                                    idDS_data, @"idDS",
                                    idStore_data, @"idStore",
                                    nameStore_data, @"nameStore",
                                    branchStore_data, @"branchStore",
                                    imageLogo, @"logoStore",
                                    nil];
            [arrStore addObject:dictDS];
        }
        [listOfStore setValue:arrStore forKey:keyCategory];
    }
}

@end

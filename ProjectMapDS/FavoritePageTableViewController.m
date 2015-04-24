//
//  FavoritePageTableViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "FavoritePageTableViewController.h"

@interface FavoritePageTableViewController ()

@end

@implementation FavoritePageTableViewController
{
    NSMutableArray *listOfidStore;
    NSMutableArray *listOfnameStore;
    NSMutableArray *listOfDepartmentStore;
    NSMutableArray *listOflogoStore;
    
    NSMutableArray *searchListOfidStore;
    NSMutableArray *searchListOfnameStore;
    NSMutableArray *searchListOfDepartmentStore;
    NSMutableArray *searchListOflogoStore;
    
    NSString *search;
}
@synthesize favoriteSearchBar;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"รายการโปรด";
    self.navigationController.navigationBar.hidden = NO;
    
    //reload Table View
    [self getFavorite];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide the search bar until user scrolls up
    CGRect newBounds = [self.tableView bounds];
    newBounds.origin.y = favoriteSearchBar.bounds.size.height;
    [self.tableView setBounds:newBounds];
    
    //call initDatabse : use to check connected MapDepartmentStore.sqlite
    [self initDatabase];
    //call getFavorite : connect DB & use data from MapDepartmentStore.sqlite
    //[self getFavorite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([search isEqual:@"search"])
    {
        return [searchListOfidStore count];
    }
    else
    {
        return [listOfidStore count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleIdentifier];
    }
    
    if ([search isEqual:@"search"])
    {
        // Cell Label text = "nameStore"
        cell.textLabel.text = [searchListOfnameStore objectAtIndex:indexPath.row];
        
        // Cell Detail text = "branchStore"
        NSString *callDetail = [searchListOfDepartmentStore objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [@"ห้าง: " stringByAppendingString:callDetail];
        
        // Cell Image = "logoDS"
        cell.imageView.image = [searchListOflogoStore objectAtIndex:indexPath.row];
    }
    else
    {
        // Cell Label text = "nameStore"
        cell.textLabel.text = [listOfnameStore objectAtIndex:indexPath.row];
        
        // Cell Detail text = "branchStore"
        NSString *callDetail = [listOfDepartmentStore objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [@"ห้าง: " stringByAppendingString:callDetail];
        
        // Cell Image = "logoDS"
        cell.imageView.image = [listOflogoStore objectAtIndex:indexPath.row];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([search isEqual:@"search"])
    {
        storeID = [searchListOfidStore objectAtIndex:indexPath.row];
    }
    else
    {
        storeID = [listOfidStore objectAtIndex:indexPath.row];
    }
    
    //next to Offline TabBar Store Page
    OfflineTabBarStoreViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineTabBarStoreViewController"];
    [self.navigationController pushViewController:destView animated:YES];
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//search
-(void)filterContentForSearchText:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    
    searchListOfidStore = [[NSMutableArray alloc] init];
    searchListOfnameStore = [[NSMutableArray alloc] init];
    searchListOfDepartmentStore = [[NSMutableArray alloc] init];
    searchListOflogoStore = [[NSMutableArray alloc] init];
    
    for (NSString *idStore in listOfidStore)
    {
        NSUInteger index = [listOfidStore indexOfObject:idStore];
        
        NSArray *arr = [[NSArray alloc] initWithObjects:[listOfnameStore objectAtIndex:index],[listOfDepartmentStore objectAtIndex:index], nil];
        
        NSArray *arrResult = [[NSArray alloc] init];
        arrResult = [arr filteredArrayUsingPredicate:predicate];
        
        if ([arrResult count] != 0)
        {
            [searchListOfidStore addObject:idStore];
            [searchListOfnameStore addObject:[arr objectAtIndex:0]];
            [searchListOfDepartmentStore addObject:[arr objectAtIndex:1]];
            [searchListOflogoStore addObject:[listOflogoStore objectAtIndex:index]];
        }
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isEqual: @""])
    {
        search = @"search";
        [self filterContentForSearchText:searchText];
    }
    else
    {
        search = nil;
    }
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    search = nil;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
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

-(void)getFavorite
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "SELECT Favorite.idStore,Store.nameStore,Store.logoStore,DepartmentStore.nameDS,DepartmentStore.branchDS FROM DepartmentStore,Floor,LinkFloorStore,Store,Favorite WHERE DepartmentStore.idDS=Floor.idDS and Floor.idFloor=LinkFloorStore.idFloor and LinkFloorStore.idStore=Store.idStore and Store.idStore=Favorite.idStore GROUP BY Store.idStore ORDER BY Favorite.date DESC, Store.nameStore ASC";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            listOfidStore = [[NSMutableArray alloc] init];
            listOfnameStore = [[NSMutableArray alloc] init];
            listOfDepartmentStore = [[NSMutableArray alloc] init];
            listOflogoStore = [[NSMutableArray alloc] init];
            
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *idStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 0)];
                
                NSString *nameStore = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 1)];
                
                UIImage *imageLogo = [UIImage imageNamed:@"Info-icon.png"];
                if ((char*)sqlite3_column_text(searchStament, 2) != NULL)
                {
                    NSData *logo = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 2) length:sqlite3_column_bytes(searchStament, 2)];
                    if ([logo length] != 0)
                    {
                        imageLogo = [UIImage imageWithData:logo];
                    }
                }
                
                NSString *nameDS = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 3)];
                NSString *branchDS = @"";
                if ((char*)sqlite3_column_text(searchStament, 4) != NULL) {
                    branchDS = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 4)];
                }
                nameDS = [nameDS stringByAppendingFormat:@" %@",branchDS];
                
                [listOfidStore addObject:idStore];
                [listOfnameStore addObject:nameStore];
                [listOfDepartmentStore addObject:nameDS];
                [listOflogoStore addObject:imageLogo];
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

@end

//
//  OfflinePageTableViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OfflinePageTableViewController.h"

@interface OfflinePageTableViewController ()

@end

@implementation OfflinePageTableViewController
{
    NSMutableArray *listOfidDS;
    NSMutableArray *listOfnameDS;
    NSMutableArray *listOfbranchDS;
    NSMutableArray *listOflogoDS;
    
    NSMutableArray *listOfnameEN;
    NSMutableArray *listOfnameTH;
    
    NSMutableArray *searchListOfidDS;
    NSMutableArray *searchListOfnameDS;
    NSMutableArray *searchListOfbranchDS;
    NSMutableArray *searchListOflogoDS;
    
    NSString *search;
}
@synthesize offlineSearchBar;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"ศูนย์การค้า";
    self.navigationController.navigationBar.hidden = NO;
    
    //reload Table View
    [self getDepartmentStore];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide the search bar until user scrolls up
    CGRect newBounds = [self.tableView bounds];
    newBounds.origin.y = offlineSearchBar.bounds.size.height;
    [self.tableView setBounds:newBounds];
    
    //call initDatabse : use to check connected MapDepartmentStore.sqlite
    [self initDatabase];
    //call getDepartmentStore : connect DB & use data from MapDepartmentStore.sqlite
    //[self getDepartmentStore];
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
        return [searchListOfidDS count];
    }
    else
    {
        return [listOfidDS count];
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
        // Cell Label text = "nameDS"
        cell.textLabel.text = [searchListOfnameDS objectAtIndex:indexPath.row];
        
        // Cell Detail text = "branchDS"
        NSString *callDetail = [searchListOfbranchDS objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [@"สาขา " stringByAppendingString:callDetail];
        
        // Cell Image = "logoDS"
        cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cell.imageView.image = [searchListOflogoDS objectAtIndex:indexPath.row];
    }
    else
    {
        // Cell Label text = "nameDS"
        cell.textLabel.text = [listOfnameDS objectAtIndex:indexPath.row];
        
        // Cell Detail text = "branchDS"
        NSString *callDetail = [listOfbranchDS objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [@"สาขา " stringByAppendingString:callDetail];
        
        // Cell Image = "logoDS"
        cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cell.imageView.image = [listOflogoDS objectAtIndex:indexPath.row];
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
    if ([search isEqual: @"search"])
    {
        dataID = [searchListOfidDS objectAtIndex:indexPath.row];
    }
    else
    {
        dataID = [listOfidDS objectAtIndex:indexPath.row];
    }
    
    OfflineTabBarDSViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineTabBarDSViewController"];
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
    
    searchListOfidDS = [[NSMutableArray alloc] init];
    searchListOfnameDS = [[NSMutableArray alloc] init];
    searchListOfbranchDS = [[NSMutableArray alloc] init];
    searchListOflogoDS = [[NSMutableArray alloc] init];
    
    for (NSString *idDS in listOfidDS)
    {
        NSUInteger index = [listOfidDS indexOfObject:idDS];
        
        NSString *searchDS = [NSString stringWithFormat:@"%@ %@ %@",[listOfnameEN objectAtIndex:index],[listOfnameTH objectAtIndex:index],[listOfbranchDS objectAtIndex:index]];
        
        NSArray *arr = [[NSArray alloc] initWithObjects:searchDS, nil];
        
        NSArray *arrResult = [[NSArray alloc] init];
        arrResult = [arr filteredArrayUsingPredicate:predicate];
        
        if ([arrResult count] != 0)
        {
            [searchListOfidDS addObject:idDS];
            [searchListOfnameDS addObject:[listOfnameDS objectAtIndex:index]];
            [searchListOfbranchDS addObject:[listOfbranchDS objectAtIndex:index]];
            [searchListOflogoDS addObject:[listOflogoDS objectAtIndex:index]];
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

-(void)getDepartmentStore
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "SELECT idDS,nameDS,branchDS,logoDS,nameDSEN,nameDSTH FROM DepartmentStore ORDER BY nameDS ASC";
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            listOfidDS = [[NSMutableArray alloc] init];
            listOfnameDS = [[NSMutableArray alloc] init];
            listOfbranchDS = [[NSMutableArray alloc] init];
            listOflogoDS = [[NSMutableArray alloc] init];
            
            listOfnameEN = [[NSMutableArray alloc] init];
            listOfnameTH = [[NSMutableArray alloc] init];
            
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
                
                UIImage *imageLogo = [UIImage imageNamed:@"No-icon.png"];
                //NSData *logo = UIImagePNGRepresentation(imageLogo);
                if ((char*)sqlite3_column_text(searchStament, 3) != NULL)
                {
                    NSData *logo = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 3) length:sqlite3_column_bytes(searchStament, 3)];
                    if ([logo length] != 0)
                    {
                        imageLogo = [UIImage imageWithData:logo];
                    }
                }
                
                NSString *nameEN = @"";
                if ((char*)sqlite3_column_text(searchStament, 4) != NULL) {
                    nameEN = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 4)];
                }
                
                NSString *nameTH = @"";
                if ((char*)sqlite3_column_text(searchStament, 5) != NULL) {
                    nameTH = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 5)];
                }
                
                /*
                NSLog(@"id: %@", idDS);
                NSLog(@"name: %@", name);
                NSLog(@"branch: %@", branch);
                NSLog(@"logo: %@", logo);
                NSLog(@"image: %@", imageLogo);
                NSLog(@"EN:%@ TH:%@",nameEN,nameTH);
                */
                
                [listOfidDS addObject:idDS];
                [listOfnameDS addObject:name];
                [listOfbranchDS addObject:branch];
                [listOflogoDS addObject:imageLogo];
                
                [listOfnameEN addObject:nameEN];
                [listOfnameTH addObject:nameTH];
                
                //NSLog(@"count of idDS: %lu",(unsigned long)[listOfidDS count]);
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

@end

//
//  OnlinePageTableViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlinePageTableViewController.h"
#import "URL_GlobalVar.h"                   //use Global variable: urlLocalhost

@interface OnlinePageTableViewController ()

@end

@implementation OnlinePageTableViewController
{
    NSMutableArray *listOfDS;
    
    NSMutableArray *searchListOfDS;
    
    NSString *search;
    
    //NSString *idDS;
    //NSString *nameDS;
    //NSString *branchDS;
    //NSString *logoDS;
    
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
    
    // case Download-Update ALL
    NSMutableArray *arrDownload;
    NSMutableArray *arrUpdate;
}
@synthesize onlineSearchBar;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"ห้างสรรพสินค้า";
    self.navigationController.navigationBar.hidden = NO;
    
    //reload Table View
    [self getDepartmentStore];
    [self.tableView reloadData];
    
    // CHECK
    [self checkAll];
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self action:@selector(rightFuntion)];*/
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"Download-icon.png"]
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)];
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"MORE"
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)];
     */
    self.navigationItem.rightBarButtonItem = rightButton;
    
    if ([arrDownload count]==0 && [arrUpdate count]==0)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide the search bar until user scrolls up
    CGRect newBounds = [self.tableView bounds];
    newBounds.origin.y = onlineSearchBar.bounds.size.height;
    [self.tableView setBounds:newBounds];
    
    //call getDepartmentStore : connect DB & use data from URL
    //[self getDepartmentStore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([search isEqual:@"search"])
    {
        return [searchListOfDS count];
    }
    else
    {
        return [listOfDS count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
 {
     static  NSString *simpleIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier forIndexPath:indexPath];
     
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleIdentifier];
     }
     
     if ([search isEqual:@"search"])
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
         NSDictionary *tmpDict = [listOfDS objectAtIndex:indexPath.row];
         
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
        NSDictionary *tmpDict = [searchListOfDS objectAtIndex:indexPath.row];
        dataID = [tmpDict objectForKey:@"idDS"];
    }
    else
    {
        NSDictionary *tmpDict = [listOfDS objectAtIndex:indexPath.row];
        dataID = [tmpDict objectForKey:@"idDS"];
    }
    
    OnlineTabBarDSViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineTabBarDSViewController"];
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
-(void)getDepartmentStore
{
    //idDS = @"idDS";
    //nameDS = @"nameDS";
    //branchDS = @"branchDS";
    //logoDS = @"logoDS";
    
    listOfDS = [[NSMutableArray alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/getDSList.php",urlLocalhost];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    //Case connection error!!
    if (jsonSource == NULL) { [self alertConnectionError]; return; }
    
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
        
        //NSLog(@"DS id: %@",idDS_data);
        //NSLog(@"DS name: %@",nameDS_data);
        //NSLog(@"DS branch: %@",branchDS_data);
        //NSLog(@"DS image: %@",logoDS_data);
        
        NSDictionary *dictDS = [NSDictionary dictionaryWithObjectsAndKeys:
                                idDS_data, @"idDS",
                                nameDS_data, @"nameDS",
                                branchDS_data, @"branchDS",
                                imageLogo, @"logoDS",
                                nil];
        [listOfDS addObject:dictDS];
    }
}

-(void)alertConnectionError
{
    UIAlertView *alv = [[UIAlertView alloc]
                        initWithTitle:@"Connection Error"
                        message:@"\nProblem with network connection.\nPlease try again."
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles: nil];
    [alv show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
            
        default:
            break;
    }
}

//method for Right Button
-(void)rightFuntion
{
    NSString *strDL = [NSString stringWithFormat:@"Download All"];
    NSString *strUP = [NSString stringWithFormat:@"Update All"];
    //NSString *strDL = [NSString stringWithFormat:@"Download All (%d)",(int)[arrDownload count]];
    //NSString *strUP = [NSString stringWithFormat:@"Update All (%d)",(int)[arrUpdate count]];
    
    UIActionSheet *func = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
    if ([arrDownload count] == 0)
    {
        [func addButtonWithTitle:strUP];
    }
    else if ([arrUpdate count] == 0)
    {
        [func addButtonWithTitle:strDL];
    }
    else
    {
        [func addButtonWithTitle:strDL];
        [func addButtonWithTitle:strUP];
    }
    func.cancelButtonIndex = [func addButtonWithTitle:@"Cancel"];
    [func showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView *alv = [[UIAlertView alloc]
                        initWithTitle:@""
                        message:@"Waiting"
                        delegate:self
                        cancelButtonTitle: nil
                        otherButtonTitles: nil];
    
    if ([arrDownload count] == 0)
    {
        if (buttonIndex == 0)
        {
            [self searchBarCancelButtonClicked:onlineSearchBar];
            
            //NSLog(@"UPdate");
            [alv show];
            [self performSelector:@selector(waitProcess2:) withObject:alv afterDelay:1];
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
    else if ([arrUpdate count] == 0)
    {
        if (buttonIndex == 0)
        {
            [self searchBarCancelButtonClicked:onlineSearchBar];
            
            //NSLog(@"DownLoad");
            [alv show];
            [self performSelector:@selector(waitProcess1:) withObject:alv afterDelay:1];
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            [self searchBarCancelButtonClicked:onlineSearchBar];
            
            //NSLog(@"DownLoad");
            [alv show];
            [self performSelector:@selector(waitProcess1:) withObject:alv afterDelay:1];
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        else if (buttonIndex == 1)
        {
            [self searchBarCancelButtonClicked:onlineSearchBar];
            
            //NSLog(@"UPdate");
            [alv show];
            [self performSelector:@selector(waitProcess2:) withObject:alv afterDelay:1];
        }
    }
}

-(void)waitProcess1:(UIAlertView *)alv
{
    //NSLog(@"DL-all");
    for (NSString *strID in arrDownload)
    {
        //NSLog(@"DL-all [%@]",strID);
        [self downloadData:strID];
    }
    for (NSString *strID in arrUpdate)
    {
        //NSLog(@"DL-all [%@]",strID);
        [self downloadData:strID];
    }
    [arrDownload removeAllObjects];
    [arrUpdate removeAllObjects];
    
    [alv dismissWithClickedButtonIndex:-1 animated:YES];
}

-(void)waitProcess2:(UIAlertView *)alv
{
    //NSLog(@"UP-all");
    for (NSString *strID in arrUpdate)
    {
        //NSLog(@"UP-all [%@]",strID);
        [self downloadData:strID];
    }
    [arrUpdate removeAllObjects];
    
    [alv dismissWithClickedButtonIndex:-1 animated:YES];
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
// CHECK ALL
-(void)checkAll
{
    arrDownload = [[NSMutableArray alloc] init];
    arrUpdate = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in listOfDS)
    {
        NSString *strID = [dict objectForKey:@"idDS"];
        NSString *strCheck = [self checkData:strID];
        //NSLog(@"List DS:%@ check:%@",strID,strCheck);
        
        if ([strCheck isEqual:@"UPDATE"])
        {
            [arrUpdate addObject:strID];
        }
        else if ([strCheck isEqual:@"DOWNLOAD"])
        {
            [arrDownload addObject:strID];
        }
    }
    
    //NSLog(@"check: dl[%d] up[%d]",(int)[arrDownload count],(int)[arrUpdate count]);
}
// CHECK 1 ID
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
    
    //NSLog(@"arrDepartmentStore:%lu",(unsigned long)[arrDepartmentStore count]);
    //NSLog(@"arrImageDS:%lu",(unsigned long)[arrImageDS count]);
    //NSLog(@"arrFloor:%lu",(unsigned long)[arrFloor count]);
    //NSLog(@"arrLinkFloorStore:%lu",(unsigned long)[arrLinkFloorStore count]);
    //NSLog(@"arrStore:%lu",(unsigned long)[arrStore count]);
    //NSLog(@"arrImageStore:%lu",(unsigned long)[arrImageStore count]);
    
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
    NSString *url = [NSString stringWithFormat:@"%@/getTableDepartmentStore.php?idDS=%@",urlLocalhost,idDS];
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
        
        NSString *strlogoDS = [dataDict objectForKey:@"logoDS"];
        NSData *logoDS_data = [[NSData alloc] initWithBase64EncodedString:strlogoDS options:0];
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
    NSString *url = [NSString stringWithFormat:@"%@/getTableImageDS.php?idDS=%@",urlLocalhost,idDS];
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
    NSString *url = [NSString stringWithFormat:@"%@/getTableFloor.php?idDS=%@",urlLocalhost,idDS];
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
    NSString *url = [NSString stringWithFormat:@"%@/getTableLinkFloorStore.php?idFloor=%@",urlLocalhost,idFloor];
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
    NSString *url = [NSString stringWithFormat:@"%@/getTableStore.php?idStore=%@",urlLocalhost,idStore];
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
    NSString *url = [NSString stringWithFormat:@"%@/getTableImageStore.php?idStore=%@",urlLocalhost,idStore];
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

@end

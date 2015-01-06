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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"Offline List";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //call initDatabse : use to check connected MapDepartmentStore.sqlite
    [self initDatabase];
    //call getDepartmentStore : connect DB & use data from MapDepartmentStore.sqlite
    [self getDepartmentStore];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [listOfidDS count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleIdentifier];
    }
    
    // Cell Label text = "nameDS"
    cell.textLabel.text = [listOfnameDS objectAtIndex:indexPath.row];
    
    // Cell Detail text = "branchDS"
    NSString *detailText = @"สาขา ";
    NSString *callDetail = [listOfbranchDS objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [detailText stringByAppendingString:callDetail];
    
    // Cell Image = "logoDS"
    cell.imageView.image = [listOflogoDS objectAtIndex:indexPath.row];
    
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

-(void)getDepartmentStore
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
            listOfidDS = [[NSMutableArray alloc] init];
            listOfnameDS = [[NSMutableArray alloc] init];
            listOfbranchDS = [[NSMutableArray alloc] init];
            listOflogoDS = [[NSMutableArray alloc] init];
            
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
                NSData *logo = UIImagePNGRepresentation(imageLogo);
                if ((char*)sqlite3_column_text(searchStament, 3) != NULL)
                {
                    logo = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 3) length:sqlite3_column_bytes(searchStament, 3)];
                    if ([logo length] != 0)
                    {
                        imageLogo = [UIImage imageWithData:logo];
                    }
                }
                
                /*
                NSLog(@"id: %@", idDS);
                NSLog(@"name: %@", name);
                NSLog(@"branch: %@", branch);
                NSLog(@"logo: %@", logo);
                NSLog(@"image: %@", imageLogo);
                */
                
                [listOfidDS addObject:idDS];
                [listOfnameDS addObject:name];
                [listOfbranchDS addObject:branch];
                [listOflogoDS addObject:imageLogo];
                
                //NSLog(@"count of idDS: %lu",(unsigned long)[listOfidDS count]);
            }
        }
        sqlite3_finalize(searchStament);

    }
}

@end

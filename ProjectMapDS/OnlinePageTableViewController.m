//
//  OnlinePageTableViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlinePageTableViewController.h"

@interface OnlinePageTableViewController ()

@end

@implementation OnlinePageTableViewController
{
    NSMutableArray *listOfDS;
    
    NSDictionary *dictDS;
    
    NSString *idDS;
    NSString *nameDS;
    NSString *branchDS;
    NSString *logoDS;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"Online List";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //call getDepartmentStore : connect DB & use data from URL
    [self getDepartmentStore];
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
    return [listOfDS count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
 {
     static  NSString *simpleIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier forIndexPath:indexPath];
     
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleIdentifier];
     }
     
     NSDictionary *tmpDict = [listOfDS objectAtIndex:indexPath.row];
     
     // Cell Label text = "nameDS"
     NSString *text = [tmpDict objectForKey:nameDS];
     cell.textLabel.text = text;
     
     // Cell Detail text = "branchDS"
     NSString *detail = [tmpDict objectForKey:branchDS];
     cell.detailTextLabel.text = [@"สาขา " stringByAppendingString:detail];;
     
     // Cell Image = "logoDS"
     cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
     cell.imageView.image = [tmpDict objectForKey:logoDS];
     
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
    OnlineTabBarDSViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineTabBarDSViewController"];
    NSDictionary *tmpDict = [listOfDS objectAtIndex:indexPath.row];
    dataID = [tmpDict objectForKey:idDS];
    [self.navigationController pushViewController:destView animated:YES];
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getDepartmentStore
{
    idDS = @"idDS";
    nameDS = @"nameDS";
    branchDS = @"branchDS";
    logoDS = @"logoDS";
    
    listOfDS = [[NSMutableArray alloc] init];
    
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://localhost/projectDS/getDSList.php"]];
    
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
        
        dictDS = [NSDictionary dictionaryWithObjectsAndKeys:
                      idDS_data, idDS,
                      nameDS_data, nameDS,
                      branchDS_data, branchDS,
                      imageLogo, logoDS,
                      nil];
        [listOfDS addObject:dictDS];
    }
}

@end

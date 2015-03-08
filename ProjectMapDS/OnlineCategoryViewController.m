//
//  OnlineCategoryViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineCategoryViewController.h"
#import "OnlineTabBarDSViewController.h"   //use Global variable: dataID, dataFloor

@interface OnlineCategoryViewController ()

@end

@implementation OnlineCategoryViewController
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
    
    OnlineTabBarStoreViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineTabBarStoreViewController"];
    storeID = store;
    [self.navigationController pushViewController:destView animated:YES];
}

//method
-(void)getCategory:(NSString *) floor  //get array of Category Section Title
{
    category = [[NSMutableArray alloc] init];
    
    NSString *url_floor = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)floor, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getCategory.php?idDS=%@&floor=%@",dataID,url_floor];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getCategory.php?idDS=%@&floor=%@",dataID,url_floor];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *category_data = [dataDict objectForKey:@"category"];
        [category addObject:category_data];
    }
}

-(void)getShopCategory:(NSString *) floor //get data Store
{
    shopCategory = [[NSMutableDictionary alloc] init];
    idShopCategory = [[NSMutableDictionary alloc] init];
    floorShopCategory = [[NSMutableDictionary alloc] init];
    
    for (NSString *keyCategory in category)
    {
        NSString *url_keyCategory = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)keyCategory, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        NSString *url_floor = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)floor, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getCategoryShop.php?idDS=%@&category=%@&floor=%@",dataID,url_keyCategory,url_floor];
        //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getCategoryShop.php?idDS=%@&category=%@&floor=%@",dataID,url_keyCategory,url_floor];
        NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *arrName = [[NSMutableArray alloc] init];
        NSMutableArray *arrID = [[NSMutableArray alloc] init];
        NSMutableArray *arrFloor = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dataDict in jsonObjects)
        {
            NSString *idStore_data = [dataDict objectForKey:@"idStore"];
            
            NSString *nameStore_data = [dataDict objectForKey:@"nameStore"];
            
            NSString *floorStore = [self getStringFloor:idStore_data];
            
            [arrName addObject:nameStore_data];
            [arrID addObject:idStore_data];
            [arrFloor addObject:floorStore];
        }
        //add Key:category and Value:shop in Dict.
        [shopCategory setValue:arrName forKey:keyCategory];
        [idShopCategory setValue:arrID forKey:keyCategory];
        [floorShopCategory setValue:arrFloor forKey:keyCategory];
    }
}

-(NSString *)getStringFloor:(NSString *) shop
{
    NSString *strFloor = @"";
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getShopFloor.php?idDS=%@&idStore=%@",dataID,shop];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getShopFloor.php?idDS=%@&idStore=%@",dataID,shop];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *floor_data = [dataDict objectForKey:@"floor"];
        
        if ([strFloor isEqual:@""])
        {
            strFloor = [strFloor stringByAppendingString:floor_data];
        }
        else
        {
            strFloor = [strFloor stringByAppendingString:@", "];
            strFloor = [strFloor stringByAppendingString:floor_data];
        }
    }
    
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
        //[self getCategory:@"%"];
        //[self getShopCategory:@"%"];
        [self showCategory:@"%"];
        [self.onlineCategoryTable reloadData];
    }
    else if (buttonIndex != [dataFloor count]+1)
    {
        titleRightButton = [NSString stringWithFormat:@"%@ Floor",dataFloor[buttonIndex-1]];
        [self.parentViewController.navigationItem.rightBarButtonItem setTitle:titleRightButton];
        //[self getCategory:dataFloor[buttonIndex-1]];
        //[self getShopCategory:dataFloor[buttonIndex-1]];
        [self showCategory:dataFloor[buttonIndex-1]];
        [self.onlineCategoryTable reloadData];
    }
}

//call mathod for SHOW FloorPlan
-(void)showCategory:(NSString *) floor
{
    //for TEST data value:NULL
    if ([dataFloor[0]  isEqual: @"%"]) {
        return;
    }
    
    //call method for Database
    [self getCategory:floor];
    [self getShopCategory:floor];
}

@end

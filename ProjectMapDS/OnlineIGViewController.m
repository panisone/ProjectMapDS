//
//  OnlineIGViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 4/15/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineIGViewController.h"
#import "OnlineTabBarDSViewController.h"    //use Global variable: dataID, dataFloor
#import "URL_GlobalVar.h"                   //use Global variable: urlLocalhost

@interface OnlineIGViewController ()
{
    NSString *countLocation;
    NSString *countTag;
    NSString *count;
    
    NSString *totalLocation;
    NSString *totalTag;
    NSString *total;
    
    NSMutableArray *igLocation;
    NSMutableArray *igTag;
}
@end

@implementation OnlineIGViewController
@synthesize onlineCollectionView;
@synthesize segment;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"";
    //self.navigationController.navigationBar.topItem.title = @"";
    self.parentViewController.navigationItem.rightBarButtonItems = nil;
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    igLocation = [[NSMutableArray alloc] init];
    igTag = [[NSMutableArray alloc] init];
    
    segment.selectedSegmentIndex = 0;
    countLocation = @"0";
    totalLocation = @"0";
    countTag = @"0";
    totalTag = @"0";
    
    [self getTotalIG];
    [self instagram];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (segment.selectedSegmentIndex == 0)
    {
        count = countTag;
        total = totalTag;
        return [igTag count];
    }
    else
    {
        count = countLocation;
        total = totalLocation;
        return [igLocation count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *SimpleIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SimpleIdentifier forIndexPath:indexPath];
    
    UIImageView *igImageView = (UIImageView *)[cell viewWithTag:100];
    //igImageView.image = [UIImage imageNamed:@"Info-icon.png"];
    
    if (segment.selectedSegmentIndex == 0)
    {
        NSDictionary *dict = [igTag objectAtIndex:indexPath.row];
        NSString *url_Img = [dict objectForKey:@"imageThumbnail"];
        NSData *data_Img = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img]];
        igImageView.image = [UIImage imageWithData:data_Img];
        //NSLog(@"%ld -> %@ | %@",(long)indexPath.row,url_Img,data_Img);
    }
    else
    {
        NSDictionary *dict = [igLocation objectAtIndex:indexPath.row];
        NSString *url_Img = [dict objectForKey:@"imageThumbnail"];
        NSData *data_Img = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img]];
        igImageView.image = [UIImage imageWithData:data_Img];
        //NSLog(@"%ld -> %@ | %@",(long)indexPath.row,url_Img,data_Img);
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idIG;
    NSString *type;
    
    if (segment.selectedSegmentIndex == 0)
    {
        NSDictionary *dict = [igTag objectAtIndex:indexPath.row];
        idIG = [dict objectForKey:@"idIG"];
        type = @"Tag";
    }
    else
    {
        NSDictionary *dict = [igLocation objectAtIndex:indexPath.row];
        idIG = [dict objectForKey:@"idIG"];
        type = @"Location";
    }
    
    OnlineIGDetailViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineIGDetailViewController"];
    destView.idIG = idIG;
    destView.type = type;
    [self.navigationController pushViewController:destView animated:YES];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //NSLog(@"count:%@ total:%@",count,total);
    
    if ([count isEqual:total])
    {
        return CGSizeZero;
    }
    else
    {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 40);
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        
        reusableview = footerView;
    }
    
    return reusableview;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//method
-(void)instagram
{
    if (segment.selectedSegmentIndex == 0)
    {
        [self getIGType_Tag];
    }
    else
    {
        [self getIGType_Location];
    }
    
    [self.onlineCollectionView reloadData];
}

-(void)getIGType_Location
{
    NSString *url = [NSString stringWithFormat:@"%@/getIGLocation.php?idDS=%@&start=%@",urlLocalhost,dataID,countLocation];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *idIG_data = [dataDict objectForKey:@"idIG"];
        
        NSString *imageThumbnail_data = [dataDict objectForKey:@"imageThumbnail"];
        
        NSDictionary *dictIG = [NSDictionary dictionaryWithObjectsAndKeys:
                                idIG_data, @"idIG",
                                imageThumbnail_data, @"imageThumbnail",
                                nil];
        [igLocation addObject:dictIG];
    }
    
    countLocation = [NSString stringWithFormat:@"%lu",(unsigned long)[igLocation count]];
    //NSLog(@"dataID:%@ countLocation:%@",dataID,countLocation);
    //NSLog(@"location: %@",igLocation);
}

-(void)getIGType_Tag
{
    NSString *url = [NSString stringWithFormat:@"%@/getIGTag.php?idDS=%@&start=%@",urlLocalhost,dataID,countTag];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *idIG_data = [dataDict objectForKey:@"idIG"];
        
        NSString *imageThumbnail_data = [dataDict objectForKey:@"imageThumbnail"];
        
        NSDictionary *dictIG = [NSDictionary dictionaryWithObjectsAndKeys:
                                idIG_data, @"idIG",
                                imageThumbnail_data, @"imageThumbnail",
                                nil];
        [igTag addObject:dictIG];
    }
    
    countTag = [NSString stringWithFormat:@"%lu",(unsigned long)[igTag count]];
    //NSLog(@"dataID:%@ countLocation:%@",dataID,countTag);
    //NSLog(@"location: %@",igTag);
}

-(void)getTotalIG
{
    NSString *url_local = [NSString stringWithFormat:@"%@/getIGLocationTotal.php?idDS=%@",urlLocalhost,dataID];
    NSData *jsonSource_local = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_local]];
    
    id jsonObjects_local = [NSJSONSerialization JSONObjectWithData:jsonSource_local options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects_local)
    {
        totalLocation = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"Total"]];
    }
    
    //NSLog(@"Total location: %@",totalLocation);
    
    NSString *url_tag = [NSString stringWithFormat:@"%@/getIGTagTotal.php?idDS=%@",urlLocalhost,dataID];
    NSData *jsonSource_tag = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_tag]];
    
    id jsonObjects_tag = [NSJSONSerialization JSONObjectWithData:jsonSource_tag options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects_tag)
    {
        totalTag = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"Total"]];
    }
    
    //NSLog(@"Total tag: %@",totalTag);
}

- (IBAction)selectSegment:(id)sender
{
    if ([igLocation count] == 0)
    {
        [self getIGType_Location];
    }
    
    [self.onlineCollectionView setContentOffset:CGPointZero animated:NO];
    [self.onlineCollectionView reloadData];
}

- (IBAction)actionIGSeeMore:(id)sender
{
    [self instagram];
}

@end

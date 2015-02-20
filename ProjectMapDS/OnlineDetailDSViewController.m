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
}
@synthesize nameLabel,branchLabel,logoImage,detailTextView;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Detail DS";
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
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
        floor = [@"Floor: \n" stringByAppendingString:@"-"];
    }
    else
    {
        floor = [@"Floor: \n" stringByAppendingString:floor];
    }
}

@end

//
//  OnlineTabBarStoreViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineTabBarStoreViewController.h"

NSString *storeID;  //Global variable
NSMutableArray *storeFloor;  //Global variable

@interface OnlineTabBarStoreViewController ()

@end

@implementation OnlineTabBarStoreViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = storeID;
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getFloorStore];
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

-(void)getFloorStore
{
    storeFloor = [[NSMutableArray alloc] init];
    
    //NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getStoreFloor.php?idStore=%@",storeID];
    NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getStoreFloor.php?idStore=%@",storeID];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *floor_data = [dataDict objectForKey:@"floor"];
        [storeFloor addObject:floor_data];
    }
    
    //test case: no data
    if ([storeFloor count] == 0)
    {
        [storeFloor addObject:@"%"];
    }
}

@end

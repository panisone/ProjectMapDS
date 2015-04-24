//
//  OnlineTabBarDSViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineTabBarDSViewController.h"
#import "URL_GlobalVar.h"                   //use Global variable: urlLocalhost

NSString *dataID;           //Global variable
NSMutableArray *dataFloor;  //Global variable

@interface OnlineTabBarDSViewController ()

@end

@implementation OnlineTabBarDSViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = dataID;
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getFloorDS];
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

-(void)getFloorDS
{
    dataFloor = [[NSMutableArray alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/getDSFloor.php?idDS=%@",urlLocalhost,dataID];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        //NSString *idFloor_data = [dataDict objectForKey:@"idFloor"];
        NSString *floor_data = [dataDict objectForKey:@"floor"];
        
        //NSLog(@"DS Floor id: %@",idFloor_data);
        //NSLog(@"DS Floor name: %@",floor_data);
        
        [dataFloor addObject:floor_data];
    }
    
    //test case: no data
    if ([dataFloor count] == 0) {
        [dataFloor addObject:@"%"];
    }
}

@end

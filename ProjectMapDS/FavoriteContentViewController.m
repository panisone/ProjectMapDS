//
//  FavoriteContentViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/15/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "FavoriteContentViewController.h"

@interface FavoriteContentViewController ()

@end

@implementation FavoriteContentViewController
@synthesize imageView;
@synthesize imageStore;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = imageStore;
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

@end

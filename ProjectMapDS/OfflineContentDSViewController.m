//
//  OfflineContentDSViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/11/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OfflineContentDSViewController.h"

@interface OfflineContentDSViewController ()

@end

@implementation OfflineContentDSViewController
@synthesize scroll,imageView;
@synthesize imageDS;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = imageDS;
    
    //set Scroll view
    [scroll setDelegate:self];
    [scroll setMinimumZoomScale:1.0];
    [scroll setMaximumZoomScale:3.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
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

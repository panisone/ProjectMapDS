//
//  OnlineContentDSViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineContentDSViewController.h"

@interface OnlineContentDSViewController ()

@end

@implementation OnlineContentDSViewController
@synthesize scroll,imageView;
@synthesize imageDS;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //set image to Show
    scroll.zoomScale = 1.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = imageDS;
    
    //set Scroll view
    [scroll setDelegate:self];
    [scroll setMinimumZoomScale:1.0];
    [scroll setMaximumZoomScale:3.0];
    
    scroll.contentSize = imageView.frame.size;
    
    float min = 1.0;
    float scaleW = self.view.frame.size.width/imageView.frame.size.width;
    float scaleH = (self.view.frame.size.height-64-49-37)/imageView.frame.size.height;
    if (MIN(scaleW, scaleH) > 1)
    {
        min = MIN(scaleW, scaleH);
    }
    [scroll setMinimumZoomScale:min];
    scroll.zoomScale = min;
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

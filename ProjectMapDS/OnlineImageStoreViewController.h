//
//  OnlineImageStoreViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineContentStoreViewController.h"

@interface OnlineImageStoreViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

-(void)getImageStore;

@end

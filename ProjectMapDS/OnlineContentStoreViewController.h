//
//  OnlineContentStoreViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineContentStoreViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) UIImage *imageStore;
@property NSUInteger pageIndex;

@end

//
//  FavoriteContentViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/15/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) UIImage *imageStore;
@property NSUInteger pageIndex;

@end

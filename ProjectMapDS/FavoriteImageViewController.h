//
//  FavoriteImageViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/15/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FavoriteContentViewController.h"

@interface FavoriteImageViewController : UIViewController <UIPageViewControllerDataSource>
{
    sqlite3 *database;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;

-(void)initDatabase;
-(void)getImageStore;

@end

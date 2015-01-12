//
//  OfflineImageDSViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/11/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "OfflineContentDSViewController.h"

@interface OfflineImageDSViewController : UIViewController <UIPageViewControllerDataSource>
{
    sqlite3 *database;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;

-(void)initDatabase;
-(void)getImageDS;

@end

//
//  AppDelegate.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>

//assign "class" for SQLite
@class OfflinePageTableViewController;
@class OfflineDetailDSViewController;
@class OfflineCategoryViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    OfflinePageTableViewController *offlinePageTableViewController;
    OfflineDetailDSViewController *offlineDetailDSViewController;
    OfflineCategoryViewController *offlineCategoryViewController;
}

@property (strong, nonatomic) UIWindow *window;


@end


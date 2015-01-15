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
@class OfflineTabBarDSViewController;
@class OfflineDetailDSViewController;
@class OfflineFloorPlanViewController;
@class OfflineCategoryViewController;

@class FavoritePageTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    OfflinePageTableViewController *offlinePageTableViewController;
    OfflineTabBarDSViewController *offlineTabBarDSViewController;
    OfflineDetailDSViewController *offlineDetailDSViewController;
    OfflineFloorPlanViewController *offlineFloorPlanViewController;
    OfflineCategoryViewController *offlineCategoryViewController;
    
    FavoritePageTableViewController *favoritePageTableViewController;
}

@property (strong, nonatomic) UIWindow *window;


@end


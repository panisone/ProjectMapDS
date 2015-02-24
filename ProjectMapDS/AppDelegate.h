//
//  AppDelegate.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>

//assign "class" for SQLite
@class testViewController;

@class OnlineDetailDSViewController;

@class OfflinePageTableViewController;
@class OfflineTabBarDSViewController;
@class OfflineDetailDSViewController;
@class OfflineImageDSViewController;
@class OfflineFloorPlanViewController;
@class OfflineCategoryViewController;
@class OfflineTabBarStoreViewController;
@class OfflineDetailStoreViewController;
@class OfflineImageStoreViewController;
@class OfflinePositionViewController;

@class FavoritePageTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    testViewController *testViewController;
    
    OnlineDetailDSViewController *onlineDetailDSViewController;
    
    OfflinePageTableViewController *offlinePageTableViewController;
    OfflineTabBarDSViewController *offlineTabBarDSViewController;
    OfflineDetailDSViewController *offlineDetailDSViewController;
    OfflineImageDSViewController *offlineImageDSViewController;
    OfflineFloorPlanViewController *offlineFloorPlanViewController;
    OfflineCategoryViewController *offlineCategoryViewController;
    OfflineTabBarStoreViewController *offlineTabBarStoreViewController;
    OfflineDetailStoreViewController *offlineDetailStoreViewController;
    OfflineImageStoreViewController *offlineImageStoreViewController;
    OfflinePositionViewController *offlinePositionViewController;
    
    FavoritePageTableViewController *favoritePageTableViewController;
}

@property (strong, nonatomic) UIWindow *window;


@end


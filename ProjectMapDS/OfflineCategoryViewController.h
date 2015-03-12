//
//  OfflineCategoryViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/8/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "OfflineTabBarStoreViewController.h"    //next to Offline TabBar Store Page

@interface OfflineCategoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIActionSheetDelegate>
{
    sqlite3 *database;
}

@property (strong, nonatomic) IBOutlet UITableView *offlineCategoryTable;
@property (strong, nonatomic) IBOutlet UISearchBar *offlineSearchBar;

-(void)initDatabase;
-(void)getCategory:(NSString *) floor;
-(void)getShopCategory:(NSString *) floor;
-(NSString *)getStringFloor:(NSString *) shop;

@end

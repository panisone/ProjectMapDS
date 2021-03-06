//
//  OfflinePageTableViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "OfflineTabBarDSViewController.h"   //next to Offline TabBar DS Page

@interface OfflinePageTableViewController : UITableViewController <UISearchBarDelegate>
{
    sqlite3 *database;
}

@property (strong, nonatomic) IBOutlet UISearchBar *offlineSearchBar;

-(void)initDatabase;
-(void)getDepartmentStore;

@end

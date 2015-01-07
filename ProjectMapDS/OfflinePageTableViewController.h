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
#import "OfflineDetailDSViewController.h"   //next to Offline Detail DS Page

@interface OfflinePageTableViewController : UITableViewController
{
    sqlite3 *database;
}

-(void)initDatabase;
-(void)getDepartmentStore;

@end

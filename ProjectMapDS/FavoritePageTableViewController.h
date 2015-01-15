//
//  FavoritePageTableViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FavoriteTabBarViewController.h"    //next to Favorite TabBar Page

@interface FavoritePageTableViewController : UITableViewController
{
    sqlite3 *database;
}

-(void)initDatabase;
-(void)getFavorite;

@end

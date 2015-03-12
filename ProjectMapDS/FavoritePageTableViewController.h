//
//  FavoritePageTableViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "OfflineTabBarStoreViewController.h"    //next to Offline TabBar Store Page

@interface FavoritePageTableViewController : UITableViewController <UISearchBarDelegate>
{
    sqlite3 *database;
}

@property (strong, nonatomic) IBOutlet UISearchBar *favoriteSearchBar;

-(void)initDatabase;
-(void)getFavorite;

@end

//
//  FavoriteTabBarViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/15/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

extern NSString *storeID;           //Global variable
extern NSMutableArray *storeFloor;  //Global variable

@interface FavoriteTabBarViewController : UITabBarController
{
    sqlite3 *database;
}

-(void)initDatabase;
-(void)getFloorStore;

@end

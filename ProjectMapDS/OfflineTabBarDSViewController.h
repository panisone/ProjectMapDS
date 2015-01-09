//
//  OfflineTabBarDSViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/7/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

extern NSString *dataID;    //Global variable
extern NSMutableArray *dataFloor;

@interface OfflineTabBarDSViewController : UITabBarController
{
    sqlite3 *database;
}

-(void)initDatabase;
-(void)getFloorDS;

@end

//
//  OfflineCategoryViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/8/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface OfflineCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 *database;
}

-(void)initDatabase;
-(void)getCategory:(NSString *) floor;
-(void)getShopCategory:(NSString *) floor;
-(NSString *)getStringFloor:(NSString *) shop;

@end

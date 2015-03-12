//
//  OnlineCategoryViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineTabBarStoreViewController.h"    //next to Online TabBar Store Page

@interface OnlineCategoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *onlineCategoryTable;
@property (strong, nonatomic) IBOutlet UISearchBar *onlineSearchBar;

-(void)getCategory:(NSString *) floor;
-(void)getShopCategory:(NSString *) floor;
-(NSString *)getStringFloor:(NSString *) shop;

@end

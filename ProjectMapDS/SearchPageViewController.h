//
//  SearchPageViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 4/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ActionSheetPicker.h"
#import "OnlineTabBarDSViewController.h"        //next to Online TabBar DS Page
#import "OnlineTabBarStoreViewController.h"     //next to Online TabBar Store Page
#import "OfflineTabBarDSViewController.h"       //next to Offline TabBar DS Page
#import "OfflineTabBarStoreViewController.h"    //next to Offline TabBar Store Page

@interface SearchPageViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    sqlite3 *database;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchTextBar;
@property (strong, nonatomic) IBOutlet UITextField *searchType;
@property (strong, nonatomic) IBOutlet UITextField *searchCategory;
@property (strong, nonatomic) IBOutlet UITableView *searchTable;

@property (nonatomic, assign) NSInteger selectedIndexType;
@property (nonatomic, assign) NSInteger selectedIndexCategory;

- (IBAction)selectType:(id)sender;
- (IBAction)selectCategory:(id)sender;

-(void)checkNetworkConnection;

//
// INIT-DB SQLite
//
-(void)initDatabase;

//
// SQLite
//
-(void)selectDepartmentStore;
-(void)selectCategory;
-(void)selectStore;

//
// SQL Server
//
-(void)getDepartmentStore;
-(void)getCategory;
-(void)getStore;

@end

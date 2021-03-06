//
//  OnlineDetailDSViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface OnlineDetailDSViewController : UIViewController
{
    sqlite3 *database;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *branchLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

-(void)getDetailDS;
-(void)getFloorDS;

//
// INIT-DB SQLite
//
-(void)initDatabase;

//
// CHECK
//
-(NSString *)checkData:(NSString *)idDS;

//
// DOWNLOAD
//
-(void)downloadData:(NSString *)idDS;

//
//
// SQLite
//
//
-(void)selectTableDepartmentStore:(NSString *)idDS;
-(void)selectTableFloor:(NSString *)idDS;
-(void)selectTableLinkFloorStore:(NSString *)idFloor;

-(void)deleteTableDepartmentStore:(NSString *)idDS;
-(void)deleteTableImageDS:(NSString *)idDS;
-(void)deleteTableFloor:(NSString *)idDS;
-(void)deleteTableLinkFloorStore:(NSString *)idFloor;
-(void)deleteTableStore:(NSString *)idStore;
-(void)deleteTableImageStore:(NSString *)idStore;
-(void)deleteTableFavorite:(NSString *)idStore;

-(void)insertTableDepartmentStore:(NSMutableArray *)arr;
-(void)insertTableImageDS:(NSMutableArray *)arr;
-(void)insertTableFloor:(NSMutableArray *)arr;
-(void)insertTableLinkFloorStore:(NSMutableArray *)arr;
-(void)insertTableStore:(NSMutableArray *)arr;
-(void)insertTableImageStore:(NSMutableArray *)arr;

//
//
// SQL Server
//
//
-(void)getTableDepartmentStore:(NSString *)idDS;
-(void)getTableImageDS:(NSString *)idDS;
-(void)getTableFloor:(NSString *)idDS;
-(void)getTableLinkFloorStore:(NSString *)idFloor;
-(void)getTableStore:(NSString *)idStore;
-(void)getTableImageStore:(NSString *)idStore;

@end

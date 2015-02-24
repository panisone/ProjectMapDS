//
//  OfflineDetailDSViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/7/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface OfflineDetailDSViewController : UIViewController
{
    sqlite3 *database;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *branchLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

-(void)initDatabase;
-(void)getDetailDS;
-(void)getFloorDS;

//
// DELETE
//
-(void)deleteData:(NSString *)idDS;

//
//
// SQLite
//
//
-(void)selectTableFloor:(NSString *)idDS;
-(void)selectTableLinkFloorStore:(NSString *)idFloor;

-(void)deleteTableDepartmentStore:(NSString *)idDS;
-(void)deleteTableImageDS:(NSString *)idDS;
-(void)deleteTableFloor:(NSString *)idDS;
-(void)deleteTableLinkFloorStore:(NSString *)idFloor;
-(void)deleteTableStore:(NSString *)idStore;
-(void)deleteTableImageStore:(NSString *)idStore;
-(void)deleteTableFavorite:(NSString *)idStore;

@end

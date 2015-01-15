//
//  FavoriteDetailViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/15/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface FavoriteDetailViewController : UIViewController <UIActionSheetDelegate>
{
    sqlite3 *database;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *branchLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

-(void)initDatabase;
-(void)getDetailStore;
-(void)getFavorite;
-(void)addFavorite;
-(void)removeFavorite;

-(NSString *)getStringAddressNumber;

@end

//
//  OnlineDetailStoreViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineDetailStoreViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *branchLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

-(void)getDetailStore;

-(NSString *)getStringAddressNumber;

@end

//
//  OnlineIGDetailViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 4/16/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineIGDetailViewController : UIViewController

@property (nonatomic,retain) NSString *idIG;
@property (nonatomic,retain) NSString *type;

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *igImage;
@property (strong, nonatomic) IBOutlet UITextView *captionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *commentImage;

-(void)getDetailWithLocation;
-(void)getDetailWithTag;

@end

//
//  OnlineReviewViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 4/18/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@interface OnlineReviewViewController : UIViewController <CustomIOSAlertViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *onlineCollectionReview;
@property (strong, nonatomic) IBOutlet UILabel *totalReviewLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleReviewLabel;

-(void)getReview;
-(void)getReviewCount;
-(void)insertReview:(NSString *)reviewScore name:(NSString *)reviewName comment:(NSString *)reviewComment;

- (IBAction)writeReview:(id)sender;

@end

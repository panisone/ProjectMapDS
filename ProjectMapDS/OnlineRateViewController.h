//
//  OnlineRateViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface OnlineRateViewController : UIViewController <RatingViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *countRatingLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentStar5Label;
@property (strong, nonatomic) IBOutlet UILabel *percentStar4Label;
@property (strong, nonatomic) IBOutlet UILabel *percentStar3Label;
@property (strong, nonatomic) IBOutlet UILabel *percentStar2Label;
@property (strong, nonatomic) IBOutlet UILabel *percentStar1Label;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;

@property (strong, nonatomic) IBOutlet UIView *rateView;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *rateButton;

- (IBAction)selectSegment:(id)sender;
- (IBAction)insertRate:(id)sender;

-(void)getRating:(NSString *)score;

@end

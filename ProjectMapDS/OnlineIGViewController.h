//
//  OnlineIGViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 4/15/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineIGDetailViewController.h"   //next to Online IG Detail Page

@interface OnlineIGViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *onlineCollectionView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;

-(void)instagram;
-(void)getIGType_Location;
-(void)getIGType_Tag;
-(void)getTotalIG;

- (IBAction)selectSegment:(id)sender;
- (IBAction)actionIGSeeMore:(id)sender;

@end

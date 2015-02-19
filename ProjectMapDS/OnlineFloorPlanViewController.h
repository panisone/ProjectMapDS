//
//  OnlineFloorPlanViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OnlineTabBarStoreViewController.h"    //next to Online TabBar Store Page

@interface OnlineFloorPlanViewController : UIViewController <UIActionSheetDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIImageView *floorImage;

-(void)getFloorPlan:(NSString *) floor;

@end

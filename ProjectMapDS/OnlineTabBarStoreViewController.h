//
//  OnlineTabBarStoreViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *storeID;           //Global variable
extern NSMutableArray *storeFloor;  //Global variable

@interface OnlineTabBarStoreViewController : UITabBarController

-(void)getFloorStore;

@end

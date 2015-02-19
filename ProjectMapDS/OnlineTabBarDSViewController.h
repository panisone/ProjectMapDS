//
//  OnlineTabBarDSViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *dataID;            //Global variable
extern NSMutableArray *dataFloor;   //Global variable

@interface OnlineTabBarDSViewController : UITabBarController

-(void)getFloorDS;

@end

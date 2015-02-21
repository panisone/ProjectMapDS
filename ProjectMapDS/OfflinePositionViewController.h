//
//  OfflinePositionViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/22/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface OfflinePositionViewController : UIViewController <UIActionSheetDelegate,UIScrollViewDelegate>
{
    sqlite3 *database;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIImageView *floorImage;

-(void)initDatabase;
-(void)getFloorPlan:(NSString *) floor;

@end

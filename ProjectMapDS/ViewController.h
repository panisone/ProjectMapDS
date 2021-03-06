//
//  ViewController.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlinePageTableViewController.h"   //next to Online Page
#import "OfflinePageTableViewController.h"  //next to Offline Page
#import "FavoritePageTableViewController.h" //next to Favorite Page
#import "SearchPageViewController.h"        //next to Search Page

@interface ViewController : UIViewController

- (IBAction)InfoView:(id)sender;
- (IBAction)OnlinePage:(id)sender;
- (IBAction)OfflinePage:(id)sender;
- (IBAction)FavoritePage:(id)sender;
- (IBAction)SearchPage:(id)sender;

@end


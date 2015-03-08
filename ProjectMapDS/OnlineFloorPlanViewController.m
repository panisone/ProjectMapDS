//
//  OnlineFloorPlanViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineFloorPlanViewController.h"
#import "OnlineTabBarDSViewController.h"        //use Global variable: dataID, dataFloor

@interface OnlineFloorPlanViewController ()

@end

@implementation OnlineFloorPlanViewController
{
    NSString *titleRightButton;
    UIImage *image;
}
@synthesize scroll,floorImage;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Map DS";
    //self.navigationController.navigationBar.topItem.title = @"back";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:titleRightButton
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)];
    self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
    //[self.parentViewController.navigationItem setRightBarButtonItem:rightButton animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //call method for Database
    [self showFloorPlan:dataFloor[0]];
    //set title Right Button
    titleRightButton = [NSString stringWithFormat:@"Floor: %@",dataFloor[0]];
    //set Scroll view
    [scroll setDelegate:self];
    [scroll setMinimumZoomScale:1.0];
    [scroll setMaximumZoomScale:4.0];
    
    scroll.userInteractionEnabled = YES;        //Solution Problem zoom image with button
    scroll.exclusiveTouch = YES;                //Solution Problem zoom image with button
    
    [floorImage setUserInteractionEnabled:YES]; //Solution Problem zoom image with button
    [floorImage setExclusiveTouch:YES];         //Solution Problem zoom image with button
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return floorImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)getFloorPlan:(NSString *) floor
{
    //NSURL *url_floor = [NSURL URLWithString:[floor stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *url_floor = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)floor, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getFloorPlan.php?idDS=%@&floor=%@",dataID,url_floor];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getFloorPlan.php?idDS=%@&floor=%@",dataID,url_floor];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *mapFloor_data = [dataDict objectForKey:@"mapFloor"];
        image = [UIImage imageNamed:@"Info-icon.png"];
        if ([mapFloor_data length] != 0) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:mapFloor_data options:0];
            image = [UIImage imageWithData:imageData];
        }
    }
}

//method for Right Button
-(void)rightFuntion
{
    UIActionSheet *func = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
    for (NSString *title in dataFloor) {
        [func addButtonWithTitle:title];
    }
    func.cancelButtonIndex = [func addButtonWithTitle:@"Cancel"];
    [func showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [dataFloor count])
    {
        //change title of Right Button
        titleRightButton = [NSString stringWithFormat:@"Floor: %@",dataFloor[buttonIndex]];
        [self.parentViewController.navigationItem.rightBarButtonItem setTitle:titleRightButton];
        
        //remove Button of page before
        for (UIView *subview in [floorImage subviews])
        {
            if (subview.tag == 1) {
                [subview removeFromSuperview];
            }
        }
        
        [self showFloorPlan:dataFloor[buttonIndex]];
    }
}

//call mathod for SHOW FloorPlan
-(void)showFloorPlan:(NSString *) floor
{
    //for TEST data value:NULL
    if ([dataFloor[0]  isEqual: @"%"]) {
        return;
    }
    
    //call method for Database
    [self getFloorPlan:floor];
    //set image to Show
    floorImage.image = image;
    //create Button on FloorPlan
    [self createButton:floor];
}

//create SUBVIEW for SHOW
-(void)createButton:(NSString *) floor
{
    //NSURL *url_floor = [NSURL URLWithString:[floor stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *url_floor = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)floor, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getFloorPlanButton.php?idDS=%@&floor=%@",dataID,url_floor];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getFloorPlanButton.php?idDS=%@&floor=%@",dataID,url_floor];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, floorImage.frame.size.width, floorImage.frame.size.height)];
    newView.tag = 1;
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *idStore = [dataDict objectForKey:@"idStore"];
        
        NSString *logoStore_data = [dataDict objectForKey:@"logoStore"];
        UIImage *imageButton = [UIImage imageNamed:@"Logo.png"];
        if ([logoStore_data length] != 0) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:logoStore_data options:0];
            imageButton = [UIImage imageWithData:imageData];
        }
        
        NSString *pointX = [dataDict objectForKey:@"pointX"];
        NSString *pointY = [dataDict objectForKey:@"pointY"];
        //NSString *width = [dataDict objectForKey:@"width"];
        NSString *height = [dataDict objectForKey:@"height"];
        
        //NSLog(@"id:%@ x:%@ y:%@ w:%@ h:%@",idStore,pointX,pointY,width,height);
        
        CGRect buttonFrame = CGRectMake([pointX intValue], [pointY intValue], [height intValue]*imageButton.size.width/imageButton.size.height, [height intValue]);
        
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        //set TAG is storeID
        button.tag = [idStore intValue];
        
        //test
        [button setTitle:idStore forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [button setBackgroundImage:imageButton forState:UIControlStateNormal];
        [button addTarget:self action:@selector(storeView:) forControlEvents:UIControlEventTouchUpInside];
        
        [newView addSubview:button];
    }
    
    [floorImage addSubview:newView];
}

-(void)storeView:(UIButton *) sender
{
    OnlineTabBarStoreViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineTabBarStoreViewController"];
    storeID = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self.navigationController pushViewController:destView animated:YES];
}

@end

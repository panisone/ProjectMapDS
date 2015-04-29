//
//  OnlineFloorPlanViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineFloorPlanViewController.h"
#import "OnlineTabBarDSViewController.h"    //use Global variable: dataID, dataFloor
#import "URL_GlobalVar.h"                   //use Global variable: urlLocalhost

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
    self.parentViewController.navigationItem.rightBarButtonItems = nil;
    self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
    //[self.parentViewController.navigationItem setRightBarButtonItem:rightButton animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set Scroll view
    [scroll setDelegate:self];
    [scroll setMinimumZoomScale:1.0];
    [scroll setMaximumZoomScale:4.0];
    
    scroll.contentSize = floorImage.frame.size;
    
    scroll.userInteractionEnabled = YES;        //Solution Problem zoom image with button
    scroll.exclusiveTouch = YES;                //Solution Problem zoom image with button
    
    [floorImage setUserInteractionEnabled:YES]; //Solution Problem zoom image with button
    [floorImage setExclusiveTouch:YES];         //Solution Problem zoom image with button
    
    //call method for Database
    [self showFloorPlan:dataFloor[0]];
    
    //set title Right Button
    titleRightButton = [NSString stringWithFormat:@"Floor: %@",dataFloor[0]];
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
    
    NSString *url = [NSString stringWithFormat:@"%@/getFloorPlan.php?idDS=%@&floor=%@",urlLocalhost,dataID,url_floor];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *mapFloor_data = [dataDict objectForKey:@"mapFloor"];
        image = [UIImage imageNamed:@"No-icon.png"];
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
    
    [scroll setMinimumZoomScale:1.0];
    scroll.zoomScale = 1.0;
    
    //call method for Database
    [self getFloorPlan:floor];
    
    //set image to Show
    floorImage.image = image;
    
    //create Button on FloorPlan
    [self createButton:floor];
    
    //set Scroll zoom Scale
    float min = 1.0;
    float scaleW = self.view.frame.size.width/floorImage.frame.size.width;
    float scaleH = (self.view.frame.size.height-64-49)/floorImage.frame.size.height;
    if (MIN(scaleW, scaleH) > 1)
    {
        min = MIN(scaleW, scaleH);
    }
    [scroll setMinimumZoomScale:min];
    scroll.zoomScale = min;
}

//create SUBVIEW for SHOW
-(void)createButton:(NSString *) floor
{
    //NSURL *url_floor = [NSURL URLWithString:[floor stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *url_floor = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)floor, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *url = [NSString stringWithFormat:@"%@/getFloorPlanButton.php?idDS=%@&floor=%@",urlLocalhost,dataID,url_floor];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, floorImage.frame.size.width, floorImage.frame.size.height)];
    newView.tag = 1;
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *idStore = [dataDict objectForKey:@"idStore"];
        
        NSString *logoStore_data = [dataDict objectForKey:@"logoStore"];
        UIImage *imageButton = [UIImage imageNamed:@"button-icon.png"];
        if ([logoStore_data length] != 0) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:logoStore_data options:0];
            imageButton = [UIImage imageWithData:imageData];
        }
        
        NSString *pointX = [dataDict objectForKey:@"pointX"];
        NSString *pointY = [dataDict objectForKey:@"pointY"];
        NSString *width = [dataDict objectForKey:@"width"];
        NSString *height = [dataDict objectForKey:@"height"];
        
        //NSLog(@"image w:%f h:%f",image.size.width,image.size.height);
        //NSLog(@"frame w:%f h:%f",floorImage.frame.size.width,floorImage.frame.size.height);
        //NSLog(@"id:%@ x:%@ y:%@ w:%@ h:%@",idStore,pointX,pointY,width,height);
        
        float frameX;
        float frameY;
        float diffX = 0;
        float diffY = 0;
        
        if (floorImage.frame.size.height > image.size.height*floorImage.frame.size.width/image.size.width)
        {
            frameX = floorImage.frame.size.width;
            frameY = floorImage.frame.size.width*image.size.height/image.size.width;
            
            diffY = (floorImage.frame.size.height-frameY)/2;
        }
        else
        {
            frameX = floorImage.frame.size.height*image.size.width/image.size.height;
            frameY = floorImage.frame.size.height;
            
            diffX = (floorImage.frame.size.width-frameX)/2;
        }
        
        //NSLog(@"cover w:%f h:%f",frameX,frameY);
        
        if (![pointX isEqual:@"-"] && ![pointY isEqual:@"-"])
        {
            float pX = ([pointX floatValue]*frameX)+diffX;
            float pY = ([pointY floatValue]*frameY)+diffY;
            float bWidth = [width floatValue]*frameX;
            float bHeight = [height floatValue]*frameY;
            float diffW = 0;
            float diffH = 0;
            
            //NSLog(@"button x:%f y:%f w:%f h:%f",pX,pY,bWidth,bHeight);
            //NSLog(@"frame w:%f h:%f",bWidth,bHeight);
            //NSLog(@"image w:%f h:%f",imageButton.size.width,imageButton.size.height);
            //NSLog(@"W: %f [-] %f",bWidth,imageButton.size.width*bHeight/imageButton.size.height);
            //NSLog(@"H: %f [-] %f",bHeight,imageButton.size.height*bWidth/imageButton.size.width);
            
            if (bHeight > imageButton.size.height*bWidth/imageButton.size.width)
            {
                diffH = (bHeight-bWidth*imageButton.size.height/imageButton.size.width)/2;
                bHeight = bWidth*imageButton.size.height/imageButton.size.width;
            }
            else
            {
                diffW = (bWidth-bHeight*imageButton.size.width/imageButton.size.height)/2;
                bWidth = bHeight*imageButton.size.width/imageButton.size.height;
            }
            
            //NSLog(@"cover[%@] w:%f h:%f",idStore,bWidth,bHeight);
            //NSLog(@"diff w:%f h:%f",diffW,diffH);
            
            CGRect buttonFrame = CGRectMake(pX+diffW, pY+diffH, bWidth, bHeight);
            
            UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
            
            //set TAG is storeID
            button.tag = [idStore intValue];
            
            //test
            //[button setTitle:idStore forState:UIControlStateNormal];
            //[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [button setBackgroundImage:imageButton forState:UIControlStateNormal];
            [button addTarget:self action:@selector(storeView:) forControlEvents:UIControlEventTouchUpInside];
            
            [newView addSubview:button];
        }
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

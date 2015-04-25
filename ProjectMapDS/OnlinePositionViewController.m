//
//  OnlinePositionViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/24/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlinePositionViewController.h"
#import "OnlineTabBarStoreViewController.h"     //use Global variable: storeID, storeFloor
#import "URL_GlobalVar.h"                       //use Global variable: urlLocalhost

@interface OnlinePositionViewController ()

@end

@implementation OnlinePositionViewController
{
    NSString *titleRightButton;
    UIImage *image;
}
@synthesize scroll,floorImage;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Position Store";
    //self.navigationController.navigationBar.topItem.title = @"back";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:titleRightButton
                                    style:UIBarButtonItemStyleDone
                                    target:self action:@selector(rightFuntion)];
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
    
    //call method for Database
    [self showFloorPlan:storeFloor[0]];
    
    //set title Right Button
    titleRightButton = [NSString stringWithFormat:@"Floor: %@",storeFloor[0]];
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
    NSString *url_floor = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)floor, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *url = [NSString stringWithFormat:@"%@/getStoreFloorPlan.php?idStore=%@&floor=%@",urlLocalhost,storeID,url_floor];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    image = [UIImage imageNamed:@"Info-icon.png"];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *mapFloor_data = [dataDict objectForKey:@"mapFloor"];
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
    for (NSString *title in storeFloor) {
        [func addButtonWithTitle:title];
    }
    func.cancelButtonIndex = [func addButtonWithTitle:@"Cancel"];
    
    if ([storeFloor count] != 1) {
        [func showInView:self.view];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [storeFloor count])
    {
        //change title of Right Button
        titleRightButton = [NSString stringWithFormat:@"Floor: %@",storeFloor[buttonIndex]];
        [self.parentViewController.navigationItem.rightBarButtonItem setTitle:titleRightButton];
        
        //remove Button of page before
        for (UIView *subview in [floorImage subviews])
        {
            if (subview.tag == 1) {
                [subview removeFromSuperview];
            }
        }
        
        //change image & call method create Button connect to Store
        [self showFloorPlan:storeFloor[buttonIndex]];
    }
}

//call mathod for SHOW FloorPlan
-(void)showFloorPlan:(NSString *) floor
{
    [scroll setMinimumZoomScale:1.0];
    scroll.zoomScale = 1.0;
    
    //call method for Database
    [self getFloorPlan:floor];
    
    //set image to Show
    floorImage.image = image;
    
    //create Button on FloorPlan
    [self createPoint:floor];
    
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
-(void)createPoint:(NSString *) floor
{
    NSString *url_floor = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)floor, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *url = [NSString stringWithFormat:@"%@/getStoreFloorPlanPiont.php?idStore=%@&floor=%@",urlLocalhost,storeID,url_floor];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, floorImage.frame.size.width, floorImage.frame.size.height)];
    newView.tag = 1;
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *pointX = [dataDict objectForKey:@"pointX"];
        NSString *pointY = [dataDict objectForKey:@"pointY"];
        NSString *width = [dataDict objectForKey:@"width"];
        NSString *height = [dataDict objectForKey:@"height"];
        
        //NSLog(@"id:%@ x:%@ y:%@ w:%@ h:%@",storeID,pointX,pointY,width,height);
        
        if (![width isEqual:@"0"] && ![height isEqual:@"0"])
        {
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
            
            float pX = ([pointX floatValue]*frameX)+diffX;
            float pY = ([pointY floatValue]*frameY)+diffY;
            float bWidth = [width floatValue]*frameX;
            float bHeight = [height floatValue]*frameY;
            
            CGRect imageFrame = CGRectMake(pX, pY, bWidth, bHeight);
            
            UIImage *imagePoint = [UIImage imageNamed:@"Point3-icon.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:imagePoint];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = imageFrame;
            
            //set TAG is "1"
            imageView.tag = 1;
            
            [floorImage addSubview:imageView];
        }
    }
}

@end

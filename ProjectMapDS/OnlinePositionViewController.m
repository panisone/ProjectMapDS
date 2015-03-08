//
//  OnlinePositionViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/24/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlinePositionViewController.h"
#import "OnlineTabBarStoreViewController.h"    //use Global variable: storeID, storeFloor

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
    //call method for Database
    [self showFloorPlan:storeFloor[0]];
    //set title Right Button
    titleRightButton = [NSString stringWithFormat:@"Floor: %@",storeFloor[0]];
    //set Scroll view
    [scroll setDelegate:self];
    [scroll setMinimumZoomScale:1.0];
    [scroll setMaximumZoomScale:4.0];
    //scroll.zoomScale = 1;
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
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getStoreFloorPlan.php?idStore=%@&floor=%@",storeID,url_floor];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getStoreFloorPlan.php?idStore=%@&floor=%@",storeID,url_floor];
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
    //call method for Database
    [self getFloorPlan:floor];
    //set image to Show
    floorImage.image = image;
    //create Button on FloorPlan
    [self createPoint:floor];
}

//create SUBVIEW for SHOW
-(void)createPoint:(NSString *) floor
{
    NSString *url_floor = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)floor, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getStoreFloorPlanPiont.php?idStore=%@&floor=%@",storeID,url_floor];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getStoreFloorPlanPiont.php?idStore=%@&floor=%@",storeID,url_floor];
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
        
        if (![pointX isEqual:@"-"] && ![pointY isEqual:@"-"]) {
            //set X & Y & SizeIcon
            int sizeIcon = MAX([width intValue], [height intValue]);
            int x = [pointX intValue]+([width intValue]/2)-(sizeIcon/2);
            int y = [pointY intValue]-(sizeIcon/2);
            if (x>320-sizeIcon && y<0) {
                y = [pointY intValue];
                sizeIcon = MIN([width intValue], [height intValue]);
            }
            else if (x>320-sizeIcon) {
                sizeIcon = [width intValue];
            }
            else if (y<0) {
                y = [pointY intValue];
                sizeIcon = [height intValue];
            }
            CGRect imageFrame = CGRectMake(x, y, sizeIcon, sizeIcon);
            
            UIImage *imagePoint = [UIImage imageNamed:@"Point-icon.png"];
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

//
//  OnlineRateViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineRateViewController.h"
#import "RatingView.h"
#import "OnlineTabBarStoreViewController.h"    //use Global variable: storeID

@interface OnlineRateViewController ()

//@property (strong, nonatomic) RatingView *ratingView;

@end

@implementation OnlineRateViewController
{
    RatingView *avgRate;
    RatingView *star5Rate;
    RatingView *star4Rate;
    RatingView *star3Rate;
    RatingView *star2Rate;
    RatingView *star1Rate;
    
    RatingView *rate;
}
@synthesize countRatingLabel,percentStar5Label,percentStar4Label,percentStar3Label,percentStar2Label,percentStar1Label;
@synthesize segment;
@synthesize rateView,scoreLabel,rateButton;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Rating Store";
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //call mathod for Create Rating Star and Bar
    [self creatRating];
    
    //call method for Database & set text to Show
    [self getRating:@"%"];
    [self getRating:@"5"];
    [self getRating:@"4"];
    [self getRating:@"3"];
    [self getRating:@"2"];
    [self getRating:@"1"];
    
    rateView.hidden = YES;
    [self.view addSubview:rateView];
    scoreLabel.text = [NSString stringWithFormat:@"Score: -"];
    rateButton.enabled = NO;
    
    segment.selectedSegmentIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectSegment:(id)sender
{
    if (segment.selectedSegmentIndex == 0) {
        rateView.hidden = YES;
        //remove SubView on AVG-Rate
        for (UIView *subview in [self.view subviews])
        {
            if (subview.tag == 1) {
                [subview removeFromSuperview];
            }
        }
    }
    else {
        rateView.hidden = NO;
        //create SubView on AVG-Rate
        UIImageView *blackview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Starx5.png"]];
        blackview.frame = CGRectMake(60, 135, 200, 40);
        blackview.tag = 1;
        blackview.alpha = 0.25;
        [self.view addSubview:blackview];
    }
}

- (IBAction)insertRate:(id)sender
{
    UIAlertView *alv = [[UIAlertView alloc]
                        initWithTitle:@"RATE"
                        message:@"sure?"
                        delegate:self
                        cancelButtonTitle:nil
                        otherButtonTitles:@"OK", @"Cancel", nil];
    [alv show];
}

-(void)getRating:(NSString *)score
{
    NSString *url_score = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)score, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    //NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getRating.php?idStore=%@&score=%@",storeID,url_score];
    NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getRating.php?idStore=%@&score=%@",storeID,url_score];
    
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *avgScore_data = [dataDict objectForKey:@"avgScore"];
        NSString *count_data = [dataDict objectForKey:@"count"];
        NSString *percent_data = [dataDict objectForKey:@"percent"];
        
        if ([score isEqual: @"%"])
        {
            if ([count_data intValue] != 0)
            {
                float value = floorf([avgScore_data floatValue]);
                if ([avgScore_data floatValue]-value >= 0.25)
                {
                    if ([avgScore_data floatValue]-value >= 0.75) {
                        value = value + 1;
                    }
                    else {
                        value = value + 0.5;
                    }
                }
                avgRate.value = value;
                countRatingLabel.text = [NSString stringWithFormat:@"Based on %@ Ratings",count_data];
            }
            else {
                countRatingLabel.text = [NSString stringWithFormat:@"Based on - Ratings"];
            }
        }
        else if ([score isEqual:@"5"])
        {
            if ([count_data intValue] != 0) {
                star5Rate.value = [percent_data floatValue]*0.28;
                percentStar5Label.text = [NSString stringWithFormat:@"%@%%",percent_data];
            }
            else {
                percentStar5Label.text = [NSString stringWithFormat:@"0%%"];
            }
        }
        else if ([score isEqual:@"4"])
        {
            if ([count_data intValue] != 0) {
                star4Rate.value = [percent_data floatValue]*0.28;
                percentStar4Label.text = [NSString stringWithFormat:@"%@%%",percent_data];
            }
            else {
                percentStar4Label.text = [NSString stringWithFormat:@"0%%"];
            }
        }
        else if ([score isEqual:@"3"])
        {
            if ([count_data intValue] != 0) {
                star3Rate.value = [percent_data floatValue]*0.28;
                percentStar3Label.text = [NSString stringWithFormat:@"%@%%",percent_data];
            }
            else {
                percentStar3Label.text = [NSString stringWithFormat:@"0%%"];
            }
        }
        else if ([score isEqual:@"2"])
        {
            if ([count_data intValue] != 0) {
                star2Rate.value = [percent_data floatValue]*0.28;
                percentStar2Label.text = [NSString stringWithFormat:@"%@%%",percent_data];
            }
            else {
                percentStar2Label.text = [NSString stringWithFormat:@"0%%"];
            }
        }
        else if ([score isEqual:@"1"])
        {
            if ([count_data intValue] != 0) {
                star1Rate.value = [percent_data floatValue]*0.28;
                percentStar1Label.text = [NSString stringWithFormat:@"%@%%",percent_data];
            }
            else {
                percentStar1Label.text = [NSString stringWithFormat:@"0%%"];
            }
        }
        
    }
}

-(void)creatRating
{
    avgRate = [[RatingView alloc] initWithFrame:CGRectMake(60, 135, 200, 40)
                                       selectedImageName:@"StarYellow-icon.png"
                                         unSelectedImage:@"StarWhite-icon.png"
                                                minValue:0
                                                maxValue:5
                                           intervalValue:1
                                              stepByStep:NO];
    avgRate.delegate = self;
    avgRate.value = 0;
    [self.view addSubview:avgRate];
    
    //create VIEW on RatingView: not action rate score
    UIView *view_avgRate = [[UIView alloc] initWithFrame:CGRectMake(60, 135, 200, 40)];
    [self.view addSubview:view_avgRate];
    
    
    star5Rate = [[RatingView alloc] initWithFrame:CGRectMake(20, 253+46, 280, 10)
                                          selectedImageName:@"Black.png"
                                            unSelectedImage:@"Gray.png"
                                                   minValue:0
                                                   maxValue:28
                                              intervalValue:1
                                                 stepByStep:NO];
    star5Rate.delegate = self;
    star5Rate.value = 0;
    [self.view addSubview:star5Rate];
    
    //create VIEW on RatingView: not action rate score
    UIView *view_star5Rate = [[UIView alloc] initWithFrame:CGRectMake(20, 253+46, 280, 10)];
    [self.view addSubview:view_star5Rate];
    
    star4Rate = [[RatingView alloc] initWithFrame:CGRectMake(20, 302+46, 280, 10)
                                            selectedImageName:@"Black.png"
                                              unSelectedImage:@"Gray.png"
                                                     minValue:0
                                                     maxValue:28
                                                intervalValue:1
                                                   stepByStep:NO];
    star4Rate.delegate = self;
    star4Rate.value = 0;
    [self.view addSubview:star4Rate];
    
    //create VIEW on RatingView: not action rate score
    UIView *view_star4Rate = [[UIView alloc] initWithFrame:CGRectMake(20, 302+46, 280, 10)];
    [self.view addSubview:view_star4Rate];
    
    star3Rate = [[RatingView alloc] initWithFrame:CGRectMake(20, 351+46, 280, 10)
                                          selectedImageName:@"Black.png"
                                            unSelectedImage:@"Gray.png"
                                                   minValue:0
                                                   maxValue:28
                                              intervalValue:1
                                                 stepByStep:NO];
    star3Rate.delegate = self;
    star3Rate.value = 0;
    [self.view addSubview:star3Rate];
    
    //create VIEW on RatingView: not action rate score
    UIView *view_star3Rate = [[UIView alloc] initWithFrame:CGRectMake(20, 351+46, 280, 10)];
    [self.view addSubview:view_star3Rate];
    
    star2Rate = [[RatingView alloc] initWithFrame:CGRectMake(20, 400+46, 280, 10)
                                          selectedImageName:@"Black.png"
                                            unSelectedImage:@"Gray.png"
                                                   minValue:0
                                                   maxValue:28
                                              intervalValue:1
                                                 stepByStep:NO];
    star2Rate.delegate = self;
    star2Rate.value = 0;
    [self.view addSubview:star2Rate];
    
    //create VIEW on RatingView: not action rate score
    UIView *view_star2Rate = [[UIView alloc] initWithFrame:CGRectMake(20, 400+46, 280, 10)];
    [self.view addSubview:view_star2Rate];
    
    star1Rate = [[RatingView alloc] initWithFrame:CGRectMake(20, 448+46, 280, 10)
                                          selectedImageName:@"Black.png"
                                            unSelectedImage:@"Gray.png"
                                                   minValue:0
                                                   maxValue:28
                                              intervalValue:1
                                                 stepByStep:NO];
    star1Rate.delegate = self;
    star1Rate.value = 0;
    [self.view addSubview:star1Rate];
    
    //create VIEW on RatingView: not action rate score
    UIView *view_star1Rate = [[UIView alloc] initWithFrame:CGRectMake(20, 448+46, 280, 10)];
    [self.view addSubview:view_star1Rate];
    
    rate = [[RatingView alloc] initWithFrame:CGRectMake(60, 57, 200, 40)
                                       selectedImageName:@"StarYellow-icon.png"
                                         unSelectedImage:@"StarWhite-icon.png"
                                                minValue:0
                                                maxValue:5
                                           intervalValue:1
                                              stepByStep:NO];
    rate.delegate = self;
    rate.value = 0;
    [rateView addSubview:rate];
}
/*
- (IBAction)increaseRating:(id)sender
{
    self.ratingView.value = self.ratingView.value + 1;
}
*/
- (void)rateChanged:(RatingView *)ratingView
{
    if (ratingView.value != 0) {
        scoreLabel.text = [NSString stringWithFormat:@"Score: %d",(int)ratingView.value];
        rateButton.enabled = YES;
    }
    else {
        scoreLabel.text = [NSString stringWithFormat:@"Score: -"];
        rateButton.enabled = NO;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/insertRating.php?idStore=%@&score=%d",storeID,(int)rate.value];
        NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/insertRating.php?idStore=%@&score=%d",storeID,(int)rate.value];
        [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        [self viewDidLoad];
    }
}

@end

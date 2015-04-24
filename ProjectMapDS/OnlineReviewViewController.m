//
//  OnlineReviewViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 4/18/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineReviewViewController.h"
#import "OnlineTabBarStoreViewController.h"     //use Global variable: storeID, storeFloor
#import "URL_GlobalVar.h"                       //use Global variable: urlLocalhost
#import "ASProgressPopUpView.h"

@interface OnlineReviewViewController () <ASProgressPopUpViewDataSource>
{
    NSMutableArray *arrReview;
    
    NSString *reviewTotal;
    NSString *reviewNum;
    
    UITextField *nameTextField;
    UISegmentedControl *correctSegment;
    UITextView *commentReview;
    
}
@property (strong, nonatomic) IBOutlet ASProgressPopUpView *progressView;
@end

@implementation OnlineReviewViewController
@synthesize onlineCollectionReview;
@synthesize totalReviewLabel,titleReviewLabel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Reviews";
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.parentViewController.navigationItem.rightBarButtonItems = nil;
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getReviewCount];
    [self getReview];
    
    // set Value CORRECT infomation
    [self.progressView showPopUpViewAnimated:NO];
    self.progressView.dataSource = self;
    self.progressView.popUpViewCornerRadius = 12.0;
    self.progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:28];
    self.progressView.popUpViewColor = [UIColor colorWithRed:(248/255.0) green:(137/255.0) blue:(10/255.0) alpha:1.0]; //#F88A0A
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([arrReview count] == 0)
    {
        titleReviewLabel.hidden = YES;
    }
    else
    {
        titleReviewLabel.hidden = NO;
    }
    
    return [arrReview count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *SimpleIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SimpleIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = [arrReview objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = [dict objectForKey:@"fromName"];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:200];
    dateLabel.text = [[dict objectForKey:@"date"] substringToIndex:10];
    
    UITextField *reviewTextField = (UITextField *)[cell viewWithTag:300];
    reviewTextField.text = [dict objectForKey:@"textReview"];
    
    return cell;
}

#pragma mark - ASProgressPopUpView dataSource

// <ASProgressPopUpViewDataSource> is entirely optional
// it allows you to supply custom NSStrings to ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    
    if ([reviewTotal isEqual:@"0"])
    {
        s = @"No Review";
    }
    
    return s;
}

// by default ASProgressPopUpView precalculates the largest popUpView size needed
// it then uses this size for all values and maintains a consistent size
// if you want the popUpView size to adapt as values change then return 'NO'
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - AlertView

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //NSLog(@"cilck SEND");
        //NSLog(@"username: '%@'",nameTextField.text);
        //NSLog(@"select: %lu => %@",correctSegment.selectedSegmentIndex,reviewNum);
        //NSLog(@"review: '%@'",commentReview.text);
        
        [self insertReview:reviewNum name:nameTextField.text comment:commentReview.text];
        [self getReviewCount];
        [self getReview];
        [onlineCollectionReview reloadData];
    }
    
    [alertView close];
}

-(void)showReviewView
{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createAlertView]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", @"Send", nil]];
    [alertView setDelegate:self];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

- (UIView *)createAlertView
{
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 288, 160)];
    
    UILabel *fromTitle = [[UILabel alloc] initWithFrame:CGRectMake(27, 15, 70, 30)];
    [fromTitle setFont:[UIFont systemFontOfSize:14]];
    fromTitle.text = @"Name:";
    
    UILabel *correctTitle = [[UILabel alloc] initWithFrame:CGRectMake(27, 50, 70, 30)];
    [correctTitle setFont:[UIFont systemFontOfSize:14]];
    correctTitle.text = @"Correct:";
    
    UILabel *commentTitle = [[UILabel alloc] initWithFrame:CGRectMake(27, 85, 70, 30)];
    [commentTitle setFont:[UIFont systemFontOfSize:14]];
    commentTitle.text = @"Comment:";
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 15, 166, 30)];
    [nameTextField setBackgroundColor:[UIColor whiteColor]];
    [nameTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [nameTextField setFont:[UIFont systemFontOfSize:14]];
    //nameTextField.placeholder = @"name";
    nameTextField.delegate = self;
    
    correctSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Yes", @"No", nil]];
    [correctSegment setBackgroundColor:[UIColor whiteColor]];
    [correctSegment setTintColor:[UIColor colorWithRed:(248/255.0) green:(137/255.0) blue:(10/255.0) alpha:1.0]]; //#F88A0A
    [correctSegment addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    correctSegment.frame = CGRectMake(100, 51, 166, 29);
    correctSegment.selectedSegmentIndex = 0;
    reviewNum = @"1";
    
    commentReview = [[UITextView alloc] initWithFrame:CGRectMake(100, 85, 166, 60)];
    [commentReview setBackgroundColor:[UIColor whiteColor]];
    commentReview.delegate = self;
    
    [alertView addSubview:fromTitle];
    [alertView addSubview:nameTextField];
    [alertView addSubview:correctTitle];
    [alertView addSubview:correctSegment];
    [alertView addSubview:commentTitle];
    [alertView addSubview:commentReview];
    
    return alertView;
}

- (void)segmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        //NSLog(@"Correct ==> 1");
        reviewNum = @"1";
    }
    else
    {
        //NSLog(@"Wrong ==> 0");
        reviewNum = @"0";
    }
}

//method
-(void)getReview
{
    arrReview = [[NSMutableArray alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/getReview.php?idStore=%@",urlLocalhost,storeID];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *correct = [dataDict objectForKey:@"correct"];
        
        NSString *textReview = [dataDict objectForKey:@"textReview"];
        if ([textReview isEqual: [NSNull null]] || textReview.length == 0)
        {
            //NSLog(@"text continue");
            continue;
        }
        
        NSString *fromName = [dataDict objectForKey:@"fromName"];
        if ([fromName isEqual: [NSNull null]] || fromName.length == 0)
        {
            fromName = @"username";
            //NSLog(@"name is NULL");
        }
        
        NSString *date = [dataDict objectForKey:@"date"];
        
        NSDictionary *dictReview = [NSDictionary dictionaryWithObjectsAndKeys:
                                correct, @"correct",
                                textReview, @"textReview",
                                fromName, @"fromName",
                                date, @"date",
                                nil];
        [arrReview addObject:dictReview];
    }
}

-(void)getReviewCount
{
    NSString *url = [NSString stringWithFormat:@"%@/getReviewCount.php?idStore=%@",urlLocalhost,storeID];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *avgCorrect = [dataDict objectForKey:@"avgCorrect"];
        if ([avgCorrect isEqual: [NSNull null]])
        {
            self.progressView.progress = 0.0;
        }
        else
        {
            self.progressView.progress = [avgCorrect floatValue];
        }
        
        //NSString *countCorrect = [dataDict objectForKey:@"countCorrect"];
        
        NSString *total = [dataDict objectForKey:@"total"];
        totalReviewLabel.text = [NSString stringWithFormat:@"Based on %@ Reviews",total];
        reviewTotal = total;
    }
}

-(void)insertReview:(NSString *)reviewScore name:(NSString *)reviewName comment:(NSString *)reviewComment
{
    NSString *url_score = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)reviewScore, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    NSString *url_name = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)reviewName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    NSString *url_comment = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)reviewComment, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *url = [NSString stringWithFormat:@"%@/insertReview.php?idStore=%@&correct=%@&textReview=%@&fromName=%@",urlLocalhost,storeID,url_score,url_comment,url_name];
    
    [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
}

- (IBAction)writeReview:(id)sender
{
    [self showReviewView];
}

@end

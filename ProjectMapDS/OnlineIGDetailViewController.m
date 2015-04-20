//
//  OnlineIGDetailViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 4/16/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineIGDetailViewController.h"
#import "OnlineTabBarDSViewController.h"   //use Global variable: dataID, dataFloor

@interface OnlineIGDetailViewController ()

@end

@implementation OnlineIGDetailViewController
@synthesize idIG,type;
@synthesize userImage,nameLabel,datetimeLabel,igImage,captionTextView,commentImage;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"InstaGram Detail";
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"type:%@ idIG:%@",type,idIG);
    
    if ([type isEqual:@"Tag"])
    {
        [self getDetailWithTag];
    }
    else
    {
        [self getDetailWithLocation];
    }
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

-(void)getDetailWithLocation
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getIGLocationDetail.php?idDS=%@&idIG=%@",dataID,idIG];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getIGLocationDetail.php?idDS=%@&idIG=%@",dataID,idIG];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *username = [dataDict objectForKey:@"username"];
        nameLabel.text = username;
        
        NSString *imageProfile = [dataDict objectForKey:@"imageProfile"];
        NSData *data_ImgProfile = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageProfile]];
        if (data_ImgProfile == NULL)
        {
            userImage.image = [UIImage imageNamed:@"Profile.png"];
        }
        else
        {
            userImage.image = [UIImage imageWithData:data_ImgProfile];
        }
        
        NSString *datetime = [dataDict objectForKey:@"datetime"];
        datetimeLabel.text = datetime;
        
        NSString *imageStandard = [dataDict objectForKey:@"imageStandard"];
        NSData *data_ImgStandard = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStandard]];
        if (data_ImgStandard == NULL)
        {
            igImage.image = [UIImage imageNamed:@"Instagram.png"];
        }
        else
        {
            igImage.image = [UIImage imageWithData:data_ImgStandard];
        }
        
        NSString *captionText = [dataDict objectForKey:@"captionText"];
        captionTextView.text = captionText;
        
        if ([captionText isEqual:@""])
        {
            commentImage.hidden = YES;
        }
        else
        {
            commentImage.hidden = NO;
        }
    }
}

-(void)getDetailWithTag
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getIGTagDetail.php?idDS=%@&idIG=%@",dataID,idIG];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getIGTagDetail.php?idDS=%@&idIG=%@",dataID,idIG];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *username = [dataDict objectForKey:@"username"];
        nameLabel.text = username;
        
        NSString *imageProfile = [dataDict objectForKey:@"imageProfile"];
        NSData *data_ImgProfile = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageProfile]];
        if (data_ImgProfile == NULL)
        {
            userImage.image = [UIImage imageNamed:@"Profile.png"];
        }
        else
        {
            userImage.image = [UIImage imageWithData:data_ImgProfile];
        }
        
        NSString *datetime = [dataDict objectForKey:@"datetime"];
        datetimeLabel.text = datetime;
        
        NSString *imageStandard = [dataDict objectForKey:@"imageStandard"];
        NSData *data_ImgStandard = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStandard]];
        if (data_ImgStandard == NULL)
        {
            igImage.image = [UIImage imageNamed:@"Instagram.png"];
        }
        else
        {
            igImage.image = [UIImage imageWithData:data_ImgStandard];
        }
        
        NSString *captionText = [dataDict objectForKey:@"captionText"];
        captionTextView.text = captionText;
        
        if ([captionText isEqual:@""])
        {
            commentImage.hidden = YES;
        }
        else
        {
            commentImage.hidden = NO;
        }
    }
}

@end

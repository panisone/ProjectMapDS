//
//  OnlineDetailStoreViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineDetailStoreViewController.h"
#import "OnlineTabBarStoreViewController.h"    //use Global variable: storeID

@interface OnlineDetailStoreViewController ()

@end

@implementation OnlineDetailStoreViewController
{
    NSString *name;
    NSString *branch;
    NSString *detail;
    UIImage *image;
}
@synthesize nameLabel,branchLabel,logoImage,detailTextView;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Detail Store";
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //call method for Database
    [self getDetailStore];
    //set text to Show
    nameLabel.text = name;
    branchLabel.text = [@"สาขา " stringByAppendingString:branch];
    logoImage.image = image;
    detailTextView.text = detail;
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

-(void)getDetailStore
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getStoreDetail.php?idStore=%@",storeID];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getStoreDetail.php?idStore=%@",storeID];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *nameStore_data = [dataDict objectForKey:@"nameStore"];
        name = nameStore_data;
        
        NSString *branchStore_data = [dataDict objectForKey:@"branchStore"];
        if ([branchStore_data length] == 0) {
            branchStore_data = @"-";
        }
        branch = [NSString stringWithFormat:@"%@",branchStore_data];
        
        NSString *category_data = [dataDict objectForKey:@"category"];
        if ([category_data  isEqual: @""]) {
            category_data = @"-";
        }
        detail = [NSString stringWithFormat:@"ประเภทของร้าน: \n%@\n\n",category_data];
        
        detail = [detail stringByAppendingString:@"ตำแหน่งที่ตั้งร้าน: \n"];
        detail = [detail stringByAppendingString:[self getStringAddressNumber]];
        detail = [detail stringByAppendingString:@"\n\n"];
        
        NSString *openTimeStore_data = [dataDict objectForKey:@"openTimeStore"];
        if ([openTimeStore_data  isEqual: @""]) {
            openTimeStore_data = @"-";
        }
        NSString *closeTimeStore_data = [dataDict objectForKey:@"closeTimeStore"];
        if ([closeTimeStore_data  isEqual: @""]) {
            closeTimeStore_data = @"-";
        }
        detail = [detail stringByAppendingString:@"เวลาบริการ: \n"];
        if ([openTimeStore_data  isEqual:@"-"] || [closeTimeStore_data isEqual:@"-"])
        {
            detail = [detail stringByAppendingString:@"-"];
        }
        else
        {
            detail = [NSString stringWithFormat:@"%@%@ - %@",detail,openTimeStore_data,closeTimeStore_data];
        }
        detail = [detail stringByAppendingString:@"\n\n"];
        
        NSString *telStore_data = [dataDict objectForKey:@"telStore"];
        if ([telStore_data  isEqual: @""]) {
            telStore_data = @"-";
        }
        detail = [NSString stringWithFormat:@"%@เบอร์โทรศัพท์: \n%@\n\n",detail,telStore_data];
        
        NSString *faxStore_data = [dataDict objectForKey:@"faxStore"];
        if ([faxStore_data  isEqual: @""]) {
            faxStore_data = @"-";
        }
        detail = [NSString stringWithFormat:@"%@เบอร์โทรสาร: \n%@\n\n",detail,faxStore_data];
        
        NSString *emailStore_data = [dataDict objectForKey:@"emailStore"];
        if ([emailStore_data  isEqual: @""]) {
            emailStore_data = @"-";
        }
        detail = [NSString stringWithFormat:@"%@E-Mail: \n%@\n\n",detail,emailStore_data];
        
        NSString *webStore_data = [dataDict objectForKey:@"webStore"];
        if ([webStore_data  isEqual: @""]) {
            webStore_data = @"-";
        }
        detail = [NSString stringWithFormat:@"%@Website: \n%@\n\n",detail,webStore_data];
        
        NSString *detailStore_data = [dataDict objectForKey:@"detailStore"];
        if ([detailStore_data  isEqual: @""]) {
            detailStore_data = @"-";
        }
        detail = [NSString stringWithFormat:@"%@รายละเอียดร้าน: \n%@",detail,detailStore_data];
        
        NSString *logoStore_data = [dataDict objectForKey:@"logoStore"];
        image = [UIImage imageNamed:@"Info-icon.png"];
        if ([logoStore_data length] != 0) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:logoStore_data options:0];
            image = [UIImage imageWithData:imageData];
        }
    }
}

-(NSString *)getStringAddressNumber
{
    NSString *strFloor = @"";
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getStoreAddressNumber.php?idStore=%@",storeID];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getStoreAddressNumber.php?idStore=%@",storeID];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *floor_data = [dataDict objectForKey:@"floor"];
        if ([strFloor isEqual:@""])
        {
            strFloor = [NSString stringWithFormat:@"%@ชั้น %@",strFloor,floor_data];
        }
        else
        {
            strFloor = [strFloor stringByAppendingString:@"\n"];
            strFloor = [NSString stringWithFormat:@"%@ชั้น %@",strFloor,floor_data];
        }
        
        NSString *addressNumber_data = [dataDict objectForKey:@"addressNumber"];
        if (![addressNumber_data  isEqual: @""]) {
            strFloor = [NSString stringWithFormat:@"%@\tห้อง %@",strFloor,addressNumber_data];
        }
    }
    
    return strFloor;
}

@end

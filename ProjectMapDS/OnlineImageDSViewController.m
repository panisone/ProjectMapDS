//
//  OnlineImageDSViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineImageDSViewController.h"
#import "OnlineTabBarDSViewController.h"    //use Global variable: dataID
#import "URL_GlobalVar.h"                   //use Global variable: urlLocalhost

@interface OnlineImageDSViewController ()

@end

@implementation OnlineImageDSViewController
{
    NSMutableArray *listOfimageDS;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Image DS";
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.parentViewController.navigationItem.rightBarButtonItems = nil;
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create the data model
    [self getImageDS];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlinePageDSViewController"];
    self.pageViewController.dataSource = self;
    
    OnlineContentDSViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    //image start:+64 end: -49(TabBar-->455) -37(PageControl-->418)
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
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
- (IBAction)startWalkthrough:(id)sender {
    OnlineContentDSViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (OnlineContentDSViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([listOfimageDS count] == 0) || (index >= [listOfimageDS count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    OnlineContentDSViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineContentDSViewController"];
    pageContentViewController.imageDS = listOfimageDS[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OnlineContentDSViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OnlineContentDSViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [listOfimageDS count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [listOfimageDS count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)getImageDS
{
    listOfimageDS = [[NSMutableArray alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/getDSImage.php?idDS=%@",urlLocalhost,dataID];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *imageDS_data = [dataDict objectForKey:@"imageDS"];
        UIImage *image = [UIImage imageNamed:@"Info-icon.png"];
        if ([imageDS_data length] != 0) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageDS_data options:0];
            image = [UIImage imageWithData:imageData];
        }
        
        [listOfimageDS addObject:image];
    }
    
    if ([listOfimageDS count] == 0) {
        [listOfimageDS addObject:[UIImage imageNamed:@"Info-icon.png"]];
    }
}

@end

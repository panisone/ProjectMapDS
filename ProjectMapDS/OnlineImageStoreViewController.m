//
//  OnlineImageStoreViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/19/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OnlineImageStoreViewController.h"
#import "OnlineTabBarStoreViewController.h"    //use Global variable: storeID

@interface OnlineImageStoreViewController ()

@end

@implementation OnlineImageStoreViewController
{
    NSMutableArray *listOfimageStore;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Image Store";
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create the data model
    [self getImageStore];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlinePageStoreViewController"];
    self.pageViewController.dataSource = self;
    
    OnlineContentStoreViewController *startingViewController = [self viewControllerAtIndex:0];
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
    OnlineContentStoreViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (OnlineContentStoreViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([listOfimageStore count] == 0) || (index >= [listOfimageStore count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    OnlineContentStoreViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineContentStoreViewController"];
    pageContentViewController.imageStore = listOfimageStore[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OnlineContentStoreViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OnlineContentStoreViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [listOfimageStore count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [listOfimageStore count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)getImageStore
{
    listOfimageStore = [[NSMutableArray alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getStoreImage.php?idStore=%@",storeID];
    //NSString *url = [NSString stringWithFormat:@"http://panisone.in.th/pani/getStoreImage.php?idStore=%@",storeID];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *imageStore_data = [dataDict objectForKey:@"imageStore"];
        UIImage *image = [UIImage imageNamed:@"Info-icon.png"];
        if ([imageStore_data length] != 0) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageStore_data options:0];
            image = [UIImage imageWithData:imageData];
        }
        
        [listOfimageStore addObject:image];
    }
    
    if ([listOfimageStore count] == 0) {
        [listOfimageStore addObject:[UIImage imageNamed:@"Info-icon.png"]];
    }
}

@end

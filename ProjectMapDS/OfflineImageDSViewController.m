//
//  OfflineImageDSViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/11/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OfflineImageDSViewController.h"
#import "OfflineTabBarDSViewController.h"   //use Global variable: dataID

@interface OfflineImageDSViewController ()

@end

@implementation OfflineImageDSViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create the data model
    [self initDatabase];
    [self getImageDS];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflinePageDSViewController"];
    self.pageViewController.dataSource = self;
    
    OfflineContentDSViewController *startingViewController = [self viewControllerAtIndex:0];
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
    OfflineContentDSViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (OfflineContentDSViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([listOfimageDS count] == 0) || (index >= [listOfimageDS count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    OfflineContentDSViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineContentDSViewController"];
    pageContentViewController.imageDS = listOfimageDS[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OfflineContentDSViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OfflineContentDSViewController *) viewController).pageIndex;
    
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

-(void)initDatabase
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    if (success) {
        return;
    }
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
}

-(void)getImageDS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT imageDS FROM ImageDS WHERE idDS=%@",dataID] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            listOfimageDS = [[NSMutableArray alloc] init];
            
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                UIImage *image = [UIImage imageNamed:@"No-icon.png"];
                if ((char*)sqlite3_column_text(searchStament, 0) != NULL)
                {
                    NSData *dataImage = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 0) length:sqlite3_column_bytes(searchStament, 0)];
                    
                    if ([dataImage length] != 0)
                    {
                        image = [UIImage imageWithData:dataImage];
                    }
                }
                
                [listOfimageDS addObject:image];
            }
            
            if ([listOfimageDS count] == 0) {
                [listOfimageDS addObject:[UIImage imageNamed:@"No-icon.png"]];
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

@end

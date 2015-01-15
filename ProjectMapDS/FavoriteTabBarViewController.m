//
//  FavoriteTabBarViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/15/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "FavoriteTabBarViewController.h"

NSString *storeID;          //Global variable
NSMutableArray *storeFloor; //Global variable

@interface FavoriteTabBarViewController ()

@end

@implementation FavoriteTabBarViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = storeID;
    self.navigationController.navigationBar.topItem.title = @"back";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDatabase];
    [self getFloorStore];
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

-(void)getFloorStore
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT Floor.idFloor,Floor.floor FROM Floor,LinkFloorStore WHERE Floor.idFloor=LinkFloorStore.idFloor and LinkFloorStore.idStore=%@ ORDER BY Floor.idFloor ASC",storeID] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            storeFloor = [[NSMutableArray alloc] init];
            
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                NSString *nameFloor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 1)];
                //NSLog(@"name: %@",nameFloor);
                [storeFloor addObject:nameFloor];
            }
            //test case: no data
            if ([storeFloor count] == 0) {
                [storeFloor addObject:@"%"];
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

@end

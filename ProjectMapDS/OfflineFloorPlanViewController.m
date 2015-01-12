//
//  OfflineFloorPlanViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/9/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OfflineFloorPlanViewController.h"
#import "OfflineTabBarDSViewController.h"   //use Global variable: dataID, dataFloor

@interface OfflineFloorPlanViewController ()

@end

@implementation OfflineFloorPlanViewController
{
    //NSString *namefloor;
    UIImage *image;
}
@synthesize floorImage;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationItem.title = @"Map DS";
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //call method for Database
    [self initDatabase];
    if ([dataFloor count]==0)
    {
        [self getFloorPlan:@""];
    }
    else
    {
        //init Offline-FloorPlan-ViewController
        [self getFloorPlan:dataFloor[0]];
    }
    //set image to Show
    floorImage.image = image;
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

-(void)getFloorPlan:(NSString *) floor
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT mapFloor FROM Floor WHERE idDS=%@ and floor='%@'",dataID,floor] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                image = [UIImage imageNamed:@"Info-icon.png"];
                if ((char*)sqlite3_column_text(searchStament, 0) != NULL)
                {
                    NSData *plan = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 0) length:sqlite3_column_bytes(searchStament, 0)];
                    
                    if ([plan length] != 0)
                    {
                        image = [UIImage imageWithData:plan];
                    }
                }
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

@end

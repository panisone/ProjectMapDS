//
//  OfflineDetailDSViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/7/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "OfflineDetailDSViewController.h"
#import "OfflineTabBarDSViewController.h"   //use Global variable: dataID

@interface OfflineDetailDSViewController ()

@end

@implementation OfflineDetailDSViewController
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
    //self.navigationItem.title = @"Detail DS";
    //self.navigationController.navigationBar.topItem.title = @"back";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //call method for Database
    [self initDatabase];
    [self getDetailDS];
    //set text to Show
    nameLabel.text = name;
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

-(void)getDetailDS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MapDepartmentStore.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = [[NSString stringWithFormat:@"SELECT * FROM DepartmentStore WHERE idDS=%@",dataID] cStringUsingEncoding:NSUTF8StringEncoding];
        
        sqlite3_stmt *searchStament;
        
        if (sqlite3_prepare_v2(database, sql, -1, &searchStament, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(searchStament) == SQLITE_ROW)
            {
                name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 1)];
                
                branch = @"-";
                if ((char*)sqlite3_column_text(searchStament, 2) != NULL) {
                    branch = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 2)];
                    if ([branch  isEqual: @""]) {
                        branch = @"-";
                    }
                }
                branchLabel.text = [@"สาขา " stringByAppendingString:branch];
                
                UIImage *imageLogo = [UIImage imageNamed:@"Info-icon.png"];
                if ((char*)sqlite3_column_text(searchStament, 7) != NULL)
                {
                    NSData *logo = [[NSData alloc] initWithBytes:sqlite3_column_blob(searchStament, 7) length:sqlite3_column_bytes(searchStament, 7)];
                    if ([logo length] != 0)
                    {
                        imageLogo = [UIImage imageWithData:logo];
                    }
                }
                logoImage.image = imageLogo;
                
                detail = @"";
                NSString *address = @"-";
                if ((char*)sqlite3_column_text(searchStament, 3) != NULL) {
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 3)];
                    if ([address  isEqual: @""]) {
                        address = @"-";
                    }
                }
                detail = [detail stringByAppendingString:@"สถานที่ตั้ง: \n"];
                detail = [detail stringByAppendingString:address];
                detail = [detail stringByAppendingString:@"\n\n"];
                
                NSString *openTime = @"-";
                if ((char*)sqlite3_column_text(searchStament, 4) != NULL) {
                    openTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 4)];
                    if ([openTime  isEqual: @""]) {
                        openTime = @"-";
                    }
                }
                NSString *closeTime = @"-";
                if ((char*)sqlite3_column_text(searchStament, 5) != NULL) {
                    closeTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStament, 5)];
                    if ([closeTime  isEqual: @""]) {
                        closeTime = @"-";
                    }
                }
                
                detail = [detail stringByAppendingString:@"เวลาทำการ: \n"];
                if ([openTime  isEqual:@"-"] || [closeTime isEqual:@"-"])
                {
                    detail = [detail stringByAppendingString:@"-"];
                }
                else
                {
                    openTime = [openTime stringByAppendingString:@" - "];
                    openTime = [openTime stringByAppendingString:closeTime];
                    detail = [detail stringByAppendingString:openTime];
                }
                detail = [detail stringByAppendingString:@"\n\n"];
                
                detailTextView.text = detail;
                //NSLog(@"detail: %@",detail);
            }
        }
        sqlite3_finalize(searchStament);
    }
    sqlite3_close(database);
}

@end

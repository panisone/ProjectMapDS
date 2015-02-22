//
//  Global.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/22/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "Global.h"

NSString *idDS_table;
NSString *idFloor_table;
NSString *idStore_table;

NSMutableArray *idDS_arr;
NSMutableArray *idFloor_arr;
NSMutableArray *idStore_arr;

@implementation Global

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

+(void)showString:(NSString *)str
{
    NSLog(@"Global_file >> print string: %@",str);
}

+(void)check
{
    
}

+(void)downloadAll
{
    
}

+(void)download:(NSString *)idDS
{
    idDS_table = idDS;
}

//method GET data for DATABASE
+(void)getDepartmentStoreTable:(NSString *)idDS
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/projectDS/getTableDepartmentStore.php?idDS=%@",idDS];
    NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:[dataDict objectForKey:@"idDS"]];
        [arr addObject:[dataDict objectForKey:@"nameDS"]];
        [arr addObject:[dataDict objectForKey:@"branchDS"]];
        [arr addObject:[dataDict objectForKey:@"addressDS"]];
        [arr addObject:[dataDict objectForKey:@"openTimeDS"]];
        [arr addObject:[dataDict objectForKey:@"closeTimeDS"]];
        [arr addObject:[dataDict objectForKey:@"numFloorDS"]];
        NSString *logoDS = [dataDict objectForKey:@"logoDS"];
        [arr addObject:[[NSData alloc] initWithBase64EncodedString:logoDS options:0]];
        [arr addObject:[dataDict objectForKey:@"latestUpdate"]];
        
        [idDS_arr addObject:arr];
    }
}

+(void)getImageDSTable
{
    
}

+(void)getFloorTable
{
    
}

+(void)getLinkFloorStoreTable
{
    
}

+(void)getStoreTable
{
    
}

+(void)getImageStoreTable;
{
    
}

/*
 How to call Global
 
 #import "Global.h"
 
 [Global showString:@"1234567890"];
 */
@end

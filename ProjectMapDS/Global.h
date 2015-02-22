//
//  Global.h
//  ProjectMapDS
//
//  Created by Panisara Intoe on 2/22/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

extern NSString *idDS_table;
extern NSString *idFloor_table;
extern NSString *idStore_table;

extern NSMutableArray *idDS_arr;
extern NSMutableArray *idFloor_arr;
extern NSMutableArray *idStore_arr;

@interface Global : NSObject
{
    sqlite3 *database;
}

-(void)initDatabase;

+(void)showString:(NSString *) str;

+(void)check;

+(void)downloadAll;
+(void)download:(NSString *)idDS;

+(void)getDepartmentStoreTable:(NSString *)idDS;
+(void)getImageDSTable;
+(void)getFloorTable;
+(void)getLinkFloorStoreTable;
+(void)getStoreTable;
+(void)getImageStoreTable;

@end

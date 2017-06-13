//
//  DLJsonFileHandler.m
//  DLRouter-Example
//
//  Created by ice on 2017/6/13.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLJsonFileHandler.h"
#import "DLRouter.h"

@implementation DLJsonFileHandler : NSObject

+ (NSArray *)getModulesFromJsonFile:(NSArray <NSString *>*)files{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (NSString *fileName in files) {
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *modules = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [mutableArray addObjectsFromArray:modules];
    }
    
    return mutableArray;
}

+ (NSString *)searchVcClassNameWithModuleID:(NSInteger)moduleID{
    NSString *vcClassName = nil;
    for (NSDictionary *module in [DLRouter shareInstance].modules) {
        NSNumber *tempModuleID =module[@"moduleID"];
        if ([tempModuleID integerValue] ==moduleID) {
            vcClassName = module[@"targetVC"];
            break;
        }
    }
    return vcClassName;
}

@end

//
//  DLJsonFileHandler.h
//  DLRouter-Example
//
//  Created by ice on 2017/6/13.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLJsonFileHandler : NSObject

+ (NSArray *)getModulesFromJsonFile:(NSArray <NSString *>*)files;

+ (NSString *)searchVcClassNameWithModuleID:(NSInteger)moduleID;

@end

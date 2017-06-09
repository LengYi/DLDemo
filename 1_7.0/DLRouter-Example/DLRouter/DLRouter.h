//
//  DLRouter.h
//  DLRouter-Example
//
//  Created by ice on 2017/5/23.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLRouterConfig.h"

typedef NS_ENUM(NSInteger,AccessRight){
    DLRouterAccessRight0 = 0,
    DLRouterAccessRight1,
    DLRouterAccessRight2,
    DLRouterAccessRight3,
    DLRouterAccessRight4,
    DLRouterAccessRight5,
};

#pragma mark - RouterRight
@interface RouterRight : NSObject
@property (nonatomic,assign) AccessRight *accessRight;   // 访问模块的权限
@property (nonatomic,strong) NSString *info;             // 辅助信息

+ (instancetype)defaultRouterRight;

@end

#pragma mark - RouterOptions
@interface RouterOptions : NSObject
@property (nonatomic,assign) BOOL isPressent;     // 正常跳转方式 1 => present   0 => push
@property (nonatomic,assign) BOOL animated;       // 跳转时是否有动画
@property (nonatomic,copy,readonly) NSString *moduleID; // 每个页面对应的模块ID,自行约定
@property (nonatomic,strong) RouterRight *routerRight;   // 用户访问具有的权限

+ (instancetype)defaultOptions;

@end

#pragma mark - DLRouter
@interface DLRouter : NSObject

+ (instancetype)shareInstance;
+ (void)configRouter:(DLRouterConfig *)config;
+ (void)open:(NSString *)vcClassName;
@end


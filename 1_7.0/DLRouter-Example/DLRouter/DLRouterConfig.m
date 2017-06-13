//
//  DLRouterConfig.m
//  DLRouter-Example
//
//  Created by ice on 2017/5/23.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLRouterConfig.h"

@implementation DLRouterConfig

+ (DLRouterConfig *)routerConfig:(NSArray<NSString *> *)routerJsonArray
                     specialJump:(NSString *)sepcialJumpList
                       urlScheme:(NSString *)urlScheme
                       rootNavVC:(UINavigationController *)rootNavVC{
    DLRouterConfig *routerConfig = [[DLRouterConfig alloc] init];
    routerConfig.routerJsonArray = routerJsonArray;
    routerConfig.sepcialJumpList = sepcialJumpList;
    routerConfig.urlScheme = urlScheme;
    routerConfig.rootNavVC = rootNavVC;
    return routerConfig;
}

@end

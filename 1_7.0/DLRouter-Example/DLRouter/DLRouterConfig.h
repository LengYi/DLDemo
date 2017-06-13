//
//  DLRouterConfig.h
//  DLRouter-Example
//
//  Created by ice on 2017/5/23.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DLRouterConfig : NSObject
@property (nonatomic,strong) NSArray<NSString *> *routerJsonArray;    // 路由配置JSON文件数组
@property (nonatomic,strong) NSString *sepcialJumpList;               // 跳转时有特殊的动画的集合
@property (nonatomic,strong) NSString *urlScheme;                     // 自定义的URL协议名称
@property (nonatomic,strong) UINavigationController *rootNavVC;       // 控制器


+ (DLRouterConfig *)routerConfig:(NSArray<NSString *> *)routerJsonArray
                     specialJump:(NSString *)sepcialJumpList
                       urlScheme:(NSString *)urlScheme
                       rootNavVC:(UINavigationController *)rootNavVC;
@end

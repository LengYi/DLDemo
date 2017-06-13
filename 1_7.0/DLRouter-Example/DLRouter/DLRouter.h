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
@property (nonatomic,copy,readwrite) NSString *moduleID;  // 每个页面对应的模块ID,自行约定
@property (nonatomic,strong) RouterRight *routerRight;   // 用户访问具有的权限
@property (nonatomic,strong) NSDictionary *params;       // 跳转传递的参数

// 默认的options
+ (instancetype)defaultOptions;
// 带参数的options
+ (instancetype)optionsWithParams:(NSDictionary *)params;

@end

#pragma mark - DLRouter
@interface DLRouter : NSObject

@property (nonatomic, copy, readwrite) NSSet <NSDictionary *>* modules; // 存储路由，moduleID信息，权限配置信息
@property (nonatomic, copy, readwrite) NSSet <NSDictionary *>* specialOptionsSet; // 特殊跳转的页面信息的集合
@property (nonatomic,strong) DLRouterConfig *config;

+ (instancetype)shareInstance;
/**
 *  配置路由参数信息
 *
 *  @param config 配置信息
 */
+ (void)configRouter:(DLRouterConfig *)config;

/**
 *  默认push一个新的页面
 *
 *  @param vcClassName 新页面类名
 */
+ (void)open:(NSString *)vcClassName;

/**
 *  打开一个新的页面,并传递相关
 *
 *  @param vcClassName 新页面类名
 *  @param options     参数及相关配置信息
 */
+ (void)open:(NSString *)vcClassName options:(RouterOptions *)options;

/**
 *  根据协议跳转到指定模块
 *
 *  @param url 跳转的路由 可以携带参数
 */
+ (void)openWithUrl:(NSString *)url;

/**
 *  打开指定的页面
 *
 *  @param vc      指定的页面
 *  @param options 页面信息
 */
+ (void)openSecialVC:(UIViewController *)vc options:(RouterOptions *)options;

/**
 *  关闭当前页面返回上一级页面
 *
 *  @param animated 是否有转场动画
 */
+ (void)pop:(BOOL)animated;

/**
 *  关闭当前页面返回上一级页面,并回调参数
 *
 *  @param params   回调参数
 *  @param animated 是否带转场动画效果
 */
+ (void)pop:(NSDictionary *)params animated:(BOOL)animated;
@end


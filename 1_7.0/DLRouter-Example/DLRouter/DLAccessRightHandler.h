//
//  DLAccessRightHandler.h
//  DLRouter-Example
//
//  Created by ice on 2017/6/13.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RouterOptions;

@interface DLAccessRightHandler : NSObject

/**
 *  检查URL是否合法,默认合法,具体实现要通过category重载来实现
 *
 *  @param url 待检查的URL
 *
 *  @return 是否合法 默认 合法
 */
+ (BOOL)validateUrl:(NSString *)url;

/**
 *  根据权限等级判断是否跳转,默认可以跳转,具体实现要通过category重载来实现
 *
 *  @param options 配置信息
 *
 *  @return 是否跳转
 */
+ (BOOL)validRightToOpenVC:(RouterOptions *)options;

/**
 *  配置路由权限,默认default权限,具体实现要通过category重载来实现
 *
 *  @param options 配置信息
 *
 *  @return 含默认权限的配置信息
 */
+ (RouterOptions *)configAccessRight:(RouterOptions *)options;

/**
 *  无权限跳转处理接口,具体实现要通过category重载处理
 *
 *  @param options 配置信息
 */
+ (void)handleNoRightVC:(RouterOptions *)options;
@end

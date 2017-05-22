//
//  Mediator+ModuleA.h
//  DLMetadiator
//
//  Created by ice on 17/3/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "Mediator.h"
#import <UIKit/UIKit.h>

/**
 解耦调度具体业务模块,只处理相关业务类名称,方法名
 */

@interface Mediator (ModuleA)

/**
 @brief 展示一个详细页模块
 @param info  被显示的字符串
 @return 被实例化的具体对象
 */
- (UIViewController *)showDetailViewController:(NSString *)info;

/**
 @brief 展示一个警告框
 @param message 展示的信息
 @param cancleAction 取消操作回调接口
 @param confirmAction 确认操作回调接口
 */
- (void)showAlertWithMessage:(NSString *)message
                cancleAction:(void(^)(NSDictionary *info))cancleAction
                cofirmAction:(void(^)(NSDictionary *info))confirmAction;

/**
 @brief 展示一张图片
 @param image 被展示的图片
 */
- (void)presentImage:(UIImage *)image;

@end

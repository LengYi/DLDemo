//
//  Mediator.h
//  DLMetadiator
//
//  Created by ice on 17/3/7.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 原理:业务组件通过中间件Mediator通信,中间件Mediator通过 runtime接口解耦,通过 target-action 简化写法,通过 catetory 感官上分离组件接口代码
 */

@interface Mediator : NSObject

/**
 @brief 实例化一个中间件对象
 */
+ (instancetype)shareInstance;

/**
 @brief 根据url 执行业务模块调用
 @param url 格式 scheme://[target]/[action]?[params]  eg:app://Target_A/Action_PresentImage?id=1234
 @param handle 通过block 返回对象
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))handle;

/**
 @brief 根据类名,方法,参数实例化对象并执行
 @param targetName 被实例化的类名称
 @param actionName 被执行的类对应的方法名
 @param params 执行方法对应的参数
 @param shouldCacheTarget 是否缓存被实例化的对象
 */
- (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName
             params:(NSDictionary *)params
  shouldCacheTarget:(BOOL)shouldCacheTarget;

/**
 @brief 根据类名称清除缓存的实例
 @param targetName 需要被清除实例的类名称
 */
- (void)releaseCacheTargetWithTargetName:(NSString *)targetName;

@end

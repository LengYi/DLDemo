//
//  DLKeyChain.h
//  KeyChain
//
//  Created by ice on 17/3/6.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLKeyChain : NSObject

/**
 @brief 根据Key将数据保存到KeyChain中,KeyChain属于系统,相应的App删除了被保存的数据依然存在
 @param data 需要被保存的数据
 @param key 被保存数据对应的key 建议命名格式为  com.xxx.xxx
 */
+ (void)saveDataWithKeyChain:(id)data forKey:(NSString *)key;

/**
 @brief 根据Key读取被保存的数据
 @param key 被保存数据对应的key
 */
+ (id)loadDataWithKeyChain:(NSString *)key;

/**
 @brief 删除被保存到KeyChain中的数据
 @param key 被保存数据对应的key
 */
+ (void)deleteDataWithKeyChain:(NSString *)key;

@end

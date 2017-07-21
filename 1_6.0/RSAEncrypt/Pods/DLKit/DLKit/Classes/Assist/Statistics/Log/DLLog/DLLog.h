//
//  DLLog.h
//  Pods
//
//  Created by ice on 2017/6/20.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  NSLog输出到控制台,并增强输出功能
 *  DLog日志保存在 /Document/log.txt中
 *  第三方日志框架  pod 'CocoaLumberjack' 有时间继续完善自己的框架
 */

#define NSLog(s, ...) NSLog( @"====>>>>>  %@ #%d: %@",[NSString stringWithUTF8String:__FUNCTION__],__LINE__,[NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define DLog(...) [DLLog log:[NSString stringWithFormat:__VA_ARGS__] func:[NSString stringWithUTF8String:__FUNCTION__] linnum:__LINE__];


typedef void(^MailVCBlock)(UIViewController *vc,BOOL isDismiss);

@interface DLLog : NSObject
/**
 *  实例化一个对象
 *
 *  @return 单例
 */
+ (DLLog *)shareInstance;

/**
 *  打印日志
 *
 *  @param str 日志
 *  @param fun 类名方法名
 *  @param num 方法所在的行索引
 */
+ (void)log:(NSString*)str func:(NSString *)fun linnum:(int)num;

/**
 *  已附件的形式发送日志
 *
 *  @param email   接收附件的邮箱地址
 *  @param title   邮箱标题
 *  @param content 邮箱内容
 *  @param block   回调展示邮箱视图
 */
- (void)sendLogToEmail:(NSString *)email
                 title:(NSString *)title
               content:(NSString *)content
                 block:(MailVCBlock)block;

@end

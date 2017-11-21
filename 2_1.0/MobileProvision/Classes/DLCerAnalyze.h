//
//  DLCerAnalyze.h
//  Pods
//
//  Created by ice on 2017/8/3.
//
//

#import <Foundation/Foundation.h>

@interface DLCerAnalyze : NSObject
+ (NSDictionary *)getMobileProvision;

+ (NSString *)teamName;

+ (NSString *)teamID;

+ (NSString *)provisionExpiredTime;

+ (NSDate *)cerExpireTime;

@end

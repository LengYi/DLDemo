//
//  NSDate+Extended.h
//  GuangdianTong
//
//  Created by ice on 17/2/10.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extended)

+ (NSDate *)dateFromString:(NSString *)str;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSInteger)compareCurrentTime:(NSDate *)date;

- (NSInteger)year;

- (NSInteger)month;

- (NSInteger)day;

- (NSInteger)hour;

- (NSInteger)miniute;

- (NSInteger)second;

//周日为 1，周一为 2，周二为 3，周三为 4，周四为 5，周五为 6，周六为 7
- (NSInteger)weekDay;
@end

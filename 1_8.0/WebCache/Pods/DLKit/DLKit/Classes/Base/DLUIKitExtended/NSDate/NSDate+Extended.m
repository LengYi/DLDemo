//
//  NSDate+Extended.m
//  GuangdianTong
//
//  Created by ice on 17/2/10.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "NSDate+Extended.h"

@implementation NSDate (Extended)
+ (NSDate *)dateFromString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (NSInteger)compareCurrentTime:(NSDate *)date{
    NSDate *currentDate = [NSDate date];    
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:date];
    
    return ((NSInteger)interval)/(3600 * 24);
}

- (NSInteger)year{
    return [[self getDateComponent:self] year];
}

- (NSInteger)month{
    return [[self getDateComponent:self] month];
}

- (NSInteger)day{
    return [[self getDateComponent:self] day];
}

- (NSInteger)hour{
    return [[self getDateComponent:self] hour];
}

- (NSInteger)miniute{
    return [[self getDateComponent:self] minute];
}

- (NSInteger)second{
    return [[self getDateComponent:self] second];
}

- (NSInteger)weekDay{
    return [[self getDateComponent:self] weekday];
}

- (NSDateComponents*)getDateComponent:(NSDate *)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *dayComponent = [cal components:unitFlags fromDate:date];
    return dayComponent;
}

@end

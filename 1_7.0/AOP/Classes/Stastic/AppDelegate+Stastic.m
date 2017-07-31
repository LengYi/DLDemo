//
//  AppDelegate+Stastic.m
//  AOP
//
//  Created by ice on 2017/7/21.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "AppDelegate+Stastic.h"
#import "DLAOP.h"

@implementation AppDelegate (Stastic)
+ (void)setupLogging{
    NSDictionary *configDic = @{
                                @"ViewController":@{
                                        @"des":@"show ViewController",
                                        },
                                @"Test1ViewController":@{
                                        @"des":@"show Test1ViewController",
                                        @"TrackEvents":@[@{
                                                             @"EventDes":@"click action1",
                                                             @"EventSelectorName":@"action1",
                                                             @"block":^(id<AspectInfo>aspectInfo){
                                                                 NSLog(@"统计 Test1ViewController action1 点击事件");
                                                             },
                                                             },
                                                         @{
                                                             @"EventDes":@"click action2",
                                                             @"EventSelectorName":@"action2",
                                                             @"block":^(id<AspectInfo>aspectInfo){
                                                                 NSLog(@"统计 Test1ViewController action2 点击事件");
                                                             },
                                                             }],
                                        },
                                @"Test2ViewController":@{
                                        @"des":@"show Test2ViewController",
                                        }
                                };
    
    [DLAOP setUpWithConfig:configDic];
}

@end

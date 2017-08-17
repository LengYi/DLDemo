//
//  HtmlCacheManager.m
//  WebCache
//
//  Created by ice on 2017/8/16.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "HtmlCacheManager.h"

static NSString *const cacheName = @"HtmlCacheName";
@implementation HtmlCacheManager

+ (instancetype)shareInstance{
    static HtmlCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[HtmlCacheManager alloc] initWithName:cacheName];
        }
    });
    
    return manager;
}
@end

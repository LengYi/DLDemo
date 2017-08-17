//
//  HtmlCacheManager.h
//  WebCache
//
//  Created by ice on 2017/8/16.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache/YYCache.h>

@interface HtmlCacheManager : YYCache
+ (instancetype)shareInstance;
@end

//
//  CacheURLProtocol.h
//  Cache
//
//  Created by ice on 2017/8/15.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  缓存网络请求结果,无网络时直接返回上次缓存结果
 */
@interface CacheURLProtocol : NSURLProtocol

@end

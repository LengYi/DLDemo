//
//  NSObject+Swizzle.h
//  Pods
//
//  Created by ice on 2017/7/24.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 *  通用IMP方法交换处理类
 */
@interface NSObject (Swizzle)

+ (void)swizzleSelector:(SEL)originalSelector
   withSwizzledSelector:(SEL)swizzledSelector;

@end

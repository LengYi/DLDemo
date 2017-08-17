//
//  NSObject+Swizzle.m
//  Pods
//
//  Created by ice on 2017/7/24.
//
//

#import "NSObject+Swizzle.h"

@implementation NSObject (Swizzle)

+ (void)swizzleSelector:(SEL)originalSelector
   withSwizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class,originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class,swizzledSelector);
    
    // 若已经存在，则添加会失败
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    /**
     *  若原来的方法并不存在，则添加即可
     *  方法可能不是在这个类里，可能是在其父类中才有实现，
     *  因此先尝试添加方法的实现，若添加成功了，则直接替换一下实现即可。
     *  若添加失败了，说明已经存在这个方法实现了，则只需要交换这两个方法的实现就可以了。
     */
    if (didAddMethod) {
        class_replaceMethod(class,swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end

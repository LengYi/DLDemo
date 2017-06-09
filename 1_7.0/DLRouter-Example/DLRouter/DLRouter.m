//
//  DLRouter.m
//  DLRouter-Example
//
//  Created by ice on 2017/5/23.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLRouter.h"

#pragma mark - RouterRight
@implementation RouterRight
+ (instancetype)defaultRouterRight{
    RouterRight *defaultRight = [[RouterRight alloc] init];
    defaultRight.accessRight = DLRouterAccessRight0;
    defaultRight.info = @"";
    return defaultRight;
}

@end

#pragma mark - RouterOptions
@implementation RouterOptions
+ (instancetype)defaultOptions{
    RouterOptions *option = [[RouterOptions alloc] init];
    option.routerRight = [RouterRight defaultRouterRight];
    return option;
}

@end

#pragma mark - DLRouter
@interface DLRouter ()
@property (nonatomic,strong) DLRouterConfig *config;
@end

@implementation DLRouter

+ (instancetype)shareInstance{
    static DLRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[DLRouter alloc] init];
    });
    
    return router;
}

+ (void)configRouter:(DLRouterConfig *)config{
    [DLRouter shareInstance].config = config;
}

+ (void)open:(NSString *)vcClassName{
    
}

+ (void)open:(NSString *)vcClassName block:(void (^)())block{
    if (!vcClassName || ![vcClassName isKindOfClass:[NSString class]]) {
        NSAssert(NO,@"vcClassName is nil OR is not a NSString class");
        return;
    }
    
    UIViewController *vc = [self getVCWithConfigInfo:vcClassName];
    if (![self routerViewController:vc options:nil]) {
        
    }
}

+ (UIViewController *)getVCWithConfigInfo:(NSString *)vcClassName{
    Class vcClass = NSClassFromString(vcClassName);
    UIViewController *vc = [[vcClass alloc] init];
    if (!vc) { // 创建失败返回一个默认的空 VC
        vc = [[UIViewController alloc] init];
    }
    return vc;
}

+ (BOOL)routerViewController:(UIViewController *)vc options:(RouterOptions *)options{
    // 跳转之前先检查是否有相关的跳转权限,没有则不跳转并进行异常处理
    
    UINavigationController *nav = [DLRouter shareInstance].config.rootNavVC;
    if (!nav && [nav isKindOfClass:[UINavigationController class]]) {
        return NO;
    }
    
    if (nav.presentationController) {
        [nav dismissViewControllerAnimated:options.animated completion:nil];
    }
    
    if (options.isPressent) {
        [nav presentViewController:vc
                          animated:options.animated
                        completion:nil];
        return YES;
    }else{
        [nav pushViewController:vc
                       animated:options.animated];
        return YES;
    }
    
    return NO;
}
@end

//
//  DLRouter.m
//  DLRouter-Example
//
//  Created by ice on 2017/5/23.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLRouter.h"
#import "DLJsonFileHandler.h"

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
    option.isPressent = NO;
    option.animated = YES;
    option.routerRight = [RouterRight defaultRouterRight];
    return option;
}

+ (instancetype)optionsWithParams:(NSDictionary *)params{
    RouterOptions *options = [self defaultOptions];
    options.params = params;
    return options;
}

@end

#pragma mark - DLRouter
@interface DLRouter ()
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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:config.sepcialJumpList ofType:nil];
    NSArray  *specialOptionsArr = [NSArray arrayWithContentsOfFile:path];
    NSArray *modulesArr = [DLJsonFileHandler getModulesFromJsonFile:config.routerJsonArray];
    
    [DLRouter shareInstance].modules = [NSSet setWithArray:modulesArr];
    [DLRouter shareInstance].specialOptionsSet = [NSSet setWithArray:specialOptionsArr];
    [DLRouter shareInstance].config = config;
}

+ (void)open:(NSString *)vcClassName{
    RouterOptions *options = [RouterOptions defaultOptions];
    [self open:vcClassName options:options block:nil];
}

+ (void)open:(NSString *)vcClassName options:(RouterOptions *)options{
    [self open:vcClassName options:options block:nil];
}

+ (void)open:(NSString *)vcClassName
     options:(RouterOptions *)options
       block:(void (^)())block{
    if (!vcClassName || ![vcClassName isKindOfClass:[NSString class]]) {
        NSAssert(NO,@"vcClassName is nil OR is not a NSString class");
        return;
    }
    
    // 如果options为空则指定默认配置
    if(!options){
        options = [RouterOptions defaultOptions];
    }
    // 配置路由权限,默认是default,如果有重载该方法,则获取到新的权限
    options = [DLAccessRightHandler configAccessRight:options];
    
    UIViewController *vc = [self configVCWithClassName:vcClassName options:options];
    if (![self routerViewController:vc options:options]) {
        // 跳转失败
        return;
    }
    
    if (block) {
        block();
    }
}

+ (void)openWithUrl:(NSString *)url{
    [self openWithUrl:url params:nil];
}

+ (void)openWithUrl:(NSString *)url params:(NSDictionary *)params{
    // 需要进行校验 TODO
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *tempURL = [NSURL URLWithString:url];
    NSString *scheme =tempURL.scheme;
    NSString *resourceSpecifier = tempURL.resourceSpecifier;
    if (![scheme isEqualToString:[DLRouter shareInstance].config.urlScheme]){
        if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
            [self openWithHttp:url];
            return;
        }
    }else{
        scheme = [DLRouter shareInstance].config.urlScheme;
    }
    
    url = [NSString stringWithFormat:@"%@:%@",scheme,resourceSpecifier];
    NSURL *targetURL = [NSURL URLWithString:url];
    
    // 端口号作为moduleID
    NSNumber *moduleID = targetURL.port;
    NSString *path =targetURL.path;
    
    if(path && ![path isEqualToString:@""]){
        if (params) {
            
        }else{
            
        }
    }else{
         NSString *parameterStr = [[targetURL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (parameterStr) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSArray *parameterArr = [parameterStr componentsSeparatedByString:@"&"];
            for (NSString *parameter in parameterArr) {
                NSArray *parameterBoby = [parameter componentsSeparatedByString:@"="];
                if (parameterBoby.count == 2) {
                    [dic setObject:parameterBoby[1] forKey:parameterBoby[0]];
                }else
                {
                    NSLog(@"参数不完整");
                }
            }
            
            // 设置完参数执行页面跳转
            [self openWithModelID:[moduleID integerValue] params:[dic copy]];
            return;
        }else{
            // 没有参数直接跳转
            [self openWithModelID:[moduleID integerValue] params:[params copy]];
        }
    }
   
}

+ (void)openWithHttp:(NSString *)url{
    
}

+ (void)openWithModelID:(NSInteger)moduleID params:(NSDictionary *)params{
    NSEnumerator * enumerator = [[DLRouter shareInstance].modules objectEnumerator];
    NSDictionary *module = nil;
    while (module = [enumerator nextObject]) {
        NSEnumerator * specailEnumerator = [[DLRouter shareInstance].specialOptionsSet objectEnumerator];
        NSDictionary *specialModule = nil;
        NSString *vcClassName = [DLJsonFileHandler searchVcClassNameWithModuleID:moduleID];
//        while (specialModule = [specailEnumerator nextObject]) {
//            return;
//        }
        
        
        // 不存在特殊跳转
        RouterOptions *options = [RouterOptions optionsWithParams:params];
        // 配置权限
        options.moduleID = [NSString stringWithFormat:@"%d",(int)moduleID];
        [self open:vcClassName options:options];
        return;
    }
}

+ (void)openSecialVC:(UIViewController *)vc options:(RouterOptions *)options{
    if (!options) {
        options = [RouterOptions defaultOptions];
    }
    
    // 获取权限配置
    
    [self routerViewController:vc options:options];
}

+ (void)pop:(BOOL)animated{
    [self pop:nil animated:animated];
}

+ (void)pop:(NSDictionary *)params animated:(BOOL)animated{
    NSArray *vcArray = [DLRouter shareInstance].config.rootNavVC.viewControllers;
    NSUInteger count = vcArray.count;
    UIViewController *vc = nil;
    if (count > 1) {
        vc = vcArray[count - 2];
    }else{
        // 已经是跟视图,直接dismiss视图
        [self popToSpecialVC:nil animated:animated];
        return;
    }
    
    RouterOptions *options = [RouterOptions optionsWithParams:params];
    [self configVC:vc options:options];
    [self popToSpecialVC:vc animated:animated];
}

#pragma mark - PrivateMethod

+ (UIViewController *)configVCWithClassName:(NSString *)vcClassName options:(RouterOptions *)options{
    Class vcClass = NSClassFromString(vcClassName);
    UIViewController *vc = [[vcClass alloc] init];
    if (!vc) { // 创建失败返回一个默认的空 VC
        vc = [[UIViewController alloc] init];
    }
    
    NSString *modleID = options.moduleID;
    
    // 设置参数
    if (modleID) {
        //[vc setValue:modleID forKey:@"moduleID"];
    }
    
    [self configVC:vc options:options];
    return vc;
}

+ (void)configVC:(UIViewController *)vc options:(RouterOptions *)options{
    NSDictionary *params = options.params;
    if (params) {
        NSArray *propertyArr = [params allKeys];
        for (NSString *key in propertyArr) {
            id value = params[key];
            [vc setValue:value forKey:key];
        }
    }
}

+ (BOOL)routerViewController:(UIViewController *)vc options:(RouterOptions *)options{
    // 跳转之前先检查是否有相关的跳转权限,没有则不跳转并进行异常处理
    if(![DLAccessRightHandler validRightToOpenVC:options]){
        [DLAccessRightHandler handleNoRightVC:options];
        return NO;
    }
    
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


+ (void)popToSpecialVC:(UIViewController *)vc animated:(BOOL)animated{
    UINavigationController *nav = [DLRouter shareInstance].config.rootNavVC;
    if (nav.presentedViewController) {
        [nav dismissViewControllerAnimated:animated completion:nil];
    }else{
        [nav popToViewController:vc animated:animated];
    }
}
@end

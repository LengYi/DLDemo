//
//  UIApplication+Extern.m
//  AppManager
//
//  Created by ice on 17/3/16.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "UIApplication+Extern.h"
#import "LSApplicationProxy.h"
#import "LSApplicationWorkspace.h"
#import "LSPlugInKitProxy.h"

@implementation UIApplication (Extern)

#pragma mark - Public_Method
+ (NSDictionary *)scanAllInstanedApp{
    NSMutableDictionary *appProxyDict = [[NSMutableDictionary alloc] init];
    
#if APPSTORE == 1
    // 代码需要提交AppStore,则进行代码混淆
    // 将LSApplicationWorkspace,defaultWorkspace,allInstalledApplications 进行字符串加密,再解密使用,不显示使用这些字符串
    NSLog(@"请使用一种加密方式,加密 LSApplicationWorkspace,defaultWorkspace,allInstalledApplications，再解密使用");
    // 字符串加解密的操作请自行处理
    NSObject *ws = [self performTarget:@"LSApplicationWorkspace" action:@"defaultWorkspace" params:nil];
    SEL selector = NSSelectorFromString(@"allInstalledApplications");
    
    id apps = [self targetDoAction:ws action:selector params:nil];
#else
    LSApplicationWorkspace *ws = [LSApplicationWorkspace defaultWorkspace];
    id apps = [ws allInstalledApplications];
#endif

    // ios 11 使用以下方法获取安装列表,但是只能获取到部分已安装(APP 内含有插件eg:自定义键盘,appleWatch等)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
        apps = [[NSMutableArray alloc] init];
        // 获取含有插件的app信息
        NSArray *pluginsArr = [ws installedPlugins];
        for (int i = 0; i < pluginsArr.count; i++) {
            LSPlugInKitProxy *installedPlugin = pluginsArr[i];
            id bundle = [installedPlugin containingBundle];
            if (bundle) {
                [apps addObject:bundle];
            }
        }
    }
    if ([apps isKindOfClass:[NSArray class]]) {
        NSArray *applist = (NSArray *)apps;
        if (applist.count > 0) {
            for (LSApplicationProxy *appProxy in applist) {
                //id o = [appProxy installProgress];
                //BOOL s = [appProxy isPlaceholder];
                NSArray *array = [self getAppInfoWithProxy:appProxy];
                if (array.count >= 2) {
                    [appProxyDict setObject:array[1] forKey:array[0]];
                }
            }
        }
    }
    
    return appProxyDict;
}

#pragma mark - Private_Method
+ (NSArray *)getAppInfoWithProxy:(LSApplicationProxy *)appProxy{
    if (!appProxy) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // App 类型  System,User
    NSString *appType = [self checkString:[appProxy applicationType]];
    
    if ([appType isEqualToString:@"User"]) {
        NSString *appIdentifier = [self checkString:[appProxy applicationIdentifier]];
        NSString *shortVer = [self checkString:[appProxy shortVersionString]];
        NSString *bundleVer = [self checkString:[appProxy bundleVersion]];
        NSString *appDsid = [self checkString:[appProxy applicationDSID]];
        NSString *bundleDisplayName = [self checkString:[appProxy localizedName]];
        NSString *path = [self checkString:[[appProxy bundleURL] absoluteString]];
        NSString *bundleExecutable = [self checkString:[appProxy bundleExecutable]];
        NSString *teamID = [self checkString:[appProxy teamID]];
        NSString *signerIdentity = [appProxy signerIdentity];
        
        [dict setObject:appType forKey:@"ApplicationType"];
        [dict setObject:appIdentifier forKey:@"CFBundleIdentifier"];
        [dict setObject:shortVer forKey:@"CFBundleShortVersionString"];
        [dict setObject:bundleVer forKey:@"CFBundleVersion"];
        [dict setObject:appDsid forKey:@"ApplicationDSID"];
        [dict setObject:bundleDisplayName forKey:@"CFBundleDisplayName"];
        [dict setObject:path forKey:@"Path"];
        [dict setObject:bundleExecutable forKey:@"CFBundleExecutable"];
        [dict setObject:teamID forKey:@"TeamID"];
        [dict setObject:signerIdentity forKey:@"SignerIdentity"];
        
        [array addObject:appIdentifier];
        [array addObject:dict];
    }
    
    return array;
}

+ (NSString *)checkString:(NSString *)str{
    return str && str.length > 0 ? str : @"";
}

#if APPSTORE == 1
+ (id)performTarget:(NSString *)classString
             action:(NSString *)actionString
             params:(NSDictionary *)params{
    if (!classString || [classString isEqualToString:@""] || !actionString || [actionString isEqualToString:@""]) {
        return nil;
    }

    Class targetClass = NSClassFromString(classString);
    
    // 获取执行方法
    SEL selector = NSSelectorFromString(actionString);
    
    if ([targetClass respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [targetClass performSelector:selector withObject:params];
#pragma clang diagnostic pop
    }
    
    return nil;
}

+ (id)targetDoAction:(NSObject *)target action:(SEL)action params:(id)params{
    if (!target) {
        return nil;
    }
    
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    }
    return nil;
}

#endif

// 另一种调用类方法的列子
//+ (void)test{
//    NSObject *ws = [self performTarget:@"LSApplicationWorkspace" action:@"defaultWorkspace" params:nil];
//    SEL s = NSSelectorFromString(@"openApplicationWithBundleID:");
//    Method method = class_getInstanceMethod(NSClassFromString(@"LSApplicationWorkspace"),s);
//    IMP imp = method_getImplementation(method);
//    ((BOOL(*)(id self,SEL _cmd,NSString *))imp)(ws,s,@"com.tencent.mqq");
//}
@end

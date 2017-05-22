//
//  Mediator.m
//  DLMetadiator
//
//  Created by ice on 17/3/7.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "Mediator.h"

// 请修改为当前工程App的scheme
#define SELF_APP_SCHEME @"aaa"

@interface Mediator ()
@property (nonatomic,strong) NSMutableDictionary *cacheTargetDic;
@end

@implementation Mediator

#pragma mark - Public_Method
+ (instancetype)shareInstance{
    static Mediator *mediator = nil;
    static dispatch_once_t onceTokent;
    dispatch_once(&onceTokent, ^{
        mediator = [[Mediator alloc] init];
    });
    return mediator;
}

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))handle{
    if (![url.scheme isEqualToString:SELF_APP_SCHEME]) {
        return @(NO);
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *arr = [param componentsSeparatedByString:@"="];
        if (arr.count < 2) {
            continue;
        }
        [params setObject:[arr lastObject] forKey:[arr firstObject]];
    }
    
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    id objc = [self performTarget:url.host
                           action:actionName
                           params:params
                shouldCacheTarget:NO];
    if (handle) {
        if (objc) {
            handle(@{@"objc":objc});
        }else{
            handle(nil);
        }
    }
    
    return objc;
}

- (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName
             params:(NSDictionary *)params
  shouldCacheTarget:(BOOL)shouldCacheTarget{
    if (!targetName || [targetName isEqualToString:@""] || !actionName || [actionName isEqualToString:@""]) {
        return nil;
    }
    
    NSString *classString = [NSString stringWithFormat:@"Target_%@",targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:",actionName];

    // 获取实例对象
    NSObject *target = self.cacheTargetDic[classString];
    if (target == nil) {
        Class targetClass = NSClassFromString(classString);
        target = [[targetClass alloc] init];
    }
    
    // 获取执行方法
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        return nil;
    }
    
    // 是否缓存当前对象
    if (shouldCacheTarget) {
        self.cacheTargetDic[classString] = target;
    }
    
    // 正常执行OC方法
    id objc = [self targetDoAction:target action:action params:params];
    if (objc == nil) {
        // 判断是否是Swift对象及方法
        actionString = [NSString stringWithFormat:@"Action_%@WithParams:",actionName];
        action = NSSelectorFromString(actionString);
        objc = [self targetDoAction:target action:action params:params];
        if (objc == nil) {
            // 是否实现了notFound:方法
            action = NSSelectorFromString(@"notFound:");
            objc = [self targetDoAction:target action:action params:params];
            if (objc == nil) {
                // 找不到对应执行的方法
                [self.cacheTargetDic removeObjectForKey:classString];
                return nil;
            }
        }
    }
    
    return objc;
}

- (void)releaseCacheTargetWithTargetName:(NSString *)targetName{
    if (!targetName) {
        NSString *classString = [NSString stringWithFormat:@"Target_%@",targetName];
        [self.cacheTargetDic removeObjectForKey:classString];
    }
}

#pragma mark - Private_Method
- (id)targetDoAction:(NSObject *)target action:(SEL)action params:(NSDictionary*)params{
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    }
    return nil;
}


#pragma mark - SetGet_Method
- (NSMutableDictionary *)cacheTargetDic{
    if (!_cacheTargetDic) {
        _cacheTargetDic = [[NSMutableDictionary alloc] init];
    }
    
    return _cacheTargetDic;
}













@end

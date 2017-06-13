//
//  DLAccessRightHandler.m
//  DLRouter-Example
//
//  Created by ice on 2017/6/13.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLAccessRightHandler.h"
#import "DLRouter.h"

@implementation DLAccessRightHandler

+ (BOOL)validateUrl:(NSString *)url{
    return YES;
}

+ (BOOL)validRightToOpenVC:(RouterOptions *)options{
    return YES;
}

+ (RouterOptions *)configAccessRight:(RouterOptions *)options{
    // 默认权限为default
    options.routerRight.accessRight = DLRouterAccessRightDefault;
    return options;
}

+ (void)handleNoRightVC:(RouterOptions *)options{
    
}

@end

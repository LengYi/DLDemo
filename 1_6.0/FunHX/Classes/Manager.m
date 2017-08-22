//
//  Manager.m
//  FunHX
//
//  Created by ice on 2017/8/22.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "Manager.h"

static Manager_t *manager = NULL;

@implementation _Manager

static BOOL _isVip(void){
    return YES;
}

static BOOL _isVerified(void){
     return YES;
}

static void _resetPassword(NSString *password){
    NSLog(@"重置密码 %@",password);
}

+ (Manager_t *)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = malloc(sizeof(Manager_t));
        manager->isVip = _isVip;
        manager->isVerified = _isVerified;
        manager->resetPassword = _resetPassword;
    });
    
    return manager;
}

+ (void)destroy{
    manager ? free(manager) : 0;
    manager = NULL;
}

@end

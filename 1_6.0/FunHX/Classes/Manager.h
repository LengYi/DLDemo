//
//  Manager.h
//  FunHX
//
//  Created by ice on 2017/8/22.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _man{
    BOOL (*isVip)(void);
    BOOL (*isVerified)(void);
    void (*resetPassword)(NSString *password);
}Manager_t;

#define Manager ([_Manager sharedInstance])

@interface _Manager : NSObject
//+ (BOOL)isVip;
//+ (BOOL)isVerified;
//+ (void)resetPassword:(NSString *)password;

+ (Manager_t *)sharedInstance;

@end

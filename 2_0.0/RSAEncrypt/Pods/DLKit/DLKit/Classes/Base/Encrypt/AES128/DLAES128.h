//
//  DLAES128.h
//  WC
//
//  Created by ice on 17/3/28.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLAES128 : NSObject

+ (NSString *)encryptStr:(NSString *)plainStr
                     key:(NSString *)key
                      iv:(NSString *)iv;

+ (NSString*)decryStr:(NSString*)plainStr
                  key:(NSString*)key
                   iv:(NSString *)iv;

+ (NSData *)encryData:(NSData *)data
                  key:(NSString *)key
                   iv:(NSString *)iv;

+ (NSData *)decryData:(NSData *)data
                  key:(NSString *)key
                   iv:(NSString *)iv;

@end

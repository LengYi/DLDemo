//
//  NSString+Encrypto.m
//  GuangdianTong
//
//  Created by ice on 17/2/15.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "NSString+Encrypto.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MD5)

- (NSString *)MD5{
    const char *str = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (unsigned int)strlen(str), digest);
    
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultStr appendFormat:@"%02x",digest[i]];
    }
    
    return resultStr;
}

- (NSString *)SHA1{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([data bytes], (unsigned int)[data length], digest);
    
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [resultStr appendFormat:@"%02x",digest[i]];
    }
    
    return resultStr;
}


@end

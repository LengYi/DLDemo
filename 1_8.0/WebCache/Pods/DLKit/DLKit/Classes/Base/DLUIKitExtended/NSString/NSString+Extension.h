//
//  NSString+Extension.h
//  Pods
//
//  Created by ice on 17/4/24.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)stringFromData:(NSData *)data;

+ (NSData *)dataFromHexString:(NSString *)hexString;
+ (NSString *)hexStringFromData:(NSData *)data;

+ (BOOL)isValidEmailString:(NSString *)string;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isTelephoneNumber;

@end

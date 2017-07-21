//
//  DLDESBase64.h
//  WC
//
//  Created by ice on 17/3/28.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLDESBase64 : NSObject

+ (NSString *)encryptText:(NSString *)plainText
                      key:(NSString *)key;

+ (NSString*)desText:(NSString*)plainText
                 key:(NSString*)key;

@end

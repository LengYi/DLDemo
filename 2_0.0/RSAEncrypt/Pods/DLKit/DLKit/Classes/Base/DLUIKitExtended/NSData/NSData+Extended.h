//
//  NSData+Extended.h
//  GuangdianTong
//
//  Created by ice on 17/2/10.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extended)
// 字符串转成NSData
+ (NSData *)dataFromString:(NSString *)string;
// BOOL转成NSData
+ (NSData *)dataFromBool:(BOOL)value;
// Int转成NDSata
+ (NSData *)dataFromInt:(NSInteger)value;
// Number转成NSData
+ (NSData *)dataFromNumber:(NSNumber *)value;
// 字典转成JSONData
+ (NSData *)dictToJsonData:(NSDictionary *)dict;
// JSONData转成字典
+ (NSDictionary *)jsonDataToDict:(NSData *)data;
@end

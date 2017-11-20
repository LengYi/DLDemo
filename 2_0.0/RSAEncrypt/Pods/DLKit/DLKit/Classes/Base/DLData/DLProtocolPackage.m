//
//  DLProtocolPackage.m
//
//  Created by ice on 17/2/10.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLProtocolPackage.h"

@implementation DLProtocolPackage

+ (NSData *)packageDataWithStringObjects:(id)firstObject,...{
    id eachObject = nil;
    va_list argumentList;
    if (firstObject && [firstObject isKindOfClass:[NSString class]]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        // 第一个参数转换成Data,并存储至数组
        [array addObject:[self dataFromString:firstObject]];
        
        // 获取所有参数并存入 argumentList
        va_start(argumentList, firstObject);
        // 取出每一个参数
        while ((eachObject = va_arg(argumentList, id))) {
            [array addObject:[DLProtocolPackage dataFromString:eachObject]];
        }
        
        va_end(argumentList);
        
        return [DLProtocolPackage packageDataWithDataArray:array];
    }else{
#ifdef DEBUG
        NSLog(@"参数仅支持NSString类型");
#endif
    }
    
    return nil;
}

/*
 * 每项前加4个字节的头,连成bytes串
*/
+ (NSData *)packageDataWithDataArray:(NSArray *)array{
    if (array == nil || array.count <= 0) {
        return nil;
    }
    
    
    // 计算bytes数组总长度,iOS int类型是4字节所有用int即可
    int totalLen = 0;
    for (NSData *data in array) {
        if (![data isKindOfClass:[NSData class]]) {
#ifdef DEBUG
            NSLog(@"参数数组包含非NSData类型");
#endif
            return nil;
        }else{
            totalLen += [data length];
            // 每项数据加4字节长度用于标记实际数据长度
            totalLen += 4;
        }
    }
    
    // 封装发送数据包 (byte数组)
    // 开辟空间 大小 = 类型字节大小 * 总长
    Byte *bytes = malloc(sizeof(Byte) * totalLen);
    // 开辟的空间清0
    memset(bytes, 0, totalLen);
    
    Byte header[4];
    int index = 0;
    for (int i = 0; i < array.count; i++) {
        NSData *data = array[i];
        if (data == nil) {
            [DLProtocolPackage intToByte:header value:0];
            memcpy(bytes + index, header, 4);
            index += 4;
        }else{
            [DLProtocolPackage intToByte:header value:(int)[data length]];
            memcpy(bytes + index, header, 4);
            index += 4;
            
            memcpy(bytes + index, [data bytes], [data length]);
            index += [data length];
        }
    }
    
    NSData *postData = [NSData dataWithBytes:bytes length:totalLen];
    free(bytes);
    bytes = NULL;
    return postData;
}

+ (NSData *)dataFromString:(NSString *)string{
    if (string == nil || ![string isKindOfClass:[NSString class]]) {
#ifdef DEBUG
        NSLog(@"参数 %@ 是 %@,不是NSStirng类型",string,[string class]);
#endif
        return nil;
    }
    
    NSData *resultData = [NSData dataWithBytes:[string UTF8String]
                                        length:strlen([string UTF8String])];
    return resultData;
}


/* 高位                                   低位
 *  第四个字节   第三个字节   第二个字节   第一个字节
 * 0000 0000  0000 0000  0100 1101  1010 0100   = 19876
 * 从低位字节开始存储到Byte数组中
 */
+ (void)intToByte:(Byte *)intByte value:(int)value
{
    //将int放入一个byte数组的前四位
    intByte[0] = (Byte)(0xff & value);                  // 取第一个字节  右移,右边数据丢弃,左边无符号数补0,有符号数填充补符位
    intByte[1] = (Byte)((0xff00 & value) >> 8);         // 取第二个字节
    intByte[2] = (Byte)((0xff0000 & value) >> 16);      // 取第三个字节
    intByte[3] = (Byte)((0xff000000 & value) >> 24);    // 取第四个字节
}




@end

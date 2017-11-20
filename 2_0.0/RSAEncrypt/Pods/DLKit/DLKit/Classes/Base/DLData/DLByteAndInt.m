//
//  DLByteAndInt.m
//
//  Created by ice on 17/2/13.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLByteAndInt.h"

@implementation DLByteAndInt

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

+ (int)ByteToInt:(Byte *)intByte{
    int value = (intByte[0] & 0xff) |               // 还原第一个字节值  左移,右边补0
    ((intByte[1] << 8) & 0xff00) |                  // 还原第二个字节值
    ((intByte[2] << 16) & 0xff0000) |               // 还原第三个字节值
    ((intByte[3] << 24) & 0xff000000);              // 还原第四个字节值
    return value;
}

@end

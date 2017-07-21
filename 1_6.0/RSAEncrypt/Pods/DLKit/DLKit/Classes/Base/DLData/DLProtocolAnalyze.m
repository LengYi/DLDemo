//
//  DLProtocolAnalyze.m
//  GuangdianTong
//
//  Created by ice on 17/2/13.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLProtocolAnalyze.h"

const int BYTE_MAX_LENGTH = 2097152; // 2*1024*1024 = 2MB

@implementation DLProtocolAnalyze

+ (void)analyzeData:(NSData *)data completion:(void (^)(ProtocolAnalyzeCode code,NSArray *arr))handle{
    if (data && [data isKindOfClass:[NSData class]]) {
#ifdef DEBUG
        NSLog(@"解析的总字节数: %d",(int)[data length]);
#endif
        NSArray *resultArr = [DLProtocolAnalyze analyzeReceiveData:data];
        handle(kProtocolAnalyzeCodeSuccess,resultArr);
    }else{
#ifdef DEBUG
        NSLog(@"数据非法,解析失败");
#endif
        handle(kProtocolAnalyzeCodeFailed,nil);
    }
}

+ (NSArray *)analyzeReceiveData:(NSData *)data{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *resultArr = [self unpack:data];
    
    for (NSData *deva in resultArr) {
        if ([DLProtocolAnalyze tryunpack:deva]) {
            [array addObject:[DLProtocolAnalyze analyzeReceiveData:deva]];
        }else{
            NSString *value = [[NSString alloc] initWithBytes:[deva bytes]
                                                       length:[deva length]
                                                     encoding:NSUTF8StringEncoding];
            [array addObject:(value.length > 0 ? value : @"")];
        }
    }
    return array;
}

+ (BOOL)tryunpack:(NSData *)data{
    @try {
        if ([DLProtocolAnalyze unpack:data].count > 0) {
            return YES;
        }
        
        return NO;
    } @catch (NSException *exception) {
        return NO;
    }
}

+ (NSArray *)unpack:(NSData *)data{
    
    int index = 0;
    Byte *bytes = (Byte *)[data bytes];
    int totalLen = (int)[data length];
    
    NSMutableArray *arr = [NSMutableArray array];
    while (index + 4 <= totalLen) {
        Byte lenByte[4];
        memcpy(lenByte, bytes + index, 4);
        int len = [DLProtocolAnalyze ByteToInt:lenByte];
        
        // 数据长度合法检查,最多容纳BYTE_MAX_LENGTH长度数据
        if (len < 0 || len > BYTE_MAX_LENGTH) {
            return  nil;
        }else{
            index += 4;
            
            Byte *data = (Byte *)malloc(sizeof(Byte) * len);
            memset(data, 0, len);
            memcpy(data, bytes + index, len);
            
            [arr addObject:[NSData dataWithBytes:data length:len]];
            free(data);
            
            index += len;
        }
    }

    return arr;
}

+ (int)ByteToInt:(Byte *)intByte{
    int value = (intByte[0] & 0xff) |               // 还原第一个字节值  左移,右边补0
    ((intByte[1] << 8) & 0xff00) |                  // 还原第二个字节值
    ((intByte[2] << 16) & 0xff0000) |               // 还原第三个字节值
    ((intByte[3] << 24) & 0xff000000);              // 还原第四个字节值
    return value;
}

@end

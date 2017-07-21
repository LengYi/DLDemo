//
//  DLDESBase64.m
//  WC
//
//  Created by ice on 17/3/28.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLAES128.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation DLAES128

+ (NSString *)encryptStr:(NSString *)plainStr
                      key:(NSString *)key
                       iv:(NSString *)iv{
    NSString *enStr = @"";
    if (!plainStr) {
        return enStr;
    }
    NSData *orignData = [[NSData alloc] initWithBytes:[plainStr UTF8String] length:strlen([plainStr UTF8String])];
    NSData *resultData = [self AES128Operation:kCCEncrypt
                                          data:orignData
                                           key:key
                                            iv:iv];
    if(resultData){
        enStr = [GTMBase64 stringByEncodingData:resultData];
    }
    
    return enStr;
}

+ (NSString*)decryStr:(NSString*)plainStr
                 key:(NSString*)key
                  iv:(NSString *)iv{
    NSString *enStr = @"";
    if (!plainStr) {
        return enStr;
    }
    
    NSData *originData = [[NSData alloc] initWithBytes:[plainStr UTF8String] length:strlen([plainStr UTF8String])];
    NSData *data = [GTMBase64 decodeData:originData];
    NSData *resultData = [self AES128Operation:kCCDecrypt
                                          data:data
                                           key:key
                                            iv:iv];
    if(resultData){
        enStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    
    return enStr;
}

+ (NSData *)encryData:(NSData *)data
                  key:(NSString *)key
                  iv:(NSString *)iv{
    return [self AES128Operation:kCCEncrypt
                            data:data
                             key:key
                              iv:iv];
}

+ (NSData *)decryData:(NSData *)data
                  key:(NSString *)key
                   iv:(NSString *)iv{
    return [self AES128Operation:kCCDecrypt
                            data:data
                             key:key
                              iv:iv];
}

+ (NSData *)AES128Operation:(CCOperation)operation
                       data:(NSData *)data
                        key:(NSString *)key
                         iv:(NSString *)iv{
    NSMutableData *keyData = [NSMutableData dataWithLength:kCCKeySizeAES128];
    [keyData setData:[NSData dataWithBytes:[key UTF8String]
                                    length:strlen([key UTF8String])]];
    [keyData setLength:kCCKeySizeAES128];
    
    const char *keyPtr = keyData.bytes;
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = (dataLength + kCCBlockSizeAES128) &~(kCCBlockSizeAES128 - 1);
    void *buffer = malloc(bufferSize* sizeof(char));
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return resultData;
        
    }
    free(buffer);
    return nil;
}

@end

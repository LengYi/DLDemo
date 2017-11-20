//
//  DLDESBase64.m
//  WC
//
//  Created by ice on 17/3/28.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLDESBase64.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation DLDESBase64

+ (NSString *)encryptText:(NSString *)plainText
                      key:(NSString *)key{
    return [self desText:plainText
        encryptOrDecrypt:kCCEncrypt
                     key:key];
}

+ (NSString*)desText:(NSString*)plainText
                 key:(NSString*)key{
    return [self desText:plainText
        encryptOrDecrypt:kCCDecrypt
                     key:key];
}

+ (NSString*)desText:(NSString*)plainText
    encryptOrDecrypt:(CCOperation)encryptOrDecrypt
                 key:(NSString*)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const char *keyPtr = NULL;
    if (key.length <= kCCKeySizeDES) {
        char keyArr[kCCKeySizeDES + 1];
        bzero(keyArr, sizeof(keyArr));
        [key getCString:keyArr maxLength:sizeof(keyArr) encoding:NSUTF8StringEncoding];
        keyPtr = keyArr;
    }else{
        keyPtr = [key UTF8String];
    }
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       keyPtr,
                       kCCKeySizeDES,
                       keyPtr,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);

    NSString *result = @"";
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
        
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    free(bufferPtr);
    
    return result;
    
}

@end

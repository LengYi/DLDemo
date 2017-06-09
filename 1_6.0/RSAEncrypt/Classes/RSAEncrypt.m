//
//  RSAEncrypt.m
//  RSAEncrypt
//
//  Created by ice on 2017/6/5.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "RSAEncrypt.h"

@implementation RSAEncrypt

+ (BOOL)generateKeyWithSize:(int)keySize
                 privateKey:(RSA **)privateKey
                  publicKey:(RSA **)publicKey{
    if (keySize == 512 || keySize == 1024 || keySize == 2048) {
        RSA *rsa = RSA_generate_key(keySize,RSA_F4,NULL,NULL);
        if (rsa) {
            *privateKey = RSAPrivateKey_dup(rsa);
            *publicKey = RSAPublicKey_dup(rsa);
            if (publicKey && privateKey) {
                return YES;
            }
        }
    }
    
    return NO;
}

+ (NSString *)pemFormatPrivateKey:(RSA *)key{
    if (!key) {
        return nil;
    }
    
    BIO *bio = BIO_new(BIO_s_mem());
    PEM_write_bio_RSAPrivateKey(bio, key, NULL, NULL, 0, NULL, NULL);
    
    BUF_MEM *bptr;
    BIO_get_mem_ptr(bio, &bptr);
    BIO_set_close(bio, BIO_NOCLOSE); /* So BIO_free() leaves BUF_MEM alone */
    BIO_free(bio);
    
    return [NSString stringWithUTF8String:bptr->data];
}

+ (NSString *)pemFormatPublicKey:(RSA *)key{
    if (!key) {
        return @"";
    }
    
    BIO *bio = BIO_new(BIO_s_mem());
    PEM_write_bio_RSA_PUBKEY(bio, key);
    
    BUF_MEM *bptr;
    BIO_get_mem_ptr(bio, &bptr);
    BIO_set_close(bio, BIO_NOCLOSE); /* So BIO_free() leaves BUF_MEM alone */
    BIO_free(bio);
    
    return [NSString stringWithUTF8String:bptr->data];
}

+ (NSString *)base64EncodeFromPem:(NSString *)pemFormate{
    return [[pemFormate componentsSeparatedByString:@"-----"] objectAtIndex:2];
}

#pragma mark ---密钥格式转换
+ (RSA *)RSAPublicKeyFromPEM:(NSString *)publicKeyPEM{
    const char *buffer = [publicKeyPEM UTF8String];
    
    BIO *bpubkey = BIO_new_mem_buf(buffer, (int)strlen(buffer));
    
    RSA *rsaPublic = PEM_read_bio_RSA_PUBKEY(bpubkey, NULL, NULL, NULL);
    
    BIO_free_all(bpubkey);
    return rsaPublic;
}

+ (RSA *)RSAPrivateKeyFromPEM:(NSString *)privatePEM {
    
    const char *buffer = [privatePEM UTF8String];
    
    BIO *bpubkey = BIO_new_mem_buf(buffer, (int)strlen(buffer));
    
    RSA *rsaPrivate = PEM_read_bio_RSAPrivateKey(bpubkey, NULL, NULL, NULL);
    BIO_free_all(bpubkey);
    return rsaPrivate;
}

+ (RSA *)RSAPublicKeyFromBase64:(NSString *)base64PubKey{
    //格式化公钥
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    int count = 0;
    for (int i = 0; i < [base64PubKey length]; ++i) {
        
        unichar c = [base64PubKey characterAtIndex:i];
        if (c == '\n' || c == '\r') {
            continue;
        }
        [result appendFormat:@"%c", c];
        if (++count == 64) {
            [result appendString:@"\n"];
            count = 0;
        }
    }
    [result appendString:@"\n-----END PUBLIC KEY-----"];
    
    return [self RSAPublicKeyFromPEM:result];
}


+ (RSA *)RSAPrivateKeyFromBase64:(NSString *)base64PrivateKey{
    //格式化私钥
    const char *pstr = [base64PrivateKey UTF8String];
    int len = (int)[base64PrivateKey length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN RSA PRIVATE KEY-----\n"];
    int index = 0;
    int count = 0;
    while (index < len) {
        char ch = pstr[index];
        if (ch == '\r' || ch == '\n') {
            ++index;
            continue;
        }
        [result appendFormat:@"%c", ch];
        if (++count == 64) {
            
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END RSA PRIVATE KEY-----"];
    return [self RSAPrivateKeyFromPEM:result];
    
}

#pragma mark --- 公钥加密->私钥解密
+ (NSData *)encryptWithPublicKey:(RSA *)publicKey plainData:(NSData *)plainData{
    if (!publicKey || !plainData || plainData.length == 0) {
        return nil;
    }
    
    int publicRSALength = RSA_size(publicKey);
    double totalLength = [plainData length];
    int blockSize = publicRSALength - 11;
    int blockCount = ceil(totalLength / blockSize);
    size_t publicEncryptSize = publicRSALength;
    NSMutableData *encryptDate = [NSMutableData data];
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        char *publicEncrypt = malloc(publicRSALength);
        memset(publicEncrypt, 0, publicRSALength);
        const unsigned char *str = [dataSegment bytes];
        
        if(RSA_public_encrypt(dataSegmentRealSize,str,(unsigned char*)publicEncrypt,publicKey,RSA_PKCS1_PADDING)>=0){
            NSData *encryptData = [[NSData alloc] initWithBytes:publicEncrypt length:publicEncryptSize];
            [encryptDate appendData:encryptData];
        }
        free(publicEncrypt);
    }
    
    return encryptDate;
}

+ (NSData *)decryptWithPrivateKey:(RSA *)privateKey cipherData:(NSData *)cipherData{
    if (!privateKey || !cipherData || cipherData.length == 0) {
        return nil;
    }
    
    int privateRSALenght = RSA_size(privateKey);
    double totalLength = [cipherData length];
    int blockSize = privateRSALenght;
    int blockCount = ceil(totalLength / blockSize);
    NSMutableData *decrypeData = [NSMutableData data];
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        long dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        const unsigned char *str = [dataSegment bytes];
        unsigned char *privateDecrypt = malloc(privateRSALenght);
        memset(privateDecrypt, 0, privateRSALenght);
        
        if(RSA_private_decrypt(privateRSALenght,str,privateDecrypt,privateKey,RSA_PKCS1_PADDING)>=0){
            NSInteger length =strlen((char *)privateDecrypt);
            NSData *data = [[NSData alloc] initWithBytes:privateDecrypt length:length];
            [decrypeData appendData:data];
        }
        free(privateDecrypt);
    }
    
    return decrypeData;
}

#pragma mark --- 私钥加密->公钥解密
+ (NSData *)encryptWithPrivateRSA:(RSA *)privateKey plainData:(NSData *)plainData{
    if(!privateKey || !plainData || plainData.length == 0){
        return nil;
    }
    
    int privateRSALength = RSA_size(privateKey);
    double totalLength = [plainData length];
    int blockSize = privateRSALength - 11;
    int blockCount = ceil(totalLength / blockSize);
    size_t privateEncryptSize = privateRSALength;
    NSMutableData *encryptDate = [NSMutableData data];
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        char *publicEncrypt = malloc(privateRSALength);
        memset(publicEncrypt, 0, privateRSALength);
        const unsigned char *str = [dataSegment bytes];
        if(RSA_private_encrypt(dataSegmentRealSize,str,(unsigned char*)publicEncrypt,privateKey,RSA_PKCS1_PADDING)>=0){
            NSData *encryptData = [[NSData alloc] initWithBytes:publicEncrypt length:privateEncryptSize];
            [encryptDate appendData:encryptData];
        }
        free(publicEncrypt);
    }
    return encryptDate;
}

+ (NSData *)decryptWithPublicKey:(RSA *)publicKey cipherData:(NSData *)cipherData{
    if (!publicKey || !cipherData || cipherData.length == 0) {
        return nil;
    }
    
    int publicRSALenght = RSA_size(publicKey);
    double totalLength = [cipherData length];
    int blockSize = publicRSALenght;
    int blockCount = ceil(totalLength / blockSize);
    NSMutableData *decrypeData = [NSMutableData data];
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        long dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        const unsigned char *str = [dataSegment bytes];
        unsigned char *privateDecrypt = malloc(publicRSALenght);
        memset(privateDecrypt, 0, publicRSALenght);
        if(RSA_public_decrypt(publicRSALenght,str,privateDecrypt,publicKey,RSA_PKCS1_PADDING)>=0){
            NSInteger length =strlen((char *)privateDecrypt);
            NSData *data = [[NSData alloc] initWithBytes:privateDecrypt length:length];
            [decrypeData appendData:data];
        }
        free(privateDecrypt);
    }
    return decrypeData;
}

@end

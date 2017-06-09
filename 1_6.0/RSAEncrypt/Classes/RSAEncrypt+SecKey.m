//
//  RSAEncrypt+SecKey.m
//  RSAEncrypt
//
//  Created by ice on 2017/6/6.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "RSAEncrypt+SecKey.h"

@implementation RSAEncrypt (SecKey)
#pragma mark - 生成SecKey格式秘钥
+ (BOOL)generateSecKeyWithSize:(int)keySize
                    privateKey:(SecKeyRef *)privateKeyRef
                     publicKey:(SecKeyRef *)publicKeyRef{
    OSStatus sanityCheck = noErr;
    if (keySize == 512 || keySize == 1024 || keySize == 2048) {
        NSData *publicTag = [@"com.my.company.publickey" dataUsingEncoding:NSUTF8StringEncoding];
        NSData *privateTag = [@"com.my.company.privateTag" dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary * privateKeyAttr = [[NSMutableDictionary alloc] init];
        NSMutableDictionary * publicKeyAttr = [[NSMutableDictionary alloc] init];
        NSMutableDictionary * keyPairAttr = [[NSMutableDictionary alloc] init];
        
        // Set top level dictionary for the keypair.
        [keyPairAttr setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
        [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:keySize] forKey:(id)kSecAttrKeySizeInBits];
        
        // Set the private key dictionary.
        [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecAttrIsPermanent];
        [privateKeyAttr setObject:privateTag forKey:(id)kSecAttrApplicationTag];
        // See SecKey.h to set other flag values.
        
        // Set the public key dictionary.
        [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecAttrIsPermanent];
        [publicKeyAttr setObject:publicTag forKey:(id)kSecAttrApplicationTag];
        // See SecKey.h to set other flag values.
        
        // Set attributes to top level dictionary.
        [keyPairAttr setObject:privateKeyAttr forKey:(id)kSecPrivateKeyAttrs];
        [keyPairAttr setObject:publicKeyAttr forKey:(id)kSecPublicKeyAttrs];
        
        // SecKeyGeneratePair returns the SecKeyRefs just for educational purposes.
        sanityCheck = SecKeyGeneratePair((CFDictionaryRef)keyPairAttr, publicKeyRef, privateKeyRef);
        if ( sanityCheck == noErr && publicKeyRef != NULL && privateKeyRef != NULL) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 秘钥格式转换 SecKeyRef->NSData  NSData->SecKeyRef
static NSString * const kTransfromIdenIdentifierPublic = @"kTransfromIdenIdentifierPublic";
static NSString * const kTransfromIdenIdentifierPrivate = @"kTransfromIdenIdentifierPrivate";
+ (NSData *)publicKeyBitsFromSecKey:(SecKeyRef)publicRefKey{
    if (!publicRefKey) {
        return nil;
    }
    
    NSData *peerTag = [kTransfromIdenIdentifierPublic dataUsingEncoding:NSUTF8StringEncoding];
    
    OSStatus sanityCheck = noErr;
    NSData * keyBits = nil;
    
    NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
    [queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryKey setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryKey setObject:(__bridge id)publicRefKey forKey:(__bridge id)kSecValueRef];
    [queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryKey setObject:@YES forKey:(__bridge id)kSecReturnData];
    [queryKey setObject:(id)kSecAttrKeyClassPublic forKey:(id)kSecAttrKeyClass];
    
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) queryKey, &result);
    if (sanityCheck == errSecSuccess) {
        keyBits = CFBridgingRelease(result);
        
        (void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
    }
    
    return keyBits;
}

+ (SecKeyRef)publicSecKeyFromKeyBits:(NSData *)publicKeyData{
    if (!publicKeyData || publicKeyData.length == 0) {
        return nil;
    }
    
    NSData *peerTag = [kTransfromIdenIdentifierPublic dataUsingEncoding:NSUTF8StringEncoding];
    
    OSStatus sanityCheck = noErr;
    SecKeyRef secKey = nil;
    
    NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
    [queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryKey setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryKey setObject:publicKeyData forKey:(__bridge id)kSecValueData];
    [queryKey setObject:@YES forKey:(__bridge id)kSecReturnRef];
    [queryKey setObject:(id)kSecAttrKeyClassPublic forKey:(id)kSecAttrKeyClass];
    
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) queryKey, &result);
    if (sanityCheck == errSecSuccess) {
        secKey = (SecKeyRef)result;
        
        (void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
    }
    
    return secKey;
}

+ (NSData *)privateKeyBitsFromSecKey:(SecKeyRef)privateKeyRef {
    if (!privateKeyRef) {
        return nil;
    }
    NSData *peerTag = [kTransfromIdenIdentifierPrivate dataUsingEncoding:NSUTF8StringEncoding];
    
    OSStatus sanityCheck = noErr;
    NSData * keyBits = nil;
    
    NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
    [queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryKey setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryKey setObject:(id)kSecAttrKeyClassPrivate forKey:(id)kSecAttrKeyClass];
    
    [queryKey setObject:(__bridge id)privateKeyRef forKey:(__bridge id)kSecValueRef];
    [queryKey setObject:@YES forKey:(__bridge id)kSecReturnData];
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) queryKey, &result);
    if (sanityCheck == errSecSuccess) {
        keyBits = CFBridgingRelease(result);
        
        (void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
    }
    
    return keyBits;
}

+ (SecKeyRef)privateSecKeyFromKeyBits:(NSData *)privateKeyData {
    if (!privateKeyData || privateKeyData.length == 0) {
        return nil;
    }
    NSData *peerTag = [kTransfromIdenIdentifierPrivate dataUsingEncoding:NSUTF8StringEncoding];
    
    OSStatus sanityCheck = noErr;
    SecKeyRef secKey = nil;
    
    NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
    [queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryKey setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryKey setObject:(id)kSecAttrKeyClassPrivate forKey:(id)kSecAttrKeyClass];
    [queryKey setObject:privateKeyData forKey:(__bridge id)kSecValueData];
    [queryKey setObject:@YES forKey:(__bridge id)kSecReturnRef];
    
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) queryKey, &result);
    if (sanityCheck == errSecSuccess) {
        secKey = (SecKeyRef)result;
        
        (void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
    }
    
    return secKey;
}

#pragma mark - 公钥加密->私钥解密
+ (NSData *)encryptwithPublicKeyRef:(SecKeyRef)publciKeyRef plainData:(NSData *)plainData{
    if (!publciKeyRef || !plainData || plainData.length == 0) {
        return nil;
    }
    
    size_t publciKeyLenght = SecKeyGetBlockSize(publciKeyRef) * sizeof(uint8_t);
    double totalLength = [plainData length];
    size_t blockSize = publciKeyLenght - 11;
    int blockCount = ceil(totalLength / blockSize);
    NSMutableData *encryptDate = [NSMutableData data];
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        unsigned char *cipherBuffer = malloc(publciKeyLenght);
        memset(cipherBuffer, 0, publciKeyLenght);
        
        OSStatus status = noErr;
        size_t cipherBufferSize ;
        status = SecKeyEncrypt(publciKeyRef,
                               kSecPaddingPKCS1,
                               [dataSegment bytes],
                               dataSegmentRealSize,
                               cipherBuffer,
                               &cipherBufferSize
                               );
        
        if(status == noErr){
            NSData *encryptData = [[NSData alloc] initWithBytes:cipherBuffer length:cipherBufferSize];
            [encryptDate appendData:encryptData];
        }
        free(cipherBuffer);
    }
    return encryptDate;
}

+ (NSData *)decryptWithPrivateKeyRef:(SecKeyRef)privateKeyRef cipherData:(NSData *)cipherData{
    if (!privateKeyRef || !cipherData || cipherData.length == 0) {
        return nil;
    }
    
    size_t privateRSALenght = SecKeyGetBlockSize(privateKeyRef) * sizeof(uint8_t);
    double totalLength = [cipherData length];
    size_t blockSize = privateRSALenght;
    int blockCount = ceil(totalLength / blockSize);
    NSMutableData *decrypeData = [NSMutableData data];
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        long dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        unsigned char *plainBuffer = malloc(privateRSALenght);
        memset(plainBuffer, 0, privateRSALenght);
        OSStatus status = noErr;
        size_t plainBufferSize ;
        status = SecKeyDecrypt(privateKeyRef,
                               kSecPaddingPKCS1,
                               [dataSegment bytes],
                               dataSegmentRealSize,
                               plainBuffer,
                               &plainBufferSize
                               );
        if(status == noErr){
            NSData *data = [[NSData alloc] initWithBytes:plainBuffer length:plainBufferSize];
            [decrypeData appendData:data];
        }
        free(plainBuffer);
    }
    
    return decrypeData;
}

#pragma mark - 私钥加密->公钥解密
+ (NSData *)encryptwithPrivateKeyRef:(SecKeyRef)keyRef plainData:(NSData *)plainData{
    if (!keyRef || !plainData || plainData.length == 0) {
        return nil;
    }
    
    size_t keyLength = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    double totalLength = [plainData length];
    size_t blockSize = keyLength - 11;
    int blockCount = ceil(totalLength / blockSize);
    NSMutableData *encryptDate = [NSMutableData data];
    for (int i = 0; i < blockCount; i++){
        NSUInteger loc = i * blockSize;
        int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        unsigned char *cipherBuffer = malloc(keyLength);
        memset(cipherBuffer, 0, keyLength);
        
        OSStatus status = noErr;
        size_t cipherBufferSize ;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               [dataSegment bytes],
                               dataSegmentRealSize,
                               cipherBuffer,
                               &cipherBufferSize
                               );
        if(status == noErr){
            NSData *encryptData = [[NSData alloc] initWithBytes:cipherBuffer length:cipherBufferSize];
            [encryptDate appendData:encryptData];
        }
        free(cipherBuffer);
    }
    return encryptDate;
}

+ (NSData *)decryptWithPublicKeyRef:(SecKeyRef)keyRef cipherData:(NSData *)cipherData{
    if (!keyRef || !cipherData || cipherData.length == 0) {
        return nil;
    }
    
    size_t keyLength = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    double totalLength = [cipherData length];
    size_t blockSize = keyLength;
    int blockCount = ceil(totalLength / blockSize);
    NSMutableData *decrypeData = [NSMutableData data];
    for (int i = 0; i < blockCount; i++){
        NSUInteger loc = i * blockSize;
        long dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        unsigned char *plainBuffer = malloc(keyLength);
        memset(plainBuffer, 0, keyLength);
        OSStatus status = noErr;
        size_t plainBufferSize ;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingPKCS1,
                               [dataSegment bytes],
                               dataSegmentRealSize,
                               plainBuffer,
                               &plainBufferSize
                               );
        if(status == noErr){
            NSData *data = [[NSData alloc] initWithBytes:plainBuffer length:plainBufferSize];
            [decrypeData appendData:data];
        }
        free(plainBuffer);
    }
    return decrypeData;
}
@end

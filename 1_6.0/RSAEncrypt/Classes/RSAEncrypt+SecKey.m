//
//  RSAEncrypt+SecKey.m
//  RSAEncrypt
//
//  Created by ice on 2017/6/6.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "RSAEncrypt+SecKey.h"
#import <CommonCrypto/CommonDigest.h>

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
#pragma mark - 模指生成 秘钥SecKeyRef
// 公钥模数
+ (NSData *)getPublicKeyMod:(NSData *)pk {
    if (pk == NULL) return NULL;
    
    int iterator = 0;
    
    iterator++; // TYPE - bit stream - mod + exp
    [self derEncodingGetSizeFrom:pk at:&iterator]; // Total size
    
    iterator++; // TYPE - bit stream mod
    int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator];
    
    return [pk subdataWithRange:NSMakeRange(iterator, mod_size)];
}

//公钥指数
+ (NSData *)getPublicKeyExp:(NSData *)pk {
    
    if (pk == NULL) return NULL;
    
    int iterator = 0;
    
    iterator++; // TYPE - bit stream - mod + exp
    [self derEncodingGetSizeFrom:pk at:&iterator]; // Total size
    
    iterator++; // TYPE - bit stream mod
    int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator];
    iterator += mod_size;
    
    iterator++; // TYPE - bit stream exp
    int exp_size = [self derEncodingGetSizeFrom:pk at:&iterator];
    
    return [pk subdataWithRange:NSMakeRange(iterator, exp_size)];
}

+ (SecKeyRef)getPublicKeyWithMod:(NSData *)modBits exp:(NSData *)expBits{
    NSData *publicData = [self publicKeyDataWithMod:modBits exp:expBits];
    return [self publicSecKeyFromKeyBits:publicData];
}

+ (NSData *)publicKeyDataWithMod:(NSData *)modBits exp:(NSData *)expBits{
    /*
     整个数据分为8个部分
     0x30 包长 { 0x02 包长 { modBits} 0x02 包长 { expBits } }
     */
    
    //创建证书存储空间，其中第二第四部分包长按照 ** 1byte ** 处理，如果不够在后面在添加
    NSMutableData *fullKey = [[NSMutableData alloc] initWithLength:6+[modBits length]+[expBits length]];
    unsigned char *fullKeyBytes = [fullKey mutableBytes];
    
    unsigned int bytep = 0; // 当前指针位置
    
    //第一部分：（1 byte）固定位0x30
    fullKeyBytes[bytep++] = 0x30;
    
    //第二部分：（1-3 byte）记录总包长
    NSUInteger ml = 4 + [modBits length]  + [expBits length];
    if (ml >= 256) {
        
        //当长度大于256时占用 3 byte
        fullKeyBytes[bytep++] = 0x82;
        [fullKey increaseLengthBy:2];
        
        //先设置高位数据
        fullKeyBytes[bytep++] = ml >> 8;
    }else if(ml >= 128) {
        
        //当长度大于128时占用 2 byte
        fullKeyBytes[bytep++] = 0x81 ;
        [fullKey increaseLengthBy:1];
    }
    unsigned int seqLenLoc = bytep; // 记录总长数据的位置，如果需要添加可直接取值
    fullKeyBytes[bytep++] = 4 + [modBits length] + [expBits length]; // 默认第二第四部分包长按照 ** 1byte ** 处理
    
    //第三部分 （1 byte）固定位0x02
    fullKeyBytes[bytep++] = 0x02;
    
    //第四部分：（1-3 byte）记录包长
    ml = [modBits length];
    if (ml >= 256) {
        
        //当长度大于256时占用 3 byte
        fullKeyBytes[bytep++] = 0x82;
        [fullKey increaseLengthBy:2];
        
        //先设置高位数据
        fullKeyBytes[bytep++] = ml >> 8;
        
        //第二部分包长+2
        fullKeyBytes[seqLenLoc] += 2;
    }else if(ml >= 128){
        //当长度大于256时占用 2 byte
        fullKeyBytes[bytep++] = 0x81 ;
        [fullKey increaseLengthBy:1];
        
        //第二部分包长＋1
        fullKeyBytes[seqLenLoc]++;
    }
    // 这里如果 [modBits length] > 255 (ff),就会数据溢出，高位会被截断。所以上面 ml >> 8 先对高位进行了复制
    fullKeyBytes[bytep++] = [modBits length];
    
    
    //第五部分
    [modBits getBytes:&fullKeyBytes[bytep] length:[modBits length]];
    bytep += [modBits length];
    
    //第六部分
    fullKeyBytes[bytep++] = 0x02;
    
    //第七部分
    fullKeyBytes[bytep++] = [expBits length];
    
    //第八部分
    [expBits getBytes:&fullKeyBytes[bytep++] length:[expBits length]];
    
    return fullKey;
}

+ (int)derEncodingGetSizeFrom:(NSData*)buf at:(int*)iterator {
    const uint8_t* data = [buf bytes];
    int itr = *iterator;
    int num_bytes = 1;
    int ret = 0;
    
    if (data[itr] > 0x80) {
        num_bytes = data[itr] - 0x80;
        itr++;
    }
    
    for (int i = 0 ; i < num_bytes; i++) ret = (ret * 0x100) + data[itr + i];
    
    *iterator = itr + num_bytes;
    return ret;
}

#pragma mark - 秘钥格式转换 Base64->SecKeyRef
static NSString * const kTransfromIdenIdentifierPublic = @"kTransfromIdenIdentifierPublic";
static NSString * const kTransfromIdenIdentifierPrivate = @"kTransfromIdenIdentifierPrivate";

+ (SecKeyRef)privateSecKeyFromBase64:(NSString *)privateBase64Key{
    if (!privateBase64Key) {
        return nil;
    }
    
    NSRange spos = [privateBase64Key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [privateBase64Key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        privateBase64Key = [privateBase64Key substringWithRange:range];
    }
    
    privateBase64Key = [privateBase64Key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    privateBase64Key = [privateBase64Key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    privateBase64Key = [privateBase64Key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    privateBase64Key = [privateBase64Key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    NSData *privateKeyData = base64_decode(privateBase64Key);
    
    if (!privateKeyData) {
        return nil;
    }
    
    return [self privateSecKeyFromKeyBits:privateKeyData];
}

+ (SecKeyRef)publicSecKeyFromBase64:(NSString *)publicBase64Key{
    if (!publicBase64Key) {
        return nil;
    }
    
    NSRange spos = [publicBase64Key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [publicBase64Key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        publicBase64Key = [publicBase64Key substringWithRange:range];
    }
    
    publicBase64Key = [publicBase64Key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    publicBase64Key = [publicBase64Key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    publicBase64Key = [publicBase64Key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    publicBase64Key = [publicBase64Key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    NSData *publicKeyData = base64_decode(publicBase64Key);
    
    if (!publicKeyData) {
        return nil;
    }
    
    NSData *mod = [self getPublicKeyMod:publicKeyData];
    NSData *pk = [self getPublicKeyExp:publicKeyData];
    
    return [self getPublicKeyWithMod:mod exp:pk];
//    if (1) {
//        publicKeyData = [self stripPublicKeyHeader:publicKeyData];
//    }
    
    return [self publicSecKeyFromKeyBits:publicKeyData];
}
#pragma mark - 秘钥格式转换 SecKeyRef->Base64
+ (NSString *)privateKeyBase64FromSecKey:(SecKeyRef)privateRefKey{
    if (!privateRefKey) {
        return nil;
    }
    
    NSData *privateData = [self privateKeyBitsFromSecKey:privateRefKey];
    NSString *privateKey = @"";
    if (privateData) {
        privateKey = [privateData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    const char *pstr = [privateKey UTF8String];
    int len = (int)[privateKey length];
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
    return privateKey;
}

+ (NSString *)publicKeyBase64FromSecKey:(SecKeyRef)publicRefKey{
    if (!publicRefKey) {
        return nil;
    }
    
    NSData *publicData = [self publicKeyBitsFromSecKey:publicRefKey];
    NSString *publicKey = @"";
    if (publicData) {
        publicKey = [publicData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    int count = 0;
    for (int i = 0; i < [publicKey length]; ++i) {
        
        unichar c = [publicKey characterAtIndex:i];
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
    
    return publicKey;
}

#pragma mark - 秘钥格式转换 NSData->SecKeyRef
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

#pragma mark - 秘钥格式转换 SecKeyRef->NSData
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

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    unsigned long len = [d_key length];
    if (!len) return(nil);
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    if (c_key[idx++] != 0x30) return(nil);
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    idx += 15;
    if (c_key[idx++] != 0x03) return(nil);
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    if (c_key[idx++] != '\0') return(nil);
    // Now make a new NSData from this buffer
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str    options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
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

#pragma mark - 私钥加签->公钥验签(SHA256)
+ (NSData *)signData:(NSData*)data withKeyRef:(SecKeyRef)privateKeyRef{
    if (!data || !privateKeyRef) {
        return nil;
    }
    size_t signedHashBytesSize = SecKeyGetBlockSize(privateKeyRef);
    uint8_t* signedHashBytes = malloc(signedHashBytesSize);
    memset(signedHashBytes, 0x0, signedHashBytesSize);
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([data bytes], (CC_LONG)[data length], hashBytes)) {
        return nil;
    }
    
    SecKeyRawSign(privateKeyRef,
                  kSecPaddingPKCS1SHA256,
                  hashBytes,
                  hashBytesSize,
                  signedHashBytes,
                  &signedHashBytesSize);
    
    NSData* signedHash = [NSData dataWithBytes:signedHashBytes
                                        length:(NSUInteger)signedHashBytesSize];
    
    if (hashBytes)
        free(hashBytes);
    if (signedHashBytes)
        free(signedHashBytes);
    
    return signedHash;
}

+ (BOOL)vertifyData:(NSData *)plainData
              signature:(NSData *)signature
             withKeyRef:(SecKeyRef)publicKeyRef{
    if (!publicKeyRef || !plainData || !signature) {
        return nil;
    }
    
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKeyRef);
    const void* signedHashBytes = [signature bytes];
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }
    
    OSStatus status = SecKeyRawVerify(publicKeyRef,
                                      kSecPaddingPKCS1SHA256,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}

@end

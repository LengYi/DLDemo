//
//  RSAEncrypt+SecKey.h
//  RSAEncrypt
//
//  Created by ice on 2017/6/6.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "RSAEncrypt.h"

@interface RSAEncrypt (SecKey)
#pragma mark - 生成SecKey格式秘钥
/**
 *  生成Ref格式秘钥
 *
 *  @param keySize       秘钥长度 512 1024 2048
 *  @param privateKeyRef 生成的私钥
 *  @param publicKeyRef  生成的公钥
 *
 *  @return 是否成功生成秘钥
 */
+ (BOOL)generateSecKeyWithSize:(int)keySize
                    privateKey:(SecKeyRef *)privateKeyRef
                     publicKey:(SecKeyRef *)publicKeyRef;

+ (NSData *)getPublicKeyMod:(NSData *)pk;
//公钥指数
+ (NSData *)getPublicKeyExp:(NSData *)pk;
+ (SecKeyRef)getPublicKeyWithMod:(NSData *)modBits exp:(NSData *)expBits;

#pragma mark - 秘钥格式转换 SecKeyRef->NSData  NSData->SecKeyRef
/**
 *  公钥 SecKeyRef->NSData
 *
 *  @param publicRefKey SecKeyRef公钥
 *
 *  @return NSData格式公钥
 */
+ (NSData *)publicKeyBitsFromSecKey:(SecKeyRef)publicRefKey;

/**
 *  公钥 NSData->SecKeyRef
 *
 *  @param publicKeyData NSData公钥
 *
 *  @return SecKeyRef格式公钥
 */
+ (SecKeyRef)publicSecKeyFromKeyBits:(NSData *)publicKeyData;

/**
 *  私钥 SecKeyRef->NSData
 *
 *  @param privateKeyRef SecKeyRef私钥
 *
 *  @return NSData格式私钥
 */
+ (NSData *)privateKeyBitsFromSecKey:(SecKeyRef)privateKeyRef;

/**
 *  私钥 NSData->SecKeyRef
 *
 *  @param privateKeyData NSData私钥
 *
 *  @return SecKeyRef格式私钥
 */
+ (SecKeyRef)privateSecKeyFromKeyBits:(NSData *)privateKeyData;


+ (SecKeyRef)privateSecKeyFromBase64:(NSString *)privateBase64Key;
+ (SecKeyRef)publicSecKeyFromBase64:(NSString *)publicBase64Key;

+ (NSString *)privateKeyBase64FromSecKey:(SecKeyRef)privateRefKey;
+ (NSString *)publicKeyBase64FromSecKey:(SecKeyRef)publicRefKey;

#pragma mark - 公钥加密->私钥解密
/**
 *  SecKeyRef 公钥加密
 *
 *  @param publciKeyRef SecKeyRef 公钥
 *  @param plainData    待加密数据
 *
 *  @return 公钥加密后数据
 */
+ (NSData *)encryptwithPublicKeyRef:(SecKeyRef)publciKeyRef plainData:(NSData *)plainData;

/**
 *  SecKeyRef 私钥解密
 *
 *  @param privateKeyRef SecKeyRef 私钥
 *  @param cipherData    待解密数据
 *
 *  @return 私钥解密后数据
 */
+ (NSData *)decryptWithPrivateKeyRef:(SecKeyRef)privateKeyRef cipherData:(NSData *)cipherData;

#pragma mark - 私钥加签->公钥验签(SHA256)
/**
 *  SecKeyRef 私钥加签
 *
 *  @param data          待签名的原始数据
 *  @param privateKeyRef SecKeyRef 私钥
 *
 *  @return 数字签名串
 */
+ (NSData *)signData:(NSData*)data
          withKeyRef:(SecKeyRef)privateKeyRef;

/**
 *  SecKeyRef 公钥验签
 *
 *  @param plainData    待签名的原始数据
 *  @param signature    私钥加签后的数字签名串
 *  @param publicKeyRef 公钥
 *
 *  @return 验签结果
 */
+ (BOOL)vertifyData:(NSData *)plainData
          signature:(NSData *)signature
         withKeyRef:(SecKeyRef)publicKeyRef;
@end

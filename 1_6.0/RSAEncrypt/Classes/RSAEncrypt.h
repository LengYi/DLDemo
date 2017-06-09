//
//  RSAEncrypt.h
//  RSAEncrypt
//
//  Created by ice on 2017/6/5.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/pem.h>

@interface RSAEncrypt : NSObject

/**
 *
 *
 *  @param keySize    秘钥长度 512 1024 2048
 *  @param privateKey 生成的私钥
 *  @param publicKey  生成的公钥
 *
 *  @return 是否成功生成秘钥
 */
+ (BOOL)generateKeyWithSize:(int)keySize
                 privateKey:(RSA **)privateKey
                  publicKey:(RSA **)publicKey;

/**
 *  将私钥转换成PEM格式   RSA->PEM
 *
 *  @param key 待格式化的私钥
 *
 *  @return PEM 格式的私钥
 */
+ (NSString *)pemFormatPrivateKey:(RSA *)key;

/**
 *  将公钥转换成PEM格式 RSA->PEM
 *
 *  @param key 待格式化的公钥
 *
 *  @return PEM 格式的公钥
 */
+ (NSString *)pemFormatPublicKey:(RSA *)key;

/**
 *  公钥格式转换 PEM->RSA
 *
 *  @param publicKeyPEM PEM 格式公钥
 *
 *  @return RSA 格式公钥
 */
+ (RSA *)RSAPublicKeyFromPEM:(NSString *)publicKeyPEM;

/**
 *  私钥格式转换 PEM->RSA
 *
 *  @param privatePEM PEM 格式私钥
 *
 *  @return RSA 格式私钥
 */
+ (RSA *)RSAPrivateKeyFromPEM:(NSString *)privatePEM;

/**
 *  取出秘钥的base64部分去掉头部  PEM->Base64
 *
 *  @param pemFormate PEM格式秘钥
 *
 *  @return 去掉头部后只含base64部分的秘钥
 */
+ (NSString *)base64EncodeFromPem:(NSString *)pemFormate;

/**
 *  Base64格式公钥转换成RSA格式  Base64->RSA
 *
 *  @param base64PubKey Base64格式公钥
 *
 *  @return RSA 格式公钥
 */
+ (RSA *)RSAPublicKeyFromBase64:(NSString *)base64PubKey;

/**
 *  Base64格式私钥转换成RSA格式  Base64->RSA
 *
 *  @param base64PrivateKey Base64格式私钥
 *
 *  @return RSA 格式私钥
 */
+ (RSA *)RSAPrivateKeyFromBase64:(NSString *)base64PrivateKey;


#pragma mark --- 公钥加密->私钥解密
/**
 *  公钥加密
 *
 *  @param publicKey 公钥
 *  @param plainData 原始待加密数据
 *
 *  @return 公钥加密后数据
 */
+ (NSData *)encryptWithPublicKey:(RSA *)publicKey plainData:(NSData *)plainData;

/**
 *  私钥解密
 *
 *  @param privateKey 私钥
 *  @param cipherData 待解密数据
 *
 *  @return 私钥解密后数据
 */
+ (NSData *)decryptWithPrivateKey:(RSA *)privateKey cipherData:(NSData *)cipherData;

#pragma mark --- 私钥加密->公钥解密
/**
 *  私钥加密
 *
 *  @param privateKey 私钥
 *  @param plainData  原始待加密数据
 *
 *  @return 私钥加密后数据
 */
+ (NSData *)encryptWithPrivateRSA:(RSA *)privateKey plainData:(NSData *)plainData;

/**
 *  公钥解密
 *
 *  @param publicKey  公钥
 *  @param cipherData 待解密数据
 *
 *  @return 公钥解密后数据
 */
+ (NSData *)decryptWithPublicKey:(RSA *)publicKey cipherData:(NSData *)cipherData;
@end

//
//  DLKeyChain.m
//  KeyChain
//
//  Created by ice on 17/3/6.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DLKeyChain.h"

@implementation DLKeyChain

#pragma mark - PublicMethod
+ (void)saveDataWithKeyChain:(id)data forKey:(NSString *)key{
    NSMutableDictionary *dataDic = [DLKeyChain getDataWithKeychain:key];
    SecItemDelete((CFDictionaryRef)dataDic);
    [dataDic setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)dataDic, NULL);
}

+ (id)loadDataWithKeyChain:(NSString *)key{
    id ret = nil;
    
    NSMutableDictionary *dataDic = [DLKeyChain getDataWithKeychain:key];
    [dataDic setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [dataDic setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)dataDic, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", key, exception);
        } @finally {
            
        }
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return ret;
}

+ (void)deleteDataWithKeyChain:(NSString *)key{
    NSMutableDictionary *dataDic = [DLKeyChain getDataWithKeychain:key];
    SecItemDelete((CFDictionaryRef)dataDic);
}

#pragma mark - PrivateMethod
+ (NSMutableDictionary *)getDataWithKeychain:(NSString *)key{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            key, (id)kSecAttrService,
            key, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

@end

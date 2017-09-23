//
//  LSPlugInKitProxy.h
//  ScanIOSApp
//
//  Created by ice on 2017/9/22.
//  Copyright © 2017年 ice. All rights reserved.
//

@interface LSPlugInKitProxy : NSObject
@property (readonly, nonatomic) NSString* pluginIdentifier;
@property (readonly, nonatomic) NSString* originalIdentifier;
@property (readonly, nonatomic) NSString* protocol;
@property (readonly, nonatomic) NSUUID* pluginUUID;
@property (readonly, nonatomic) NSDictionary* pluginKitDictionary;
@property (readonly, nonatomic) NSDictionary* infoPlist;
@property (readonly, nonatomic) NSDate* registrationDate;
@property (readonly, nonatomic) LSBundleProxy* containingBundle;
@property (readonly, nonatomic, getter=isOnSystemPartition)
BOOL onSystemPartition;
@property (readonly, nonatomic) NSString* teamID;


+ (id) plugInKitProxyForUUID:(id)arg1 bundleIdentifier:(id)arg2 pluginIdentifier:(id)arg3 effectiveIdentifier:(id)arg4 version:(id)arg5 bundleURL:(id)arg6;
+ (id) containingBundleIdentifiersForPlugInBundleIdentifiers:(id)arg1 error:(id*)arg2;
+ (id) plugInKitProxyForPlugin:(unsigned int)arg1 withContext:(struct LSContext*)arg2;
+ (BOOL) supportsSecureCoding;
+ (id) pluginKitProxyForIdentifier:(id)arg1;
+ (id) pluginKitProxyForUUID:(id)arg1;
+ (id) pluginKitProxyForURL:(id)arg1;

- (id) un_applicationBundleURL;
- (id) un_applicationBundleIdentifier;
- (BOOL) UPPValidated;
- (id) signerOrganization;
- (id) localizedNameWithPreferredLocalizations:(id)arg1 useShortNameOnly:(BOOL)arg2;
- (id) _initWithPlugin:(unsigned int)arg1 andContext:(struct LSContext*)arg2;
- (id) originalIdentifier;
- (id) _initWithUUID:(id)arg1 bundleIdentifier:(id)arg2 pluginIdentifier:(id)arg3 effectiveIdentifier:(id)arg4 version:(id)arg5 bundleURL:(id)arg6;
- (BOOL) pluginCanProvideIcon;
- (id) pluginUUID;
- (id) boundIconsDictionary;
- (BOOL) isOnSystemPartition;
- (id) _valueForEqualityTesting;
- (id) initWithCoder:(id)arg1;
- (void) encodeWithCoder:(id)arg1;
- (void) dealloc;
- (id) description;
- (id) iconDataForVariant:(int)arg1 withOptions:(int)arg2;
- (id) containingBundle;
- (id) protocol;
- (id) registrationDate;
- (id) objectForInfoDictionaryKey:(id)arg1 ofClass:(Class)arg2 inScope:(unsigned long)arg3;
- (BOOL) profileValidated;
- (id) teamID;
- (id) pluginIdentifier;
- (id) infoPlist;
- (id) pluginKitDictionary;

@end

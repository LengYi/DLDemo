//
//  UIApplication+Extern.h
//  AppManager
//
//  Created by ice on 17/3/16.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APPSTORE   1   // 0 : 直接使用私有方法,1 : 混淆私有方法
/**
    扫描iOS设备上所有已安装的 App,并获取App相关信息
    使用该类准备工作:
 1.导出MobileCoreServices.framework 的所有头文件 class-dump -H
 2.将导出的头文件添加到使用的工程中,否则工程将找不到头文件无法编译
 3.添加MobileCoreServices.framework 到工程中
 */
@interface UIApplication (Extern)

/**
 - 扫描iOS设备上所有已安装的 App, APPSTORE 宏默认为0,如上AppStore请将APPSTORE 宏修改为1 并将私有方法类名和方法名称 加解密处理
        ApplicationDSID App如果是从Store上下载的将会有一个 DSID 值
        ApplicationType App 类型 是系统应用(system)还是普通应用(User)
        CFBundleDisplayName App 名称
        CFBundleExecutable App 二进制可执行文件名称
        CFBundleIdentifier App sku
        CFBundleShortVersionString App 内部版本号
        CFBundleVersion App 外部版本号
        Path xxx.app 包路径
        SignerIdentity App 签名证书名称
        TeamID App 签名证书所在的组 ID
 */
+ (NSDictionary *)scanAllInstanedApp;

@end

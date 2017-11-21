# OpenSSL-lib-iOS

[![CI Status](http://img.shields.io/travis/707689817@qq.com/OpenSSL-lib-iOS.svg?style=flat)](https://travis-ci.org/707689817@qq.com/OpenSSL-lib-iOS)
[![Version](https://img.shields.io/cocoapods/v/OpenSSL-lib-iOS.svg?style=flat)](http://cocoapods.org/pods/OpenSSL-lib-iOS)
[![License](https://img.shields.io/cocoapods/l/OpenSSL-lib-iOS.svg?style=flat)](http://cocoapods.org/pods/OpenSSL-lib-iOS)
[![Platform](https://img.shields.io/cocoapods/p/OpenSSL-lib-iOS.svg?style=flat)](http://cocoapods.org/pods/OpenSSL-lib-iOS)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

OpenSSL-lib-iOS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OpenSSL-lib-iOS'
```

## Author

707689817@qq.com, 707689817@qq.com

## License

OpenSSL-lib-iOS is available under the MIT license. See the LICENSE file for more info.


# OpenSSL-iOS
根据最新官方源码编译的 OpenSSL iOS 库, 官方网址: https://www.openssl.org/source/

1.cd OpenSSL-iOS/Build    
2.运行 ./build-libssl.sh 脚本 运行后如果同级目录下有 openssl-1.0.2l.tar.gz包则直接编译,否则先下载该包(时间略久)  编译之前先修改脚本内容  VERSION="1.0.2l" 为指定的原始包版本
3.运行 ./create-openssl-framework.sh 编译成openssl.framework包
4.将openssl.framework 拷贝至 /OpenSSL-iOS/OpenSSL-iOS/Vendors/目录下
5.编辑更新OpenSSL-iOS.podspec

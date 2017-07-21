//
//  DLProtocolAnalyze.h
//
//  Created by ice on 17/2/13.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ProtocolAnalyzeCode) {
    /* 协议解析成功 */
    kProtocolAnalyzeCodeSuccess = 1,
    /* 协议解析失败 */
    kProtocolAnalyzeCodeFailed = 0
};

@interface DLProtocolAnalyze : NSObject

+ (void)analyzeData:(NSData *)data completion:(void (^)(ProtocolAnalyzeCode code,NSArray *arr))handle;

@end

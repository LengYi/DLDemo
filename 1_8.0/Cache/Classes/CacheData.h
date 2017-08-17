//
//  CacheData.h
//  Cache
//
//  Created by ice on 2017/8/15.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheData : NSObject<NSCoding>
@property (nonatomic, readwrite, strong) NSData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
@property (nonatomic, readwrite, strong) NSURLRequest *redirectRequest;
@end

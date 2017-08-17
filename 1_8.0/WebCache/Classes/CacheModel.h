//
//  CacheModel.h
//  WebCache
//
//  Created by ice on 2017/8/16.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheModel : NSObject<NSCoding>
@property (nonatomic , strong) NSData *data;
@property (nonatomic , strong) NSURLResponse *response;
@property (nonatomic , strong) NSURLRequest *redirectRequest;
@end

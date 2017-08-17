//
//  CacheData.m
//  Cache
//
//  Created by ice on 2017/8/15.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "CacheData.h"

static NSString *const kDataKey = @"data";
static NSString *const kResponseKey = @"response";
static NSString *const kRedirectRequestKey = @"redirectRequest";

@implementation CacheData

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.data forKey:kDataKey];
    [aCoder encodeObject:self.response forKey:kResponseKey];
    [aCoder encodeObject:self.redirectRequest forKey:kRedirectRequestKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [self setData:[aDecoder decodeObjectForKey:kDataKey]];
        [self setResponse:[aDecoder decodeObjectForKey:kResponseKey]];
        [self setRedirectRequest:[aDecoder decodeObjectForKey:kRedirectRequestKey]];
    }
    
    return self;
}
@end

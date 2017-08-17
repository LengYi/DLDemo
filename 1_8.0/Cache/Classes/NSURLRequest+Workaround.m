//
//  NSURLRequest+Workaround.m
//  Cache
//
//  Created by ice on 2017/8/15.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "NSURLRequest+Workaround.h"

@implementation NSURLRequest (Workaround)
- (id) mutableCopyWorkaround {
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[self URL]
                                                                          cachePolicy:[self cachePolicy]
                                                                      timeoutInterval:[self timeoutInterval]];
    [mutableURLRequest setAllHTTPHeaderFields:[self allHTTPHeaderFields]];
    if ([self HTTPBodyStream]) {
        [mutableURLRequest setHTTPBodyStream:[self HTTPBodyStream]];
    } else {
        [mutableURLRequest setHTTPBody:[self HTTPBody]];
    }
    [mutableURLRequest setHTTPMethod:[self HTTPMethod]];
    
    return mutableURLRequest;
}
@end

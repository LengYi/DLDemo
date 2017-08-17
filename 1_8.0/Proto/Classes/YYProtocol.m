//
//  YYProtocol.m
//  Proto
//
//  Created by ice on 2017/8/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "YYProtocol.h"

@interface YYProtocol ()<NSURLConnectionDelegate>
@property (nonatomic,strong) NSURLConnection *connection;
@end

@implementation YYProtocol

// 是否进入当前自定义方法
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{

    NSLog(@"TTProtocol %@",request.URL.absoluteString);
    
    if ([NSURLProtocol propertyForKey:@"URLProtocolHandledKey" inRequest:request]) {
        return NO;
    }
    
    NSString *urlString = request.URL.absoluteString;
    if ([urlString isEqualToString:@"https://sina.cn/"]) {
        return YES;
    }
    
    return NO;
}

// 重新设置NSURLRequest信息
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

// 判断两个request是否相同,相同可以使用缓存数据
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading{
    NSMutableURLRequest *request = [self.request mutableCopy];
    [NSURLProtocol setProperty:@(YES) forKey:@"URLProtocolHandledKey" inRequest:request];
    self.connection = [NSURLConnection connectionWithRequest:[self changeSinaToSohu:request] delegate:self];
}

- (void)stopLoading{
    
}

//把所用url中包括sina的url重定向到sohu
- (NSMutableURLRequest *)changeSinaToSohu:(NSMutableURLRequest *)request{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString isEqualToString:@"https://sina.cn/"]) {
        urlString = @"http://m.sohu.com/";
        request.URL = [NSURL URLWithString:urlString];
    }
    return request;
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}
@end

//
//  CacheURLProtocol.m
//  Cache
//
//  Created by ice on 2017/8/15.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "CacheURLProtocol.h"
#import "CacheData.h"
#import "NSString+Encrypto.h"
#import "Reachability.h"
#import "NSURLRequest+Workaround.h"

#define WORKAROUND_MUTABLE_COPY_LEAK 1

static NSObject *monitor;
static NSSet *schemes;

static NSString *cacheHeader = @"X-RNCache";

@interface CacheURLProtocol ()<NSURLConnectionDataDelegate>
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic, readwrite, strong) NSMutableData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
@end

@implementation CacheURLProtocol
+ (void)initialize{
    if (self == [CacheURLProtocol class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            monitor = [[NSObject alloc] init];
        });
        
        [self setSupportedSchemes:[NSSet setWithObjects:@"http",@"https", nil]];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    if ([[self supportedSchemes] containsObject:[[request URL] scheme]] && [request valueForHTTPHeaderField:cacheHeader] == nil) {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

- (void)startLoading{
    if (![self useCache]) {
        NSMutableURLRequest *request =
#if WORKAROUND_MUTABLE_COPY_LEAK
        [[self request] mutableCopyWorkaround];
#else
        [[self request] mutableCopy];
#endif
        
        [request setValue:@"" forHTTPHeaderField:cacheHeader];
        
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }else{
        CacheData *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathForRequest:[self request]]];
        if (cache) {
            NSData *data = cache.data;
            NSURLResponse *response= cache.response;
            NSURLRequest *redirectRequest = cache.redirectRequest;
            
            if (redirectRequest) {
                [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
            }else{
                [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                [[self client] URLProtocol:self didLoadData:data];
                [[self client] URLProtocolDidFinishLoading:self];
            }
        }else{
            [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil]];
            
        }
    }
}

- (void)stopLoading{
    [_connection cancel];
}

#pragma mark - NSURLConnection delegate
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    if (response != nil) {
        NSMutableURLRequest *redirectRequest =
#if WORKAROUND_MUTABLE_COPY_LEAK
        [request mutableCopyWorkaround];
#else
        [request mutableCopy];
#endif
        
        [redirectRequest setValue:@"" forHTTPHeaderField:cacheHeader];
        
        NSString *cachePath = [self cachePathForRequest:request];
        CacheData *cache = [[CacheData alloc] init];
        cache.response = response;
        cache.redirectRequest = redirectRequest;
        cache.data = self.data;
        
        [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
        
        [[self client] URLProtocol:self
            wasRedirectedToRequest:redirectRequest
                  redirectResponse:response];
        return redirectRequest;
    }else{
        return request;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [[self client] URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [[self client] URLProtocol:self didFailWithError:error];
    
    _connection = nil;
    _data = nil;
    _response = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _response = response;
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [[self client] URLProtocolDidFinishLoading:self];
    
    NSString *cachePath = [self cachePathForRequest:[self request]];
    CacheData *cache = [[CacheData alloc] init];
    cache.response = self.response;
    cache.data = self.data;
    
    [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
    
    _connection = nil;
    _data = nil;
    _response = nil;
}

+ (NSSet *)supportedSchemes{
    NSSet *scheme;
    @synchronized (monitor) {
        scheme = schemes;
    }
    
    return scheme;
}

- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [[[aRequest URL] absoluteString] SHA1];
    
    return [cachesPath stringByAppendingPathComponent:fileName];
}

+ (void)setSupportedSchemes:(NSSet *)scheme{
    @synchronized (monitor) {
        schemes = scheme;
    }
}

- (BOOL)useCache{
    BOOL reachable = (BOOL) [[Reachability reachabilityWithHostName:[[[self request] URL] host]] currentReachabilityStatus] != NotReachable;
    return !reachable;
}

- (void)appendData:(NSData *)newData{
    if ([self data] == nil) {
        [self setData:[newData mutableCopy]];
    }
    else {
        [[self data] appendData:newData];
    }
}
@end

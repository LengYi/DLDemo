//
//  WebUrlProtocol.m
//  WebCache
//
//  Created by ice on 2017/8/16.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "WebUrlProtocol.h"
#import "CacheModel.h"
#import "HtmlCacheManager.h"
#import "NSString+Encrypto.h"
#import "NSURLRequest+Workaround.h"
#import "Reachability.h"

static NSString *cachingURLHeader = @"cachingURLHeader";
static NSString *URLProtocolHandledKey = @"URLProtocolHandledKey";
static NSSet *schemes;

static NSString * const cacheUrlStringKey = @"cacheUrlStringKey"; // 本地保存缓存urlKey的数组key

@interface WebUrlProtocol ()<NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLResponse *response;
@end

@implementation WebUrlProtocol
+ (void)initialize{
    if (self == [WebUrlProtocol class]){
        schemes = [NSSet setWithObjects:@"http", @"https", nil];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    if ([schemes containsObject:[[request URL] scheme]] &&
        ([request valueForHTTPHeaderField:cachingURLHeader] == nil)){
        
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    return mutableReqeust;
}

- (void)startLoading{
   [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:[[self request] mutableCopy]];
    
    // 加载本地缓存
    CacheModel *cache = (CacheModel *)[[HtmlCacheManager shareInstance] objectForKey:[[[self.request URL] absoluteString] MD5]];
    if ([self useCache]) {
        if (cache) {
            [self loadCacheData:cache];
        }else{
            [self loadRequest];
        }
    }else{
        [self loadRequest];
    }
    
}

- (void)stopLoading{
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDataDelegate
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    if (response != nil) {
        NSMutableURLRequest *redirectableRequest = [request mutableCopyWorkaround];
        [redirectableRequest setValue:nil forHTTPHeaderField:cachingURLHeader];
        
         [self cacheDataWithResponse:response redirectRequest:redirectableRequest];
        
        [[self client] URLProtocol:self wasRedirectedToRequest:redirectableRequest redirectResponse:response];
        return redirectableRequest;
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
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self setResponse:response];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [[self client] URLProtocolDidFinishLoading:self];
    
    ////  有缓存则不缓存
    CacheModel *cacheModel = (CacheModel *)[[HtmlCacheManager shareInstance] objectForKey:[[[self.request URL] absoluteString] MD5]];
    if (!cacheModel) {
        [self cacheDataWithResponse:self.response redirectRequest:nil];
    }
}

- (BOOL)useCache{
    NSLog(@"--- %@",[[[self request] URL] host]);
    BOOL reachable = (BOOL) [[Reachability reachabilityWithHostName:[[[self request] URL] host]] currentReachabilityStatus] != NotReachable;
    return !reachable;
}

- (void)appendData:(NSData *)newData{
    if ([self data] == nil) {
        [self setData:[newData mutableCopy]];
    } else {
        [[self data] appendData:newData];
    }
}

- (void)loadRequest{
    NSMutableURLRequest *connectionRequest = [[self request] mutableCopyWorkaround];
    [connectionRequest setValue:@"" forHTTPHeaderField:cachingURLHeader];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:connectionRequest delegate:self];
    [self setConnection:connection];
}

- (void)loadCacheData:(CacheModel *)cacheModel{
    if (cacheModel) {
        NSData *data = [cacheModel data];
        NSURLResponse *response = [cacheModel response];
        NSURLRequest *redirectRequest = [cacheModel redirectRequest];
        
        if (redirectRequest) {
            // 重定向
            [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
        }else{
            // 直接使用缓存
            [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [[self client] URLProtocol:self didLoadData:data];
            [[self client] URLProtocolDidFinishLoading:self];
        }
    }else{
        [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil]];
    }
}

- (void)cacheDataWithResponse:(NSURLResponse *)response redirectRequest:(NSMutableURLRequest *)redirectableRequest{

    CacheModel *cacheModel = [[CacheModel alloc] init];
    cacheModel.response = response;
    cacheModel.data = self.data;
    cacheModel.redirectRequest = redirectableRequest;
    
    NSString *key = [[[self.request URL] absoluteString] MD5];
    [[HtmlCacheManager shareInstance] setObject:cacheModel forKey:key withBlock:^{
        
    }];
    
}

@end

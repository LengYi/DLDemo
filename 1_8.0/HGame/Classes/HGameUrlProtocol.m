//
//  HGameUrlProtocol.m
//  HGame
//
//  Created by ice on 2017/8/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "HGameUrlProtocol.h"
#import <MobileCoreServices/UTType.h>

static NSString *const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface HGameUrlProtocol ()
//@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation HGameUrlProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *monitorStr = request.URL.absoluteString;
    if ([monitorStr hasPrefix:@"http://localhost:8080"]) {
//        //看看是否已经处理过了，防止无限循环
//        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
//            return NO;
//        }
        
        return YES;
    }
    return NO;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading{
    //1.获取资源文件路径 ajkyq/index.html
    NSURL *url = [self request].URL;
    NSString *resourcePath = url.path;
    resourcePath = [resourcePath substringFromIndex:1];//把第一个/去掉
    
    //2.读取资源文件内容
    NSString *path = [[NSBundle mainBundle] pathForResource:resourcePath ofType:nil];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    //3.拼接响应Response
    NSInteger dataLength = data.length;
    NSString *mimeType = [self getMIMETypeWithCAPIAtFilePath:path];
    NSString *httpVersion = @"HTTP/1.1";
    NSHTTPURLResponse *response = nil;
    
    if (dataLength > 0) {
        response = [self jointResponseWithData:data dataLength:dataLength mimeType:mimeType requestUrl:url statusCode:200 httpVersion:httpVersion];
    }else{
        response = [self jointResponseWithData:[@"404" dataUsingEncoding:NSUTF8StringEncoding] dataLength:3 mimeType:mimeType requestUrl:url statusCode:404 httpVersion:httpVersion];
    }
    
    //4.响应
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

- (void)stopLoading{
   
}

- (NSHTTPURLResponse *)jointResponseWithData:(NSData *)data dataLength:(NSInteger)dataLength mimeType:(NSString *)mimeType requestUrl:(NSURL *)requestUrl statusCode:(NSInteger)statusCode httpVersion:(NSString *)httpVersion
{
    NSDictionary *dict = @{@"Content-type":mimeType,
                           @"Content-length":[NSString stringWithFormat:@"%ld",dataLength]};
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:requestUrl statusCode:statusCode HTTPVersion:httpVersion headerFields:dict];
    return response;
}

- (NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return @"text/html";
    }
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}
@end

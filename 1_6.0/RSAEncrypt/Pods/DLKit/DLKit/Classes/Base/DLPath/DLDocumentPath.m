//
//  DLDocumentPath.m
//
//  Created by ice on 15-2-12.
// 
//

#import "DLDocumentPath.h"

@implementation DLDocumentPath

+ (NSString *)homePath{
    NSString *path = NSHomeDirectory();
    return path;
}

/*
 document 路径
 */
+ (NSString *)documentPath{
    NSString *documentPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        documentPath = [paths objectAtIndex:0];
    }
    return documentPath;
}

+ (NSString *)tmpPath{
    NSString *path = NSTemporaryDirectory();
    return path;
}

+ (NSString *)cachePath {
    NSString *cachesPath = nil;
#if TARGET_IPHONE_SIMULATOR
    cachesPath = @"/tmp";
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        cachesPath = [paths objectAtIndex:0];
    }
#endif
    return cachesPath;
}

+ (NSString *)homePathWithFileName:(NSString *)fileName{
    NSString *filePath = [self rootPath:[self homePath] WithFileName:fileName];
    return filePath;
}

+ (NSString *)documentPathWithFileName:(NSString *)fileName{
    NSString *filePath = [self rootPath:[self documentPath] WithFileName:fileName];
    return filePath;
}

+ (NSString *)tmpPathWithFileName:(NSString *)fileName{
    NSString *filePath = [self rootPath:[self tmpPath] WithFileName:fileName];
    return filePath;
}

+ (NSString *)cachePathWithFileName:(NSString *)fileName{
    NSString *filePath = [self rootPath:[self cachePath] WithFileName:fileName];
    return filePath;
}

+ (NSString *)rootPath:(NSString *)rootPath WithFileName:(NSString *)fileName{
    NSString *filePath = @"";
    if (rootPath && fileName) {
        filePath = [rootPath stringByAppendingPathComponent:fileName];
    }
    
    return filePath;
}

@end

//
//  DLDocumentPath.h
//
//  Created by ice on 15-2-12.
// 
//


/*
 * home路径  /var/mobile/Containers/Data/Application/7C310E50-BA77-4BDC-8EA2-7A1E51C60301
 * document路径  /var/mobile/Containers/Data/Application/7C310E50-BA77-4BDC-8EA2-7A1E51C60301/Documents
 * tmp路径 /private/var/mobile/Containers/Data/Application/941478D7-6BA2-4709-A6B8-79435416FEBF/tmp/
 * cash路径 /var/mobile/Containers/Data/Application/941478D7-6BA2-4709-A6B8-79435416FEBF/Library/Caches
 */

#import <Foundation/Foundation.h>

@interface DLDocumentPath : NSObject

+ (NSString *)homePath;

+ (NSString *)documentPath;

+ (NSString *)tmpPath;

+ (NSString *)cachePath;

/**
 *  @param fileName   test
 *  @return 返回新组装的路径    xxx/xxx/test
 */
+ (NSString *)homePathWithFileName:(NSString *)fileName;

/**
 *  @param fileName   test
 *  @return 返回新组装的路径    xxx/xxx/Documents/test
 */
+ (NSString *)documentPathWithFileName:(NSString *)fileName;

/**
 *  @param fileName   test
 *  @return 返回新组装的路径    xxx/xxx/tmp/test
 */
+ (NSString *)tmpPathWithFileName:(NSString *)fileName;

/**
 *  @param fileName   test
 *  @return 返回新组装的路径    xxx/xxx/Caches/test
 */
+ (NSString *)cachePathWithFileName:(NSString *)fileName;

/**
 *  在某个路径下新建新的路径
 *  @param rootPath   xxx/xxx/Documents
 *  @param fileName   test
 *  @return 返回新组装的路径    xxx/xxx/Documents/test
 */
+ (NSString *)rootPath:(NSString *)rootPath WithFileName:(NSString *)fileName;

@end

//
//  DLDownloadFile.h
//
//  Created by ice on 15/11/5.
// 
//

/**
 *  请在主线程中使用本类
 *  NSURLConnection 代理必须在主线程才会回调
 */
#import <Foundation/Foundation.h>

#define OBject @"OBject"

/**
 *  下载中回调block
 *
 *  @param contentSize   软件实际大小
 *  @param receiveSize   已下载部分的软件包大小
 *  @param curReciveSize 刚接收的数据大小(计算实时下载速度)
 */
typedef void(^DownloadParamersBlock)(long long contentSize,long long receiveSize,long long curReciveSize,NSError *error);
typedef void(^DownloadPreBlock)(long long totalSize);
typedef void(^DownloadErrorBlock)(NSError *error);

@interface DLDownloadFile : NSObject

+ (DLDownloadFile *)createDownloadFile:(NSString *)urlString
                                  path:(NSString *)tempFilePath
                            headerFile:(NSDictionary *)headerFieldDic
                                  from:(long long)from
                                    to:(long long)to
                                   pre:(DownloadPreBlock)preBlock
                              progress:(DownloadParamersBlock)processBlock
                              complete:(DownloadParamersBlock)completeBlock
                                failed:(DownloadParamersBlock)failedBlock;
/**
 *  开始下载文件
 *
 *  @return 是否在下载
 */
- (BOOL)startDownload;

/**
 *  取消下载
 */
- (void)cancelDownload;

@end

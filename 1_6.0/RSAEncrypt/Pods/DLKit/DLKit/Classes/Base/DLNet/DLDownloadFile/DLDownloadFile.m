//
//  DLDownloadFile.m
//
//  Created by ice on 15/11/5.
// 
//

#import "DLDownloadFile.h"
#import "NSURL+DLAdditions.h"

@interface DLDownloadFile ()
@property (nonatomic,assign) BOOL finished;
@property (nonatomic,assign) long long  from;
@property (nonatomic,assign) long long  to;
@property (nonatomic,assign) long long  totalSize;

@property (nonatomic,assign) long long         receiveLength;
@property (nonatomic,assign) FILE               *fd;
@property (nonatomic,strong) NSString           *tempFilePath;
@property (nonatomic,strong) NSString           *urlString;
@property (nonatomic,strong) NSDictionary       *headerFieldDic;
@property (nonatomic,strong) NSURLConnection    *connection;

@property (nonatomic,strong) DownloadPreBlock      preBlock;
@property (nonatomic,strong) DownloadParamersBlock progressBlock;
@property (nonatomic,strong) DownloadParamersBlock completeBlock;
@property (nonatomic,strong) DownloadParamersBlock failedBlock;
@end

@implementation DLDownloadFile

- (instancetype)init{
    self = [super init];
    if (self) {
        _from   =   0;
        _to     =   0;
        _receiveLength  =   0;
        _totalSize      =   0;
    }
    return self;
}

+ (DLDownloadFile *)createDownloadFile:(NSString *)urlString
                                path:(NSString *)tempFilePath
                          headerFile:(NSDictionary *)headerFieldDic
                                from:(long long)from
                                  to:(long long)to
                                 pre:(DownloadPreBlock)preBlock
                            progress:(DownloadParamersBlock)processBlock
                            complete:(DownloadParamersBlock)completeBlock
                              failed:(DownloadParamersBlock)failedBlock{
    DLDownloadFile *downloadFile  =   [[DLDownloadFile alloc] init];
    downloadFile.urlString        =   urlString;
    downloadFile.tempFilePath     =   tempFilePath;
    downloadFile.headerFieldDic   =   headerFieldDic;
    downloadFile.from             =   from;
    downloadFile.to               =   to;
    downloadFile.preBlock         =   preBlock;
    downloadFile.progressBlock    =   processBlock;
    downloadFile.completeBlock    =   completeBlock;
    downloadFile.failedBlock      =   failedBlock;
    return downloadFile;
}

- (BOOL)startDownload{
    if (_from > _to) {
        return NO;
    }
    
    _receiveLength = _from;
    [self openStream];
    return [self resumeFrom:_from to:_to];
}

- (void)cancelDownload{
    if (_connection) {
        [_connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_connection cancel];
        _connection = nil;
    }
    [self closeStream];
}

// 打开下载文件流
- (void)openStream{
    if (NULL == _fd){
        _fd = fopen([self.tempFilePath UTF8String], "a+");
    }
}

// 关闭下载文件流
- (void)closeStream{
    if (_fd){
        fclose(_fd);
        _fd = NULL;
    }
}

- (BOOL)resumeFrom:(long long)from to:(long long)to{
    BOOL success = NO;
    if(_urlString && ![_urlString isEqualToString:@""]){

        NSURL *url = [NSURL encodeURLWithString:_urlString];
        if(url){
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setTimeoutInterval:30];
            assert(request != nil);
            //忽略缓存直接从原始地址下载
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            
            if (_headerFieldDic) {
                NSArray *keys = [_headerFieldDic allKeys];
                for (NSString *key in keys) {
                    [request setValue:[_headerFieldDic valueForKey:key] forHTTPHeaderField:key];
                }
            }
            
             // from和to同时有值的时候，才开始断点，否则重新开始下载。
            if (_to != 0 && _from != 0) {
                NSString *range = [[NSString alloc] initWithFormat:@"bytes=%lld-",_from];
                [request addValue:range forHTTPHeaderField:@"Range"];
            }
            
            if (self.connection) {
                self.connection = nil;
            }
            
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
            assert(_connection != nil);
            success = YES;
        }
    }
    
    return success;
}

#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    assert([httpResponse isKindOfClass:[NSHTTPURLResponse class]]);
    NSDictionary *dict = httpResponse.allHeaderFields;
    // 软件实际大小 = 本地已接收大小 + 未接收大小
    _totalSize = [[dict objectForKey:@"Content-Length"] longLongValue] + _from;
    
    if (self.preBlock) {
        self.preBlock(_totalSize);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSUInteger sz = [data length];
    const void *bytes = [data bytes];
    if (_fd) {
        fseek(_fd, (long)(_from + _receiveLength), SEEK_SET);
        NSUInteger len = 0;
        while (len < sz) {
            NSUInteger wt = fwrite(bytes, 1, sz, _fd);
            len += wt;
        }
        
        _receiveLength += sz;
    }
    
    if (self.progressBlock) {
        self.progressBlock(_totalSize,_receiveLength,sz,nil);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    assert(connection == _connection);
  
    [self closeStream];
    
    if (self.completeBlock) {
        self.completeBlock(_totalSize,_receiveLength,0,nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    assert(connection == _connection);
    NSInteger code = 200000 - error.code;

    [self cancelDownload];
    if (self.failedBlock) {
        NSError *tbError = [NSError errorWithDomain:error.domain code:code userInfo:error.userInfo];
        if (_totalSize == 0) {
            _totalSize = _to;
        }
        self.failedBlock(_totalSize,_receiveLength,0,tbError);
    }
}

@end

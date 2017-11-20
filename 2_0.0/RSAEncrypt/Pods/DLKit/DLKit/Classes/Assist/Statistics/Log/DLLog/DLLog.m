//
//  DLLog.m
//  Pods
//
//  Created by ice on 2017/6/20.
//
//

#import "DLLog.h"
#import "NSDate+Extended.h"
#import <MessageUI/MessageUI.h>

// 日志保留最大天数
static const int LogMaxSaveDay = 7;

@interface DLLog ()<MFMailComposeViewControllerDelegate>
@property (nonatomic,strong) NSFileHandle *fileHandle;
@property (nonatomic,assign) MailVCBlock block;
@end

@implementation DLLog
+ (DLLog *)shareInstance{
    static DLLog *log = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!log) {
            log = [[DLLog alloc] init];
        }
    });
    return log;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        // 超过7天先删除旧日志文件,再创建新的日志文件
        [self clearExpiredLog];

        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:[self logPath]];
        [_fileHandle seekToEndOfFile];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *content = [NSString stringWithFormat:
                       @"**********************Start************************"
                       "\n----------------------------------------------------"
                       "\n日志:%@\n"
                       "----------------------------------------------------\n"
                       ,strDate];
        [_fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [_fileHandle synchronizeFile];
    }
    return self;
}

+ (void)log:(NSString*)str func:(NSString *)fun linnum:(int)num{
    DLLog *log = [DLLog shareInstance];
    [log log:[NSString stringWithFormat:@"====>>>>> %@ %@ #%d: %@\n",[NSDate stringFromDate:[NSDate date]],fun,num,str]];
}

- (void)sendLogToEmail:(NSString *)email
                 title:(NSString *)title
               content:(NSString *)content
                 block:(MailVCBlock)block{
    if (email) {
        if (!title) {
            title = @"";
        }
        
        if (!content) {
            content = @"";
        }
        
        NSString *log = @"";
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self logPath]]) {
            log = [NSString stringWithContentsOfFile:[self logPath] encoding:NSUTF8StringEncoding error:nil];
        }
        // 用户设备是否绑定了邮箱账号
        if ([MFMailComposeViewController canSendMail]){
            MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
            vc.mailComposeDelegate = self;
            // 标题
            [vc setSubject:title];
            //设置收件人
            [vc setToRecipients:[NSArray arrayWithObjects:email, nil]];
            //设置邮件内容
            [vc setMessageBody:content isHTML:NO];
            // 日志以附件的方式发送
            [vc addAttachmentData:[NSData dataWithContentsOfFile:[self logPath]] mimeType:@"text" fileName:@"log.txt"];
            if (block) {
                self.block = block;
                block(vc,NO);
            }
        }else{
            // 打开设备添加账户页面   设置->邮件、通讯录、日历->添加账户
            // NSString *urlStr = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",email,title,content]; 发送少量数据
            NSString *urlStr = [NSString stringWithFormat:@"mailto:%@",email];
            NSURL *url = [NSURL URLWithString:urlStr];
            if ([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }else{
                // 出错处理
            }
        }
    }
}

- (void)clearExpiredLog{
    NSString *path = [self logPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        NSString *createTime = dict[@"NSFileCreationDate"];
        NSString *dateStr = [NSString stringWithFormat:@"%@",createTime];
        NSRange range = [dateStr rangeOfString:@" +"];
        if (range.location != NSNotFound) {
            dateStr = [dateStr substringToIndex:range.location];
        }
        // 计算当前时间跟文件创建时的时间差是否 >= 7 天
        NSDate *fileCreateDate = [NSDate dateFromString:dateStr];
        if(fileCreateDate){
            NSTimeInterval oldTime = [fileCreateDate timeIntervalSince1970];
            NSTimeInterval currTime = [[NSDate date] timeIntervalSince1970];
            
            NSTimeInterval second = currTime - oldTime;
            int day = (int)second / (24 * 3600);
            if (day >= LogMaxSaveDay) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }else{
            }
        }
    }else{
        [[NSFileManager defaultManager] createFileAtPath:path
                                                contents:nil
                                              attributes:nil];
    }
}

- (void)log:(NSString*)str{
    [_fileHandle seekToEndOfFile];
    [_fileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [_fileHandle synchronizeFile];
}

- (NSString *)logPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"log.txt"];
    return filePath;
}

#pragma mark --邮件代理
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error{
    self.block(controller,YES);
}

@end

//
//  ViewController.m
//  WebCache
//
//  Created by ice on 2017/8/16.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "WebUrlProtocol.h"
#import <WebKit/WebKit.h>
#import "DLHttp.h"
#import "UIDevice+extended.h"

/**
 *  缓存UIWebView 和 WKWebView的 网页内容
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlString = @"http://www.jianshu.com/u/87ba39ac990d";
    
    NSInteger flag = 1;
    switch (flag) {
        case 0:
            [self testUIWebView:urlString];
            break;
        case 1:
            [self testWkWebView:urlString];
            break;
        case 3:
            [self testPost];
            break;
        default:
            break;
    }
    
}

- (void)testUIWebView:(NSString *)urlString{
    [NSURLProtocol registerClass:[WebUrlProtocol class]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)testWkWebView:(NSString *)urlString{
    [NSURLProtocol registerClass:[WebUrlProtocol class]];
    
    Class cls = NSClassFromString(@"WKBrowsingContextController");
    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
    if ([cls respondsToSelector:sel]) {
        // 通过http和https的请求，同理可通过其他的Scheme 但是要满足ULR Loading System
        [cls performSelector:sel withObject:@"http"];
        [cls performSelector:sel withObject:@"https"];
    }
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)testPost{
     [NSURLProtocol registerClass:[WebUrlProtocol class]];
    
    NSString *outsideVersion = @"1.0.1";//[ABTarget bundleShortVersion];
    NSString *sku       =   @"com.test110";//[ABTarget bundleIdentifier];
    NSString *idfa      =   [UIDevice idfa];
    NSString *idfv      =   [UIDevice idfv];
    NSString *devVer    =   @"1000";
    NSString *sn = @"";
    
    NSString *postString = [NSString stringWithFormat:@"sku=%@&idfa=%@&idfv=%@&sn=%@&ver=%@&devver=%@",sku,idfa,idfv,sn,outsideVersion,devVer];
    NSData *postData = [NSData dataWithBytes:[postString UTF8String] length:[postString length]];
    
    [DLHttp synWithPostURLString:@"http://update.xingyuncap.com/req/?t=10000&token=Nx8jD95vSVy8ewB5p76R6g"
                        withData:postData
                 withHeaderField:nil
             withTimeoutInterval:10
                  withForeground:YES
                 shouldURLEncode:NO
               completionHandler:^(NSData *data, NSError *error, NSHTTPURLResponse *response) {
                   if (data) {
                       NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                       NSLog(@"resultDic = %@",resultDic);
                       
                   }else{
                       NSLog(@"data == NULL");
                   }
                   
               }];
}
@end

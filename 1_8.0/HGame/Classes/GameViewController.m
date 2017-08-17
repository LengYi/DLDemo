//
//  GameViewController.m
//  HGame
//
//  Created by ice on 2017/8/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "GameViewController.h"
#import "HGameUrlProtocol.h"

@interface GameViewController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showGameWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    [NSURLProtocol registerClass:[HGameUrlProtocol class]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [NSURLProtocol unregisterClass:[HGameUrlProtocol class]];
}

- (void)showGameWebView{
    [self.view addSubview:self.webView];
    NSLog(@"gameUrl ---- %@",self.gameUrl);
    if (self.gameUrl) {
        NSURL *url = [NSURL URLWithString:self.gameUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    }
    return _webView;
}
@end

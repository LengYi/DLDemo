//
//  ViewController.m
//  Proto
//
//  Created by ice on 2017/8/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *web;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 访问sina重定向至souhu
    _web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _web.delegate = self;
    _web.backgroundColor = [UIColor redColor];
    [self.view addSubview:_web];

    NSURL *url = [[NSURL alloc] initWithString:@"https://sina.cn"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_web loadRequest:request];
}



@end

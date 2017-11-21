//
//  ViewController.m
//  MobileProvision
//
//  Created by ice on 2017/11/21.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "DLCerAnalyze.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *name = [DLCerAnalyze teamName];
    NSString *ID = [DLCerAnalyze teamID];
    NSString *provisionExpiredTime = [DLCerAnalyze provisionExpiredTime];
    NSDate *cerExpiredTime = [DLCerAnalyze cerExpireTime];
    
    NSLog(@"\n 证书名称: %@ \n 证书ID: %@ \n 证书过期日期: %@ \n cer过期日期: %@ \n ",name,ID,provisionExpiredTime,cerExpiredTime);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

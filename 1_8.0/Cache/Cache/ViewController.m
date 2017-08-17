//
//  ViewController.m
//  Cache
//
//  Created by ice on 2017/8/15.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "DLHttp.h"
#import "UIDevice+extended.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 80)];
    [btn addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Click" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}


- (void)btnClickAction {
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

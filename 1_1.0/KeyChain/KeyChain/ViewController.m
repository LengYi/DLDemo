//
//  ViewController.m
//  KeyChain
//
//  Created by ice on 17/3/6.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "DL_KeyChain.h"

#define KEY_PASSWORD @"com.dl.app.password"
#define KEY_USERNAME_PASSWORD @"com.dl.app.usernamepassword"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 将数据存储到keyChain中
    NSDictionary *dataDic = @{@"mmmm" : KEY_PASSWORD};
    [DL_KeyChain saveDataWithKeyChain:dataDic forKey:KEY_USERNAME_PASSWORD];
    
    // 取出存储到keyChain中的数据
    NSLog(@"读取存储结果 %@",[DL_KeyChain loadDataWithKeyChain:KEY_USERNAME_PASSWORD]);
    
    // 删除存储到keyChain中的数据
    [DL_KeyChain deleteDataWithKeyChain:KEY_USERNAME_PASSWORD];
}


@end

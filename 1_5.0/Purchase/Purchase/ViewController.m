//
//  ViewController.m
//  Purchase
//
//  Created by ice on 17/5/2.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "IAPManager.h"

@interface ViewController ()
@property (nonatomic,strong) IAPManager *iapManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 60)];
    [button setTitle:@"购买" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(purchaseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)purchaseAction {
 
    if (!_iapManager) {
        _iapManager = [[IAPManager alloc] init];
    }
    
    // iTunesConnect 苹果后台配置的产品ID
    [_iapManager startPurchWithID:@"com.bb.helper_advisory" completeHandle:^(IAPPurchType type,NSData *data) {
        
    }];
}

@end

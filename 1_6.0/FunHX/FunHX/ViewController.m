//
//  ViewController.m
//  FunHX
//
//  Created by ice on 2017/8/22.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "Manager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (Manager->isVip) {
        NSLog(@"isVIP");
    }
    
    Manager->resetPassword(@"98760");
}

@end

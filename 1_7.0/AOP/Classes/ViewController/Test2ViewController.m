//
//  Test2ViewController.m
//  AOP
//
//  Created by ice on 2017/7/21.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "Test2ViewController.h"

@interface Test2ViewController ()

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test2ViewController";
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


@end

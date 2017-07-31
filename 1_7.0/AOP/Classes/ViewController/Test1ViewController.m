//
//  Test1ViewController.m
//  AOP
//
//  Created by ice on 2017/7/21.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "Test1ViewController.h"
#import "Test2ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test1ViewController";
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 100, 80)];
    [btn1 setTitle:@"Press_One" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(300, 80, 100, 80)];
    [btn2 setTitle:@"Press_Two" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)action1{
    Test2ViewController *vc = [[Test2ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)action2{
    
}

@end

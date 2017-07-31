//
//  ViewController.m
//  AOP
//
//  Created by ice on 2017/7/21.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "Test1ViewController.h"


@interface ViewController ()
@property (nonatomic,strong)  UINavigationController *nav;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Test1ViewController *test1 = [[Test1ViewController alloc] init];
    _nav = [[UINavigationController alloc] initWithRootViewController:test1];
    [self.view addSubview:_nav.view];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


@end

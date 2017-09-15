//
//  ViewController.m
//  Operation
//
//  Created by ice on 2017/9/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "RootViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UINavigationController *nav;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RootViewController *vc = [[RootViewController alloc] init];
    _nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.view addSubview:_nav.view];
}

@end

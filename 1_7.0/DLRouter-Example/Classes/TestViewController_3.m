//
//  TestViewController_3.m
//  DLRouter-Example
//
//  Created by ice on 2017/6/12.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "TestViewController_3.h"
#import "DLRouter.h"

@interface TestViewController_3 ()
@property (nonatomic,strong) UIButton *btn;
@end

@implementation TestViewController_3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"正常跳转+回调参数";
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.btn];
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
        _btn.center = self.view.center;
        _btn.backgroundColor = [UIColor blueColor];
        [_btn setTitle:@"clickToBack" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btn;
}


- (void)btnAction{
    // backStr 是父视图的属性
    [DLRouter pop:@{@"backStr":@"Hi,我是从 TestViewController_3 回调的参数"} animated:YES];
}

@end

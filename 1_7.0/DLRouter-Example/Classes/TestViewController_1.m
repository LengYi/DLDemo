//
//  TestViewController_1.m
//  DLRouter-Example
//
//  Created by ice on 2017/5/23.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "TestViewController_1.h"

@interface TestViewController_1 ()
@property (nonatomic,strong) UILabel *label;
@end

@implementation TestViewController_1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正常跳转";
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.label];
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
        _label.text = @"TestViewController_1";
        _label.textColor = [UIColor redColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    
    return _label;
}
@end

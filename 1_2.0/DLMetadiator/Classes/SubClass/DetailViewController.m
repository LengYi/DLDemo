//
//  DetailViewController.m
//  DLMetadiator
//
//  Created by ice on 17/3/10.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic,strong) UIButton *button;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.label];
    [self.view addSubview:self.button];
}

- (void)buttpnAction{
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 334, 300)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.center = CGPointMake(self.view.center.x, 200);
    }
    return _imageView;
}

- (id)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor redColor];
        _label.center = CGPointMake(self.view.center.x, 200);
    }
    
    return _label;
}

- (id)button{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_button addTarget:self action:@selector(buttpnAction) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor redColor];
        _button.center = CGPointMake(self.view.center.x, 250);
        [_button setTitle:@"close" forState:UIControlStateNormal];
    }
    return _button;
}

@end

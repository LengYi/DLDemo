//
//  TestViewController_2.m
//  DLRouter-Example
//
//  Created by ice on 2017/6/12.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "TestViewController_2.h"

@interface TestViewController_2 ()
@property (nonatomic,strong) NSString *params;
@end

@implementation TestViewController_2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正常跳转+传参";
    self.view.backgroundColor = [UIColor greenColor];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"传递的参数" message:_params delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end

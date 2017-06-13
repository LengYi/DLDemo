//
//  ViewController.m
//  DLRouter-Example
//
//  Created by ice on 2017/5/23.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "ActionManager.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSString *backStr; // 回调参数
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}


- (void)viewWillAppear:(BOOL)animated{
    if (_backStr) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_backStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    _backStr = nil;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [ActionManager dealAction:indexPath.row];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"正常跳转",
                     @"正常跳转+传参",
                     @"正常跳转+回调参数",
                     @"路由跳转",
                     @"路由跳转+传参",
                     @"路由跳转+权限校验",
                     @"Present跳转",
                     @"打开指定的页面"];
    }
    
    return _dataArr;
}
@end

//
//  ViewController.m
//  DLMetadiator
//
//  Created by ice on 17/3/7.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "Mediator+ModuleA.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation ViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellIdentifier"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            // present 一个viewcontroller
            UIViewController *viewcontroller = [[Mediator shareInstance] showDetailViewController:@"Present View"];
            [self presentViewController:viewcontroller animated:YES completion:nil];
        }
            break;
        case 1:{
            // push 一个viewcontroller
            // 需改动Main.storboard 配置 入口界面为navigationController, ViewController 为其RootViewController
            UIViewController *viewcontroller = [[Mediator shareInstance] showDetailViewController:@"Push View"];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
            break;
        case 2:{
            // 显示一个警告框
            [[Mediator shareInstance] showAlertWithMessage:@"Hello World!!!"
                                              cancleAction:^(NSDictionary *info) {
                                                  NSLog(@"取消");
                                              } cofirmAction:^(NSDictionary *info) {
                                                  NSLog(@"确定");
                                              }];
        }
            break;
        case 3:{
            // 显示一张图片
            [[Mediator shareInstance] presentImage:[UIImage imageNamed:@"1.jpg"]];
        }
            break;
        case 4:{
            // 参数为空处理方式
            [[Mediator shareInstance] presentImage:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - SetGet_Method
- (id)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame = [UIScreen mainScreen].bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kCellIdentifier"];
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"Present DetailViewController",@"Push DetailViewController",@"show Alert",@"present image",@"present image but image is nil"];
    }
    return _dataArray;
}

@end

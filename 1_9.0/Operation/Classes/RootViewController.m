//
//  RootViewController.m
//  Operation
//
//  Created by ice on 2017/9/15.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "RootViewController.h"
#import "Test.h"
#import "ImageViewController.h"

@interface RootViewController ()

@end

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) Test *threadTest;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.textLabel.text = self.imageArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Test *test = nil;
    if (indexPath.row != 6) {
        test = [[Test alloc] init];
    }
    switch (indexPath.row) {
        case 0:
            [test testNSInvocationOperation];
            break;
        case 1:
            [test testNSBlockOperation];
            break;
        case 2:
            [test testNSOperation];
            break;
        case 3:
            [test testOperationQueue];
            break;
        case 4:
            [test testOperationQueueWithBlock];
            break;
        case 5:
            [test testNSOperationDependency];
            break;
        case 6:{
            if (!_threadTest) {
                _threadTest = [[Test alloc] init];
            }
            [_threadTest testThread];
        }
            break;
        case 7:{
            ImageViewController *vc = [[ImageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        default:
            break;
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"NSInvocationOperation",@"NSBlockOperation",@"NSOperation",@"OperationQueue",@"OperationQueueWithBlock",@"OperationDependency",@"testThread",@"图片下载"];
    }
    
    return _imageArray;
}
@end

//
//  ViewController.m
//  HGame
//
//  Created by ice on 2017/8/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithObjects:@"ajkyq",@"cjmla",@"cjrst",@"qqppp",@"100c",@"CandyPig",@"wugui",nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"identify";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertController *alertController= [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您将进入\"%@\"本地休闲游戏",self.dataArr[indexPath.row]] message:@"提示：游戏为本地游戏，不需要消耗任何流量，您可关闭网络来玩" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GameViewController *webVc = [[GameViewController alloc] init];
        webVc.gameUrl = [NSString stringWithFormat:@"http://localhost:8080/GameRes/%@/index.html",self.dataArr[indexPath.row]];
        [self.navigationController pushViewController:webVc animated:YES];
        
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end

//
//  ImageViewController.m
//  Operation
//
//  Created by ice on 2017/9/15.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ImageViewController.h"
#import "ImageModel.h"

@interface ImageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,strong) NSMutableDictionary *imageCache;
@property (nonatomic,strong) NSMutableDictionary *operations;
@property (nonatomic,strong) NSOperationQueue *queue;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 500;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    NSString *iconUrl = self.datas[indexPath.row];
    
    // 从内存中取出照片
    UIImage *image = self.imageCache[iconUrl];
    if (image) {
        cell.imageView.image = image;
    }else{
        //获得Library/Caches文件夹
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //获得url中图片名字
        NSString *filename = [iconUrl lastPathComponent];
        //拼接路径
        NSString *file = [cachesPath stringByAppendingPathComponent:filename];
        //将沙盒里面的图片转换为data
        NSData *data = [NSData dataWithContentsOfFile:file];
        
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            cell.imageView.image = image;
            self.imageCache[iconUrl] = image;
        }else{
            // 首先设置默认背景图,图片下载之后重新刷新当前行
            cell.imageView.image = [UIImage imageNamed:@"timg.jpeg"];
            
            NSOperation *op = nil;
            if (!op) {
                op = [NSBlockOperation blockOperationWithBlock:^{
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
                    if (imageData == nil) {
                        // 删除操作之后才会再次执行
                        [self.operations removeObjectForKey:iconUrl];
                        return ;
                    }
                    
                    UIImage *image = [UIImage imageWithData:imageData];
                    // 保存到字典中
                    self.imageCache[iconUrl] = image;
                    // 主线程刷新界面
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        cell.imageView.image = image;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                    // 写入沙盒中,缓存图片数据
                    [imageData writeToFile:file atomically:YES];
                    // 优化内存使用
                    [self.operations removeObjectForKey:iconUrl];
                }];
                
                // 添加到队列执行,添加完自动执行
                [self.queue addOperation:op];
                // 保存队列
                self.operations[iconUrl] = op;
            }
        }
    }
    return cell;
}


- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}

- (NSMutableDictionary *)operations{
    if (_operations == nil) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (NSMutableDictionary *)imageCache{
    if (!_imageCache) {
        _imageCache = [NSMutableDictionary dictionary];
    }
    return _imageCache;
}

- (NSArray *)datas{
    if (!_datas) {
        _datas = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil]];
    }
    
    return _datas;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}
@end

//
//  ViewController.m
//  IOP
//
//  Created by ice on 17/3/27.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "MapEngine.h"

@interface ViewController ()

@end

@implementation ViewController

/**
 面向协议编程
 MapEngine 调用不同的地图工厂,不同的工厂遵循相同的接口协议  IMapFactory
 地图工厂负责生产不同的地图视图,不同的地图视图遵循相同的接口协议 ImapView
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    MapEngine *engine = [[MapEngine alloc] init];
    id <IMapFactory> factory = [engine getMapFactoryWithType:baidu];
    id <ImapView> mapview = [factory getMapViewWithFrame:self.view.frame];
    [self.view addSubview:[mapview getMapView]];
}

@end

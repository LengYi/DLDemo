//
//  BaiduMapView.m
//  IOP
//
//  Created by ice on 17/3/27.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "BaiduMapView.h"
@interface BaiduMapView ()
@property (nonatomic,strong) UIView *mapView;
@end

@implementation BaiduMapView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _mapView = [[UIView alloc] initWithFrame:frame];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text = @"百度地图";
        label.center = _mapView.center;
        [_mapView addSubview:label];
        _mapView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (UIView *)getMapView{
    return _mapView;
}

@end

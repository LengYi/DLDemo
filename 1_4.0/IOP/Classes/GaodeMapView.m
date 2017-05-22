//
//  GaodeMapView.m
//  IOP
//
//  Created by ice on 17/3/28.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "GaodeMapView.h"

@interface GaodeMapView ()
@property (nonatomic,strong) UIView *mapView;
@end

@implementation GaodeMapView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _mapView = [[UIView alloc] initWithFrame:frame];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text = @"高德地图";
        label.center = _mapView.center;
        [_mapView addSubview:label];
        _mapView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (UIView *)getMapView{
    return _mapView;
}

@end

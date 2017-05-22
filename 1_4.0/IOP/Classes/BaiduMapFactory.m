//
//  BaiduMapFactory.m
//  IOP
//
//  Created by ice on 17/3/27.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "BaiduMapFactory.h"
#import "BaiduMapView.h"

@interface BaiduMapFactory ()
@property (nonatomic,strong) UIView *baiduMap;
@end

@implementation BaiduMapFactory


- (id<ImapView>)getMapViewWithFrame:(CGRect)frame{
    BaiduMapView *baiduMap = [[BaiduMapView alloc] initWithFrame:frame];
    baiduMap.backgroundColor = [UIColor redColor];
    return baiduMap;
}

@end

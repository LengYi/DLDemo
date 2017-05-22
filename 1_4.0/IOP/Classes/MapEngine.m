//
//  MapEngine.m
//  IOP
//
//  Created by ice on 17/3/27.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "MapEngine.h"
#import "BaiduMapFactory.h"
#import "GaodeMapFactory.h"

@implementation MapEngine

- (id<IMapFactory>)getMapFactoryWithType:(MapType)type{
    if (type == baidu) {
        return [[BaiduMapFactory alloc] init];
    }else if(type == gaode){
        return [[GaodeMapFactory alloc] init];
    }
    
    return nil;
}

@end

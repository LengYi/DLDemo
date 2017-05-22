//
//  MapEngine.h
//  IOP
//
//  Created by ice on 17/3/27.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMapFactory.h"

typedef NS_ENUM(NSInteger,MapType){
    baidu,
    gaode
};

@interface MapEngine : NSObject

- (id<IMapFactory>)getMapFactoryWithType:(MapType)type;

@end

//
//  IMapFactory.h
//  IOP
//
//  Created by ice on 17/3/27.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImapView.h"

@protocol IMapFactory <NSObject>

- (id<ImapView>)getMapViewWithFrame:(CGRect)frame;

@end

//
//  ImapView.h
//  IOP
//
//  Created by ice on 17/3/27.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImapView <NSObject>

- (instancetype)initWithFrame:(CGRect)frame;
- (UIView *)getMapView;

@end

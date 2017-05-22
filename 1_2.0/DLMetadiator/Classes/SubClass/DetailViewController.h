//
//  DetailViewController.h
//  DLMetadiator
//
//  Created by ice on 17/3/10.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 详细页具体业务模块
*/

@interface DetailViewController : UIViewController
/// 展示一张照片
@property (nonatomic,strong) UIImageView *imageView;
/// 显示一段文字
@property (nonatomic,strong) UILabel *label;
@end

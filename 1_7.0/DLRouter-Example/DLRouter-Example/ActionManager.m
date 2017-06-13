//
//  ActionManager.m
//  DLRouter-Example
//
//  Created by ice on 2017/5/23.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ActionManager.h"
#import "DLRouter.h"
#import "TestViewController_5.h"

@implementation ActionManager
+ (void)dealAction:(NSInteger)index{
    switch (index) {
        case 0:
            [DLRouter open:@"TestViewController_1"];
            break;
        case 1:
            // 字典的key params 就是 TestViewController_2 的属性  params
            [DLRouter open:@"TestViewController_2" options:[RouterOptions optionsWithParams:@{@"params":@"Hello World!!!"}]];
            break;
        case 2:
            [DLRouter open:@"TestViewController_3"];
            break;
        case 3:// 路由跳转
            [DLRouter openWithUrl:@"dlApp://jackApp:10002"];
            break;
        case 4:
            [DLRouter openWithUrl:@"dlApp://jackApp:10002?params=parame----->Hello World!"];
            break;
        case 5:// 路由跳转
            [DLRouter openWithUrl:@"dlApp://jackApp:10003"];
            break;
        case 6:{
            RouterOptions *options = [RouterOptions defaultOptions];
            options.isPressent = YES;
            [DLRouter open:@"TestViewController_4" options:options];
        }
            break;
        case 7:{
            UIViewController *vc = [[TestViewController_5 alloc] init];
            RouterOptions *options = [RouterOptions defaultOptions];
            [DLRouter openSecialVC:vc options:options];
        }
            break;
        default:
            break;
    }
}
@end

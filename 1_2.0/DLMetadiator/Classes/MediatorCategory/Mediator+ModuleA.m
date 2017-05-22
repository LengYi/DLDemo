//
//  Mediator+ModuleA.m
//  DLMetadiator
//
//  Created by ice on 17/3/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "Mediator+ModuleA.h"

NSString *const kMediatorTargetA = @"A";
NSString *const kMediatorActionDetailViewController = @"ShowDetailViewController";
NSString *const KMediatorActionShowAlert = @"ShowAlert";
NSString *const kMediatorActionPresentImage = @"PresentImage";

@implementation Mediator (ModuleA)

- (UIViewController *)showDetailViewController:(NSString *)info{
    UIViewController *viewController = [self performTarget:kMediatorTargetA
                                                    action:kMediatorActionDetailViewController
                                                    params:@{@"key":info}
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    }else{
        return [[UIViewController alloc] init];
    }
}

- (void)showAlertWithMessage:(NSString *)message
                cancleAction:(void(^)(NSDictionary *info))cancleAction
                cofirmAction:(void(^)(NSDictionary *info))confirmAction{
    NSDictionary *dic = @{@"message" : message,@"cancelAction":cancleAction,@"confirmAction":confirmAction};
    [self performTarget:kMediatorTargetA
                 action:KMediatorActionShowAlert
                 params:dic
      shouldCacheTarget:NO];
}

- (void)presentImage:(UIImage *)image{
    if (image) {
        [self performTarget:kMediatorTargetA
                     action:kMediatorActionPresentImage
                     params:@{@"image" : image,@"key":@"show Image"}
          shouldCacheTarget:NO];
    }else{
        [self performTarget:kMediatorTargetA
                     action:kMediatorActionPresentImage
                     params:@{@"image" : [UIImage imageNamed:@"2.png"],@"key":@"No Image"}
          shouldCacheTarget:NO];
    }
}

@end

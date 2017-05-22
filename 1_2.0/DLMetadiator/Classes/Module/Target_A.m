//
//  Target_A.m
//  DLMetadiator
//
//  Created by ice on 17/3/10.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "Target_A.h"
#import "DetailViewController.h"

typedef void (^CTUrlRouterCallbackBlock)(NSDictionary *info);

@implementation Target_A

- (UIViewController *)Action_ShowDetailViewController:(NSDictionary *)params{
    DetailViewController *viewController = [[DetailViewController alloc] init];
    viewController.label.text = params[@"key"];
    return viewController;
}

- (id)Action_ShowAlert:(NSDictionary *)params{
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             CTUrlRouterCallbackBlock callback = params[@"cancelAction"];
                                                             if (callback) {
                                                                 callback(@{@"alertAction" : action});
                                                             }
                                                         }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"confirm"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              CTUrlRouterCallbackBlock callback = params[@"confirmAction"];
                                                              if (callback) {
                                                                  callback(@{@"alertAction":action});
                                                              }
                                                          }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:params[@"message"]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    return nil;
}

- (void)Action_PresentImage:(NSDictionary *)params{
    DetailViewController *viewController = [[DetailViewController alloc] init];
    viewController.label.text = params[@"key"];
    viewController.imageView.image = params[@"image"];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
}

@end

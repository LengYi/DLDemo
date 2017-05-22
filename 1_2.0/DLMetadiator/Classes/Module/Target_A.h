//
//  Target_A.h
//  DLMetadiator
//
//  Created by ice on 17/3/10.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Target_A : NSObject
- (UIViewController *)Action_ShowDetailViewController:(NSDictionary *)params;
- (id)Action_ShowAlert:(NSDictionary *)params;
- (void)Action_PresentImage:(NSDictionary *)params;
@end

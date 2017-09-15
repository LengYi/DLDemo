//
//  YSOPeration.m
//  Operation
//
//  Created by ice on 2017/9/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "YSOPeration.h"

@implementation YSOPeration

- (void)main{
    for (int i = 0; i < 2; ++i) {
        NSLog(@"1-----%@",[NSThread currentThread]);
    }
}

@end

//
//  ViewController.m
//  ScanIOSApp
//
//  Created by ice on 17/3/17.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "ViewController.h"
#import "UIApplication+Extern.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict = [UIApplication scanAllInstanedApp];
    NSLog(@"---- %@",dict);
}



@end

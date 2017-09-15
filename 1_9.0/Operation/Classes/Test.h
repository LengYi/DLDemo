//
//  Test.h
//  Operation
//
//  Created by ice on 2017/9/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Test : NSObject

- (void)testNSInvocationOperation;
- (void)testNSBlockOperation;
- (void)testNSOperation;
- (void)testOperationQueue;
- (void)testOperationQueueWithBlock;
- (void)testNSOperationDependency;
- (void)testThread;

@end

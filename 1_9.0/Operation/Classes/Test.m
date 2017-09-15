//
//  Test.m
//  Operation
//
//  Created by ice on 2017/9/14.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "Test.h"
#import "YSOPeration.h"

@interface Test()
@property (nonatomic,strong) NSThread *thread;
@end

@implementation Test

- (instancetype)init{
    self = [super init];
    if (self) {
        _thread = [[NSThread alloc] initWithTarget:self
                                          selector:@selector(threadRun1)
                                            object:nil];
        [_thread start];
    }
    return self;
}

- (void)testNSInvocationOperation{
    // 单独使用工作在主线程,不开启新的线程
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    [op start];
}

- (void)run{
    NSLog(@"----- %@",[NSThread currentThread]);
}

- (void)testNSBlockOperation{
    // 单独使用工作在主线程,不开启新的线程
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1----- %@",[NSThread currentThread]);
    }];
    
    // 工作在其它线程
    [op addExecutionBlock:^{
        NSLog(@"2----- %@",[NSThread currentThread]);
    }];
    
    [op addExecutionBlock:^{
        NSLog(@"3----- %@",[NSThread currentThread]);
    }];
    
    [op addExecutionBlock:^{
        NSLog(@"4----- %@",[NSThread currentThread]);
    }];
    
    [op start];
}

- (void)testNSOperation{
    // 单独使用工作在主线程,不开启新的线程
    YSOPeration *op = [[YSOPeration alloc] init];
    [op start];
}

- (void)testOperationQueue{
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2. 创建操作
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"5-----%@", [NSThread currentThread]);
        }
    }];
    
    // 3. 添加操作到队列中,然后系统自动开辟新线程处理任务。
    [queue addOperation:op1];
    [queue addOperation:op2];
}


- (void)testOperationQueueWithBlock{
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // [queue setMaxConcurrentOperationCount:1];// 设置成1 则为串行执行
    // 2.添加操作到队列中
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"block1 i = %d -----%@",i, [NSThread currentThread]);
        }
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"block 2");
    }];
    
}

- (void)testNSOperationDependency{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1-----%@", [NSThread  currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2-----%@", [NSThread  currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3-----%@", [NSThread  currentThread]);
    }];
    
    [op2 addDependency:op1]; // 让op2 依赖于 op1，则先执行op1，在执行op2, 无论运行几次，其结果都是op1先执行，op2后执行
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}

- (void)testThread{
    [self performSelector:@selector(threadRun2) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 开启常驻内存线程
- (void)threadRun1{
    NSLog(@"thread Run1");
    
    // 开启RunLoop，之后self.thread就变成了常驻线程，可随时添加任务，并交于RunLoop处理
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    // 测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环。
    NSLog(@"未开启Runloop");
}

- (void)threadRun2{
     NSLog(@"----thread Run2------");
}

@end

//
//  ViewController.m
//  多线程
//
//  Created by 王俊 on 2020/3/18.
//  Copyright © 2020 peipei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [self test1];
//    [self test3];
    [self test2];
}

//NSThread
- (void)test1 {
    
    //1,
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        //任务
        NSLog(@"11-----%@",[NSThread currentThread]);
    }];
    [thread start];//使用初始化的需要 start 启动
    thread.name = @"test1";
    thread.threadPriority = 0.8;//0-1 之间,默认 0.5,越高被执行的效率可能会越高
    [thread cancel];
    
    //2,构造器创建新线程---直接执行任务
    [NSThread detachNewThreadWithBlock:^{
        ////任务
        NSLog(@"22-----%@",[NSThread currentThread]);
    }];
}

//GCD
- (void)test2 {
    //同步执行+并发队列
    dispatch_queue_t queue1 = dispatch_queue_create("identifier", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue1, ^{
        NSLog(@"11111---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue1, ^{
        NSLog(@"22222---%@",[NSThread currentThread]);
    });
    
    //同步执行+串行队列
    dispatch_queue_t queue2 = dispatch_queue_create("identifier", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue2, ^{
        NSLog(@"33333---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue2, ^{
        NSLog(@"44444---%@",[NSThread currentThread]);
    });
    
    //异步执行+并发队列
    dispatch_async(queue1, ^{
        NSLog(@"55555---%@",[NSThread currentThread]);
    });
    dispatch_async(queue1, ^{
        NSLog(@"66666---%@",[NSThread currentThread]);
    });
    
    //异步执行+串行队列
    dispatch_async(queue2, ^{
        NSLog(@"77777---%@",[NSThread currentThread]);
    });
    dispatch_async(queue2, ^{
        NSLog(@"88888---%@",[NSThread currentThread]);
    });
}

//NSOperation
- (void)test3 {
    //都只会添加在当前线程中,并且默认同步执行,所以一般和队列一起使用
    
    //1,
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        //执行任务
        NSLog(@"1111---");
    }];
    [blockOperation start];
    
    //2,
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationAction) object:@"test"];
    [invocationOperation start];
    
    //3,自定义---继承NSOperation
//    NSOperation *operation3 = [[NSOperation alloc] init];
//    operation3.
    
    //还能设置任务之间互相依赖,invocationOperation需要在blockOperation完成后才能执行
    [invocationOperation addDependency:blockOperation];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];;
    for (int i = 0; i < 10; i ++) {
        [blockOperation addExecutionBlock:^{
            NSLog(@"-----%d",i);
        }];
    }
    [queue addOperation:blockOperation];
    queue.maxConcurrentOperationCount = 5;//当为 1 的时候表示串行队列,>1 表示并行队列
    
}

- (void)operationAction
{
    NSLog(@"2222---");

}

@end

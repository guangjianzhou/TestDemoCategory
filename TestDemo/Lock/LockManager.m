




//
//  LockManager.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "LockManager.h"

@interface LockManager ()
{
    dispatch_semaphore_t _semaphore;//定义一个信号量
    NSLock *_lock;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LockManager

static LockManager *locakManager;

+ (instancetype) sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locakManager = [[LockManager alloc] init];
    });
    return locakManager;
}

/**
 *  不能控制其它地方的代码通过alloc方法来创建更多的实例，因此我们还要重载任何一个涉及到allocation的方法，这些方法包括   +new, +alloc,+allocWithZone:, -copyWithZone:,
 */

- (id)init
{
    if (self = [super init])
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    _dataArray = [NSMutableArray array];
    for (int i = 0; i < 10000; i++)
    {
        [_dataArray addObject:[NSString stringWithFormat:@"我是第%d葫芦娃",i]];
    }
    
    //信号量初始化
    _semaphore = dispatch_semaphore_create(1);
    _lock = [[NSLock alloc] init];
}

/*
- (void)printContent
{
    @synchronized(self) {
        for (NSString *item in _dataArray)
        {
            NSLog(@"==%@",item);
        }
    }
  
}

- (void)addContent
{
    @synchronized(self)
    {
        for (int i = 0; i < 100; i++)
        {
            [_dataArray addObject:[NSString stringWithFormat:@"我是第%d人参果+100",i]];
            NSLog(@"%@",[NSString stringWithFormat:@"我是第%d人参果+100",i]);
        }
    }
}
*/


/**
 *  需要注意的是lock和unlock之间的”加锁代码“应该是抢占资源的读取和修改代码
 *  对于被抢占资源来说将其定义为 原子属性 是一个很好的习惯
 */

- (void)printContent
{
        [_lock lock];
        for (NSString *item in _dataArray)
        {
            NSLog(@"==%@",item);
        }
        [_lock unlock];
   
}

- (void)addContent
{
    [_lock lock];
    {
        for (int i = 0; i < 100; i++)
        {
            [_dataArray addObject:[NSString stringWithFormat:@"我是第%d人参果+100",i]];
            NSLog(@"%@",[NSString stringWithFormat:@"我是第%d人参果+100",i]);
        }
    }
    [_lock unlock];
    
}


/**
 *  GCD 信号量
 GCD中信号量是dispatch_semaphore_t类型，支持信号通知和信号等待。每当发送一个信号通知，则信号量+1；每当发送一个等待信号时信号量-1,；如果信号量为0则信号会处于等待状态，直到信号量大于0开始执行
 */
- (void)printContentGCD
{
    //信号量等待
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        for (NSString *item in _dataArray)
        {
            NSLog(@"==%@",item);
        }
    //信号量通知
    dispatch_semaphore_signal(_semaphore);
}

- (void)addContentGCD
{
    
    //信号量等待
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    for (int i = 0; i < 100; i++)
    {
        [_dataArray addObject:[NSString stringWithFormat:@"我是第%d人参果+100",i]];
        NSLog(@"%@",[NSString stringWithFormat:@"我是第%d人参果+100",i]);
    }
    
        dispatch_semaphore_signal(_semaphore);
}



- (void)printContentWithOut
{
    for (NSString *item in _dataArray)
    {
        NSLog(@"==%@",item);
    }
}



- (void)addContentWithOut
{
    for (int i = 0; i < 1000; i++)
    {
        [_dataArray addObject:[NSString stringWithFormat:@"熊二%d+100",i]];
        NSLog(@"%@",[NSString stringWithFormat:@"==🐻=%d人参果+100",i]);
    }
}





@end

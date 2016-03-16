//
//  DelayViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/15.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "DelayViewController.h"

@interface DelayViewController ()
{
    NSTimer *timer;
}

@end

@implementation DelayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


/**
 *
 注：此方法是一种非阻塞的执行方式，未找到取消执行的方法。
     必须在主线程中执行
 */
- (IBAction)delayAction1:(UIButton *)sender
{
    if (!sender.selected)
    {
        NSLog(@"====点击======");
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod:) object:nil]; 此方法无法取消
        [self performSelector:@selector(delayMethod:) withObject:@"performSelector" afterDelay:3];
//       dispatch_queue_t queue = dispatch_queue_create("Queue", DISPATCH_QUEUE_SERIAL);
//       dispatch_async(queue, ^{
//           NSLog(@"继续进行的方法==%@",[NSThread currentThread]);
//           [self performSelector:@selector(delayMethod:) withObject:@"performSelector" afterDelay:3];
//       });
        
        NSLog(@"===继续进行的方法===========");

    }
    else
    {
        NSLog(@"====取消======");
    }
    sender.selected = !sender.selected;
}


/**
 
 此方法是一种非阻塞的执行方式，取消执行方法：- (void)invalidate
 */
- (IBAction)delayAction2:(UIButton *)sender
{
    if (!sender.selected)
    {
        NSLog(@"====点击======");
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(delayMethod:) userInfo:@"NStimer" repeats:NO];
        NSLog(@"===继续进行的方法===========");
    }
    else
    {
        NSLog(@"====取消======");
        [timer invalidate];
    }
    sender.selected = !sender.selected;
}

/**
 *
 一种阻塞执行方式,没有取消方式
 *
 */
- (IBAction)delayAction3:(UIButton *)sender
{
    if (!sender.selected)
    {
        NSLog(@"====点击======");
//        [NSThread sleepForTimeInterval:2.0];
       dispatch_queue_t queue = dispatch_queue_create("Queue", DISPATCH_QUEUE_SERIAL);
       dispatch_async(queue, ^{
           NSLog(@"继续进行的方法==%@",[NSThread currentThread]);
           [NSThread sleepForTimeInterval:2.0];
           NSLog(@"继续进行的方法2==%@",[NSThread currentThread]);
       });
        
        NSLog(@"===继续进行的方法===========");
    }
    else
    {
        NSLog(@"====取消======");
    }
    sender.selected = !sender.selected;
}

/**
 *
 是一种非阻塞执行方式。没有找到取消执行方式。
 */
- (IBAction)delayAction4:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf delayMethod:@"GCD"];
    });
}

- (void)delayMethod:(id)object
{
    NSLog(@"======delayMethod= %@=====",object);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




@end

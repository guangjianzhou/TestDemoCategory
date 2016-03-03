//
//  NSTimerViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/1/5.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "NSTimerViewController.h"
#import "NSDate+DateHelp.h"

@interface NSTimerViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation NSTimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countAction:) userInfo:nil repeats:YES];

    {
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
//        设置区域为中国简体中文
        [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        _datePicker.backgroundColor =  [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        _datePicker.layer.masksToBounds = YES;
        _datePicker.layer.cornerRadius = 4;
        [_datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        _datePicker.minimumDate = [NSDate date];
    }
}

- (void)changeDate:(UIDatePicker *)datePicker
{
    NSString *date = [NSDate stringFromDate:datePicker.date withFormat:kDatabaseDateFormat];
    NSLog(@"==选择日期时间%@======",date);
    
}

- (void)countAction:(NSTimer *)timer1
{
    NSLog(@"=======%@======",[NSDate date]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action
- (IBAction)beginTimerAction:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UIDynamic1ViewController"];
    [self presentViewController:vc animated:YES completion:^{
        //跳转后的上一个视图
        UIViewController *vc1 = weakSelf.presentingViewController;
        //跳转后的下一个视图
        UIViewController *vc2 = weakSelf.presentedViewController;
    }];
    
    
    return;
    NSLog(@"=====begin====");
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode]; //加入runloop立即执行
//        [_timer fire];
}

- (IBAction)pauseAction:(UIButton *)sender
{
    NSLog(@"=====pauseAction====");
//    方法1
//    [_timer invalidate]; //终止了_timer 无法再次唤醒(停止timer的运行，但这个是永久的停止)
//    _timer = nil;
    
    //f方法2
    [_timer setFireDate:[NSDate distantFuture]];
    
}

- (IBAction)rescumeAction:(UIButton *)sender
{
    NSLog(@"=====rescumeAction====");
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];
}


@end

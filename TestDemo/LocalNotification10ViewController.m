//
//  LocalNotification10ViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/9/26.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "LocalNotification10ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface LocalNotification10ViewController ()

@end

@implementation LocalNotification10ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendLocalNotificationAction:(UIButton *)sender {
 
    [self greaterIos10];
}



/**
 1.注册权限
 2.注册本地通知
 3.设置本地通知属性
 4.调度本地通知
 */
- (void)lessIOS10
{
    //1.
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert  categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    
    //2. 3.
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:3];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //推送通知的触发时间(何时发出推送通知)
    notification.fireDate = date;
    notification.alertBody = @"hello,zgj";
    notification.alertAction = @"view List";
    notification.category = @"ACTIONABLE";
    
    //4.调度本地通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

- (void)greaterIos10
{
    //相当于设置本地通知属性
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    //设置应用程序数字角标
    content.badge = @1;
    //设置声音
    content.sound = [UNNotificationSound defaultSound];
    //设置文字
    content.body = @"今天天气不错";
    content.title = @"我是标题";
    content.subtitle = @"i am 子标题";
    
    
    UNNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    
    /**
     Identifier: 通知的标识符，用于区分不同的本地通知的
     content: 相当于以前的设置本地通知属性的
     trigger：设置触发时间以及重复的类
     */
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"local" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"----%@---",error);
    }];
}





@end

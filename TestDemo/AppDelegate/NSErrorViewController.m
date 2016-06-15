//
//  NSErrorViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/20.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "NSErrorViewController.h"

@interface NSErrorViewController ()

@end

@implementation NSErrorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"topWindow的点击事件====%s=",__func__);
}

#pragma mark  - StatusBar
- (BOOL)prefersStatusBarHidden
{
    return  NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
//    UIStatusBarStyleDefault
    return UIStatusBarStyleLightContent;
}

@end

//
//  LoadInitiViewContorller.m
//  TestDemo
//
//  Created by ZGJ on 16/9/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "LoadInitiViewContorller.h"
#import "Teacher.h"
#import "CustomButton.h"

@implementation LoadInitiViewContorller

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomButton *btn = [[CustomButton alloc] initWithFrame:CGRectMake(10, 80, 100, 30) image:@"timeline_icon_like" imageType:CusButtonTypeImageRight];
    [btn setTitle:@"随便测试" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    CustomButton *btn1 = [[CustomButton alloc] initWithFrame:CGRectMake(10, 150, 100, 30) image:@"timeline_icon_like" imageType:CusButtonTypeNormal];
    [btn1 setTitle:@"随便测试" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    CustomButton *btn2 = [[CustomButton alloc] initWithFrame:CGRectMake(10, 220, 100, 50) image:@"timeline_icon_like" imageType:CusButtonTypeImageTop];
    [btn2 setTitle:@"随便测试" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    CustomButton *btn3 = [[CustomButton alloc] initWithFrame:CGRectMake(10, 300, 100, 50) image:@"timeline_icon_like" imageType:CusButtonTypeImageBottom];
    [btn3 setTitle:@"随便测试" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Teacher *teacher = [[Teacher alloc] init];
}

@end

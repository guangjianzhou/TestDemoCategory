//
//  FFmpegViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/26.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "FFmpegViewController.h"


@interface FFmpegViewController ()

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@end

@implementation FFmpegViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"view1  frame = %@",NSStringFromCGRect(_view1.frame));
    NSLog(@"view2  frame = %@",NSStringFromCGRect(_view2.frame));
    NSLog(@"view3  frame = %@",NSStringFromCGRect(_view3.frame));
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear view1  frame = %@",NSStringFromCGRect(_view1.frame));
    NSLog(@"viewWillAppear view2  frame = %@",NSStringFromCGRect(_view2.frame));
    NSLog(@"viewWillAppear view3  frame = %@",NSStringFromCGRect(_view3.frame));
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear view1  frame = %@",NSStringFromCGRect(_view1.frame));
    NSLog(@" viewDidAppear view2  frame = %@",NSStringFromCGRect(_view2.frame));
    NSLog(@"viewDidAppear view3  frame = %@",NSStringFromCGRect(_view3.frame));
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews====");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

//
//  DesignPatternViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/9/5.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "DesignPatternViewController.h"

@interface DesignPatternViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DesignPatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设计模式";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

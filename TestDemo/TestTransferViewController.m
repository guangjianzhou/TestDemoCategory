//
//  TestTransferViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/11.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "TestTransferViewController.h"

@interface TestTransferViewController ()<UINavigationControllerDelegate>

@end

@implementation TestTransferViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (IBAction)dismissAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




@end

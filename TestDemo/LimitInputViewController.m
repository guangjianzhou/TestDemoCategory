

//
//  LimitInputViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/8/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "LimitInputViewController.h"

@interface LimitInputViewController ()

@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UITextView *inputView;

@end

@implementation LimitInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, 150, 60)];
    _inputTextField.backgroundColor = [UIColor lightGrayColor];
    [_inputTextField addTarget:self action:@selector(changeTextField) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_inputTextField];
    
    
    _inputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 150, 250, 120)];
    _inputView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_inputTextField];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    //1.emoji 占2 
    [super viewWillAppear:animated];
    NSString *str = @"12😄周z";
    NSLog(@"====长度%lu=",(unsigned long)str.length);
}


#pragma mark  - 
- (void)changeTextField
{
    
}

- (void)changeTextView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

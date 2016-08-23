//
//  CustomerZGJViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/8/10.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CustomerZGJViewController.h"
#import "CgView.h"

@interface CustomerZGJViewController ()

@property (nonatomic, strong) CgView *cgView;

@end

@implementation CustomerZGJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _cgView = [[CgView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    _cgView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_cgView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

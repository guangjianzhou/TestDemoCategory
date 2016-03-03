//
//  RootViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/15.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 42, 60, 42)];
    btn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btn];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //----frame---{{0, 0}, {179, 42}}---
        NSLog(@"----frame---%@---",NSStringFromCGRect(_titleLabel.frame));
    });
}

#pragma mark - 
//当vc在nav中时，上面方法没用 ，vc中的preferredStatusBarStyle方法根本不用被调用。 
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end

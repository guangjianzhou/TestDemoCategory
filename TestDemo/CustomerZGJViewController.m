//
//  CustomerZGJViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/8/10.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CustomerZGJViewController.h"
#import "CgView.h"
#import "CustomXibView.h"
#import "CustomSecondViewController.h"

@interface CustomerZGJViewController ()


/**
 *  1.drawRect 进行画
    2.纯代码 进行创建
    3.xib创建
        代码加载    正常使用
        sb加载     但是xib fileowners 
 */
@property (nonatomic, strong) CustomXibView *xibview;
@property (nonatomic, strong) CgView *cgView;

@end

@implementation CustomerZGJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self customDraw];
    [self xibView];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pushSecondVC)];
    [self.view addGestureRecognizer:press];
    
    
}

- (void)pushSecondVC
{
    CustomSecondViewController *vc = [[CustomSecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)pushSecondVC:(UIGestureRecognizer *)ges
{
    [_xibview showView];
}


- (void)customDraw
{
    _cgView = [[CgView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    _cgView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_cgView];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pushSecondVC:)];
    [_cgView addGestureRecognizer:press];
}

- (void)xibView
{
    _xibview = [[[NSBundle mainBundle] loadNibNamed:@"CustomXibView" owner:self options:nil] lastObject];
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [_xibview showView];
//}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

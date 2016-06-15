

//
//  iOS9ViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/6/14.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "iOS9ViewController.h"

//控制属性 从begin 到end  之间属性都被加了 nonnull
NS_ASSUME_NONNULL_BEGIN
@interface iOS9ViewController ()

//nonnull:// setter和getter 都不能为nil
//@property (nonatomic, strong, nonnull) NSArray *names;
//@property (nonatomic, strong) NSArray * __nonnull names;

//都可以为nil
//@property (nonatomic, strong, nullable) NSArray * names;
//@property (nonatomic, strong) NSArray * __nullable names;


//null_resettable  set可以为nil  get不可以为nil
@property (nonatomic, strong,null_resettable) NSArray *  names;



//泛型   协变性 逆变性
//__covariant 小类型(泛型类的子类型)转换成大类型(泛型类的父类型) 没有警告
//__contravariant 大类型-->小类型



//iskindof


@property (nonatomic, strong) UIWindow *topWindow;

@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) UIButton *showButton;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;


@end
NS_ASSUME_NONNULL_END


@implementation iOS9ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableString *str = [self dequenxx];
    NSLog(@"%@",str);

    _hideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 60, 44)];
    [_hideButton setTitle:@"隐藏" forState:UIControlStateNormal];
    [_hideButton setTintColor:[UIColor blackColor]];
    [_hideButton addTarget:self action:@selector(hideOrShow:) forControlEvents:UIControlEventTouchUpInside];
    _hideButton.tag = 11;
    _hideButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_hideButton];
    
    
    _showButton = [[UIButton alloc] initWithFrame:CGRectMake(_hideButton.frame.size.width, 64, 60, 44)];
    [_showButton setTitle:@"显示" forState:UIControlStateNormal];
    [_showButton setTintColor:[UIColor blackColor]];
    _showButton.tag = 12;
    [_showButton addTarget:self action:@selector(hideOrShow:) forControlEvents:UIControlEventTouchUpInside];
    _showButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_showButton];
    
    
}

/**
 *  __kindof 返回可能是nsstring  也可能是nsmutableString
 */
- (__kindof NSString *)dequenxx
{
    return @"323323";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self addCustomWindow];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.topWindow.hidden = YES;
}

#pragma mark  - UIWindow
- (void)addCustomWindow
{
    self.topWindow = [[UIWindow alloc] init];
    self.topWindow.frame = [UIApplication sharedApplication].statusBarFrame;
    self.topWindow.hidden = NO;
    self.topWindow.backgroundColor = [UIColor yellowColor];
    self.topWindow.windowLevel = UIWindowLevelAlert;
}

- (void)hideOrShow:(UIButton *)btn
{
    if (btn.tag == 11)
    {
        self.statusBarHidden = YES;
    }
    else
    {
        self.statusBarHidden = NO;
    }
    
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

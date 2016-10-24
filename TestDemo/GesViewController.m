//
//  GesViewController.m
//  TestDemo
//
//  Created by ZGJ on 2016/10/19.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "GesViewController.h"
#import "FatherView.h"
#import "SonView.h"

@interface GesViewController ()<UIGestureRecognizerDelegate>
{
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet SonView *sonView;
@property (weak, nonatomic) IBOutlet FatherView *fatherView;

@end


//一般事件的传递是从父控件传递到子控件的
//
//例如：点击了绿色的View，传递过程如下：UIApplication->Window->白色View->绿色View
//
//点击蓝色的View，传递过程如下：UIApplication->Window->白色View->橙色View->蓝色View
//
//如果父控件接受不到触摸事件，那么子控件就不可能接收到触摸事件


//UIApplication-->UIWindow-->递归找到最合适处理的控件-->控件调用touches方法-->判断是否实现touches方法-->没有实现默认会将事件传递给上一个响应者-->找到上一个响应者-->找不到方法作废
@implementation GesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    _sonView.userInteractionEnabled = false;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    tap.delegate = self;
//    [_sonView addGestureRecognizer:tap];
    
//    UIPinchGestureRecognizer *pin1 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinACtion:)];
////    pin1.delegate = self;
//    [_sonView addGestureRecognizer:pin1];
    
    
    
//    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinACtion:)];
//    pin.delegate = self;
//    [_fatherView addGestureRecognizer:pin];
    
    //只能调用实例方法
    timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(testAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:[GesViewController class]
                                   selector:@selector(staticMethod)
                                   userInfo:nil
                                    repeats: YES];
}


- (void)testAction
{
    NSLog(@"==========");
}

+ (void)staticMethod{
    NSLog(@"=====staticMethod===");
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    NSLog(@"===============tap======");
}


- (void)pinACtion:(UIPinchGestureRecognizer *)ges{
    NSLog(@"===============Pin======");
    
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    NSLog(@"ges.view = %@",gestureRecognizer.view);
//    
//    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [gestureRecognizer.view isKindOfClass:[SonView class]])
//    {
//        NSLog(@"sonView--------");
//        return YES;
//    }
//    
//    
//    if([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [gestureRecognizer.view isKindOfClass:[FatherView class]])
//    {
//        NSLog(@"fatherView========");
//        return YES;
//    }
//    
//    if([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [gestureRecognizer.view isKindOfClass:[SonView class]])
//    {
//        NSLog(@"fatherView==son======");
//        return NO;
//    }
//
//    return NO;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [timer invalidate];
}

@end

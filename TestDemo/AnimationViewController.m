//
//  AnimationViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/5/26.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "AnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimationViewController ()
{
    CALayer *scaleLayer ;
    BOOL isAnimtionPasued;
}

@end

@implementation AnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //UIView是对CALayer封装
    scaleLayer = [[CALayer alloc] init];
    scaleLayer.backgroundColor = [UIColor blueColor].CGColor;
    scaleLayer.frame = CGRectMake(60, 20 + 64, 50, 50);
    scaleLayer.cornerRadius = 10;
    [self.view.layer addSublayer:scaleLayer];
    
    //CABasicAnimation
    /**
     *  1.keyPath 决定基础动画的类型 要改变位置就取position，要改变透明度就取opacity，要等比例缩放就取transform.scale
        rotation.x 、rotation.y、rotation.z  rotation、
        sacle.x sacle.y sacle.z sacle
        translation.x translation.y translation.z translation
     
       2.fromValue: 动画的起始状态值
        3.autoreverse: 当动画执行到toValue指定的状态时是从toValue的状态逆回去，还是直接跳到fromValue的状态再执行一遍
        4.fileMode: fillMode的作用就是决定当前对象过了非active时间段的行为. 非active时间段是指动画开始之前以及动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.
        5.timingFunction：速度控制函数，控制动画运行的节奏
     
     */
    //缩放
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//keyPath不能填错，有特定被选值
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.autoreverses = YES;
    
    scaleAnimation.fillMode = kCAFillModeRemoved;
    scaleAnimation.removedOnCompletion = NO;
    
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 0.8;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [scaleLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    
    
    //移动
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(200, 0)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(320 - 80, 300)];
    moveAnimation.autoreverses = YES;
    moveAnimation.repeatCount = MAXFLOAT;
    moveAnimation.duration = 2;
//    [scaleLayer addAnimation:moveAnimation forKey:@"position"];
    
    
    //旋转
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:6.0 * M_PI];
    rotateAnimation.autoreverses = NO;
    rotateAnimation.repeatCount = MAXFLOAT;
    rotateAnimation.duration = 5;
    rotateAnimation.delegate  = self;
    [scaleLayer addAnimation:rotateAnimation forKey:@"transform123"];
    
    
    //组合
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.duration = 2;
    groupAnnimation.autoreverses = YES;
    groupAnnimation.animations = @[moveAnimation, scaleAnimation, rotateAnimation];
    groupAnnimation.repeatCount = MAXFLOAT;
//    [scaleLayer addAnimation:groupAnnimation forKey:@"group456"];
    
    //路径 CAKeyframeAnimation
    CGRect boundingRect = CGRectMake(-150, -150, 300, 300);
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animation];
    orbit.keyPath = @"position";
    orbit.path = CFAutorelease(CGPathCreateWithEllipseInRect(boundingRect, NULL));
    orbit.duration = 4;
    orbit.additive = YES;
    orbit.repeatCount = HUGE_VALF;
    orbit.calculationMode = kCAAnimationPaced;
    orbit.rotationMode = kCAAnimationRotateAuto;
//    [scaleLayer addAnimation:orbit forKey:@"orbit"];

    //晃动
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.4;
    animation.additive = YES;
    animation.repeatCount = HUGE_VALF;
    animation.calculationMode = kCAAnimationPaced;
    animation.rotationMode = kCAAnimationRotateAuto;
//    [scaleLayer addAnimation:animation forKey:@"shake"];
    
}

#pragma mark  -  CAAnimationDelegate
//执行
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"===animationDidStart===%@",anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"===animationDidStop===%@",anim);
}


//点击view 暂停
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    isAnimtionPasued = !isAnimtionPasued;
    isAnimtionPasued?[self pauseLayer:scaleLayer]:[self resumeLayer:scaleLayer];
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    //让CALayer的时间停止走动
    layer.speed = 0.0;
    
    //让CALayer的时间停留在pausedTime这个时刻
    layer.timeOffset = pausedTime;
    NSLog(@"======pauseLayer=====");
}

-(void)resumeLayer:(CALayer*)layer
{
    NSLog(@"========resumeLayer========");
    CFTimeInterval pausedTime = layer.timeOffset;
//    1.让CALayer的时间继续行走:
    layer.speed = 1.0;
    
//    2.取消上次记录的停留时刻:
    layer.timeOffset = 0.0;
    
//    3.取消上次设置的时间:
    layer.beginTime = 0.0;
    
//    4.计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
    
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime()fromLayer:nil] - pausedTime;
    
//    5.设置相对于父坐标系的开始时间(往后退timeSincePause):
    layer.beginTime = timeSincePause;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

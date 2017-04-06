//
//  OpenCVViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/6/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "OpenCVViewController.h"
#import "TouchView.h"

@interface OpenCVViewController ()

@property (nonatomic, strong) UIView *localView;

@property (nonatomic,assign) CGPoint beginpoint;
@property (nonatomic, assign) BOOL isInView;

@end

@implementation OpenCVViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.view];
//    NSLog(@"touch.view===%@",touch.view);
//    _currentPoint = point;
//    
//    [super touchesBegan:touches withEvent:event];
//    
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint currentLocation = [touch locationInView:self.view];
//    
//    
//    self.nodeView.center = currentLocation;
//    NSLog(@"--------moved");
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if (!self.isInView)    // 仅当取到touch的view是小窗口时，我们才响应触控，否则直接return
//    {
//        return;
//    }
//    
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.localView];
    //偏移量
    float offsetX = currentPosition.x - _beginpoint.x;
    float offsetY = currentPosition.y - _beginpoint.y;
    //移动后的中心坐标
    self.localView.center = CGPointMake(self.localView.center.x + offsetX, self.localView.center.y + offsetY);
    
    //x轴左右极限坐标
    if (self.localView.center.x > (self.localView.superview.frame.size.width-self.localView.frame.size.width/2))
    {
        CGFloat x = self.localView.superview.frame.size.width-self.localView.frame.size.width/2;
        self.localView.center = CGPointMake(x, self.localView.center.y + offsetY);
    }
    else if (self.localView.center.x < self.localView.frame.size.width/2)
    {
        CGFloat x = self.localView.frame.size.width/2;
        self.localView.center = CGPointMake(x, self.localView.center.y + offsetY);
    }
    
    //y轴上下极限坐标
    if (self.localView.center.y > (self.localView.superview.frame.size.height-self.localView.frame.size.height/2))
    {
        CGFloat x = self.localView.center.x;
        CGFloat y = self.localView.superview.frame.size.height-self.localView.frame.size.height/2;
        self.localView.center = CGPointMake(x, y);
    }
    else if (self.localView.center.y <= self.localView.frame.size.height/2)
    {
        CGFloat x = self.localView.center.x;
        CGFloat y = self.localView.frame.size.height/2;
        self.localView.center = CGPointMake(x, y);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view.frame.size.width == 120)   // 120为小窗口的宽度（简单起见这里使用硬编码示例），用来判断触控范围;仅当取到touch的view是小窗口时，我们才响应触控
    {
        self.isInView = YES;
    }
    else
    {
        self.isInView = NO;
    }
    _beginpoint = [touch locationInView:self.localView];
    
    [super touchesBegan:touches withEvent:event];
}


@end

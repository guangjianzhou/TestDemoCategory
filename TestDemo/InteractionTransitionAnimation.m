//
//  InteractionTransitionAnimation.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/11.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "InteractionTransitionAnimation.h"

@interface InteractionTransitionAnimation ()

@property (assign, nonatomic) BOOL canReecive;
@property (strong, nonatomic) UIViewController *remVC;

@end

@implementation InteractionTransitionAnimation

- (void)writeToViewController:(UIViewController *)toVC
{
    self.remVC = toVC;
    [self addPanGestureRecognizer:toVC.view];
}

- (void)addPanGestureRecognizer:(UIView *)view
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
    [view addGestureRecognizer:pan];
}

- (void)panRecognizer:(UIPanGestureRecognizer *)pan
{
    CGPoint panPoint = [pan translationInView:pan.view.superview];
    //该方法返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint locationPoint = [pan locationInView:pan.view.superview];
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        self.isActing = YES;
        //======判断初始位置，在屏幕的上半段才能触发pop
        if (locationPoint.y <= self.remVC.view.bounds.size.height/2.0)
        {
            [self.remVC.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (locationPoint.y >= self.remVC.view.bounds.size.height/2.0)
        {
            self.canReecive = YES;
        }
        else
        {
            self.canReecive = NO;
        }
        [self updateInteractiveTransition:panPoint.y/self.remVC.view.bounds.size.height];
    }
    else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded)
    {
        self.isActing = NO;
        if (!self.canReecive || pan.state == UIGestureRecognizerStateCancelled)
        {
            [self cancelInteractiveTransition];
        }
        else
        {
            [self finishInteractiveTransition];
        }
    }
    
    
}


@end


//
//  PushTransition.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/11.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "PushTransition.h"

@implementation PushTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toVC];
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    toVC.view.frame = CGRectOffset(finalFrameForVC, 0, bounds.size.height);
    [[transitionContext containerView] addSubview:toVC.view];
    
    
    //自定义动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVC.view.alpha = 0.8;
                         toVC.view.frame = finalFrameForVC;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                         fromVC.view.alpha = 1.0;
                     }];
    
}



@end

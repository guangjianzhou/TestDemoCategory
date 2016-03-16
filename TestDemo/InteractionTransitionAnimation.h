//
//  InteractionTransitionAnimation.h
//  TestDemo
//
//  Created by guangjianzhou on 16/3/11.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractionTransitionAnimation : UIPercentDrivenInteractiveTransition


@property (nonatomic, assign) BOOL isActing;//判断动画是否正在进行

- (void)writeToViewController:(UIViewController *)toVC;//写入的二级VC


@end

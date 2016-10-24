


//
//  SonView.m
//  TestDemo
//
//  Created by ZGJ on 2016/10/19.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "SonView.h"

@implementation SonView




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan----SonView");
    UIResponder * next = [self nextResponder];
    NSMutableString * prefix = @"".mutableCopy;
    //让下一个view 继续执行
    [next touchesBegan:touches withEvent:event];
    
    while (next != nil) {
        NSLog(@"%@%@", prefix, [next class]);
        [prefix appendString: @"--"];
        next = [next nextResponder];
    }
}


//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return YES;
//}

@end

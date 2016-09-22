//
//  UIViewController+XMGExtension.m
//  03-Runtime-Method Swizzle
//
//  Created by xiaomage on 15/8/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation UIViewController (XMGExtension)
+ (void)load
{
    Method method1 = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod(self, @selector(xmg_dealloc));
    method_exchangeImplementations(method1, method2);
}

- (void)xmg_dealloc
{
    NSLog(@"%@ - xmg_dealloc", self);
    
    //换完之后，接着执行系统原先的方法
    [self xmg_dealloc];//(dealloc系统方法比较特殊)
}



@end

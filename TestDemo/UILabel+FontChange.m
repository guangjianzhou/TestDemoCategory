

//
//  UILabel+FontChange.m
//  TestDemo
//
//  Created by guangjianzhou on 16/5/16.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "UILabel+FontChange.h"
#import <objc/runtime.h>

#define CustomFontName @"HanWangKaiBold-Gb5"

@implementation UILabel (FontChange)



/**
 *  willMoveToSuperview :在一个子视图将要被添加到另一个视图的时候发送此消息
 */
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(willMoveToSuperview:);
        SEL swizzSel = @selector(mywillMoveToSuperview:);
        
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
    
}

- (void)mywillMoveToSuperview:(UIView *)newSuperview
{
    [self mywillMoveToSuperview:newSuperview];
    //    if ([self isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
    //        return;
    //    }
    if (self)
    {
        if (self.tag == 10086)
        {
            self.font = [UIFont systemFontOfSize:self.font.pointSize];
        }
        else
        {
            if ([UIFont fontNamesForFamilyName:CustomFontName])
                self.font  = [UIFont fontWithName:CustomFontName size:self.font.pointSize];
        }
    }
}

@end

//
//  UIView+MGO.h
//  TestDemo
//
//  Created by guangjianzhou on 16/5/17.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>


//storyboard 中看不出来效果，运行效果有
//但是创建一个空白MGOImageView继承UIImageView。
//MGOImageView.m文件什么也不干，就是等机会对接UIView(MGO)自定义属性
IB_DESIGNABLE
@interface UIView (MGO)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat defineValue;

@end

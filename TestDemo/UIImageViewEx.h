//
//  UIImageViewEx.h
//  TestDemo
//
//  Created by guangjianzhou on 16/3/25.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
    UIImageExNormal = 0,
    UIImageExFull
}UIImageExState;

@interface UIImageViewEx : UIImageView<UIGestureRecognizerDelegate>
{
    UIView *parentview;         //父窗口，即用将UIImageEx所加到的UIView
    
    BOOL isPanEnable;           //是否可以移动
    BOOL isPinchEnable;         //是否可以放大缩小
    BOOL isRotateEnable;        //是否可以旋转
    BOOL isTap;                 //是否可以点击触摸
    
    UIImageExState imageState;  //图片当前状态
    
    CGFloat imageScale;        //最大缩放的倍数
    CGFloat imageSize;         //记录图片的累计缩放
    CGFloat imageRotation;     //记录图片的原始角度
    CGPoint imagePoint;        //记录图片的原始位置
    
    UITextView *textView;      //动态弹出的文本
    
}

@property (nonatomic,retain) UIView *parentview;
@property (nonatomic) CGFloat imageSize;
@property (nonatomic) CGFloat imageRotation;
@property (nonatomic) CGPoint imagePoint;

@property  BOOL isPanEnable;
@property  BOOL isRotateEnable;
@property  BOOL isPinchEnable;
@property  BOOL isTap;

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer;
- (void)handleTap:(UITapGestureRecognizer *)recognizer;

//必须设置的
- (void)setScaleAndRotation:(UIView*)imageView;
- (void)setInfoText:(NSString *)string;
- (void)setShadow:(BOOL)isShadow;
@end



//
//  UIImageViewEx.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/25.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "UIImageViewEx.h"

@implementation UIImageViewEx
@synthesize parentview;
@synthesize isRotateEnable,isPanEnable,isPinchEnable,isTap;
@synthesize imageSize,imageRotation,imagePoint;

/*
 * SetScaleAndRotation 实现 ImageView的 手势旋转，缩放，和移动
 * @parent UIView 父窗口
 */
- (void)setScaleAndRotation:(UIView*) parent
{
    parentview=parent;
    parentview.userInteractionEnabled=YES;
    
    isPanEnable=YES;
    isPinchEnable=YES;
    isRotateEnable=YES;
    isTap = YES;
    
    imageSize=1;
    imageRotation=0;
    
    imageScale= self.parentview.frame.size.width/self.frame.size.width;
    imagePoint=self.frame.origin;
    self.userInteractionEnabled=YES;
    
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRcognize.delegate=self;
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    
    UIPinchGestureRecognizer *pinchRcognize=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [pinchRcognize setEnabled:YES];
    [pinchRcognize delaysTouchesEnded];
    [pinchRcognize cancelsTouchesInView];
    
    UIRotationGestureRecognizer *rotationRecognize=[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [rotationRecognize setEnabled:YES];
    [rotationRecognize delaysTouchesEnded];
    [rotationRecognize cancelsTouchesInView];
    rotationRecognize.delegate=self;
    pinchRcognize.delegate=self;
    
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tapRecognize.numberOfTapsRequired = 1;
    tapRecognize.delegate = self;
    [tapRecognize setEnabled :YES];
    [tapRecognize delaysTouchesBegan];
    [tapRecognize cancelsTouchesInView];
    
    [self addGestureRecognizer:rotationRecognize];
    [self addGestureRecognizer:panRcognize];
    [self addGestureRecognizer:pinchRcognize];
    [self addGestureRecognizer:tapRecognize];
    
}
/*
 * setInfoText 设置介绍文字
 * @string NSString 显示的文字
 */
- (void)setInfoText:(NSString *)string
{
    if (textView!=nil) {
        [textView removeFromSuperview];
        textView = nil;
    }
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 30)];
    textView.text = string;
    textView.hidden = YES;
    textView.backgroundColor = [UIColor blueColor];
    textView.textColor =[UIColor whiteColor];
    [self addSubview:textView];
}
/*
 *  SetShadow 设置是否开启阴影效果
 *  @isShadow BOOL  YES 开启，NO 关闭
 */
- (void)setShadow:(BOOL)isShadow
{
    if (!isShadow) {
        [[self layer] setShadowOffset:CGSizeMake(0, 0)];
        [[self layer] setShadowRadius:0];
        [[self layer] setShadowOpacity:1];
        [[self layer] setShadowColor:[UIColor whiteColor].CGColor];
        return;
    }
    [[self layer] setShadowOffset:CGSizeMake(3, 3)];
    [[self layer] setShadowRadius:3];
    [[self layer] setShadowOpacity:0.5];
    [[self layer] setShadowColor:[UIColor blackColor].CGColor];
}

#pragma UIGestureRecognizer Handles
/*
 *  移动图片处理的函数
 *  @recognizer 移动手势
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    if (!isPanEnable) {
        return;
    }
    [self setShadow:YES];
    CGPoint translation = [recognizer translationInView:parentview];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:parentview];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center=CGPointMake(imagePoint.x+self.frame.size.width/2, imagePoint.y+self.frame.size.height/2);
        } completion:nil];
        
        [self setShadow:NO];
        
    }
    
}
/*
 * handPinch 缩放的函数
 * @recognizer UIPinchGestureRecognizer 手势识别器
 */
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    if (!isPinchEnable) {
        return;
    }
    imageSize*=recognizer.scale;
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:.35 animations:^{
            if (imageSize >=1 && imageState == UIImageExNormal) {
                recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform,imageScale/imageSize, imageScale/imageSize);
                imageState = UIImageExFull;
            }
            else if(imageSize<1 && imageState == UIImageExFull)
            {
                recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, 1/(imageScale*imageSize), 1/(imageScale*imageSize));
                imageState = UIImageExNormal;
            }else {
                recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, 1/imageSize,1/imageSize);
            }
            
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                recognizer.view.center=CGPointMake(imagePoint.x+self.frame.size.width/2, imagePoint.y+self.frame.size.height/2);
            } completion:nil];
//            recognizer.scale = 1;
//            imageSize = 1;
        }];
        
    }
    recognizer.scale = 1;
    
}

/*
 * handleRotate 旋转的函数
 * recognizer UIRotationGestureRecognizer 手势识别器
 */
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer{
    if (!isRotateEnable) {
        return;
    }
    imageRotation+=recognizer.rotation;
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:.35 animations:^{
            recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, -imageRotation);
            recognizer.view.center=CGPointMake(imagePoint.x+self.frame.size.width/2, imagePoint.y+self.frame.size.height/2);
        }];
        
//        imageRotation=0;
    }
    recognizer.rotation = 0;
}

/*
 *  handleTap 触摸函数
 *  @recognizer  UITapGestureRecognizer 触摸识别器
 */
-(void) handleTap:(UITapGestureRecognizer *)recognizer
{
    if (!isTap) {
        return;
    }
    if (textView.hidden) {
        [UIView animateWithDuration:0.35 delay:0.15 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            textView.hidden = NO;
            textView.frame = CGRectMake(0, 0, 120, 30);
        } completion:nil];
    }else {
        [UIView animateWithDuration:0.35 delay:0.15 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            
            textView.frame = CGRectMake(0, 0, 0, 30);
        } completion:^(BOOL finished){
            if (finished){
                textView.hidden = YES;
            }
        }];
    }
    
}


#pragma UIGestureRecognizerDelegate
/*
 *  gestureRecognizer 实现了委托，从而实现可以同时接受多个手势
 *  @return  YES 则可以接受多个手势，NO 则同时只能接受一个手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}  


@end

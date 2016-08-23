


//
//  CgView.m
//  TestDemo
//
//  Created by ZGJ on 16/8/10.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CgView.h"

@implementation CgView


/**
 *  路径 Path
 *  阴影  shandow
 *  笔画 stroke
    剪裁路径 clip Path
    线条粗细 Line Width
    混合模式 Blend Mode
    填充色 Fill color
    当前形变矩阵 CurrentDash
    线条图案 Line Dash
 
 //图形上下文获得方法
 //    重写UIView的drawRect方法，在该方法里便可得到context；
 //    调用UIGraphicsBeginImageContextWithOptions方法得到context；

 
 drawRect方法什么时候触发:
 1.当view第一次显示到屏幕上时；
 2.当调用view的setNeedsDisplay或者setNeedsDisplayInRect:方法时。

 
 步骤：
 
 1.先在drawRect方法中获得上下文context；
 2.绘制图形（线，图形，图片等）；
 3.设置一些修饰属性；
 4.渲染到上下文，完成绘图。

 
 */
- (void)drawRect:(CGRect)rect {
    UIBezierPath *apath = [UIBezierPath bezierPathWithRect:CGRectMake(20, 20, 50, 50)];
    apath.lineWidth = 8;
    apath.lineCapStyle = kCGLineCapRound;
    apath.lineJoinStyle = kCGLineCapRound;
    [[UIColor redColor] set];
    [apath stroke];//渲染 完成绘制
    
    
    //1,
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    //2.创建一个图片类型的上下文
    

}



@end

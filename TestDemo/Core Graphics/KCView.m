



//
//  KVView.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/20.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "KCView.h"

@implementation KCView
- (void)drawRect:(CGRect)rect
{
    CGContextRef context1 = UIGraphicsGetCurrentContext();
//    [self drawCurve:context1];
//    [self drawText:context1];
    [self drawImage1:context1];
//    [self drawLinearGradient:context1];
//    [self drawRadialGradient:context1];
    
    
//    [self drawLine2];
    return;
    
    
    //1.取得图形上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //2.创建路径对象
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 20, 50);
    CGPathAddLineToPoint(path, nil, 20, 100);
    CGPathAddLineToPoint(path, nil, 300, 100);
    
    //3.添加路径到图形上下文
    CGContextAddPath(context, path);
    
    
    //4.设置图形上下文状态属性
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1); //设置笔触颜色
    CGContextSetRGBFillColor(context, 0, 1, 0, 1);//设置填充色
    CGContextSetLineWidth(context, 2.0);//设置线条宽度
    CGContextSetLineCap(context, kCGLineCapRound);//设置顶点样式,（20,50）和（300,100）是顶点
    CGContextSetLineJoin(context, kCGLineJoinRound);//设置连接点样式
    
    /**
     *  设置线段样式
     phase:虚线开始位置
     lengths:虚线长度间隔 （例如下面的定义说明第一条线段长度8，然后间隔3重新绘制8点的长度线段，当然这个数组可以定义更多元素）
     count:虚线数组元素个数
     */
    
    CGFloat lengths[2] = {18, 9};
    CGContextSetLineDash(context, 0, lengths, 2);
    
    /**
     *  设置阴影
     context:图形上下文
     offset:偏移量
     blur:模糊度
     color:阴影颜色
     */
    CGColorRef color = [UIColor grayColor].CGColor;
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 0.8, color);
    
    
    //5.绘制图像到指定图形上下文
    /**
     *  CGPathDeawingMode 是填充方式，枚举类型
     KCGPathFill: 只有填充(非零缠绕数填充),不绘制边框
     KCGPathEoFill:奇偶规则填充(多条路径交叉时，奇数交叉填充，偶交叉不填充)
     KCGPathStroke:只有边框
     KCGPathFillStroke:既有边框又有填充
     KCGPathEoFillStroke:奇偶填充并绘制边框
     */
    
    CGContextDrawPath(context, kCGPathEOFillStroke);//最后一个参数是填充类型
    
    //6.释放对象
    CGPathRelease(path);
}


- (void)drawLine2
{
    //1. 获得图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.绘制路径
    CGContextMoveToPoint(context, 20, 50);
    CGContextAddLineToPoint(context, 20, 100);
    CGContextAddLineToPoint(context, 300, 100);
    CGContextClosePath(context);
    
    //3.设置图形上下文属性
    [[UIColor redColor] setStroke];
    [[UIColor greenColor] setFill];
    
    //4.绘制路径
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
}

//绘制贝塞尔曲线
- (void)drawCurve:(CGContextRef)context
{
    CGContextMoveToPoint(context, 20, 100);//移到起始位置
    /**
     *  绘制二次贝塞尔曲线(1个start Point、1个end Point、1个Control point)
     c:图形上下文
     cpx:控制点x坐标
     cpy:控制点y坐标
     x:结束x坐标
     y:结束y坐标
     */
    
    CGContextAddCurveToPoint(context, 80, 300, 240, 500, 300, 300);
    
    //设置图形上下文
    [[UIColor yellowColor] setFill];
    [[UIColor redColor] setStroke];
    
    //绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

- (void)drawText:(CGContextRef)context
{
    NSString *str = @"涉及到合肥驾驶的反馈就卡萨丁金佛数据库的南方开我我就认购我卡死你地方看见爱上对方";
    CGRect rect = CGRectMake(20, 50, 280, 300);
    UIFont *font = [UIFont systemFontOfSize:18];
    UIColor *color = [UIColor redColor];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSTextAlignment align = NSTextAlignmentLeft;
    style.alignment = align;
    [str drawInRect:rect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:style}];
}

- (void)drawImage:(CGContextRef)context
{
    UIImage *image = [UIImage imageNamed:@"share"];
    [image drawAtPoint:CGPointMake(10, 50)];
}

#pragma mark 线性渐变
-(void)drawLinearGradient:(CGContextRef)context{
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    /*绘制线性渐变
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
     */
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(320, 300), kCGGradientDrawsAfterEndLocation);
    
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

#pragma mark 径向渐变
-(void)drawRadialGradient:(CGContextRef)context{
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    /*绘制径向渐变
     context:图形上下文
     gradient:渐变色
     startCenter:起始点位置
     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
     endCenter:终点位置（通常和起始点相同，否则会有偏移）
     endRadius:终点半径（也就是渐变的扩散长度）
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    CGContextDrawRadialGradient(context, gradient, CGPointMake(160, 284),0, CGPointMake(165, 289), 150, kCGGradientDrawsAfterEndLocation);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

-(void)drawImage1:(CGContextRef)context
{
    //保存初始状态
    CGContextSaveGState(context);
    
    //形变第一步：图形上下文向右平移40
    CGContextTranslateCTM(context, 100, 0);
    
    //形变第二步：缩放0.8
    CGContextScaleCTM(context, 0.2, 0.2);
    
    //形变第三步：旋转
    CGContextRotateCTM(context, M_PI_4/4);
    
    UIImage *image=[UIImage imageNamed:@"share"];
    [image drawInRect:CGRectMake(0, 50, 240, 300)];
    
    
    //恢复到初始状态
    CGContextRestoreGState(context);
}

#pragma mark 利用位图上下文添加水印效果
-(UIImage *)drawImageAtImageContext{
    //获得一个位图图形上下文
    CGSize size=CGSizeMake(300, 188);//画布大小
    UIGraphicsBeginImageContext(size);
    
    UIImage *image=[UIImage imageNamed:@"share.png"];
    [image drawInRect:CGRectMake(0, 0, 300, 188)];//注意绘图的位置是相对于画布顶点而言，不是屏幕
    
    
    //添加水印
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 200, 178);
    CGContextAddLineToPoint(context, 270, 178);
    
    [[UIColor redColor]setStroke];
    CGContextSetLineWidth(context, 2);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    NSString *str=@"Kenshin Cui";
    [str drawInRect:CGRectMake(200, 158, 100, 30) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Marker Felt" size:15],NSForegroundColorAttributeName:[UIColor redColor]}];
    
    //返回绘制的新图形
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    //最后一定不要忘记关闭对应的上下文
    UIGraphicsEndImageContext();
    
    //保存图片
    //    NSData *data= UIImagePNGRepresentation(newImage);
    //    [data writeToFile:@"/Users/kenshincui/Desktop/myPic.png" atomically:YES];
    
    return newImage;
}


@end

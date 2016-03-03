



//
//  CoreGraphicsView.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/2.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CoreGraphicsView.h"

@implementation CoreGraphicsView

//绘制矩形
- (void)drawRectangle
{
    CGRect rectangle = CGRectMake(0, 0, 100, 25);
    //图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //路径
    CGContextAddRect(ctx, rectangle);
    //填充色
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    //绘制当前路径区域
    CGContextFillPath(ctx);
}

//绘制椭圆
- (void)drawEllipse
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rectangle = CGRectMake(0,30,300,60);
    CGContextAddEllipseInRect(ctx,rectangle);
    CGContextSetFillColorWithColor(ctx,[UIColor orangeColor].CGColor);
    CGContextFillPath(ctx);
}

// 绘制三角形
- (void)drawTriangle {
    
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    
    /**
     *  @brief 在指定点开始一个新的子路径 参数按顺序说明
     *
     *  @param c 当前图形
     *  @param x 指定点的x坐标值
     *  @param y 指定点的y坐标值
     *
     */
    CGContextMoveToPoint(ctx, 160, 220);
    
    /**
     *  @brief 在当前点追加直线段，参数说明与上面一样
     */
    CGContextAddLineToPoint(ctx, 190, 260);
    CGContextAddLineToPoint(ctx, 130, 260);
    
    // 关闭并终止当前路径的子路径，并在当前点和子路径的起点之间追加一条线
    CGContextClosePath(ctx);
    
    // 设置当前视图填充色
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    
    // 绘制当前路径区域
    CGContextFillPath(ctx);
}

- (void)drawCurve {
    
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    
    /**
     *  @brief 在指定点开始一个新的子路径 参数按顺序说明
     *
     *  @param c 当前图形
     *  @param x 指定点的x坐标值
     *  @param y 指定点的y坐标值
     *
     */
    CGContextMoveToPoint(ctx, 160, 100);
    
    /**
     *  @brief 在指定点追加二次贝塞尔曲线，通过控制点和结束点指定曲线。
     *         关于曲线的点的控制见下图说明，图片来源苹果官方网站。参数按顺序说明
     *  @param c   当前图形
     *  @param cpx 曲线控制点的x坐标
     *  @param cpy 曲线控制点的y坐标
     *  @param x   指定点的x坐标值
     *  @param y   指定点的y坐标值
     *
     */
    CGContextAddQuadCurveToPoint(ctx, 160, 50, 190, 50);
    
    // 设置图形的线宽
    CGContextSetLineWidth(ctx, 20);
    
    // 设置图形描边颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor brownColor].CGColor);
    
    // 根据当前路径，宽度及颜色绘制线
    CGContextStrokePath(ctx);
}


/**
 *  路径 path
 *  阴影 shadow
 *  笔画 stroke
 *  剪裁路径 Clip Path
 *  先调粗细 Line Width
 *  混合模式 Blend Mode
 *  填充色 Fill Color
 *  当前形变矩阵 Current Transform Matrix
 *  线条图案 Line Dash
 */
- (void)drawRect:(CGRect)rect
{
    /*
    [self drawRectangle];
    [self drawEllipse];
    [self drawTriangle];
    [self drawCurve];
    [self drawText];
    [self drawImage];
    [self drawLines];
    [self drawDiagonalLine];
    [self drawShadow];
    [self drawRectAtBottomOfScreen];
    [self drawGradient];
     */
    [self CGATransformMake];
}

- (void)drawText
{
    UIColor *magentColor = [UIColor colorWithRed:0.5 green:0 blue:0.5 alpha:1];
    [magentColor set];
    //如果宽度不够 自动折行显示
    NSString *myString = @"哈哈束带结发刷卡的缴费就开始打";
//    [myString drawAtPoint:CGPointMake(40,180) withFont:[UIFont systemFontOfSize:16]];
    [myString drawInRect:CGRectMake(40, 180, 80, 140) withAttributes:nil];
    
    //获取 CGColorGetNumberOfComponents 函数来确定组成该颜色的颜色分量数量
    CGColorRef colorRef = [magentColor CGColor];
    const CGFloat *components = CGColorGetComponents(colorRef);
    NSUInteger componentsCount = CGColorGetNumberOfComponents(colorRef);
    NSUInteger counter = 0;
    for (counter = 0; counter < componentsCount; counter++) {
        NSLog(@"Component %lu = %.02f", (unsigned long)counter + 1, components[counter]);
    }
}

- (void)drawImage
{
    UIImage *image = [UIImage imageNamed:@"share.png"];
    [image drawAtPoint:CGPointMake(0,20)];
    [image drawInRect:CGRectMake(100,120,40,40)];
}

- (void)drawLines
{
    [[UIColor redColor] set];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext,5.f);
    CGContextMoveToPoint(currentContext,50,50);
    CGContextAddLineToPoint(currentContext,100,100);
    CGContextAddLineToPoint(currentContext,300,100);
    CGContextSetLineJoin(currentContext,kCGLineJoinRound);
    CGContextStrokePath(currentContext);
}

- (void)drawShadow
{
    CGContextRef currentontext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentontext);
    CGContextSetShadowWithColor(currentontext, CGSizeMake(10, 10.f), 20.f, [UIColor blueColor].CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect firstRect = CGRectMake(55, 60, 150, 150);
    CGPathAddRect(path, NULL, firstRect);
    CGContextAddPath(currentontext, path);
    [[UIColor colorWithRed:0.2 green:0.6 blue:0.8f alpha:1.f] setFill];
    CGContextDrawPath(currentontext, kCGPathFill);
    CGPathRelease(path);
    CGContextRestoreGState(currentontext);
}


/**
 *  保存和恢复图形上下文并不只限于阴影
 */
- (void) drawRectAtBottomOfScreen{
    /* Get the handle to the current context */
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGMutablePathRef secondPath = CGPathCreateMutable();
    CGRect secondRect = CGRectMake(150.0f, 250.0f, 100.0f, 100.0f);
    CGPathAddRect(secondPath, NULL, secondRect);
    CGContextAddPath(currentContext, secondPath);
    [[UIColor purpleColor] setFill];
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(secondPath);
}

//创建和绘制渐变
- (void)drawGradient
{
    /**
     *  句柄
     *  @param space#>      色彩空间 description#>
     *  @param components#> 颜色分量 description#>
     *  @param locations#>  位置数组 description#>
     *  @param count#>      位置数组的元素数量 description#>
     *
     */
//    CGGradientCreateWithColorComponents(<#CGColorSpaceRef  _Nullable space#>, <#const CGFloat * _Nullable components#>, <#const CGFloat * _Nullable locations#>, <#size_t count#>)
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor *startColor = [UIColor blueColor];
    CGFloat *startColorComponents = (CGFloat *)CGColorGetComponents([startColor CGColor]);
    UIColor *endColor = [UIColor greenColor];
    CGFloat *endColorComponents = (CGFloat *)CGColorGetComponents([endColor CGColor]);
    CGFloat colorComponents[8] = {startColorComponents[0],startColorComponents[1],startColorComponents[2],startColorComponents[3],endColorComponents[0],endColorComponents[1],endColorComponents[2],endColorComponents[3]};
    CGFloat colorIndices[2] = {0.0f,1.0f};
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpace, (const CGFloat *) &colorComponents, (const CGFloat *)&colorIndices, 2);
    CGColorSpaceRelease(colorSpace);
    
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGRect screentBounds = [[UIScreen mainScreen] bounds];
    CGPoint startPoint,endPoint;
//    startPoint = CGPointMake(0.0f, screentBounds.size.height/2);
//    endPoint = CGPointMake(screentBounds.size.width, startPoint.y);
    startPoint = CGPointMake(120, 260);
    endPoint = CGPointMake(200.0f, 220);
    CGContextDrawLinearGradient(currentContext, gradientRef, startPoint, endPoint, 0);
    CGGradientRelease(gradientRef);
    CGContextRelease(currentContext);
}


- (void)drawDiagonalLine
{
    [[UIColor redColor] set];
}

//仿射变换:旋转图形和缩放图形
- (void)CGATransformMake
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rectAnge = CGRectMake(10, 10, 200, 300);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(100, 0);
    CGPathAddRect(path, &transform, rectAnge);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(currentContext, path);
    [[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1.f] setFill];
    [[UIColor brownColor] setStroke];
    CGContextSetLineWidth(currentContext, 5.0f);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}

@end

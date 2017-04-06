//
//  CALayerViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/10/13.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#define WIDTH 50
#define PHOTO_HEIGHT 150


#import "CALayerViewController.h"
#import "KCView1.h"

@interface CALayerViewController ()<CALayerDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIView *anchorView;


@end

@implementation CALayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBezier];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.anchorView.layer.anchorPoint = CGPointZero;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 anchorPoint 默认是(0.5,0.5)
 */
- (void)drawLayer{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    CALayer *layer = [[CALayer alloc] init];
    layer.backgroundColor = [UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1].CGColor;
    layer.position = CGPointMake(size.width/2.0, size.height/2.0);
    layer.bounds = CGRectMake(0, 0, 50, 50);
    
    //设置圆角
    layer.cornerRadius = WIDTH/2;
    
    //设置阴影
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowOpacity = 0.9;
    
    //设置边框
    layer.borderColor = [UIColor redColor].CGColor;
    layer.borderWidth = 2;
    
    //设置锚点
//    layer.anchorPoint = CGPointZero;
    
    
    
    
    [self.view.layer addSublayer:layer];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CALayer *layer = [self.view.layer.sublayers firstObject];
    CGFloat width = layer.bounds.size.width;
    if (width == WIDTH) {
        width = WIDTH * 4;
    }else{
        width = WIDTH ;
    }
    
    layer.bounds = CGRectMake(0, 0, width, width);
    layer.position = [touch locationInView:self.view];
    layer.cornerRadius = width/2;
    
}

/*************************************************************************************************************************/
/*
 图层绘图有两种方法，不管使用哪种方法绘制完必须调用图层的setNeedDisplay方法（注意是图层的方法，不是UIView的方法，前面我们介绍过UIView也有此方法）
 1.通过图层代理drawLayer: inContext:方法绘制
 2.通过自定义图层drawInContext:方法绘制
 */
- (void)drawLayer2{
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    layer.position = CGPointMake(160, 200);
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.cornerRadius = PHOTO_HEIGHT/2;
    //注意仅仅设置圆角，对图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
    layer.masksToBounds = YES;
    
    //阴影效果无法和maskToBounds同时使用
//    layer.shadowColor = [UIColor grayColor].CGColor;
//    layer.shadowOffset = CGSizeMake(2, 2);
//    layer.shadowOpacity = 0.9;
    
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 2;
    
    //设置代理CALayerDelegate
    layer.delegate = self;
    
    [self.view.layer addSublayer:layer];
    
    //调用图层setNeedDisplay,否则代理方法不会被执行
    [layer setNeedsDisplay];
}

#pragma mark - CALayerDelegate 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
//需要注意的是上面代码中绘制图片圆形裁切效果时如果不设置masksToBounds是无法显示圆形，但是对于其他图形却没有这个限制。
//原因就是当绘制一张图片到图层上的时候会重新创建一个图层添加到当前图层，这样一来如果设置了圆角之后虽然底图层有圆角效果，但是子图层还是矩形，只有设置了masksToBounds为YES让子图层按底图层剪切才能显示圆角效果
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//    //这个图层是上面的layer2图层
//    CGContextSaveGState(ctx);
//    
//    //图形上下文形变，解决图片倒立问题
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
//    
//    UIImage *image = [UIImage imageNamed:@"timg.jpeg"];
//    //注意这个位置是相对于图层而言的不是屏幕
//    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
//    
////    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
////    CGContextDrawPath(ctx, kCGPathFillStroke);
//    
//    CGContextRestoreGState(ctx);
//}


/*************************************************************************************************************************/
//1.如果设置了masksToBounds=YES之后确实可以显示图片圆角效果，但遗憾的是设置了这个属性之后就无法设置阴影效果。因为masksToBounds=YES就意味着外边框不能显示，而阴影恰恰作为外边框绘制的，这样两个设置就产生了矛盾。解决这个问题不妨换个思路:使用两个大小一样的图层，下面的图层负责绘制阴影，上面的图层用来显示图片。

//2.transform
- (void)drawLayer3
{
    CGPoint position = CGPointMake(160, 200);
    CGRect bounds = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    CGFloat cornerRadius = PHOTO_HEIGHT/2;
    CGFloat borderWidth = 2;
    
    //阴影图层
    CALayer *layerShadow = [[CALayer alloc] init];
    layerShadow.bounds = bounds;
    layerShadow.position = position;
    layerShadow.cornerRadius = cornerRadius;
    layerShadow.shadowColor = [UIColor darkGrayColor].CGColor;
    layerShadow.shadowOffset = CGSizeMake(2, 1);
    layerShadow.shadowOpacity = 1;
    layerShadow.borderColor = [UIColor whiteColor].CGColor;
    layerShadow.borderWidth = borderWidth;
    [self.view.layer addSublayer:layerShadow];
    
    
    //容器图层
    CALayer *layer=[[CALayer alloc]init];
    layer.bounds=bounds;
    layer.position=position;
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.cornerRadius=cornerRadius;
    layer.masksToBounds=YES;
    layer.borderColor=[UIColor whiteColor].CGColor;
    layer.borderWidth=borderWidth;
    
    //利用图层形变解决图像倒立问题
    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    layer.delegate = self;
    
    [self.view.layer addSublayer:layer];
    [layer setNeedsDisplay];
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
    UIImage *image=[UIImage imageNamed:@"timg.jpeg"];
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
}


/*******************通过自定义图层drawInContext:方法绘制*****************************************************************************************************/
- (void)drawLayer4{
    KCView1 *view=[[KCView1 alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
    
    
    [self.view addSubview:view];
}


/*****************************************************************************************************/

/*
CAAnimation 核心动画的基础类 不能直接使用,负责动画运行时间、速度的控制 本身实现了CAMediaTiming协议
CAPropertyAnimation
 
 CAAnimationGroup:动画组
 CATransition 专场动画
 CABaseAnimation 基础动画
 
 CAKeyframeAnimation 关键帧动画
 */


#pragma mark - UIBezierPath
/*
 UIBezierPath 创建椭圆或矩形，或者有多个直线和曲线段组成的形状
 */
- (void)drawBezier
{
    
}




@end

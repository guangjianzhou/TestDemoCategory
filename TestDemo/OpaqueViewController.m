//
//  OpaqueViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/5/17.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "OpaqueViewController.h"
//模糊效果(渲染很耗费时间，建议在子线程中渲染)
#import "UIImage+ImageEffects.h"



@interface OpaqueViewController ()

@end

@implementation OpaqueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"12.jpg"];
    
    /**
       1. CoreImage
     */
    
//    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
//    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    //将图片输入到滤镜中
//    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
//    NSLog(@"%@",[blurFilter attributes]);
//    //模糊程度
//    [blurFilter setValue:@(10) forKey:@"inputRadius"];
//    
//    //将处理好的图片输出
//    CIImage *outImage = [blurFilter valueForKey:kCIOutputImageKey];
//    
//    //CIContext 默认是cpu 渲染，也可采用Gpu
//    CIContext *context = [CIContext contextWithOptions:nil];
//    
//    //获取CGImage句柄
//    CGImageRef outCGImage = [context createCGImage:outImage fromRect:[outImage extent]];
//    
//    //最终获取到图片
//    UIImage *blueImage = [UIImage imageWithCGImage:outCGImage];
//    //释放CGImage句柄
//    CGImageRelease(outCGImage);
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
//    imageView.image = [self coreBlurImage:image withBlurNumber:10];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    
    
    /**
     *2. UIImage+ImageEffects的category 模糊效果
     */
    UIImage *sourceImage = [UIImage imageNamed:@"normal.png"];
    UIImage *blurImage = [sourceImage blurImage];
//    imageView.image = blurImage;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"模糊偏上文字" forState:UIControlStateNormal];
    [imageView addSubview:btn];
    
    
    /**
     *3. UIVisualEffectView
     */
    imageView.image = sourceImage;
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.frame = CGRectMake(0, 100, 320, 200);
    [self.view addSubview:effectView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:effectView.bounds];
    label.text = @"测试乐乐";
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
//    [effectView addSubview:label];
    
    //添加模糊子view的UIVisualEffectView
    //子view的effectForBlurEffect 和父view 相同
    UIVisualEffectView *subEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)effectView.effect]];
    subEffectView.frame = effectView.bounds;
    //2 将子模糊view添加到effectview的
    [effectView.contentView addSubview:subEffectView];
    
    //3.不应该直接添加子视图到UIVisualEffectView视图中，而是应该添加到UIVisualEffectView对象的contentView中。
    [subEffectView.contentView addSubview:label];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark  - 高斯CoreImage
- (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}


@end

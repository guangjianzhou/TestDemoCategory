//
//  CoreGraphicsViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/2.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CoreGraphicsViewController.h"
#import "CoreGraphicsView.h"
#import <Masonry.h>
#import "KCView.h"
@interface CoreGraphicsViewController ()
{
    CoreGraphicsView *cgView;
    KCView *view;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation CoreGraphicsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    const char *className = object_getClassName(self);
    NSLog(@"className:%@",[NSString stringWithUTF8String:className]);
    
    NSString *name =  NSStringFromClass([self class]);
    NSLog(@"=====name %@===",name);
    
    _imageView.layer.cornerRadius = 40/2;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.imageView.layer addAnimation:[self groupAnimationtoPoint:CGPointMake(320 / 2, 193) fromScale:@(4 / 9.f) toScale:@(1)] forKey:@"animationGroup"];
    });
}

- (CAAnimationGroup *)groupAnimationtoPoint:(CGPoint)center fromScale:(NSNumber *)fromValue toScale:(NSNumber *)toValue
{
    CABasicAnimation *rotationAnimation = [self moveAnimation:self.imageView.layer toPoint:center];
    CABasicAnimation *scaleAnimation = [self scaleAnimation:self.imageView.layer fromScale:fromValue toScale:toValue];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    animationGroup.duration = 2;
    animationGroup.autoreverses = NO;   //是否重播，原动画的倒播
    animationGroup.repeatCount = 0; //HUGE_VALF;     //HUGE_VALF,源自math.h
    [animationGroup setAnimations:[NSArray arrayWithObjects:rotationAnimation, scaleAnimation, nil]];
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    return animationGroup;
}

- (CABasicAnimation *)moveAnimation:(CALayer *)logoLayer toPoint:(CGPoint)center
{
    //位置移动
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.fromValue =  [NSValue valueWithCGPoint:logoLayer.position];
    animation.duration = 2;
    animation.toValue = [NSValue valueWithCGPoint:center];
    return animation;
}

- (CABasicAnimation *)scaleAnimation:(CALayer *)layer fromScale:(NSNumber *)fromValue toScale:(NSNumber *)toscale
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.duration = 2;
    scaleAnimation.fromValue = fromValue;
    scaleAnimation.toValue = toscale;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return scaleAnimation;
}


/**
 *  快速、高效，减小应用的文件大小。同时可以自由地使用动态的、高质量的图形图像。 使用Core Graphics，可以创建直线、路径、渐变、文字与图像等内容，并可以做变形处理。
 */

- (void)setUp
{
//    cgView  = [[CoreGraphicsView alloc] initWithFrame:CGRectMake(0, 64, 320, 300)];
    view = [[KCView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@300);
        
    }];
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img01.bqstatic.com/upload/activity/activity_v4_20575_1452217080_block.jpg@90Q"]];
//    UIImage *image = [UIImage imageWithData:data];
//    imageView.image = image;
//    [self.view addSubview:imageView];
}

- (IBAction)presnetVC:(UIButton *)sender
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NSTimerViewController"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

//
//  UIDynamic1ViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/1/25.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "UIDynamic1ViewController.h"

@interface UIDynamic1ViewController ()<UIDynamicAnimatorDelegate>
{
    UIDynamicAnimator *animitor;
}

@property (weak, nonatomic) IBOutlet UIView *graviView;

@property (weak, nonatomic) IBOutlet UIView *graView2;


@end

@implementation UIDynamic1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self setUp];
    });
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:@{@"name":@"zgj"}];
        
        UIViewController *vc1 = weakSelf.presentingViewController;
        UIViewController *vc2 = weakSelf.presentedViewController;
        NSLog(@"===VC1 = %@====,vc2 =%@",vc1,vc2);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  UIAttachmentBehavior (吸附) 描述一个视图与描点或另一个视图相连接的情况
 *  UIPushBehavior(推动)
 *  UIGravityBehavior(重力)
 *  UICollisionBehavior(碰撞)
 *  UISnapBehavior(捕捉)
 *
 */

- (void)setUp
{
    
    
    /**
     bounds:用以计算物体的边界以及重量
     center:动力学元素的中心点
     transform:动力学元素的旋转角度
     
    
     */
//    animitor = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//    [_graviView setTransform:CGAffineTransformMakeRotation(45)];
//    
//    
//    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[_graviView,_graView2]];
//    [animitor addBehavior:gravity];
//
    // 1. 实例化一个animator
     animitor = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    // 2. 实例化一个重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[_graviView,_graView2]];
    
    // 3. 将重力行为添加到animator
    [animitor addBehavior:gravity];
    
    
    // 4. 碰撞检测行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[_graviView,_graView2]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    animitor.delegate = self;
    [animitor addBehavior:collision];
    
    //吸附行为
//    UIAttachmentBehaviorTypeItems,
//    UIAttachmentBehaviorTypeAnchor
    
    //length 距离连接描点的距离

}
- (IBAction)presentVC:(UIButton *)sender
{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIDynamicAnimatorDelegate
- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    NSLog(@"pause _graviVieW.frame = %@",_graviView);
}

@end

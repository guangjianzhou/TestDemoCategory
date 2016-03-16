




//
//  TransferAnimationViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/11.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "TransferAnimationViewController.h"
#import "TestTransferViewController.h"
#import "PushTransition.h"
#import "InteractionTransitionAnimation.h"
#import "TransferView.h"

@interface TransferAnimationViewController ()<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,UIViewControllerInteractiveTransitioning,UIViewControllerContextTransitioning,UIViewControllerTransitionCoordinator>

@property (strong, nonatomic) InteractionTransitionAnimation *popInteraction;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet TransferView *topView;

@end

@implementation TransferAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    _popInteraction = [[InteractionTransitionAnimation alloc] init];
    
    
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    keyboardView.backgroundColor = [UIColor redColor];
//    self.textField.inputAccessoryView = keyboardView;
    
//    self.textView.inputAccessoryView = keyboardView;
    
    
    _topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [_topView addGestureRecognizer:tap];
    
    
    
}


- (void)tap:(UITapGestureRecognizer *)tap
{
    NSLog(@"j]==============");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.view addGestureRecognizer:ges];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"keyboardWillShow=======%@",notification.userInfo);
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"keyboardWillHide=======%@",notification.userInfo);
}


- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    
}


- (IBAction)pushAction:(UIButton *)sender
{
    TestTransferViewController *contrl1 = [self.storyboard instantiateViewControllerWithIdentifier:@"TestTransferViewController"];
    contrl1.view.backgroundColor = [UIColor yellowColor];
    
    
    [self.popInteraction writeToViewController:contrl1];
    [self.navigationController pushViewController:contrl1 animated:YES];
}


- (IBAction)presentAction:(UIButton *)sender
{
    
    TestTransferViewController *contrl1 = [self.storyboard instantiateViewControllerWithIdentifier:@"TestTransferViewController"];
    contrl1.view.backgroundColor = [UIColor orangeColor];
    
    
    [self presentViewController:contrl1 animated:YES completion:^{
        
    }];
}

#pragma makr - 转场协议

#pragma mark UIViewControllerAnimationedTransitioning  //负责实际执行动画  动画控制器  最重要 由我们实现
//- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
//
//- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
//
//- (void)animationEnded:(BOOL) transitionCompleted;


#pragma mark UIViewControllerInteractiveTransitioning  //控制可交互式的转场 交互控制器

#pragma mark Transitioning Delegates //转场代理


#pragma mark UIViewControllerContextTransitioning 转场上下文

#pragma mark UIViewControllerTransitionCoordinator 转场协调器


- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return _popInteraction.isActing?self.popInteraction:nil;
    
}


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    if(operation == UINavigationControllerOperationPush)
    {
        
        return [[PushTransition alloc] init];
    }
    else
    {
        return [[PushTransition alloc] init];
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

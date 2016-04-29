//
//  PopCustomView.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/27.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "PopCustomView.h"
#import <Masonry.h>

@interface PopCustomView ()
{
    BOOL isShowed;
}

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *backGroudView;
@property (weak, nonatomic) IBOutlet UIView *alertView;


@end

@implementation PopCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"PopCustomView" owner:self options:nil];
        [self addSubview:self.contentView];
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"awake from nib");
    [[NSBundle mainBundle] loadNibNamed:@"PopCustomView" owner:self options:nil];
    [self addSubview:self.contentView];
    [self setUp];
}

- (void)setUp
{
    self.backGroudView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    __weak typeof(self) weakSelf = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView:)];
    ges.numberOfTapsRequired = 1;
    [self.backGroudView addGestureRecognizer:ges];
}

#pragma mark  - Hidden
- (void)hideView:(UITapGestureRecognizer *)tap
{
    [self dismiss];
    return;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         _alertView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              _alertView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              [weakSelf removeFromSuperview];
                                          }];
                     }];
}

- (void)showInContainView:(UIView *)containerView
{
    if (isShowed)
    {
        return;
    }
    self.clipsToBounds=TRUE;
    [containerView addSubview:self];
    
    [self show];
    return;
    
    _alertView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    [UIView animateWithDuration:0.2
                     animations:^{
                         _alertView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.1
                                          animations:^{
                                              _alertView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                                          }
                                          completion:^(BOOL finished){
                                              
                                              
                                              [UIView animateWithDuration:0.1
                                                               animations:^{
                                                                   _alertView.transform = CGAffineTransformIdentity;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   
                                                               }];
                                          }];
                     }];
}


#pragma mark  - 动画
- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _alertView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    _alertView.alpha = 0;
    self.alpha = 1;
    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _alertView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _alertView.alpha = 1.0;
    } completion:nil];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        _alertView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _alertView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end

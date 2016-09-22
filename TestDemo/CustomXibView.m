

//
//  CustomXibView.m
//  TestDemo
//
//  Created by ZGJ on 16/9/21.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CustomXibView.h"
#import <Masonry/Masonry.h>


/**
 *  xib 名称是CustomXibView
 */

@interface CustomXibView ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *alertView;


@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation CustomXibView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _alertView.layer.cornerRadius = 6;
    _alertView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (IBAction)confirmAction:(UIButton *)sender {
    NSLog(@"确定");
    [self hideView];
}

- (void)showView
{
    __weak typeof(self) weakSelf = self;

    UIView *view = [UIApplication sharedApplication].keyWindow ;
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    self.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        weakSelf.transform = CGAffineTransformIdentity;
    }];
    
}

- (void)hideView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.transform = CGAffineTransformMakeScale(0.00001, 0.00001);

        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"==textFieldDidBeginEditing=====");
}

@end

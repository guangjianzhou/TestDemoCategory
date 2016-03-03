

//
//  CustomView.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/14.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "CustomView.h"
#import "Masonry.h"

@interface CustomView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation CustomView

- (void)awakeFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    [self addSubview:_contentView];
    
    __weak typeof(self) weakSelf = self;
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
}

@end

//
//  CustomPopView.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/31.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "CustomPopView.h"
#import <Masonry.h>

@interface CustomPopView ()


@end

@implementation CustomPopView

- (void)awakeFromNib
{
    [self setUp];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"init from nib");
        [[NSBundle mainBundle] loadNibNamed:@"CustomPopView" owner:self options:nil];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

- (void)setUp
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (IBAction)cancelBtnAction:(UIButton *)sender
{
    
}

@end

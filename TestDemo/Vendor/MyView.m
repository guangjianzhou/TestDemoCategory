//
//  MyView.m
//  testViewFromXib
//
//  Created by Fang Jian on 14-9-13.
//  Copyright (c) 2014年 Jian Fang. All rights reserved.
//

#import "MyView.h"

@implementation MyView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"init from nib");
        [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:self options:nil];
        [self addSubview:self.contentView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    NSLog(@"awake from nib");
    [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:self options:nil];
    [self addSubview:self.contentView];
}

@end

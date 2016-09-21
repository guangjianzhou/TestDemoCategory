

//
//  CustomTableViewCell.m
//  TestDemo
//
//  Created by ZGJ on 16/9/2.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(ItemModel *)itemModel
{
    self.titleLabel.text = itemModel.title;
    self.contentLabel.text = itemModel.content;
}

//失败
//- (CGFloat)rowHeight
//{
//    [self layoutIfNeeded];
//    NSLog(@"===rowHeight=%f=======",CGRectGetMaxY(_bottomView
//                                                  .frame));
//    return CGRectGetMaxY(_bottomView
//                         .frame);
//}


@end

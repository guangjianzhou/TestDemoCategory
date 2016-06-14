//
//  PhotoCollectionViewCell.m
//  TestDemo
//
//  Created by ZGJ on 16/6/14.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "XMGShop.h"
#import "UIImageView+WebCache.h"

@interface PhotoCollectionViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor yellowColor];
}

- (void)setShop:(XMGShop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.titleLabel.text = shop.price;
}

@end

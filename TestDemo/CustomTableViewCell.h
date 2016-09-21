//
//  CustomTableViewCell.h
//  TestDemo
//
//  Created by ZGJ on 16/9/2.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"


@interface CustomTableViewCell : UITableViewCell

- (void)loadData:(ItemModel *)itemModel;

- (CGFloat)rowHeight;

@end

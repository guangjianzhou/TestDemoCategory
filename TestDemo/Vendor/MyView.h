//
//  MyView.h
//  testViewFromXib
//
//  Created by Fang Jian on 14-9-13.
//  Copyright (c) 2014年 Jian Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@end





//
//  TransferView.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/11.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "TransferView.h"

@implementation TransferView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging:");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"点击事件往下touchesBegan传递==============");
//    [self.nextResponder touchesBegan:touches withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"==移动=====touchesMoved====");
    [self.nextResponder touchesMoved:touches withEvent:event];
}




@end

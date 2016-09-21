


//
//  ItemModel.m
//  TestDemo
//
//  Created by ZGJ on 16/9/2.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content
{
    if (self = [super init]) {
        self.title = title;
        self.content = content;
    }
    return self;
}

@end

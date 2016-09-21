//
//  Teacher+male.m
//  TestDemo
//
//  Created by ZGJ on 16/9/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "Teacher+male.h"

@implementation Teacher (male)

//runtime会在本身或者其子类在被第一次接收到消息（allocWithZone）的时候，initialize就会被发送给我们。当其子类被调用的时候父类的也会被调用
//子类的initialize是在整个程序中只会调用一次，但是父类可能会被调用多次

//分类的优先级要比本类高，有分类执行分类

+ (void)initialize {
    NSLog(@"==male=====");
}

@end

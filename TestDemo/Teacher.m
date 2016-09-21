

//
//  Teacher.m
//  TestDemo
//
//  Created by ZGJ on 16/9/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher


//子类的initialize是在整个程序中只会调用一次，但是父类可能会被调用多次







+ (void)initialize {
    NSLog(@"==teacher=====");
    if(self != [Teacher class]){
        return;
    }
}


@end

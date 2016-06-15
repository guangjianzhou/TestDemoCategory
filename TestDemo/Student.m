//
//  Student.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "Student.h"

@implementation Student

- (void)run
{
    NSLog(@"%s", __func__);
}

- (void)study
{
    NSLog(@"%s", __func__);
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //
    NSLog(@"===%@==%@=",value,key);
}

- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"===%@==",key);
    return  @"自己重写了valueForUndefinedKey";
    
}

@end

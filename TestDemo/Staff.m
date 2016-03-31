

//
//  Staff.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/30.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "Staff.h"
#import "Address.h"

@implementation Staff

-(NSString *)description
{
    //重写description方法，拼一个字符串，按既定个数输出
    return [NSString stringWithFormat:@"<%@:%p>,{name:%@,road:%@}",[self class],self,self.name,self.address.road];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"====staff 没有属性%@==========",key);
}

@end


//
//  NSMutableDictionary+help.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/29.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "NSMutableDictionary+help.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (help)


+ (void)load
{
    [super load];
    Method customMethod = class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(cusSetObject:valueForKey:));
    Method systemMethod = class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(setObject:forKey:));
    
    method_exchangeImplementations(customMethod, systemMethod);
}

- (void)cusSetObject:(id)obj valueForKey:(id)key
{
    
    NSLog(@"===%s===%@=key=",__func__,key);
    if (obj)
    {
        [self cusSetObject:obj valueForKey:key];
    }
    NSAssert(obj, @"obj 不能为nil");
}

@end

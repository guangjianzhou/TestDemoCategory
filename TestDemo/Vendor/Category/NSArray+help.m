//
//  NSArray+help.m
//  TestDemo
//
//  Created by ZGJ on 16/9/28.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "NSArray+help.h"
#import <objc/runtime.h>

@implementation NSArray (help)

//+ (void)load
//{
//    [super load];
//    //NSArray
//    Method customMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(swizzleObjectAtIndex:));
//    Method systemMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(swizzleObjectAtIndex:));
//    
//    
//    //NSMutableArray
//    Method custom1Method = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(swizzleObjectAtIndex:));
//    Method system1Method = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
//    
//    method_exchangeImplementations(customMethod, systemMethod);
//    method_exchangeImplementations(custom1Method, system1Method);
//}

- (id)swizzleObjectAtIndex:(NSUInteger)index
{
    if (index < self.count)
    {
        return [self swizzleObjectAtIndex:index];
    }
    NSLog(@"%@ 越界---index=%lu",self,(unsigned long)index);
    return nil;//越界返回为nil
}


- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end

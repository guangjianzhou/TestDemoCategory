
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


/**
 *  main方法之前  苹果链接编译器  dyld
 *  执行顺序:
         static void call_class_loads(void)
         {
         int i;
         struct loadable_class *classes = loadable_classes;
         int used = loadable_classes_used;
         loadable_classes = nil;
         loadable_classes_allocated = 0;
         loadable_classes_used = 0;
         for (i = 0; i < used; i++) {
         Class cls = classes[i].cls;
         load_method_t load_method = (load_method_t)classes[i].method;
         if (!cls) continue;
         (*load_method)(cls, SEL_load);
         }
         if (classes) free(classes);
         }
 
 如果在类与分类中都实现了 load 方法，它们都会被调用，不像其它的在分类中实现的方法会被覆盖，这就使 load 方法成为了方法调剂的绝佳时机
 */
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

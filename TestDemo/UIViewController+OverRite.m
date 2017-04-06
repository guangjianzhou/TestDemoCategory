//
//  UIViewController+OverRite.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "UIViewController+OverRite.h"
#import "objc/objc.h"
#import <objc/runtime.h>

@implementation UIViewController (OverRite)

+ (void)load
{
    [super load];
    Method fromMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method toMethod = class_getInstanceMethod([self class], @selector(swizzlingViewDidLoad));
    
    if (!class_addMethod([self class], @selector(viewDidLoad), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"=类别===ViewWillAppear=======");
}

// 我们自己实现的方法，也就是和self的viewDidLoad方法进行交换的方法。
- (void)swizzlingViewDidLoad {
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    // 我们在这里加一个判断，将系统的UIViewController的对象剔除掉
    if(![str containsString:@"UI"]){
        NSLog(@"统计打点 : %@", self.class);
    }
    [self swizzlingViewDidLoad];
}

@end



//
//  HeaderViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "HeaderViewController.h"
#import "UIViewController+OverRite.h"
#import "Student.h"
#import <objc/runtime.h>



/**
 *  交换系统的方法
 */
@interface HeaderViewController ()

@end

@implementation HeaderViewController

/**
 *  在每个页面做统计  1.每个VC 手动添加   2.继承    3.category  4.MethodSwizzling
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        Method method1 = class_getInstanceMethod([Student class], @selector(run));
        Method method2 = class_getInstanceMethod([Student class], @selector(study));
        method_exchangeImplementations(method1, method2);
    
    
        Student *p = [[Student alloc] init];
        [p run];
        [p study];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//
- (void)dealloc
{
    NSLog(@"-------dealloc");
}


@end

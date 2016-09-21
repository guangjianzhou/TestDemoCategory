//
//  UIViewController+load.m
//  TestDemo
//
//  Created by ZGJ on 16/9/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "UIViewController+load.h"

@implementation UIViewController (load)


//注意事项：
//1.load方法中可以不写 [super load]; 系统会自动帮你调用父类的方法。如果你写了这句话那么系统会调用两次哦。
//2.load方法只能被调用一次。


//5.1load方法是在main方法执行之前，initialize是在main方法之后，由此我们可以知道load方法中没有什么autorelease runloop。
//5.2load方法适合做一些方法实现的替换。不适合生成一些变量。做很复杂的事情
//5.3initialize方法适合进行一写static变量的初始化

+ (void)load{
//    sleep(10);
    NSLog(@"==UIViewController=====");
    
}



@end

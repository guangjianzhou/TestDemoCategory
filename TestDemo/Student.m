//
//  Student.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "Student.h"
#import "Father.h"

#import "objc/objc.h"
#import <objc/runtime.h>

@interface Student ()

{
    
}

@end

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


/*
 发送消息
 [p study]
 编译器转化为
 objc_msgSend(receiver,selector,arg1,arg2,...)
 1.首先，通过p（类Student的实例对象）的isa指针找到它的类
 2.在class的methodlist 找 study
 3.如果class中没有study方法，继续往它的superclass中找;
 4.一旦找到study这个函数，就去执行它的IMP
 */

/*
 动态方法解析和转发
 1.Method resolution
     首先 运行时会调用 +resolveInstanceMethod: 或者+resolveClassMethod,让你有机会提供一个函数实现。如果你添加
     了函数并返回YES，那运行时系统就会重新启动一次消息发送的过程
     如果返回NO，运行时就会移动到下一步：消息转发(Message forwarding)
 2.Fast forwarding
    如果目标对象实现了 -forwardingTargetForSelector: ，Runtime这时候就会调用这个方法，给你把这个消息转发给其他对象的机会
 3.Normal forwarding
 */

void fooMethod(id obj,SEL _cmd)
{
    NSLog(@"Doing foo");
}


//实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
//    IMP fooIMP = imp_implementationWithBlock(^(id _self){
//        NSLog(@"Doing foo");
//    });
//    
//    class_addMethod([self class],sel,fooIMP,"v@:");
    
    
    
    NSLog(@"%s",__func__);
    return [super resolveInstanceMethod:sel];
    
    
    if (sel == @selector(foo:)) {
        class_addMethod([self class], sel, (IMP)fooMethod, "v@:");
        //return YES;
        return NO;
    }
    
//    return [super resolveInstanceMethod:sel];
    
    
}


//静态方法
+(BOOL)resolveClassMethod:(SEL)sel
{
    NSLog(@"%s",__func__);
    return NO;
}


#pragma mark  - Fast forwarding
//只要这个方法返回的不是nil 和self，整个消息发送的过程就会被重启，当然发送的对象会变成你返回的那个对象，
//否则，就会继续 Normal Forwarding
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (aSelector = @selector(foo:)) {
//        return [[Father alloc] init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}


#pragma mark  - Normal forwarding
//最后一次挽救
/*
 1.首先它会发送 -methodSignatureForSelector: 消息获得函数的参数和返回值类型。
 如果返回一个函数签名，Runtime就会创建一个NSInvocation对象并发送-forwardInvocation: 消息给目标对象
 2.如果返回为nil,runTime则会发出-doesNotRecognizeSelector: 消息，程序会挂掉了
 
 
 
 
 NSInvocation 实际上是对一个消息的描述： 包括selector以及参数等信息。
 所以你可以在-forwardInvocation:里面传进来NSInvocation对象，然后发送-invokeWithTarget:消息给它
 传进去一个新的目标
 */

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString *sel = NSStringFromSelector(aSelector);
    if ([sel rangeOfString:@"foo"].location == 0) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return nil;
    
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sel = anInvocation.selector;
    
    Father *f = [[Father alloc] init];
    if ([f respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:f];
    }else{
        [self doesNotRecognizeSelector:sel];
    }
}



@end

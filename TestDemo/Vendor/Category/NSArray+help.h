//
//  NSArray+help.h
//  TestDemo
//
//  Created by ZGJ on 16/9/28.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (help)

/*!
 取值用它
 @method objectAtIndexCheck:
 @abstract 检查是否越界和NSNull如果是返回nil
 @result 返回对象
 */
- (id)objectAtIndexCheck:(NSUInteger)index;

@end

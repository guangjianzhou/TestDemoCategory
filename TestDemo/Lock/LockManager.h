//
//  LockManager.h
//  TestDemo
//
//  Created by guangjianzhou on 16/2/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockManager : NSObject<NSCopying,NSCoding>

+ (instancetype) sharedSingleton;

//NSLock
- (void)printContent;
- (void)addContent;

//成功
- (void)printContentGCD;
- (void)addContentGCD;


//什么都不加
- (void)printContentWithOut;
- (void)addContentWithOut;

@end

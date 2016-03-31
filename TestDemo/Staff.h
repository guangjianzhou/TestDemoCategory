//
//  Staff.h
//  TestDemo
//
//  Created by guangjianzhou on 16/3/30.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Address;

@interface Staff : NSObject


@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Address *address;

@end

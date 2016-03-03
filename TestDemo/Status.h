//
//  Status.h
//  TestDemo
//
//  Created by guangjianzhou on 15/12/14.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;


@interface Status : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Status *retweetedStatus;

@end

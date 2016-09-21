//
//  ItemModel.h
//  TestDemo
//
//  Created by ZGJ on 16/9/2.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;


- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;
@end

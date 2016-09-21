//
//  CoreTextImageData.h
//  TestDemo
//
//  Created by ZGJ on 16/8/25.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

//用于存储图片的名称及位置信息
@interface CoreTextImageData : NSObject

@property (nonatomic, copy) NSString *name;
//此坐标是Coretext的坐标，不是uikit的
@property (nonatomic, assign) CGRect imagePosition;




@end

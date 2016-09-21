//
//  CoreTextData.h
//  TestDemo
//
//  Created by ZGJ on 16/8/25.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

//用imageArray 因为可能包含多张照片
@interface CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *imageArray;

@end

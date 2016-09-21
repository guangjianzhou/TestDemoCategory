//
//  StringAttribute.h
//  CoreTextTest
//
//  Created by lingyj on 12/22/14.
//  Copyright (c) 2014 lingyongjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, StringAttributeType) {
    StringAttributeText = 0,
    StringAttributeImg = 1,
};

@interface StringAttribute : NSObject

@property (assign, nonatomic) NSRange range;
@property (strong, nonatomic) NSString *string;

@property (assign, nonatomic) StringAttributeType type;

//之后当type=StringAttributeImg，才会赋值
@property (strong, nonatomic) NSString *imgName;

@end

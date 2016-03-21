


//
//  Son.m
//  TestDemo
//
//  Created by guangjianzhou on 16/1/27.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "Son.h"

@interface Son()
{
    NSError *error;
}
@end

@implementation Son

@synthesize sonName = _sonName;

- (void)eat
{
    NSLog(@"====eat==");
    NSLog(@"=====%@==",error);
}

- (void)play
{
    [self eat];
    [self wash];
}


- (NSString *)sonName
{
//    return @"zgj";
    return _sonName;
}


- (void)setSonName:(NSString *)sonName
{
    _sonName = @"zgjhaha";
}


@end

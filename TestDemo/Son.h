//
//  Son.h
//  TestDemo
//
//  Created by guangjianzhou on 16/1/27.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "Mather.h"

@interface Son : Mather

- (void)eat;

/**
 *  xcode @synthsize  自动生成set get
 *  完全重写  @synthsize sonName = sonName;
 */
@property (nonatomic, copy) NSString *sonName;

@end

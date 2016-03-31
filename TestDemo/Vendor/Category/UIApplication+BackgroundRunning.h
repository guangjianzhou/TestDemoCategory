//
//  UIApplication+BackgroundRunning.h
//  oapim
//
//  Created by Z.F on 14-4-22.
//  Copyright (c) 2014年 jsmcc.yfzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (BackgroundRunning)

//启用长期运行
-(void) enableLongTimeBackgoundRunning;


//停用长期运行
-(void) disableLongTimeBackgroundRunning;


-(BOOL) isDisableLongTimeBackgroundRunning;

-(BOOL) isGoingToDisableLongTimeBackgroundRunning;

@end


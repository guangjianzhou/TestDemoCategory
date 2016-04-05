//
//  AvatarView.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "AvatarView.h"
#import "UIColor+help.h"

#define kdefaultName  @"未知"

#define PersonNameBackgroundColors @[[UIColor colorWithHex:0xa1887f], [UIColor colorWithHex:0x5c6bc0], [UIColor colorWithHex:0xc5cb63], [UIColor colorWithHex:0xf65e5e], [UIColor colorWithHex:0xbd84cd], [UIColor colorWithHex:0xff943e], [UIColor colorWithHex:0x3bc2b5], [UIColor colorWithHex:0xf65e8d]]


@interface AvatarView ()

@end

@implementation AvatarView

- (void)awakeFromNib
{
    [self setup];
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    
}


/**
 *  返回按照名字头像
 *
 *  @param name     名字  两个字
 *  @param phoneNum
 *
 *  @return
 */
+ (UIImage *)defaultAvatarForVoipWithName:(NSString *)name phoneNum:(NSString *)phoneNum
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    NSArray *letters = [self checkPersonName:name];
    
    BOOL isUseNum = [self verifyAvatarName:name];
    name = [self verifyAvatarName:name phoneNum:phoneNum];
    UIColor *color = [AvatarView checkBackgroudColorWithLetter:[name substringWithRange:NSMakeRange(0, 1)]];
    view.backgroundColor = color;
    
    
    if (letters.count == 2 && !isUseNum)
    {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 44, 120)];
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        firstLabel.font = [UIFont systemFontOfSize:44];
        firstLabel.textColor = [UIColor whiteColor];
        firstLabel.text = [letters firstObject];
        [view addSubview:firstLabel];
        
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 + 44, 15, 26, 120 - 15)];
        secondLabel.backgroundColor = [UIColor clearColor];
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.font = [UIFont systemFontOfSize:26];
        secondLabel.textColor = [UIColor whiteColor];
        secondLabel.text = [letters objectAtIndex:1];
        [view addSubview:secondLabel];
    }
    else
    {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:view.bounds];
        firstLabel.center = view.center;
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        firstLabel.font = [UIFont systemFontOfSize:44];
        firstLabel.textColor = [UIColor whiteColor];
        firstLabel.text = isUseNum ? name : [letters firstObject];
        [view addSubview:firstLabel];
    }
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 1);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 *  从后面数名字，排除非汉字字符
 */
+ (NSArray *)checkPersonName:(NSString *)name
{
    if (name.length == 0)
    {
        return @[kdefaultName];
    }
    else if (name.length == 1)
    {
        return @[name];
    }
    else
    {
        NSMutableArray *letters = [NSMutableArray array];
        NSInteger firstLocation = NSNotFound;
        BOOL isFirstLetterChinese = NO;
        
        for (int i = 0 ; i < name.length ; i++)
        {
            NSString *letter = [name substringWithRange:NSMakeRange(name.length-1-i, 1)];
            BOOL isChineseLetter = [self judgeChinese:letter];
            if (isChineseLetter)
            {
                firstLocation = (firstLocation == NSNotFound)?(name.length-1-i):firstLocation;
                
                [letters insertObject:letter atIndex:0];
                if (letters.count > 1)
                {
                    return letters;
                }
            }
            
            if (i == (name.length - 1))
            {
                isFirstLetterChinese = isChineseLetter;
            }
        }
        
        BOOL isHaveChinese = (letters.count > 0);
        
        for (int i = 0 ; i < name.length ; i++)
        {
            NSString *letter = [name substringWithRange:NSMakeRange(i, 1)];
            if (![self judgeChinese:letter] && ![letter isEqualToString:@" "])
            {
                if (isHaveChinese)
                {
                    if (isFirstLetterChinese)
                    {
                        [letters addObject:letter];
                    }
                    else
                    {
                        [letters insertObject:letter atIndex:0];
                    }
                }
                else
                {
                    [letters addObject:letter];
                }
                
                if (letters.count > 1)
                {
                    return letters;
                }
            }
        }
        
        return letters;
    }
}

+ (BOOL)judgeChinese:(NSString *)string
{
    if (string.length != 1)
    {
        return NO;
    }
    
    int a = [string characterAtIndex:0];
    if( a > 0x4e00 && a < 0x9fff)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)verifyAvatarName:(NSString *)name
{
    if ([name isEqualToString:@"陌生"] || [name isEqualToString:@"生人"] || [name isEqualToString:@"未知"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//陌生人采用 手机号码
+ (NSString *)verifyAvatarName:(NSString *)name phoneNum:(NSString *)phoneNum
{
    if ([self verifyAvatarName:name])
    {
        if (phoneNum.length > 4)
        {
            return [phoneNum substringFromIndex:(phoneNum.length-4)];
        }
        else if (phoneNum.length > 1)
        {
            return phoneNum;
        }
        else
        {
            return @"0";
        }
    }
    else
    {
        return name;
    }
}


+ (UIColor *)checkBackgroudColorWithLetter:(NSString *)letter
{
    int a = [letter characterAtIndex:0];
    int index = a % 8;
    
    return [PersonNameBackgroundColors objectAtIndex:index];
}

+ (UIImage *)defaultAvatarForGroupDefaultWithName:(NSString *)name phoneNum:(NSString *)phoneNum
{
    return nil;
}

@end

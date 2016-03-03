//
//  UIColor+help.m
//  ShareBicycle
//
//  Created by guangjianzhou on 15/12/18.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "UIColor+help.h"

UIColor * UIColorMakeRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha / 255.0f];
}

UIColor * UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue)
{
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}

@implementation UIColor (help)

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r, g, b, a;
    
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelRGB:
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
            break;
            
        default:                        // We don't know how to handle this model
            return NO;
    }
    
    if (red) *red = r;
    
    if (green) *green = g;
    
    if (blue) *blue = b;
    
    if (alpha) *alpha = a;
    
    return YES;
}

- (CGColorSpaceModel)colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (CGFloat)red
{
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    return c[0];
}

- (CGFloat)green
{
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    
    return c[1];
}

- (CGFloat)blue
{
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    
    return c[2];
}

- (CGFloat)alpha
{
    return CGColorGetAlpha(self.CGColor);
}

- (UInt32)rgbHex
{
    CGFloat r, g, b, a;
    
    if (![self red:&r green:&g blue:&b alpha:&a])
    {
        return 0;
    }
    
    r = MIN(MAX(r, 0.0f), 1.0f);
    g = MIN(MAX(g, 0.0f), 1.0f);
    b = MIN(MAX(b, 0.0f), 1.0f);
    
    return (UInt32)(((int)roundf(r * 255)) << 16) | (((int)roundf(g * 255)) << 8) | (((int)roundf(b * 255)));
}

+ (UIColor *)colorWithHex:(unsigned int)hex
{
    return [self colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha
{
    CGFloat red = ((float)((hex & 0xFF0000) >> 16)) / 255.0f;
    CGFloat green = ((float)((hex & 0xFF00) >> 8)) / 255.0f;
    CGFloat blue = ((float)(hex & 0xFF)) / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithHexString:(id)hexString
{
    if (![hexString isKindOfClass:[NSString class]] || [hexString length] == 0) {
        return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    }
    
    const char *s = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
    if (*s == '#') {
        ++s;
    }
    unsigned long long value = strtoll(s, nil, 16);
    int r, g, b, a;
    switch (strlen(s)) {
        case 2:
            // xx
            r = g = b = value;
            a = 255;
            break;
        case 3:
            // RGB
            r = ((value & 0xf00) >> 8);
            g = ((value & 0x0f0) >> 4);
            b = ((value & 0x00f) >> 0);
            r = r * 16 + r;
            g = g * 16 + g;
            b = b * 16 + b;
            a = 255;
            break;
        case 6:
            // RRGGBB
            r = (value & 0xff0000) >> 16;
            g = (value & 0x00ff00) >>  8;
            b = (value & 0x0000ff) >>  0;
            a = 255;
            break;
        default:
            // RRGGBBAA
            r = (value & 0xff000000) >> 24;
            g = (value & 0x00ff0000) >> 16;
            b = (value & 0x0000ff00) >>  8;
            a = (value & 0x000000ff) >>  0;
            break;
    }
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}

#pragma mark - Other methods
+ (UIColor *)randomColor
{
    float r = arc4random() % 255;
    float g = arc4random() % 255;
    float b = arc4random() % 255;
    
    return [UIColor colorWithRed:r / 255 green:g / 255 blue:b / 255 alpha:1];
}

@end

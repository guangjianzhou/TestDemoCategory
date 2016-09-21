//
//  UIView+Chat.m
//  CoreTextTest
//
//  Created by lingyj on 12/22/14.
//  Copyright (c) 2014 lingyongjian. All rights reserved.
//

#import "UIView+Chat.h"
#import <CoreText/CoreText.h>
#import "StringAttribute.h"
#import <objc/runtime.h>

static char kChatViewDataSource;

#define HEXCOLOR(hex) [UIColor colorWithRed : ((float)((hex & 0xFF0000) >> 16)) / 255.0 green : ((float)((hex & 0xFF00) >> 8)) / 255.0 blue : ((float)(hex & 0xFF)) / 255.0 alpha : 1]

#define kLineMaxWidth 140

#define kImageWidth 20
#define kImageHeight 20

#define kTextSize 15
#define kTextColor 0x343434

@implementation UIView (Chat)

#pragma mark - faceAndTextRelation

static NSDictionary *emojiDictionary = nil;
NSDictionary *SinaEmojiDictionary()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FaceAndNameDic.plist"];
        emojiDictionary = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
    });
    return emojiDictionary;
}

#pragma mark - data source
- (void)setChatViewDataSource:(id <ChatViewDataSource>)dataSource
{
    objc_setAssociatedObject(self, &kChatViewDataSource, dataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id <ChatViewDataSource>)chatViewDataSource
{
    return objc_getAssociatedObject(self, &kChatViewDataSource);
}

#pragma mark - calculate
- (CGSize)calculateSizeWithMsg:(NSString *)msg withMaxWidth:(CGFloat)maxWidth
{
    if (msg.length < 1)
    {
		return CGSizeZero;
	}
    
    NSArray *stringAtrributes = [self checkPicture:msg];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];

	for (StringAttribute *attri in stringAtrributes) {
        //color 可以不传
		[attributedString appendAttributedString:[self changeIntoAttributeString:attri isDraw:NO textColor:HEXCOLOR(kTextColor)]];
	}

//    CGFloat lineMaxWidth = kLineMaxWidth;
//    if (self.chatViewDataSource && [self.chatViewDataSource respondsToSelector:@selector(maxWidthForView)])
//    {
//        lineMaxWidth = [self.chatViewDataSource maxWidthForView];
//    }
    if (maxWidth > 0)
    {
        maxWidth = maxWidth;
    }
    else
    {
        maxWidth = kLineMaxWidth;
    }
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attributedString));
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL, CGSizeMake(maxWidth, CGFLOAT_MAX), NULL);
	CFRelease(frameSetter);
    return size;
}

#pragma mark - load msg
- (void)loadWithMsg:(NSString *)msg  textcolor:textColorHex withMaxWidth:(CGFloat)maxWidth
{
	if (msg.length < 1) {
		return;
	}
    
//    CGFloat lineMaxWidth = kLineMaxWidth;
//    if (self.chatViewDataSource && [self.chatViewDataSource respondsToSelector:@selector(maxWidthForView)])
//    {
//        lineMaxWidth = [self.chatViewDataSource maxWidthForView];
//    }

    if (maxWidth > 0)
    {
        maxWidth = maxWidth;
    }
    else
    {
        maxWidth = kLineMaxWidth;
    }
	NSArray *stringAtrributes = [self checkPicture:msg];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
	for (StringAttribute *attri in stringAtrributes) {
		[attributedString appendAttributedString:[self changeIntoAttributeString:attri isDraw:YES textColor:textColorHex]];
	}
    

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity); //设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
	CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height);
	CGContextConcatCTM(context, flipVertical); //将当前context的坐标系进行flip
    
    
	//setting
	CTParagraphStyleSetting lineBreakMode;
	CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
	lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
	lineBreakMode.value = &lineBreak;
	lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
	CTParagraphStyleSetting settings[] = {
		lineBreakMode
	};
    
	CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
	// build attributes
	NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName];
	// set attributes to attributed string
	[attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    
    
	CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    
	CGMutablePathRef path = CGPathCreateMutable();
	CGRect bounds = CGRectMake(0.0, 0.0, maxWidth, self.bounds.size.height);
	CGPathAddRect(path, NULL, bounds);
    
	CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter, CFRangeMake(0, 0), path, NULL);
	CTFrameDraw(ctFrame, context);
    
	CFArrayRef lines = CTFrameGetLines(ctFrame);
	CGPoint lineOrigins[CFArrayGetCount(lines)];
	CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
//	NSLog(@"line count = %ld", CFArrayGetCount(lines));
    
	for (int i = 0; i < CFArrayGetCount(lines); i++) {
		CTLineRef line = CFArrayGetValueAtIndex(lines, i);
		CGFloat lineAscent;
		CGFloat lineDescent;
		CGFloat lineLeading;
		CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
//		NSLog(@"ascent = %f,descent = %f,leading = %f", lineAscent, lineDescent, lineLeading);
        
		CFArrayRef runs = CTLineGetGlyphRuns(line);
//		NSLog(@"run count = %ld", CFArrayGetCount(runs));
		for (int j = 0; j < CFArrayGetCount(runs); j++) {
			CGFloat runAscent;
			CGFloat runDescent;
			CGPoint lineOrigin = lineOrigins[i];
			CTRunRef run = CFArrayGetValueAtIndex(runs, j);
			NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
			CGRect runRect;
			runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAscent, &runDescent, NULL);
//			NSLog(@"width = %f", runRect.size.width);
            
			runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
//			NSLog(@"width = %f", runRect.size.width);

            
			NSString *imageName = [attributes objectForKey:@"imageName"];
			//图片渲染逻辑
			if (imageName)
            {
				UIImage *image = [UIImage imageNamed:imageName];
				if (image)
                {
					CGRect imageDrawRect;
//					imageDrawRect.size = image.size;
                    imageDrawRect.size = CGSizeMake(kImageWidth, kImageHeight);
					imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
					imageDrawRect.origin.y = lineOrigin.y;
					CGContextDrawImage(context, imageDrawRect, image.CGImage);
				}
			}
		}
	}
    
	CFRelease(ctFrame);
	CFRelease(path);
	CFRelease(ctFramesetter);
}

#pragma mark - core text callback
void RunDelegateDeallocCallback(void *refcon) {
}

CGFloat RunDelegateGetAscentCallback(void *refCon) {
    //    NSString *imageName = (__bridge NSString *)refCon;
    //    return [UIImage imageNamed:imageName].size.height;
	return kImageHeight;
}

CGFloat RunDelegateGetDescentCallback(void *refCon) {
	return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon) {
    //    NSString *imageName = (__bridge NSString *)refCon;
    //    return [UIImage imageNamed:imageName].size.width;
	return kImageWidth;
}

#pragma mark - prase
- (NSArray *)checkPicture:(NSString *)msg {
    NSMutableArray *attris = [NSMutableArray array];
    
//    NSString *regexString = @"\[(.[^\[\]]*?)\]";
//    NSString *regexString = @"\[.{1,10}]";
    NSString *regexString = @"\\[.*?\\]";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *matches = [regex matchesInString:msg options:NSMatchingReportCompletion range:NSMakeRange(0, msg.length)];
    NSUInteger location = 0;
    NSUInteger length = 0;
    
    for (NSTextCheckingResult *rs in matches)
    {
        //如果不连续，加入文字
        if (location != rs.range.location)
        {
            StringAttribute *attri = [[StringAttribute alloc] init];
            attri.type = StringAttributeText;
            attri.range = NSMakeRange(location, rs.range.location-location);
            attri.string = [msg substringWithRange:attri.range];
            [attris addObject:attri];
        }
        
        NSString *matchString = [msg substringWithRange:rs.range];
        NSString *imgName = [self changeTextPlaceholderToImageName:matchString];
        
        if (imgName)
        {
            //图片信息
            StringAttribute *attri = [[StringAttribute alloc] init];
            attri.type = StringAttributeImg;
            attri.range = rs.range;
            attri.string = [msg substringWithRange:rs.range];
            attri.imgName = imgName;
            [attris addObject:attri];
        }
        else
        {
            //非图片信息
            StringAttribute *attri = [[StringAttribute alloc] init];
            attri.type = StringAttributeText;
            attri.range = rs.range;
            attri.string = [msg substringWithRange:rs.range];
            [attris addObject:attri];
        }
        
        location = rs.range.location + rs.range.length;
        length = rs.range.length;
        
//        NSLog(@"%lu %lu",(unsigned long)location, (unsigned long)length);
    }
    
    //最后一条匹配信息之后还有文字
    if (location + length != msg.length)
    {
        StringAttribute *attri = [[StringAttribute alloc] init];
        attri.type = StringAttributeText;
        attri.range = NSMakeRange(location, msg.length-location);
        attri.string = [msg substringWithRange:attri.range];
        [attris addObject:attri];
    }
    
	return attris;
}

- (NSString *)changeTextPlaceholderToImageName:(NSString *)text
{
//    @"[aaa]"
//	return @"123";
    NSString *png = [SinaEmojiDictionary() objectForKey:text];
    if (png)
    {
        NSArray *pngName = [png componentsSeparatedByString:@"."];
        return [pngName firstObject];
//        return [NSString stringWithFormat:@"%@_60x40",[pngName firstObject]];
    }
    return nil;
}

- (NSAttributedString *)changeIntoAttributeString:(StringAttribute *)attri isDraw:(BOOL)isDraw textColor:textColor
{
	switch (attri.type) {
		case StringAttributeText:
			return [self changeTextIntoAttribute:attri textColor:textColor];
            
		case StringAttributeImg:
			return [self changeImageIntoAttribute:attri isDraw:isDraw];
            
		default:
			return [[NSAttributedString alloc] initWithString:@""];
	}
    
	return nil;
}

- (NSAttributedString *)changeTextIntoAttribute:(StringAttribute *)attri textColor:textColor
{
//	NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:attri.string attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:kTextSize], NSForegroundColorAttributeName:HEXCOLOR(kTextColor) }];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:attri.string attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:kTextSize], NSForegroundColorAttributeName:textColor }];
	return attributeString;
}

- (NSAttributedString *)changeImageIntoAttribute:(StringAttribute *)attri isDraw:(BOOL)isDraw {
	NSString *imgName = [NSString stringWithFormat:@"%@.png", attri.imgName];
	CTRunDelegateCallbacks imageCallbacks;
	imageCallbacks.version = kCTRunDelegateVersion1;
	imageCallbacks.dealloc = RunDelegateDeallocCallback;
	imageCallbacks.getAscent = RunDelegateGetAscentCallback;
	imageCallbacks.getDescent = RunDelegateGetDescentCallback;
	imageCallbacks.getWidth = RunDelegateGetWidthCallback;
	CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(imgName));
    
    NSMutableAttributedString *imageAttributedString;
    if (isDraw) {
        imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "]; //空格用于给图片留位置
    } else {
        imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"a"]; //空格用于给图片留位置
    }
	[imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
	CFRelease(runDelegate);
    
	[imageAttributedString addAttribute:@"imageName" value:imgName range:NSMakeRange(0, 1)];
	return imageAttributedString;
}

#pragma mark - test
-(void)drawCharAndPicture
{
    NSLog(@"---------------");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    NSLog(@"bh=%f",self.bounds.size.height);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"请在这里插入一张图片位置,请在这里插入一张图片位置,请在这里插入一张图片位置请在这里插入一张图片位置这里插入一张图片位置请在这里插入一张图片位置这里插入一张图片位置请在这里插入一张图片位置"];
    
    
    //为图片设置CTRunDelegate,delegate决定留给图片的空间大小
    NSString *imgName = @"123.png";
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(imgName));
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "];//空格用于给图片留位置
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    
    [imageAttributedString addAttribute:@"imageName" value:imgName range:NSMakeRange(0, 1)];
    
    [attributedString insertAttributedString:imageAttributedString atIndex:4];
   
    //换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting settings[] = {
        lineBreakMode
    };
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    
    // set attributes to attributed string
    [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    
    
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame, context);
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    NSLog(@"line count = %ld",CFArrayGetCount(lines));
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        NSLog(@"ascent = %f,descent = %f,leading = %f",lineAscent,lineDescent,lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        NSLog(@"run count = %ld",CFArrayGetCount(runs));
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
//            NSLog(@"＝＝ width = %f, height = %f",runRect.size.width, runRect.size.height);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
//            NSLog(@"－－ width = %f, height = %f",runRect.size.width, runRect.size.height);

            NSString *imageName = [attributes objectForKey:@"imageName"];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = image.size;
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(ctFramesetter);
}

@end

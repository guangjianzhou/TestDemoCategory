
//
//  CustomPicView.m
//  TestDemo
//
//  Created by ZGJ on 16/8/25.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "CustomPicView.h"
#import <CoreText/CoreText.h>

@implementation CustomPicView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //屏幕坐标系转换系统坐标系
    
    //.Coretxt坐标 坐标原点是左下角，y轴正方向朝上，ios坐标原点是左上角，y轴朝下，如不进行坐标转换，则文字从下开始，倒着的
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置字形的变换矩阵为不做图形变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //平移方法 将画布向上平移一个屏幕高
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    //缩放方法，x轴缩放系数为1，则不变，y轴缩放系数为-1，相当于y轴旋转180度
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
    
    
    //图文混排就是要插入图片的位置插入一个富文本类型的占位符，通过CTRUNDelegate设置图片
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"\n这里在测试图文混排，\n我是一个富文本"];
    
    /**
     *  设置一个回调接口提，告诉代理回调哪些方法
     */
    
    //我们绘制图片应该从原点开始绘制，图片的高度及宽度及CTRun的高度及宽度，我们通过代理设置CTRun的尺寸间接设置图片的尺寸
    
    CTRunDelegateCallbacks callBacks; //创建一个回调结构体，设置相关参数
    memset(&callBacks,0,sizeof(CTRunDelegateCallbacks));//memset将已开辟内存空间 callbacks 的首 n 个字节的值设为值 0, 相当于对CTRunDelegateCallbacks内存空间初始化
    callBacks.version = kCTRunDelegateVersion1;//设置回调版本，默认这个
    callBacks.getAscent = ascentCallBacks; //设置图片顶部距离极限的距离
    callBacks.getDescent =  descentCallBacks;//设置图片底部距离基线的距离
    callBacks.getWidth = widthCallBacks;//设置图片的宽度
    
    
    
    NSDictionary *dicPic = @{@"height":@40,@"width":@40}; //创建一个图片尺寸的字典
    //事实上此处你可以绑定任意对象。此处你绑定的对象既是回调方法中的参数ref
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void *)dicPic);
    
    unichar placeHolder = 0xFFFC; //创建空白字符
    NSString *placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];//已空白字符生成字符串
    NSMutableAttributedString *placeHolderAttrstr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];//用字符串初始化占位符的富文本
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrstr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate); //给字符串中的范围中字符串设置代理
    
    CFRelease(delegate); //释放（__bridge进行C与OC数据类型的转换，C为非ARC，需要手动管理）
    
    //将占位符插入到我们的富文本中
    [attributeStr insertAttributedString:placeHolderAttrstr atIndex:12];
    [self drawImage:attributeStr context:context];
    
}


//绘制富文本:文本 和图片
//因为富文本中你添加的图片只是一个带有图片尺寸的空白占位符啊，你绘制的时候他只会绘制出相应尺寸的空白占位符，所以什么也显示不了啊。
//那怎么显示图片啊？拿到占位符的坐标，在占位符的地方绘制相应大小的图片就好了。恩，说到这，图文混排的原理已经说完了。
//先来绘制文本吧
- (void)drawImage:(NSMutableAttributedString *)attributeStr context:(CGContextRef )context
{
    //一个frame的工厂，负责生成CTframe
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    //创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);//添加绘制尺寸
    NSInteger length = attributeStr.length;
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0,length), path, NULL);//工厂根据绘制区域及富文本(可选范围，多次设置)设置frame
    CTFrameDraw(frame, context); //根据frame  绘制文字
    /**
     frameSetter是根据富文本生成的一个frame生成的工厂，你可以通过framesetter以及你想要绘制的富文本的范围获取该CTRun的frame。
     但是你需要注意的是，获取的frame是仅绘制你所需要的那部分富文本的frame。即当前情况下，你绘制范围定为（10，1），那么你得到的尺寸是只绘制（10，1）的尺寸，他应该从屏幕左上角开始（因为你改变了坐标系），而不是当你绘制全部富文本时他该在的位置。
     然后建立一会绘制的尺寸，实际上就是在指定你的绘制范围。
     接着生成整个富文本绘制所需要的frame。因为范围是全部文本，所以获取的frame即为全部文本的frame(此处老司机希望你一定要搞清楚全部与指定范围获取的frame他们都是从左上角开始的，否则你会进入一个奇怪的误区，稍后会提到的)。
     最后，根据你获得的frame，绘制全部富文本。
     */
    
    //绘制图片
    CGRect imgFrm =  [self calculateImageRectWithFrame:frame];
    UIImage *image = [UIImage imageNamed:@"1"]; //动态的从delegate中获取
    CGContextDrawImage(context,imgFrm, image.CGImage);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}



//ref 既是创建代理的绑定的对象   __bridget 是C的结构体转换成OC对象的一个修饰词
static CGFloat ascentCallBacks(void * ref){
//    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
    return 40;
}

static CGFloat descentCallBacks(void * ref){
    return 0;
}

static CGFloat widthCallBacks(void * ref)
{
//    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
    return 40;
}


//CTLine 可以看做Core Text绘制中的一行的对象 通过它可以获得当前行的line ascent,line descent ,line leading,还可以获得Line下的所有Glyph Runs
//CTRun 或者叫做 Glyph Run，是一组共享想相同attributes（属性）的字形的集合体


//接下来判断代理属性是否为空。因为图片的占位符我们是绑定了代理的，而文字没有。以此区分文字和图片。
- (CGRect)calculateImageRectWithFrame:(CTFrameRef)frame
{
    NSArray *arrLines = (NSArray *)CTFrameGetLines(frame); //根据frame获取需要绘制的线的数组
    NSInteger count = [arrLines count]; //获取线的数量
    CGPoint points[count];//建立点的数组
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points); //获取起点
    //遍历线的数组，遍历我们的frame中的所有CTRun，检查他是不是我们绑定图片的那个，如果是，根据该CTRun所在CTLine的origin以及CTRun在CTLine中的横向偏移量计算出CTRun的原点，加上其尺寸即为该CTRun的尺寸。
    for(int i = 0; i<count; i++){
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray *arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line); //获取GlyphRun数组（GlyphRun：高效的字符绘制方案）
        
        for (int j = 0; j<arrGlyphRun.count; j++) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j]; //获取CTRun
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run); //获取CTRun所有属性
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];////获取代理
            if (delegate == nil) {
                continue;
            }
            
            
            //通过CTRunDelegateGetRefCon取得生成代理时绑定的对象。判断类型是否是我们绑定的类型，防止取得我们之前为其他的富文本绑定过代理。
            //NSDictionary *dicPic = @{@"height":@129,@"width":@400};
            NSDictionary *dict = CTRunDelegateGetRefCon(delegate);
            if (![dict isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGPoint point = points[i];
            CGFloat ascent;
            CGFloat descent;
            CGRect boundsRun;
            boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            boundsRun.size.height = ascent + descent;
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //获取x偏移量
            boundsRun.origin.x = point.x + xOffset; //point是行起点位置，加上每个字的偏移量得到每个字的x
            boundsRun.origin.y = point.y - descent;//计算原点
            CGPathRef path = CTFrameGetPath(frame);//获取绘制区域
            CGRect colRect = CGPathGetBoundingBox(path);//获取剪裁区域边框
            
            CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
            return imageBounds;
        }
        
    }
    return CGRectZero;
}


@end

//
//  NSString+help.m
//  ShareBicycle
//
//  Created by guangjianzhou on 15/12/21.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "NSString+help.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "sys/utsname.h"
#import <AddressBook/ABPerson.h>


#define LabelFormatHead @"_$!<"

@interface NSData (base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

- (NSString *)base64EncodedString;

@end

@implementation NSData (base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    const char lookup[] = {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,  99,  99,  99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,  99,  99,  99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62,  99,  99,  99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99,  99,  99,  99, 99,
        99, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10,  11,  12,  13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99,  99,  99,  99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,  37,  38,  39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99,  99,  99,  99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:(NSUInteger)maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = { 0, 0, 0, 0 };
    
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = (unsigned char)lookup[inputBytes[i] & 0x7F];
        
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (unsigned char)(accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (unsigned char)(accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (unsigned char)(accumulated[2] << 6) | accumulated[3];
            }
            
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (unsigned char)(accumulated[0] << 2) | (accumulated[1] >> 4);
    
    if (accumulator > 1) outputBytes[++outputLength] = (unsigned char)(accumulated[1] << 4) | (accumulated[2] >> 2);
    
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = (NSUInteger)outputLength;
    return outputLength ? outputData : nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth ? (maxOutputLength / wrapWidth) * 2 : 0;
    unsigned char *outputBytes = (unsigned char *)malloc((size_t)maxOutputLength);
    
    long long i;
    long long outputLength = 0;
    
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = (unsigned char)lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = (unsigned char)lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = (unsigned char)lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = (unsigned char)lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = (unsigned char)lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, (size_t)outputLength);
        return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                              length:(size_t)outputLength
                                            encoding:NSASCIIStringEncoding
                                        freeWhenDone:YES];
    }
    else if (outputBytes)
    {
        free(outputBytes);
    }
    
    return nil;
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithWrapWidth:0];
}

@end




@implementation NSString (help)
+ (NSString *)userAgentStr
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], deviceString, [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
}

- (NSString *)URLEncoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                                                              CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                              kCFStringEncodingUTF8 ));
    return result;
}
- (NSString *)URLDecoding
{
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString*) sha1Str
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}



- (NSString *)sha256
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256([data bytes], (CC_LONG)[data length], digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *)sha512
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512([data bytes], (CC_LONG)[data length], digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
- (NSString*) HMACWithSecret:(NSString*) secret
{
    CCHmacContext    ctx;
    const char       *key = [secret UTF8String];
    const char       *str = [self UTF8String];
    unsigned char    mac[CC_SHA1_DIGEST_LENGTH];
    char             hexmac[2 * CC_SHA1_DIGEST_LENGTH + 1];
    char             *p;
    
    CCHmacInit( &ctx, kCCHmacAlgSHA1, key, strlen( key ));
    CCHmacUpdate( &ctx, str, strlen(str) );
    CCHmacFinal( &ctx, mac );
    
    p = hexmac;
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[ i ] );
        p += 2;
    }
    
    return [NSString stringWithUTF8String:hexmac];
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}


- (NSString *)convertToHexString:(NSData *)data
{
    Byte *bytes = (Byte*)[data bytes];
    NSMutableString *hexString = [NSMutableString string];
    for(int i = 0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", bytes[i] & 0xff];
    }
    
    return hexString;
}

//普通字符串转换为十六进制的。

- (NSString *)hexStringFromString{
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

- (NSString *)sha1ForHex
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    //    CC_SHA1(data.bytes, data.length, digest);
    CC_SHA1([data bytes], (CC_LONG)[data length], digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return [output hexStringFromString];
}



+ (NSString *)handelRef:(NSString *)ref path:(NSString *)path{
    if (ref.length <= 0 && path.length <= 0) {
        return nil;
    }
    
    NSMutableString *result = [NSMutableString new];
    if (ref.length > 0) {
        [result appendString:ref];
    }
    if (path.length > 0) {
        [result appendFormat:@"%@%@", ref.length > 0? @"/": @"", path];
    }
    return [result URLEncoding];
}
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    resultSize = [self boundingRectWithSize:size
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font}
                                    context:nil].size;
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}

-(BOOL)containsEmoji{
    if (!self || self.length <= 0) {
        return NO;
    }
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}
#pragma mark emotion_monkey
+ (NSDictionary *)emotion_monkey_dict {
    static NSDictionary *_emotion_monkey_dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emotion_monkey_dict = @{
                                 //猴子大表情
                                 @"coding_emoji_01": @"哈哈",
                                 @"coding_emoji_02": @"吐",
                                 @"coding_emoji_03": @"压力山大",
                                 @"coding_emoji_04": @"忧伤",
                                 @"coding_emoji_05": @"坏人",
                                 @"coding_emoji_06": @"酷",
                                 @"coding_emoji_07": @"哼",
                                 @"coding_emoji_08": @"你咬我啊",
                                 @"coding_emoji_09": @"内急",
                                 @"coding_emoji_10": @"32个赞",
                                 @"coding_emoji_11": @"加油",
                                 @"coding_emoji_12": @"闭嘴",
                                 @"coding_emoji_13": @"wow",
                                 @"coding_emoji_14": @"泪流成河",
                                 @"coding_emoji_15": @"NO!",
                                 @"coding_emoji_16": @"疑问",
                                 @"coding_emoji_17": @"耶",
                                 @"coding_emoji_18": @"生日快乐",
                                 @"coding_emoji_19": @"求包养",
                                 @"coding_emoji_20": @"吹泡泡",
                                 @"coding_emoji_21": @"睡觉",
                                 @"coding_emoji_22": @"惊讶",
                                 @"coding_emoji_23": @"Hi",
                                 @"coding_emoji_24": @"打发点咯",
                                 @"coding_emoji_25": @"呵呵",
                                 @"coding_emoji_26": @"喷血",
                                 @"coding_emoji_27": @"Bug",
                                 @"coding_emoji_28": @"听音乐",
                                 @"coding_emoji_29": @"垒码",
                                 @"coding_emoji_30": @"我打你哦",
                                 @"coding_emoji_31": @"顶足球",
                                 @"coding_emoji_32": @"放毒气",
                                 @"coding_emoji_33": @"表白",
                                 @"coding_emoji_34": @"抓瓢虫",
                                 @"coding_emoji_35": @"下班",
                                 @"coding_emoji_36": @"冒泡",
                                 @"coding_emoji_38": @"2015",
                                 @"coding_emoji_39": @"拜年",
                                 @"coding_emoji_40": @"发红包",
                                 @"coding_emoji_41": @"放鞭炮",
                                 @"coding_emoji_42": @"求红包",
                                 @"coding_emoji_43": @"新年快乐",
                                 //猴子大表情 Gif
                                 @"coding_emoji_gif_01": @"奔月",
                                 @"coding_emoji_gif_02": @"吃月饼",
                                 @"coding_emoji_gif_03": @"捞月",
                                 @"coding_emoji_gif_04": @"打招呼",
                                 @"coding_emoji_gif_05": @"悠闲",
                                 @"coding_emoji_gif_06": @"赏月",
                                 @"coding_emoji_gif_07": @"中秋快乐",
                                 @"coding_emoji_gif_08": @"爬爬",
                                 };
    });
    return _emotion_monkey_dict;
}
- (NSString *)emotionMonkeyName{
    return [NSString emotion_monkey_dict][self];
}

+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte{
    NSString *sizeDisplayStr;
    if (sizeOfByte < 1024) {
        sizeDisplayStr = [NSString stringWithFormat:@"%.2f bytes", sizeOfByte];
    }else{
        CGFloat sizeOfKB = sizeOfByte/1024;
        if (sizeOfKB < 1024) {
            sizeDisplayStr = [NSString stringWithFormat:@"%.2f KB", sizeOfKB];
        }else{
            CGFloat sizeOfM = sizeOfKB/1024;
            if (sizeOfM < 1024) {
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f M", sizeOfM];
            }else{
                CGFloat sizeOfG = sizeOfKB/1024;
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f G", sizeOfG];
            }
        }
    }
    return sizeDisplayStr;
}

- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (BOOL)isEmpty
{
    return [[self trimWhitespace] isEqualToString:@""];
}

- (BOOL)isEmptyOrListening{
    return [self isEmpty] || [self hasListenChar];
}

//判断是否为整形
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (NSRange)rangeByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (location = 0; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    return NSMakeRange(location, length - location);
}
- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (length = [self length]; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    return NSMakeRange(location, length - location);
}

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet {
    return [self substringWithRange:[self rangeByTrimmingLeftCharactersInSet:characterSet]];
}

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {
    return [self substringWithRange:[self rangeByTrimmingRightCharactersInSet:characterSet]];
}

//转换拼音
- (NSString *)transformToPinyin {
    if (self.length <= 0) {
        return self;
    }
    NSString *tempString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
    tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [tempString uppercaseString];
}

//是否包含语音解析的图标
- (BOOL)hasListenChar{
    BOOL hasListenChar = NO;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (length = [self length]; length > 0; length--) {
        if (charBuffer[length -1] == 65532) {//'\U0000fffc'
            hasListenChar = YES;
            break;
        }
    }
    return hasListenChar;
}


#pragma mark - zgjAdd
+ (NSString *)documentPath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return documentPath;
}

//检测是否是正确的手机号码
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    if ([mobileNum hasPrefix:@"+86"])
    {
        mobileNum = [mobileNum substringFromIndex:3];
    }
    else if ([mobileNum hasPrefix:@"+"])
    {
        mobileNum = [mobileNum substringFromIndex:1];
    }
    else if ([mobileNum hasPrefix:@"86"])
    {
        mobileNum = [mobileNum substringFromIndex:2];
    }
    
    if([mobileNum hasPrefix:@"1"] && (mobileNum.length == 11))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //    /**
    //     * 中国移动：China Mobile
    //     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    /**
    //     * 中国联通：China Unicom
    //     * 130,131,132,152,155,156,185,186
    //     */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    /**
    //     * 中国电信：China Telecom
    //     * 133,1349,153,180,189
    //     */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //    /**
    //     * 大陆地区固话及小灵通
    //     * 区号：010,020,021,022,023,024,025,027,028,029
    //     * 号码：七位或八位
    //     */
    //    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//读写plist
+ (BOOL)writeToPlistWithDic:(NSDictionary *)addDataDic filename:(NSString *)filenamePlist
{
    //读取plist
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:filenamePlist];   //获取路径
    BOOL isSuccess = NO;
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:filename])
    {
        if ([defaultManager createFileAtPath:filename contents:nil attributes:nil])
        {
            isSuccess  =  [addDataDic writeToFile:filename atomically:YES];
        }
    }
    else
    {
        isSuccess  =  [addDataDic writeToFile:filename atomically:YES];
    }
    
    return isSuccess;
}


+ (NSMutableArray *)readPlistName:(NSString *)filenamePlist
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:filenamePlist];   //获取路径
    NSMutableArray *dic = [NSMutableArray arrayWithContentsOfFile:filename];
    return dic;
}

+ (NSString *)removeLabelFormat:(NSString *)label
{
    if (label.length >= 4)
    {
        NSString *headStr = [label substringToIndex:4];
        
        if ([headStr isEqualToString:LabelFormatHead])
        {
            return [label substringWithRange:NSMakeRange(4, label.length - 8)];
        }
        else
        {
            return label;
        }
    }
    else
    {
        return label;
    }
}

+ (BOOL)isLabelMobile:(NSString *)label
{
    if ([label isEqualToString:(__bridge_transfer NSString *)(kABPersonPhoneMobileLabel)])
    {
        return YES;
    }
    else if ([label isEqualToString:(__bridge_transfer NSString *)(kABPersonPhoneIPhoneLabel)])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isLabelShotMobile:(NSString *)label
{
    if ([label isEqualToString:@"短号"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *)removeLabelFormat
{
    if (self.length >= 4)
    {
        NSString *headStr = [self substringToIndex:4];
        
        if ([headStr isEqualToString:LabelFormatHead])
        {
            return [self substringWithRange:NSMakeRange(4, self.length - 8)];
        }
        else
        {
            return self;
        }
    }
    else
    {
        return self;
    }
}

- (BOOL)isLabelMobile
{
    if ([self isEqualToString:(__bridge_transfer NSString *)(kABPersonPhoneMobileLabel)])
    {
        return YES;
    }
    else if ([self isEqualToString:(__bridge_transfer NSString *)(kABPersonPhoneIPhoneLabel)])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isLabelShotMobile
{
    if ([self isEqualToString:@"短号"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)isURL:(NSString *)string
{
    NSString *pattern = @"^(http|https)://.*?$(net|com|.com.cn|org|me|)";
    
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    return [urlPredicate evaluateWithObject:string];
}


- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    return [data base64EncodedString];
}

- (NSString *)base64DecodedString
{
    return [NSString stringWithBase64EncodedString:self];
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData dataWithBase64EncodedString:string];
    
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

@end


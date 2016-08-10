
//
//  NSData+help.m
//  TestDemo
//
//  Created by ZGJ on 16/8/5.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "NSData+help.h"
#import "zlib.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (help)

- (NSString *)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}


@end

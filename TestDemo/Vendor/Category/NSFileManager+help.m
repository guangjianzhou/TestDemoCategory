


//
//  NSFileManager+help.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/30.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "NSFileManager+help.h"

@implementation NSFileManager (help)

+ (NSString *)documentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)cachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)bundleDirectory
{
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString *)libraryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)pathForItemNamed:(NSString *)fname inFolder:(NSString *)path ignoreCheck:(BOOL)ignoreCheck
{
    if (ignoreCheck)
    {
        return [path stringByAppendingPathComponent:fname];
    }
    
    NSString *file;
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    while (file = [dirEnum nextObject])
    {
        if ([[file lastPathComponent] isEqualToString:fname])
        {
            return [path stringByAppendingPathComponent:file];
        }
    }
    
    return nil;
}

+ (NSString *)pathForDocumentNamed:(NSString *)fname ignoreCheck:(BOOL)ignoreCheck
{
    return [NSFileManager pathForItemNamed:fname inFolder:[NSFileManager documentsDirectory] ignoreCheck:ignoreCheck];
}

+ (NSString *)pathForBundleDocumentNamed:(NSString *)fname ignoreCheck:(BOOL)ignoreCheck
{
    return [NSFileManager pathForItemNamed:fname inFolder:[NSFileManager bundleDirectory] ignoreCheck:ignoreCheck];
}

+ (NSArray *)filesInFolder:(NSString *)path
{
    NSString *file;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    while (file = [dirEnum nextObject])
    {
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory:&isDir];
        
        if (!isDir) [results addObject:file];
    }
    return results;
}

// Case insensitive compare, with deep enumeration
+ (NSArray *)pathsForItemsMatchingExtension:(NSString *)ext inFolder:(NSString *)path
{
    NSString *file;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    while (file = [dirEnum nextObject])
        if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame) [results addObject:[path stringByAppendingPathComponent:file]];
    
    return results;
}

+ (NSArray *)pathsForDocumentsMatchingExtension:(NSString *)ext
{
    return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:[NSFileManager documentsDirectory]];
}

// Case insensitive compare
+ (NSArray *)pathsForBundleDocumentsMatchingExtension:(NSString *)ext
{
    return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:[NSFileManager bundleDirectory]];
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)copyFileFromPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    NSError *error;
    
    return [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:&error];
}

+ (BOOL)deleteFileAtPath:(NSString *)path
{
    NSError *error;
    
    return [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
}

+ (BOOL)moveFileFromPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    NSError *error;
    
    return [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:&error];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path withAttributes:(NSDictionary *)attributes
{
    NSError *error;
    
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:attributes error:&error];
}

+ (BOOL)createFileAtPath:(NSString *)path withData:(NSData *)data andAttributes:(NSDictionary *)attr
{
    return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:attr];
}

+ (NSData *)dataFromPath:(NSString *)path
{
    return [[NSFileManager defaultManager] contentsAtPath:path];
}

+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path
{
    NSError *error;
    
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
}

//referenced: http://stackoverflow.com/questions/2188469/calculate-the-size-of-a-folder
+ (unsigned long long int)sizeOfFolderPath:(NSString *)path
{
    unsigned long long int totalSize = 0;
    
    NSEnumerator *enumerator = [[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil] objectEnumerator];
    NSString *fileName;
    
    while ((fileName = [enumerator nextObject]))
        totalSize += [[[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil] fileSize];
    
    return totalSize;
}

@end


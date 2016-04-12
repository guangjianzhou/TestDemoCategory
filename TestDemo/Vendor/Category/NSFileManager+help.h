//
//  NSFileManager+help.h
//  TestDemo
//
//  Created by guangjianzhou on 16/3/30.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (help)

/**
 *	@brief document文件夹路径
 *
 *
 *	@returns 路径
 */
+ (NSString *)documentsDirectory;

/**
 *	@brief caches文件夹路径
 *
 *
 *	@returns 路径
 */
+ (NSString *)cachesDirectory;

/**
 *	@brief library文件夹路径
 *
 *
 *	@returns 路径
 */
+ (NSString *)libraryDirectory;

/**
 *	@brief bundle文件夹路径
 *
 *
 *	@returns 路径
 */
+ (NSString *)bundleDirectory;

/**
 *  @brief  拼接文件名和文件夹路径的全路径（如果ignoreCheck为NO则先本地是否存在，不存在则返回nil）
 *
 *  @param  fname   文件名（包括后缀）
 *  @param  path    文件夹
 *  @param  ignoreCheck 忽略检测
 *
 *  @return         文件夹加文件名的全路径
 */
+ (NSString *)pathForItemNamed:(NSString *)fname inFolder:(NSString *)path ignoreCheck:(BOOL)ignoreCheck;

/**
 *  @brief  拼接文件名和Documents路径的全路径
 *
 *  @param  fname   文件名（包括后缀）
 *  @param  ignoreCheck 忽略检测
 *
 *  @return         文件夹加Documents的全路径
 */
+ (NSString *)pathForDocumentNamed:(NSString *)fname ignoreCheck:(BOOL)ignoreCheck;

/**
 *  @brief  拼接文件名和Bundle路径的全路径
 *
 *  @param  fname   文件名（包括后缀）
 *  @param  ignoreCheck 忽略检测
 *
 *  @return         文件夹加Bundle的全路径
 */
+ (NSString *)pathForBundleDocumentNamed:(NSString *)fname ignoreCheck:(BOOL)ignoreCheck;

/**
 *  @brief  搜索文件中带有ext后缀名的所有文件
 *
 *  @param  ext   后缀名称
 *
 *  @return         所有包含ext后缀的文件
 */
+ (NSArray *)pathsForItemsMatchingExtension:(NSString *)ext inFolder:(NSString *)path;

/**
 *  @brief  搜索Documents中带有ext后缀名的所有文件
 *
 *  @param  ext   后缀名称
 *
 *  @return         Documents所有包含ext后缀的文件
 */
+ (NSArray *)pathsForDocumentsMatchingExtension:(NSString *)ext;

/**
 *  @brief  搜索Bundle中带有ext后缀名的所有文件
 *
 *  @param  ext   后缀名称
 *
 *  @return         Bunble所有包含ext后缀的文件
 */
+ (NSArray *)pathsForBundleDocumentsMatchingExtension:(NSString *)ext;

/**
 *  @brief  文件夹下所有文件，如果其中一个文件为目录，那么也会递归枚举它的内容
 *
 *  @param
 *
 *  @return         
 */
+ (NSArray *)filesInFolder:(NSString *)path;

/**
 *  @brief  判断是否路径文件存在
 *
 *  @param  path   路径
 *
 *  @return         是否存在
 */
+ (BOOL)fileExistsAtPath:(NSString *)path;

/**
 *  @brief  拷贝路径文件
 *
 *  @param  srcPath   源路径
 *  @param  dstPath   目标路径
 *
 *  @return         是否拷贝成功
 */
+ (BOOL)copyFileFromPath:(NSString *)srcPath toPath:(NSString *)dstPath;

/**
 *  @brief  删除路径文件
 *
 *  @param  path   源路径
 *
 *  @return         是否删除成功
 */
+ (BOOL)deleteFileAtPath:(NSString *)path;

/**
 *	@brief 移动路径文件
 *
 *	@param srcPath 源路径
 *	@param dstPath 目标路径
 *
 *	@returns 是否移动成功
 */
+ (BOOL)moveFileFromPath:(NSString *)srcPath toPath:(NSString *)dstPath;

/**
 *  @brief  创建文件夹
 *
 *  @param  path   路径
 *  @param  attributes   文件夹属性
 *
 *  @return         是否创建成功
 */
+ (BOOL)createDirectoryAtPath:(NSString *)path withAttributes:(NSDictionary *)attributes;

/**
 *  @brief  创建文件
 *
 *  @param  path   路径
 *  @param  data   文件内容
 *  @param  attributes   文件属性
 *
 *  @return         是否创建成功
 */
+ (BOOL)createFileAtPath:(NSString *)path withData:(NSData *)data andAttributes:(NSDictionary *)attr;

/**
 *  @brief  得到文件内容
 *
 *  @param  path   路径
 *
 *  @return         是否创建成功
 */
+ (NSData *)dataFromPath:(NSString *)path;

/**
 *	@brief  得到路径下的文件列表
 *
 *	@param path 路径
 *
 *	@returns 文件列表
 */
+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path;

/**
 *  @brief  得到文件夹中所有文件大小
 *
 *  @param  path   路径
 *
 *  @return         所有文件大小
 */
+ (unsigned long long int)sizeOfFolderPath:(NSString *)path;

@end


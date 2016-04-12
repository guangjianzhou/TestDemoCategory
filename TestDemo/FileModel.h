//
//  FileModel.h
//  TestDemo
//
//  Created by guangjianzhou on 16/4/5.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,FileType){
    FileTypeNormal = 0,
    FileTypeWord = 1,
    FileTypePPT = 2,
    FileTypeTXT = 3,
    FileTypePDF = 4,
    FileTypeOther = 5,
} ;

@interface FileModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileTypeStr;
@property (nonatomic,readonly ,assign) FileType fileType;
@property (nonatomic, copy) NSString *fileSize;


@end

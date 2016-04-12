

//
//  FileModel.m
//  TestDemo
//
//  Created by guangjianzhou on 16/4/5.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel


- (FileType)fileType
{
    if ([@[@"ppt"] containsObject:self.fileTypeStr])
    {
        return FileTypePPT;
    }
    else if ([@[@"txt"] containsObject:self.fileTypeStr])
    {
        return FileTypeTXT;
    }
    else if ([@[@"word"] containsObject:self.fileTypeStr])
    {
        return FileTypeWord;
    }
    else if ([@[@"pdf"] containsObject:self.fileTypeStr])
    {
        return FileTypePDF;
    }
    else
    {
        return FileTypeOther;
    }
}


@end









//
//  FileManagerViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/3/30.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "FileManagerViewController.h"
#import "NSDate+help.h"
#import "Staff.h"
#import "Address.h"
#import "NSFileManager+help.h"

@interface FileManagerViewController ()

{
    Staff *staff;
    NSMutableArray *array;
    NSMutableArray *fileArray;
}

@end

@implementation FileManagerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    staff = [[Staff alloc] init];
    
    
     Address *address = [[Address alloc] init];
//    address.road = @"1号";
    //kvc 设置值
    [address setValue:@"1号" forKey:@"road"];
    [address setValue:@"幸福大街" forKey:@"street"];
    NSLog(@"===road=%@==",[address valueForKeyPath:@"road"]);
    
    [staff addObserver:self forKeyPath:@"address.road" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void*)self];
    
    [address setValue:@"2号" forKey:@"road"];
    
    [staff setValue:address forKey:@"address"];
#warning crash
    //crash---》this class is not key value coding-compliant for the key num
    [staff setValue:@"12" forKey:@"num"];
    
    NSLog(@"staff===%@",staff);
    
    array = [[NSMutableArray alloc] initWithObjects:@"1",@"3", nil];
    
    
//    [array addObserver:self forKeyPath:@"array.count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [array addObject:@"123"];
    
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"keypath=====%@====dic===%@",keyPath,change);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    fileArray = [NSMutableArray array];
    
    
    /**
     *  两种方法：获取文件夹下面的文件
     * 1.enumeratorAtPath 一次可以枚举指定目录中的每个文件。默认情况下，如果其中一个文件为目录，那么也会递归枚举它的内容。在这个过程中，通过向枚举对象发送一条skipDescendants消息，可以动态地阻止递归过程，从而不再枚举目录中的内容。
     *  2.directoryContentsAtPath 不递归
     */
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while ((path = [dirEnum nextObject]) != nil)
    {
        NSLog(@"%@",path);
        [fileArray addObject:path];
    }
    
    //遍历目录的另一种方法：（不递归枚举文件夹种的内容）
    [fileArray removeAllObjects];
    [fileArray addObjectsFromArray:[[NSFileManager defaultManager] directoryContentsAtPath:path]];
    NSLog(@"fileArray=====%@",fileArray);
    
}


#pragma mark  - Action
- (IBAction)readWrite:(UIButton *)sender
{
    NSString *date = [NSDate stringFromDate:[NSDate date] withFormat:kDatabaseDateFormat];
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"path======%@",path);
    
    NSString *text = @"2---zgj 周广健---1";
    NSString *textPath = [path stringByAppendingPathComponent:@"hello.txt"];
    NSData *textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    //自己创建文件进行写入
    BOOL isWriteSuccess = [textData writeToFile:textPath atomically:YES];
    NSLog(@"写入=====%d",isWriteSuccess);
}


- (IBAction)readWrite1:(UIButton *)sender
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"path1======%@",path);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *textPath = [path stringByAppendingPathComponent:@"hello1.txt"];
    if ([manager fileExistsAtPath:textPath])
    {
        NSLog(@"文件存在===");
        NSString *date = [NSDate stringFromDate:[NSDate date] withFormat:kDatabaseDateFormat];
        NSFileHandle *fileHandle=[NSFileHandle fileHandleForUpdatingAtPath:textPath];
        
        [fileHandle seekToEndOfFile];
//        [fileHandle seekToFileOffset:10];
        
        NSString *str=date;
        
        NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
        
        [fileHandle writeData:data];
        
        [fileHandle closeFile];
        

        
        
    }
    else
    {
        NSLog(@"文件bu存在===");
        if ([manager createFileAtPath:textPath contents:[@"哈哈" dataUsingEncoding: NSUTF8StringEncoding] attributes:nil])
        {
            NSLog(@"创建成功");
        }
        else
        {
            NSLog(@"创建失败");
        }
        
    }
    
}









@end

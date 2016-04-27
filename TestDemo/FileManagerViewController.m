







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
#import <QuickLook/QuickLook.h>

@interface FileManagerViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>

{
    Staff *staff;
    NSMutableArray *array;
    NSMutableArray *fileArray;
    QLPreviewController *preViewControl;
    NSIndexPath *selectIndexPath;
    UIDocumentInteractionController *docuVC;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

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
//    [fileArray removeAllObjects];
//    [fileArray addObjectsFromArray:[[NSFileManager defaultManager] directoryContentsAtPath:path]];
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

#pragma mark  - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *file = fileArray[indexPath.row];
    cell.textLabel.text = file;
    
    return cell;
}


/**
 *  预览网络上的PDF文档：
 
 1、使用UIWebView去预览网络上的PDF文档，先是将要预览的文档下载iPhone内存中，然后预览，对很大的pdf文档，效率不高，用户体验也不好。
 
 2、对于使用prevoewController，因为它是分步加载的，不会一次性加载所有的pdf文档，用户体验还不错，但是在4.0中多出了一个打印按钮，一点击这个打印按钮，程序就挂了，真是杯具。
 
 3、绘制的方式也是需要一次性加载到内存，绘制效率不高，对于大文档，不应当使用这种方式

 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:fileArray[indexPath.row]];
    
    
    //方法1：
    NSURL *url = [NSURL fileURLWithPath:filePath];
//    NSURL *url = [NSURL URLWithString:@"http://znmdmtest.zhongnangroup.cn:81/test.docx"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    //方法2：
//    selectIndexPath = indexPath;
//    if (!preViewControl)
//    {
//        preViewControl = [[QLPreviewController alloc] init];
//        preViewControl.dataSource = self;
//        preViewControl.delegate = self;
//    }
//    preViewControl.currentPreviewItemIndex = indexPath.row;
//    [self presentViewController:preViewControl animated:YES completion:^{
//        
//    }];
    
    //方法3：
    if (!docuVC)
    {
        docuVC = [[UIDocumentInteractionController alloc] init];
        docuVC.delegate = self;
    }
    
    docuVC.URL = url;
    [docuVC presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
}




#pragma makr  - QLPreviewControllerDataSource
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return [fileArray count];
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    // Break the path into it's components (filename and extension)
//    NSArray *fileComponents = [[arrayOfDocuments objectAtIndex: index] componentsSeparatedByString:@"."];
    // Use the filename (index 0) and the extension (index 1) to get path
//    NSString *path = [[NSBundle mainBundle] pathForResource:[fileComponents objectAtIndex:0] ofType:[fileComponents objectAtIndex:1]];
    NSURL *url = [NSURL URLWithString:@"http://znmdmtest.zhongnangroup.cn:81/test.docx"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:fileArray[index]];
//    NSURL *url = [NSURL fileURLWithPath:filePath];
    return url;
}

- (void)dealloc
{
    [staff removeObserver:self forKeyPath:@"address.road"];
}

#pragma mark  - QLPreviewControllerDelegate
- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    
}

@end

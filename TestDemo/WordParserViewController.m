//
//  WordParserViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/6/6.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "WordParserViewController.h"
#import "SSZipArchive.h"


@interface WordParserViewController ()<UIWebViewDelegate, NSXMLParserDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, copy) NSString *tempString;
@property (nonatomic, strong) NSMutableArray *booksArray;
@property (nonatomic, copy) NSString *allXmlStr;

@end

@implementation WordParserViewController

- (NSMutableArray *)booksArray
{
    if (!_booksArray) {
        self.booksArray = [[NSMutableArray alloc] init];
    }
    return _booksArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    self.webView = webView;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    webView.frame = CGRectMake(0, 0, screenWidth, screenHeight );
    webView.scalesPageToFit = YES;
    
    
    webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ffxy" ofType:@"docx"];
    NSLog(@"%@", path);
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    
    //    NSLog(@"%@", data);
    
    NSURLRequest *requset = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requset];
    [self.view addSubview:webView];
    [self logDataStrWithData:fileData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)logDataStrWithData:(NSData *)fileData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = @"docFile";
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"%@", fullPathToFile);
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ffxy" ofType:@"docx"];
    BOOL b = [SSZipArchive unzipFileAtPath:bundlePath toDestination:fullPathToFile];
    if (b) {
        NSString *str = [NSString stringWithFormat:@"%@/word/document.xml", fullPathToFile];
        NSLog(@"%@", str);
        NSData *fileDataT = [NSData dataWithContentsOfFile:str];
        NSString *strr = [[NSString alloc] initWithData:fileDataT encoding:NSUTF8StringEncoding];
        self.allXmlStr = strr;
        [self jiexiXml:fileDataT];
        
        
        
        NSRange range = [strr rangeOfString:@"<w:bookmarkStart w:id=\"0\" w:name=\"dwmc\"/>"];
        NSRange range1 = [strr rangeOfString:@"<w:bookmarkEnd w:id=\"0\"/>"];
        NSString *strC = [strr substringWithRange:NSMakeRange(range.location + range.length, range1.location - range.location - range.length)];
        
        //        NSRange rangeT = NSMakeRange(range.location + range.length, range1.location - range.location - range.length);
        //        NSLog(@"<w:bookmarkStart w:id=\"0\" w:name=\"dwmc\"/>");
        //
        //        NSLog(@"%@", strC);
        
        //         NSLog(@"%@", strr);
    }
    
    
}

- (void)jiexiXml:(NSData *)data
{
    NSXMLParser *praser = [[NSXMLParser alloc] initWithData:data];
    praser.delegate = self;
    [praser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    NSLog(@"%@", elementName);
    if ([elementName isEqualToString:@"w:bookmarkStart"]) {
        [self.booksArray addObject:elementName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(nonnull NSString *)string
{
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    /*
     w:name="ffxygz"/><w:r w:rsidR="000769C9" w:rsidRPr="00BA5220"><w:rPr><w:rFonts w:ascii="宋体" w:hAnsi="宋体" w:hint="eastAsia"/><w:sz w:val="24"/></w:rPr><w:t xml:space="preserve"> </w:t></w:r>
     */
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"----");
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:self.allXmlStr];
    NSLog(@"%ld", self.booksArray.count);
    
    //    for (int i = 0; i < self.booksArray.count; i++) {
    NSString *indexStr = [NSString stringWithFormat:@"%d", 0];
    //        NSString *strOne = [NSString stringWithFormat:@"<w:bookmarkStart w:id=\"%@\"", indexStr];
    NSString *strOne = [NSString stringWithFormat:@"<w:bookmarkStart w:id=\"%@\" w:name=\"", indexStr];
    NSRange range = [self.allXmlStr rangeOfString:strOne];
    NSString *strTwo = [NSString stringWithFormat:@"<w:bookmarkEnd w:id=\"%@\"/>", indexStr];
    NSRange range1 = [self.allXmlStr rangeOfString:strTwo];
    NSString *strC = [self.allXmlStr substringWithRange:NSMakeRange(range.location + range.length, range1.location - range.location - range.length)];
    NSLog(@"%@", strC);
    NSRange range2 = [strC rangeOfString:@"\"/><w:r"];
    
    NSRange rangeThree = [strC rangeOfString:@"<w:t"];
    NSRange rangeFive = [strC rangeOfString:@"</w:t>"];
    NSString *newContent = @"<w:t>你好你好</w:t>";
    NSMutableString *MstrC = [[NSMutableString alloc] initWithString:strC];
    //    NSString *fullNewContent = [strC substringWithRange:NSMakeRange(rangeThree.location, rangeFive.location - rangeThree.location + rangeFive.length)];
    [MstrC replaceCharactersInRange:NSMakeRange(rangeThree.location, rangeFive.location - rangeThree.location + rangeFive.length) withString:newContent];
    NSLog(@"%@", MstrC);
    NSLog(@"rrrr%ld", range2.location);
    NSString *name = [strC substringToIndex:range2.location];
    NSLog(@"%@", name);
    NSString *newStr = @"dwmc\"/><w:r w:rsidR=\"004E3284\"><w:rPr><w:rFonts w:hAnsi=\"宋体\" w:hint=\"eastAsia\"/><w:sz w:val=\"24\"/><w:szCs w:val=\"24\"/></w:rPr><w:t>你好你好</w:t></w:r>";
    
    
    [mStr replaceCharactersInRange:NSMakeRange(range.location + range.length, range1.location - range.location - range.length) withString:newStr];
    
    NSData *data =[mStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = @"docFile";
    
    NSString *newName = @"ffty.docx";
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSString *newFullPathToFile = [documentsDirectory stringByAppendingPathComponent:newName];
    NSString *str = [NSString stringWithFormat:@"%@/word/document.xml", fullPathToFile];
    [data writeToFile:str atomically:NO];
    
    [SSZipArchive createZipFileAtPath:newFullPathToFile withContentsOfDirectory:fullPathToFile];
    
}
@end



//
//  LimitInputViewController.m
//  TestDemo
//
//  Created by ZGJ on 16/8/22.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "LimitInputViewController.h"
#import "UITextField+Category.h"
#import "Toast+UIView.h"


#define MaxNumberOfDescriptionChars 15

@interface LimitInputViewController ()<UITextViewDelegate,UITextFieldDelegate>



@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UITextView *inputView;

@end

@implementation LimitInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 60)];
    _inputTextField.backgroundColor = [UIColor lightGrayColor];
    _inputTextField.delegate = self;
    [_inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_inputTextField];
    
    
    _inputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, 120)];
    _inputView.backgroundColor = [UIColor yellowColor];
    _inputView.delegate = self;
    [self.view addSubview:_inputView];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    //1.emoji 占2 
    [super viewWillAppear:animated];
    NSString *str = @"12😄周z";
    
    //encode
    NSData *data = [str dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"gv = %@,len = %lu",goodValue,(unsigned long)goodValue.length);
    
    //decode
    data = [goodValue dataUsingEncoding:NSUTF8StringEncoding];
    goodValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    NSLog(@"gv = %@,len = %lu",goodValue,(unsigned long)goodValue.length);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
    
}


#pragma mark  - 字数限制

#pragma mark  UITextField
// 监听文本改变，byte 个数
- (void)textFieldDidChange:(UITextField*)textField
{
    [textField limitTextFieldWithBytesLength:MaxNumberOfDescriptionChars];
}


#pragma mark-- UITextfielfDelegate imp
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    return [textField isEnabledWithBytesLength:MaxNumberOfDescriptionChars shouldChangeCharactersInRange:range replacementString:string];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - UITextView
#pragma mark  UITextViewDelegate


/**
 *  //有输入时触但对于中文键盘出示的联想字选择时不会触发
 *  @param textView
 *  @param range
 *  @param text
 *
 */



/**
 *  bug:
 *
 1.当输入到只剩下一个字时，这时输入拼音时，问题出现了，发现拼音输不完。
 2.当离字数上限差距很大时，输入拼音会发现字数也跟着计算了。本来还没有输入的，此时开始计算了，有瘕次。
 在最后一个，本想输入一个拼音h开头的且还没有出现在推荐字的。哪再输入第二位拼音时发现不能输了，且字数被计算了。

 3.😄 emoj占用2个字符，所以当 最后14个字符+😈 的时候，截取15个字符，emoji将变成乱码
 *
 */
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSLog(@"text ===%@,range = %@==replaceViewText = %@",textView.text,NSStringFromRange(range),text);
// 
//    //拼接字符
//    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    NSLog(@"comcatstr = %@",comcatstr);
//    
//    NSInteger canInputLen = MaxNumberOfDescriptionChars - comcatstr.length;
//    if (canInputLen >=0 ) {
//        return  YES;
//    }
//    else
//    {
//        NSInteger len = text.length + canInputLen;
//        //防止当text.length + caninputLen < 0,是的rg.length为一个非法最大证书出错
//        NSRange rg = {0,MAX(len, 0)};
//        NSString *s = [text substringWithRange:rg];
//        [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//        return NO;
//    }
//}
//
//
//当输入且上面的代码返回YES时触发。或当选择键盘上的联想字时触发
//- (void)textViewDidChange:(UITextView *)textView
//{
//    if (textView.text.length > MaxNumberOfDescriptionChars) {
//        textView.text = [textView.text substringToIndex:MaxNumberOfDescriptionChars];
//        NSLog(@"字数超过了");
//        [UIView showToastWithText:@"字数超过了"];
//    }
//    
//}

/**
 *  修复 bug 1 2
 */
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    UITextRange *selectedRange = [textView markedTextRange];
//    //获取高亮部分
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//    //获取高亮部分内容
//    NSString *seletedtext = [textView textInRange:selectedRange];
//    NSLog(@"==seletedtext=%@====",seletedtext);
//    
//    //如果有高亮且当前字数开始位置小于最大输入限制时允许输入
//    if (pos && selectedRange) {
//        NSInteger startoffSet = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
//        NSInteger endoffSet = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
//        
//        NSRange offsetRange = NSMakeRange(startoffSet, endoffSet-startoffSet);
//        NSLog(@"==%@===",NSStringFromRange(offsetRange));
//        
//        if (offsetRange.location < MaxNumberOfDescriptionChars) {
//            return YES;
//        }else{
//            return NO;
//        }
//        
//    }
//    
//    
//    /*--------------------------------*/
//    //拼接字符
//    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    NSLog(@"comcatstr = %@",comcatstr);
//    
//    NSInteger canInputLen = MaxNumberOfDescriptionChars - comcatstr.length;
//    if (canInputLen >=0 ) {
//        return  YES;
//    }
//    else
//    {
//        NSInteger len = text.length + canInputLen;
//        //防止当text.length + caninputLen < 0,是的rg.length为一个非法最大证书出错
//        NSRange rg = {0,MAX(len, 0)};
//        NSString *s = [text substringWithRange:rg];
//        [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//        return NO;
//    }
//
//}
//
//
//- (void)textViewDidChange:(UITextView *)textView
//{
//    UITextRange *selectedRange = [textView markedTextRange];
//    //获取高亮部分
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//    
//    //如果在变化中是高亮部分在变，就不要计算字符了
//    if (selectedRange && pos) {
//        return;
//    }
//    
//    NSString  *nsTextContent = textView.text;
//    NSInteger existTextNum = nsTextContent.length;
//    
//    if (existTextNum > MaxNumberOfDescriptionChars)
//    {
//        //截取到最大位置的字符
//        NSString *s = [nsTextContent substringToIndex:MaxNumberOfDescriptionChars];
//        
//        [textView setText:s];
//    }
//    
//}


//bug 3 解决思路就是判断截取的位置是否正好为emoji。一个比较笨的方式就是判断截取的位置，先假设为emoji，取位置前1个字符和当前字串组合(AB)然后用emoji的正则判断这个组合后的字符是否为emoji如果是，则说明截取的位置正好是一个emoji的结束位。如果组合起来发现不是emoji，则再来判断截取位置和+1字符串(注意要判断是否越界)，组合后BC进行emoji正则，若为emoji则说明截取的位置正好把emoji劈成两半了，所以这个时候的实际截取应该是当前截取位置+1这样就可以让emoji截全了。如果不是则放心了，截取的位置不是emoji.(不过不能保证是不是其它双字节的)
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MaxNumberOfDescriptionChars) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MaxNumberOfDescriptionChars - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
//                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
//                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
//                                         options:NSStringEnumerationByComposedCharacterSequences
//                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
//                                          
//                                          if (idx >= rg.length) {
//                                              *stop = YES; //取出所需要就break，提高效率
//                                              return ;
//                                          }
//                                          
//                                          trimString = [trimString stringByAppendingString:substring];
//                                          
//                                          idx++;
//                                      }];
                
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          NSInteger steplen = substring.length;
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx = idx + steplen;//这里变化了，使用了字串占的长度来作为步长
                                      }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MaxNumberOfDescriptionChars)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MaxNumberOfDescriptionChars];
        
        [textView setText:s];
    }
}

@end

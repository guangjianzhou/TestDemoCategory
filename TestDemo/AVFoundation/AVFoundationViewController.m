//
//  AVFoundationViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/30.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "AVFoundationViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PopupView.h"
#import "Masonry.h"
#import "PopUpZgjView.h"

@interface AVFoundationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *alertPopBtn;

@end

@implementation AVFoundationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"===%@=适应尺寸===========",NSStringFromCGSize(_alertPopBtn.intrinsicContentSize));
}

#pragma mark  - 音频

#pragma mark 音效
void soundCompleteCallback(SystemSoundID soundID,void * clientData)
{
    NSLog(@"播放完成...");
}

/**
 *  System Sound Service是一种简单、底层的声音播放服务
 *  限制:1.音频播放时间不能超过30s   2.数据必须是pcm或者IMA4格式 3.音频文件必须打包成.caf、.aif、.wav中的一种（注意这是官方文档的说法，实际测试发现一些.mp3也可以播放）
 */
- (void)playSoundEffect:(NSString *)name
{
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:audioFile];
    //1.获取系统声音id
    SystemSoundID soundId = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundId);
    AudioServicesAddSystemSoundCompletion(soundId, NULL, NULL, soundCompleteCallback, NULL);
}

- (IBAction)btnAction:(UIButton *)sender
{
//    PopupView *view = [[[NSBundle mainBundle] loadNibNamed:@"PopupView" owner:nil options:nil] lastObject];
    
    PopUpZgjView *view = [[[NSBundle mainBundle] loadNibNamed:@"PopUpZgjView" owner:nil options:nil] lastObject];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:view];
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow);
    }];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

//
//  UIApplication+BackgroundRunning.m
//  oapim
//
//  Created by Z.F on 14-4-22.
//  Copyright (c) 2014年 jsmcc.yfzx. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>

@interface AudioService : NSObject

+(BOOL) isGoingToStop;

+(BOOL) isStop;

+(void) pauseAudioService;//暂停后，app任有cpu使用

+(void) startAudioService;

+(void) stopAudioService;//停止后，app进入完全后台状态，没有CPU使用

+(void) clearStaticVariables;//清理类变量

@end


@interface AudioServiceDelegate : NSObject<AVAudioPlayerDelegate>

-(void) applicationDidEnterBackground;

-(void) applicationWillEnterForeground;

@end



#import "UIApplication+BackgroundRunning.h"

static int enableLongTimes = 0;

static NSString* mlockObj = @"mylockObj";

@implementation UIApplication (BackgroundRunning)


-(void) enableLongTimeBackgoundRunning{
    
    @synchronized(mlockObj){
        if (enableLongTimes==0) {
            [AudioService startAudioService];
        }
        enableLongTimes++;
//        NSLog(@"可以长期运行数目：%d",enableLongTimes);
    }
    
    
}

-(void) disableLongTimeBackgroundRunning
{
    @synchronized(mlockObj){
        enableLongTimes--;
        if (enableLongTimes==0) {
            [AudioService stopAudioService];
            [AudioService clearStaticVariables];
        }
//        NSLog(@"可以长期运行数目__：%d",enableLongTimes);
    }
}

-(BOOL) isDisableLongTimeBackgroundRunning{
    return [AudioService isStop];
}

-(BOOL) isGoingToDisableLongTimeBackgroundRunning{
    return [AudioService isGoingToStop];
}
@end


//#import "LOG.h"
//#import "Constants.h"
//#import "AppInfo.h"
//#import "SensorService.h"
#import <CoreAudio/CoreAudioTypes.h>

typedef struct WAVE{
    short wFormatTag; //编码格式，包括WAVE_FORMAT_PCM，WAVEFORMAT_ADPCM等
    short nChannels; //声道数，单声道为1，双声道为2
    int nSamplesPerSec; //采样频率
    int nAvgBytesPerSec; //每秒的数据量
    short nBlockAlign; //块对齐
    short wBitsPerSample; //WAVE文件的采样大小
    short cbSize;
} WAVEFORMATEX, *PWAVEFORMATEX;


static const BOOL WAV = YES;
static NSURL* mp3;
static const float VOLUME = 0.0;
static const int AUDIO_PLAY_TIME = 1;//s  一天24小时只需要播放1个小时的音乐即可
static const float AUDIO_REPLAY_TIME = 60.0;//s
static const int AUDIO_REPLAY_DIVISION_TIMES = 6;


static AVAudioPlayer* audioPlayer;//后台播放音频服务

static UIBackgroundTaskIdentifier bgTask;
static BOOL SLEEP;//是否应该进入后台休眠
static BOOL REAL_SLEEP;//真实休眠，已audiostop为准
static AVAudioSession* audioSession;


typedef void (^RestartAudioBlock)(void);
//后台保持线程，用于在停止音乐之后保持后台线程运行一段时间
static RestartAudioBlock restartAudioBlock;
static NSNumber* restartAudioBlockCommitCount; //重启block提交的次数

static int startCount = 0;

static AudioServiceDelegate* delegate;


@implementation AudioService


+(void) clearStaticVariables{//清理类变量
    
    mp3 = nil;
    [audioPlayer stop];
    audioPlayer = nil;
    
    bgTask = UIBackgroundTaskInvalid;
    SLEEP = NO;//是否应该进入后台休眠
    REAL_SLEEP = NO;//真实休眠，已audiostop为准
    
    restartAudioBlock = nil;
    startCount = 0;
    
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:delegate];
    delegate = nil;
}

+(BOOL) isGoingToStop{
    return SLEEP;
}

+(BOOL) isStop{
    return SLEEP&&REAL_SLEEP;
}

+(void) pauseAudioService{//暂停后，app任有cpu使用
    [audioPlayer stop];
}
//停止音乐服务,没有CPU使用
+(void) stopAudioService{
    if (audioPlayer==nil) {
        return;
    }
    @synchronized(audioPlayer){
        [audioPlayer stop];
        SLEEP = YES;//标记将要停止，进入完全后台
    }
}

//重启音乐服务
//每次checkAndStartSensorSerivce都会调用：进入后台、后台重启服务、【进入前台、切换计步服务开关、修改计步服务后台模式】
+(void) startAudioService{

    [AudioService initAudioPlayer];
    [AudioService setupBlock];
    SLEEP = NO;
    
    startCount++;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        //进入后台
        [audioPlayer stop];
        [audioPlayer play];//播放音乐,AUDIO_PLAY_TIME s后自动停止
        double delayInSeconds = AUDIO_PLAY_TIME;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        
        //在主线程的串行队列上执行,Audio停止时提交重启block
        dispatch_after(popTime, dispatch_get_main_queue(), restartAudioBlock);
        
    }else{
        [AudioService pauseAudioService];//前台
    }
    
    
    //注册通知中心，应用进入后台时调用startAudioService
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:delegate];
    [nc addObserver:delegate
           selector:@selector(applicationDidEnterBackground)
               name:UIApplicationDidEnterBackgroundNotification
             object:[UIApplication sharedApplication]];
    
    [nc addObserver:delegate
           selector:@selector(applicationWillEnterForeground)
               name:UIApplicationDidBecomeActiveNotification
             object:[UIApplication sharedApplication]];
}

//初始化播放器
+(void) initAudioPlayer{
    
    if (audioSession == nil) {
        audioSession = [AVAudioSession sharedInstance];
        BOOL RES = [audioSession setCategory:AVAudioSessionCategoryPlayback
                                 withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                       error:nil];
        if (!RES) {
            [audioPlayer stop];
            audioPlayer = nil;
            return;
        }
        
        [audioSession setPreferredSampleRate:8000 error:nil];//设置最低采样率
    }
    BOOL RES2 = [audioSession setActive:YES error:nil];
    if (!RES2) {
        [audioPlayer stop];
        audioPlayer = nil;
        return;
    }
    
    //NSLog(@"rate:%f",audioSession.sampleRate);
    
    if (audioPlayer == nil) {//若为空
        if (mp3 == nil) {
            mp3 = [[NSBundle mainBundle] URLForResource:@"audio2" withExtension:@"m4a"];
        }
        
        if (delegate == nil) {
            delegate = [[AudioServiceDelegate alloc] init];
        }
        
        audioPlayer = WAV?[[AVAudioPlayer alloc] initWithData:[AudioService getWavData] error:nil]:[[AVAudioPlayer alloc] initWithContentsOfURL:mp3 error:nil];
        audioPlayer.delegate = delegate;
        [audioPlayer stop];
        [audioPlayer setVolume:VOLUME];
        audioPlayer.numberOfLoops = 0;
    }
    
}


//初始化重启block
+(void) setupBlock{
    if(restartAudioBlock)
        return;
    
    restartAudioBlockCommitCount = @0;
    restartAudioBlock = ^{
        @synchronized(restartAudioBlockCommitCount){
            if ([restartAudioBlockCommitCount intValue]!=0){
//                [LOG LOGD:[NSString stringWithFormat:@"%d:Already have restart block",startCount]];
                return ;
            }
            
            UIApplication* app = [UIApplication sharedApplication];
            if (app.applicationState != UIApplicationStateBackground)
                return;
            
            bgTask = [app beginBackgroundTaskWithName:@"restartAudioBGTask"
                                    expirationHandler:^{
                                        NSLog(@"time out");
                                        [app endBackgroundTask:bgTask];
                                        bgTask = UIBackgroundTaskInvalid;
                                    }
                      ];
            // Start the long-running task and return immediately.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                REAL_SLEEP = NO;//只要这个block在执行，就没有真正进入后台
                
                int j = AUDIO_REPLAY_DIVISION_TIMES;
                int i = j;
                while (i-->0 && !SLEEP) {
                    [NSThread sleepForTimeInterval:AUDIO_REPLAY_TIME/j];//sleep 2 minutes
                    //降低传感器采样精度
//                    [SensorService toLowSensity];
                }
                
                
                restartAudioBlockCommitCount = @0;
                if (!SLEEP) {
                    //[SensorService log:[NSString stringWithFormat:@"%d:进程重启音乐",startCount]];
                    //[SensorService checkAndStartSensorService];//检查计步服务，
                    [AudioService startAudioService];//重启音乐播放
                }else{
                    REAL_SLEEP = YES;//标记就要真正进入后台了
//                    [LOG LOGD:[NSString stringWithFormat:@"%d:停止AudioService，进入完全后台",startCount]];
                }
                
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
                
            });
            
            restartAudioBlockCommitCount = @1;
            
        }
    };
}


//生成1s长度的空白wav
+(NSData*) getWavData{
    const int sampleRate = 24000;
    int m_WaveHeaderSize = 38;
    int m_WaveFormatSize = 18;
    int m_AudioDataSize = sampleRate*AUDIO_PLAY_TIME;//1024*1024*4;
    //int m_WrittenBytes = 0;
    WAVEFORMATEX m_WaveFormatEx;
    m_WaveFormatEx.wFormatTag=1 ;
    m_WaveFormatEx.nSamplesPerSec=sampleRate;
    m_WaveFormatEx.wBitsPerSample=8;
    m_WaveFormatEx.nChannels=1;
    m_WaveFormatEx.cbSize=0;
    m_WaveFormatEx.nBlockAlign=m_WaveFormatEx.nChannels*(m_WaveFormatEx.wBitsPerSample/8);
    m_WaveFormatEx.nAvgBytesPerSec=m_WaveFormatEx.nSamplesPerSec*m_WaveFormatEx.nBlockAlign;
    
    //
    FILE *m_file;
    NSString* m_csFileName= [NSString stringWithFormat:@"%@/Documents/tmp.wav",NSHomeDirectory()];
    m_file = fopen([m_csFileName UTF8String], "wb");
    //
    fwrite("RIFF", 1, 4, m_file);
    unsigned int Sec=(m_AudioDataSize + m_WaveHeaderSize);
    fwrite(&Sec, 1, sizeof(Sec), m_file);
    fwrite("WAVE", 1, 4, m_file);
    fwrite("fmt ", 1, 4, m_file);
    fwrite(&m_WaveFormatSize, 1, sizeof(m_WaveFormatSize), m_file);
    fwrite(&m_WaveFormatEx.wFormatTag, 1, sizeof(m_WaveFormatEx.wFormatTag), m_file);
    fwrite(&m_WaveFormatEx.nChannels, 1, sizeof(m_WaveFormatEx.nChannels), m_file);
    fwrite(&m_WaveFormatEx.nSamplesPerSec, 1, sizeof(m_WaveFormatEx.nSamplesPerSec), m_file);
    fwrite(&m_WaveFormatEx.nAvgBytesPerSec, 1, sizeof(m_WaveFormatEx.nAvgBytesPerSec), m_file);
    fwrite(&m_WaveFormatEx.nBlockAlign, 1, sizeof(m_WaveFormatEx.nBlockAlign), m_file);
    fwrite(&m_WaveFormatEx.wBitsPerSample, 1, sizeof(m_WaveFormatEx.wBitsPerSample), m_file);
    fwrite(&m_WaveFormatEx.cbSize, 1, sizeof(m_WaveFormatEx.cbSize), m_file);
    fwrite("data", 1, 4, m_file);
    fwrite(&m_AudioDataSize, 1, sizeof(m_AudioDataSize), m_file);
    
    char Data[m_AudioDataSize];
    for (int i = 0; i<m_AudioDataSize; i++) {
        Data[i] = 0;
    }
    //new char[1024*1024*4];
    fwrite(Data, 1, m_AudioDataSize, m_file);
    fclose(m_file);
    
    NSFileHandle* handler = [NSFileHandle fileHandleForReadingAtPath:m_csFileName];
    NSData* data = [handler availableData];
    [handler closeFile];
    [[NSFileManager defaultManager] removeItemAtPath:m_csFileName error:nil];
    return data;
}

@end




@implementation AudioServiceDelegate
-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //[self performSelectorOnMainThread:@selector(inActiveAudioSession) withObject:nil waitUntilDone:YES];
    [self inActiveAudioSession];
}

-(void) inActiveAudioSession{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}
-(void) audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [player stop];
    NSLog(@"audio interrupt");
}

-(void) audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    
    if (flags == AVAudioSessionInterruptionOptionShouldResume) {
        NSLog(@"audio interrupt end");
    }
}

-(void) applicationDidEnterBackground{
    if (enableLongTimes>0) {
        [AudioService startAudioService];
    }
    
}

-(void) applicationWillEnterForeground{
    if (enableLongTimes>0) {
        [AudioService startAudioService];
    }
    
}


@end
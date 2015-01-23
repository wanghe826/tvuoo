//
//  Singleton.m
//  NewTvuoo
//
//  Created by xubo on 9/19 Friday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
//@synthesize switcher;
@synthesize sdkInfoList;

@synthesize tvType;

@synthesize updateInfo;
@synthesize width_rate;
@synthesize height_rate;
@synthesize tvInfoList;
@synthesize myDelegate;
@synthesize myConnDelegate;
@synthesize myStartGameDelegate;
@synthesize myBreakDownDelegate;
@synthesize myExitGameDelegate;
@synthesize mySdkBreakDownDelegate;
@synthesize myAddTvInfoOrSdk;

@synthesize conn_statue;    //0 没有发现连接   1 发现连接    2 连接成功
@synthesize current_tvInfo;
@synthesize current_sdkTvInfo;
@synthesize current_tv;
@synthesize current_sdk;
@synthesize tag;
@synthesize viewController;

@synthesize sdkArray;       //存储sdk游戏列表
@synthesize tvArray;        //存储普通可连接电视列表
@synthesize isInProtrait;

- (void) connSuc: (NSData*)data
{
    NSObject* object = (NSObject*)self.myDelegate;
    
    if([self.myConnDelegate respondsToSelector:@selector(connSuccess:)])
    {
        [object performSelectorOnMainThread:@selector(connSuccess:) withObject:data waitUntilDone:YES];
    }
}

- (void) initWithData
{
//    NSUserDefaults* defaluts = [NSUserDefaults standardUserDefaults];
//    self.switcher = [defaluts objectForKey:@"switcher"];
    tvInfoList = [[NSMutableArray alloc] init];
    sdkInfoList = [[NSMutableArray alloc] init];
    self.current_tvInfo = [[TvInfoDetail alloc] init];
    self.current_tv = [[TvInfo alloc] init];
    conn_statue = 0;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.isVoiceOn = [defaults objectForKey:@"voiceFlag"];
    self.isValidateOn = [defaults objectForKey:@"validateFlag"];
    self.isInProtrait = NO;                 //是否处于横屏操作模式; 默认处于横屏模式
    self.tvType = 0;
    
    NSMutableArray* tvArry = [[NSMutableArray alloc] init];
    self.tvArray = tvArry;
    [tvArry release];
    
    NSMutableArray* sdkArry = [[NSMutableArray alloc] init];
    self.sdkArray = sdkArry;
    [sdkArry release];
//    self.switcher = [[Switcher alloc] init];
}

+ (Singleton*) getSingle
{
    static Singleton* single = nil;
    @synchronized(self)
    {
        if(single == nil)
        {
            single = [[self alloc] init];
            [single initWithData];
        }
    }
    return single;
}

- (id) init
{
    if(self = [super init])
    {
    }
    return self;
}

- (void) dealloc
{
    self.updateInfo = nil;
    [tvInfoList release];
    [sdkInfoList release];
    [super dealloc];
}
@end

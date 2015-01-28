//
//  LordViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/4 星期四.
//  Copyright (c) 2014年 wap3. All rights reserved.
//
#import "ClearMemoryViewController.h"
#import "Singleton.h"
#import "AppDelegate.h"
#import "QuickConnViewController.h"
#import "LordViewController.h"
#import "NullMouseViewController.h"
#import "KeyPadViewController.h"
#import "DEFINE.h"
#import "NoConnViewController.h"
#import "JiejiViewController.h"
#import "AboutViewController.h"
#import "PSPViewController.h"
#import "PSPViewController.h"
#import "HongbaijiViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"
#import "SettingView.h"
#import "AllUrl.h"
#import "ParseJson.h"
#import "DXAlertView.h"
//#import "UIAlertView+Completion.h"

@interface LordViewController ()

@end
@implementation LordViewController
@synthesize connVC;
@synthesize connIV;
@synthesize timer;
@synthesize nLabel;
@synthesize searchBtn;
@synthesize w_rate;
@synthesize h_rate;
@synthesize tvArray;

@synthesize sdkArray;

@synthesize hintIv;
@synthesize single;
@synthesize schLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        NSMutableArray* tvList = [[NSMutableArray alloc] init];
        self.tvArray = tvList;
        [tvList release];
        NSMutableArray* sdkList = [[NSMutableArray alloc] init];
        self.sdkArray = sdkList;
        [sdkList release];
        self.view.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
    }
    return self;
}


#pragma tvInfo 传入的tvInfo对象（发现SDK游戏）
- (void) startSDKGame:(TvInfo*)tvInfo
{
    __block UIImage* image = nil;
    __block DXAlertView* alert = nil;
    if(image == nil)
    {
        image = [UIImage imageNamed:@"tb_morenren2.png"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        alert = [[DXAlertView alloc] initWithTitle:@"发现SDK游戏" contentImageUrl:@"" leftButtonTitle:@"启动游戏" rightButtonTitle:@"取消"];
        [alert show];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(8);
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert removeFromSuperview];
            });
        });
        alert.leftBlock = ^() {
            NSLog(@"启动游戏11111111");
            [self getStartSdk];
        };
        alert.rightBlock = ^() {
            NSLog(@"right button clicked");
        };
        alert.dismissBlock = ^() {
            NSLog(@"Do something interesting after dismiss block");
        };
        
    });
    _sdkGameTvInfo = tvInfo;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableString* url = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] gameInfoUrl]];
        [url appendString:[NSString stringWithFormat:@"?gamepkg=%@",tvInfo.pkgName]];
        GameInfo* gameInfo = [ParseJson createGameInfoFromJson:url];
        if(gameInfo != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(alert != nil)
                {
                    [alert setGameLabel:gameInfo.name];
                    [alert setImageUrl:gameInfo.iconUrl];
                    [url release];
                }
            });
        }
    });

    if(alert != nil)
    {
        [alert release];
        alert = nil;
    }
}

- (void) getStartSdk
{
    //启动游戏
    //        TvInfo* tvInfo = (TvInfo*)alertView.tag;
    TvInfo* tvInfo = _sdkGameTvInfo;
    NSLog(@"开始启动dddddddd");
    if(tvInfo != nil)
    {
        NSLog(@"tvinfo地址是：%p", tvInfo);
        NSLog(@"name: %@", tvInfo.pkgName);
        NSMutableString* url = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] gameInfoUrl]];
        [url appendString:@"?gamepkg="];
        [url appendString:tvInfo.pkgName];
        
        _startSdk = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_startSdk];
        [self.view bringSubviewToFront:_startSdk];
        _startSdk.delegate = self;
        _startSdk.labelText = @"正在启动SDK游戏，请稍后...";
        [_startSdk show:YES];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            GameInfo* gameInfo = [ParseJson createGameInfoFromJson:url];
            if(gameInfo != nil)
            {
                self.single.tvType = 2;
                connectServer(tvInfo.tvIp, tvInfo.tvServerport);
            }
            else
            {
                NSLog(@"没有连接");
            }
        });
        [url release];
    }
}

#pragma handle 电视启动了某个游戏
//- (void) gotoHandle:(NSNotification*)notification
- (void) gotoHandle:(NSDictionary *)dic
{
//    NSDictionary* dic = [notification userInfo];
    NSMutableString* url = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] gameInfoUrl]];
    [url appendString:@"?gamepkg="];
    [url appendString:[dic objectForKey:@"pkg"]];
    
    int limit = [[dic objectForKey:@"limit"] intValue];
    int act = [[dic objectForKey:@"act"] intValue];
    switch (act)
    {
        case 1:                     //启动安卓游戏的手柄
        {
            if(limit == 0)          //启动的是sdk游戏， 直接返回
            {
                [url release];
                return;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                GameInfo* gameInfo = [ParseJson createGameInfoFromJson:url];
                if(gameInfo != nil)
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        MouseControlViewController* mouseControlVC = [[MouseControlViewController alloc] initWithNibName:@"MouseControlViewController" bundle:nil];
                        mouseControlVC.currentGameInfo = gameInfo;
                        [self.navigationController presentViewController:mouseControlVC animated:NO completion:nil];
                        [mouseControlVC release];
                    });
                }
            });
            break;
        }
        case 2:                     //启动红白机游戏的手柄
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                HongbaijiViewController* hongbaiVc = [[HongbaijiViewController alloc] initWithNibName:@"HongbaijiViewController" bundle:nil];
                hongbaiVc.gameParam = limit;
                [self.navigationController presentViewController:hongbaiVc animated:NO completion:nil];
                [hongbaiVc release];
            });
            break;
        }
        case 3:                     //启动接机游戏的手柄
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                JiejiViewController* jiejiVc = [[JiejiViewController alloc] initWithNibName:@"JiejiViewController" bundle:nil];
                [self.navigationController presentViewController:jiejiVc animated:NO completion:nil];
                [jiejiVc release];
            });
            break;
        }
        case 4:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                PSPViewController* pspVc = [[PSPViewController alloc] initWithNibName:@"PSPViewController" bundle:nil];
                [self.navigationController presentViewController:pspVc animated:NO completion:nil];
                [pspVc release];
            });
            break;
        }
        default:
            break;
    }
    [url release];
}


#pragma callback 连接异常断开了
- (void) disconnectedWithTv
{
    NSLog(@"LordView 的 回调");
    //    int iP = [ip intValue];
    //    const char* disConnIp = parseIp(iP);
    //    NSString* str = [NSString stringWithFormat:@"%s", disConnIp];
    if([self.single.tvArray count] != 0)
    {
        self.single.conn_statue = 1;
        self.schLabel.text = @"发现可连接设备";
    }
    else
    {
        self.single.conn_statue = 0;
    }
    
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"很抱歉已经断开连接, 请重连!";
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:5];
    [hud release];
    return;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self];
    [_connectTvTimer invalidate];
    [self.timer invalidate];
//    self.single.myDelegate = nil;
    if(_upgradeAlertView != nil)
    {
        [_upgradeAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //需要全局通知的notification
    self.single.myBreakDownDelegate = self;
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(disconnectedWithTv) name:@"breakDown" object:nil];
//    [notification addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
//    [notification addObserver:self selector:@selector(findSDKGame:) name:@"findSDK" object:nil];
    
    if(_upgradeAlertView != nil)
    {
        [_upgradeAlertView show];
    }
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(rotateImage) userInfo:nil repeats:YES];
    
    if(self.single.conn_statue == 0)
    {
        schLabel.text = @"正在搜索设备";
        self.nLabel.hidden = YES;
        self.hintIv.hidden = YES;
        if(self.timer != nil)
        {
//            if(![self.timer isValid])
            [self.timer fire];
            NSLog(@"self.timer不是空!");
        }
        else
        {
            NSLog(@"self.time是空得！");
        }
    }
    else if(self.single.conn_statue == 1)
    {
        self.schLabel.text = @"发现可连接设备";
        self.nLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[single.tvInfoList count]];
        if(self.timer != nil)
        {
            [self.timer invalidate];
        }
        self.nLabel.hidden = NO;
        self.hintIv.hidden = NO;
    }
    else
    {
        if(self.timer != nil)
        {
            [self.timer invalidate];
        }
        
        schLabel.text = single.current_tv.tvName;
        self.nLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[single.tvInfoList count]];
        self.nLabel.hidden = YES;
        self.hintIv.hidden = YES;
    }

    
    if(self.single.conn_statue == 0)
    {
//        self.connIV.transform = CGAffineTransformIdentity;
        [self.connIV setImage:[UIImage imageNamed:@"zy_sousuo.png"]];
        [self.timer fire];
    }
    else if(self.single.conn_statue == 1)
    {
//        self.connIV.transform = CGAffineTransformIdentity;
        [self.connIV setImage:[UIImage imageNamed:@"zy_faxian.png"]];
    }
    else
    {
        self.connIV.transform = CGAffineTransformIdentity;
        [self.connIV setImage:[UIImage imageNamed:@"zy_lianjieok.png"]];
    }
    self.connIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.connIV];
    
    
    
    [self.searchBtn addTarget:self action:@selector(pressSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBtn];
    if(self.single.conn_statue == 0)
    {
        [self.searchBtn setTitle:@"搜不到?" forState:UIControlStateNormal];
    }
    else if(self.single.conn_statue == 1)
    {
        [self.searchBtn setTitle:@"开始连接" forState:UIControlStateNormal];
    }
    else
    {
        [self.searchBtn setTitle:@"更换设备" forState:UIControlStateNormal];
    }
    
    
    [self.view addSubview:self.hintIv];
    [self.view addSubview:self.nLabel];
    
    
    [self.view addSubview:schLabel];
    
    
    //定时器， 及时发现可用的电视连接
    _connectTvTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateAvalibleTv) userInfo:nil repeats:YES];
    [_connectTvTimer fire];

}



- (void)addJianTou
{
    UIImageView *iv1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_jiantou.png"]];
    iv1.frame = CGRectMake(0, 385, 31*w_rate, 18*h_rate);
    iv1.center = CGPointMake(681*w_rate, 456*h_rate+20);
    [self.view addSubview:iv1];
    
    UIImageView *iv2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_jiantou.png"]];
    iv2.frame = CGRectMake(0, 385, 31*w_rate, 18*h_rate);
    iv2.center = CGPointMake(681*w_rate, 596*h_rate+20);
    [self.view addSubview:iv2];

//    if(self.single.switcher.tvu_showgame_switch != 0)
    if([[AllUrl getInstance] tvu_showgame_switch] == 1)
    {
        UIImageView *iv3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_jiantou.png"]];
        iv3.frame = CGRectMake(0, 385, 31*w_rate, 18*h_rate);
        iv3.center = CGPointMake(681*w_rate, 736*h_rate+20);
        [self.view addSubview:iv3];
        [iv3 release];
    }
    [iv1 release];
    [iv2 release];
    
}
- (void)addControl
{
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(30*w_rate, 828*h_rate+20, 200*w_rate, 175*h_rate);
    [btn1.layer setCornerRadius:8];
    btn1.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:153.0/255.0 blue:205.0/255.0 alpha:1.0];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(goRemoteControl) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame = CGRectMake(250*w_rate, 828*h_rate+20, 200*w_rate, 175*h_rate);
    [btn2.layer setCornerRadius:8];
    btn2.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:153.0/255.0 blue:205.0/255.0 alpha:1.0];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(goMouseControl) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn3.frame = CGRectMake(30*w_rate, 1021*h_rate+20, 200*w_rate, 175*h_rate);
    [btn3.layer setCornerRadius:8];
    btn3.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:153.0/255.0 blue:205.0/255.0 alpha:1.0];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(goNullMouseControl) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn4.frame = CGRectMake(250*w_rate, 1021*h_rate+20, 200*w_rate, 175*h_rate);
    [btn4.layer setCornerRadius:8];
    btn4.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:153.0/255.0 blue:205.0/255.0 alpha:1.0];
    [self.view addSubview:btn4];
    [btn4 addTarget:self action:@selector(goKeyPadControl) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn5.frame = CGRectMake(468*w_rate, 828*h_rate+20, 225*w_rate, 370*h_rate);
    [btn5.layer setCornerRadius:8];
    btn5.backgroundColor = [UIColor colorWithRed:109.0/255.0 green:208.0/255.0 blue:36.0/255.0 alpha:1.0];
    [btn5 addTarget:self action:@selector(goClearMemoryControl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    UIImageView* iv1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_yaokong.png"]];
    iv1.frame = CGRectMake(0, 0, 92*w_rate, 80*h_rate);
//    iv1.center = btn1.center;
    [self.view addSubview:iv1];
    
    UIImageView* iv2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_shubiao.png"]];
    iv2.frame = CGRectMake(0, 0, 92*w_rate, 80*h_rate);
//    iv2.center = btn2.center;
    [self.view addSubview:iv2];
    
    UIImageView* iv3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_kongshu.png"]];
    iv3.frame = CGRectMake(0, 0, 92*w_rate, 80*h_rate);
//    iv3.center = btn3.center;
    [self.view addSubview:iv3];
    
    UIImageView* iv4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_jianpan.png"]];
    iv4.frame = CGRectMake(0, 0, 92*w_rate, 80*h_rate);
//    iv4.center = btn4.center;
    [self.view addSubview:iv4];
   
    UIImageView* iv5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_jiasu.png"]];
    iv5.frame = CGRectMake(0, 0, 117*w_rate, 168*h_rate);
//    iv5.center = btn5.center;
    [self.view addSubview:iv5];
    
    UILabel *label1, *label2, *label3, *label4, *label5;
    if(iPhone5)
    {
//        if(self.single.switcher.tvu_showgame_switch != 0)
        if([[AllUrl getInstance] tvu_showgame_switch] == 1)
        {
            btn1.frame = CGRectMake(30*w_rate, 828*h_rate+20, 200*w_rate, 175*h_rate);
            btn2.frame = CGRectMake(250*w_rate, 828*h_rate+20, 200*w_rate, 175*h_rate);
            btn3.frame = CGRectMake(30*w_rate, 1021*h_rate+20, 200*w_rate, 175*h_rate);
            btn4.frame = CGRectMake(250*w_rate, 1021*h_rate+20, 200*w_rate, 175*h_rate);
            btn5.frame = CGRectMake(468*w_rate, 828*h_rate+20, 225*w_rate, 370*h_rate);
            iv1.center = btn1.center;
            iv2.center = btn2.center;
            iv3.center = btn3.center;
            iv4.center = btn4.center;
            iv5.center = btn5.center;
            
            
            
            label1 = [[UILabel alloc] initWithFrame:CGRectMake(35,400,100,100)];
            label2 = [[UILabel alloc] initWithFrame:CGRectMake(147,400,100,100)];
            label3 = [[UILabel alloc] initWithFrame:CGRectMake(48,480,100,100)];
            label4 = [[UILabel alloc] initWithFrame:CGRectMake(147,480,100,100)];
            label5 = [[UILabel alloc] initWithFrame:CGRectMake(240, 460, 100, 100)];
        }
        else
        {
            btn1.frame = CGRectMake(30*w_rate, 828*h_rate+20-65, 200*w_rate, 175*h_rate);
            btn2.frame = CGRectMake(250*w_rate, 828*h_rate+20-65, 200*w_rate, 175*h_rate);
            btn3.frame = CGRectMake(30*w_rate, 1021*h_rate+20-65, 200*w_rate, 175*h_rate);
            btn4.frame = CGRectMake(250*w_rate, 1021*h_rate+20-65, 200*w_rate, 175*h_rate);
            btn5.frame = CGRectMake(468*w_rate, 828*h_rate+20-65, 225*w_rate, 370*h_rate);
            iv1.center = btn1.center;
            iv2.center = btn2.center;
            iv3.center = btn3.center;
            iv4.center = btn4.center;
            iv5.center = btn5.center;
            
            
            
            label1 = [[UILabel alloc] initWithFrame:CGRectMake(35,400-65,100,100)];
            label2 = [[UILabel alloc] initWithFrame:CGRectMake(147,400-65,100,100)];
            label3 = [[UILabel alloc] initWithFrame:CGRectMake(48,480-65,100,100)];
            label4 = [[UILabel alloc] initWithFrame:CGRectMake(147,480-65,100,100)];
            label5 = [[UILabel alloc] initWithFrame:CGRectMake(240, 460-65, 100, 100)];
        }
    }
    else if(iPhone4)
    {
//        if(self.single.switcher.tvu_showgame_switch != 0)
        if([[AllUrl getInstance] tvu_showgame_switch] == 1)
        {
            btn1.frame = CGRectMake(30*w_rate, 828*h_rate+20, 200*w_rate, 175*h_rate);
            btn2.frame = CGRectMake(250*w_rate, 828*h_rate+20, 200*w_rate, 175*h_rate);
            btn3.frame = CGRectMake(30*w_rate, 1021*h_rate+20, 200*w_rate, 175*h_rate);
            btn4.frame = CGRectMake(250*w_rate, 1021*h_rate+20, 200*w_rate, 175*h_rate);
            btn5.frame = CGRectMake(468*w_rate, 828*h_rate+20, 225*w_rate, 370*h_rate);
            iv1.center = btn1.center;
            iv2.center = btn2.center;
            iv3.center = btn3.center;
            iv4.center = btn4.center;
            iv5.center = btn5.center;
            
            label1 = [[UILabel alloc] initWithFrame:CGRectMake(35,340,100,100)];
            label2 = [[UILabel alloc] initWithFrame:CGRectMake(147,340,100,100)];
            label3 = [[UILabel alloc] initWithFrame:CGRectMake(48,410,100,100)];
            label4 = [[UILabel alloc] initWithFrame:CGRectMake(147,410,100,100)];
            label5 = [[UILabel alloc] initWithFrame:CGRectMake(235,400,100,100)];
        }
        else
        {
            btn1.frame = CGRectMake(30*w_rate, 828*h_rate+20-50, 200*w_rate, 175*h_rate);
            btn2.frame = CGRectMake(250*w_rate, 828*h_rate+20-50, 200*w_rate, 175*h_rate);
            btn3.frame = CGRectMake(30*w_rate, 1021*h_rate+20-50, 200*w_rate, 175*h_rate);
            btn4.frame = CGRectMake(250*w_rate, 1021*h_rate+20-50, 200*w_rate, 175*h_rate);
            btn5.frame = CGRectMake(468*w_rate, 828*h_rate+20-50, 225*w_rate, 370*h_rate);
            iv1.center = btn1.center;
            iv2.center = btn2.center;
            iv3.center = btn3.center;
            iv4.center = btn4.center;
            iv5.center = btn5.center;
            
            
            
            label1 = [[UILabel alloc] initWithFrame:CGRectMake(35,340-50,100,100)];
            label2 = [[UILabel alloc] initWithFrame:CGRectMake(147,340-50,100,100)];
            label3 = [[UILabel alloc] initWithFrame:CGRectMake(48,410-50,100,100)];
            label4 = [[UILabel alloc] initWithFrame:CGRectMake(147,410-50,100,100)];
            label5 = [[UILabel alloc] initWithFrame:CGRectMake(235,400-50,100,100)];
        }
    }
//    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(35,400,100,100)];
    label1.text = @"电视遥控器";
    [label1 setFont:[UIFont fontWithName:@"Courier New" size:10]];
    [label1 setTextColor:[UIColor whiteColor]];
    
//    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(147,400,100,100)];
    label2.text = @"鼠标";
    [label2 setFont:[UIFont fontWithName:@"Courier New" size:10]];
    [label2 setTextColor:[UIColor whiteColor]];
//    label2.center = CGPointMake(btn2.center.x/2, btn2.center.y/2);
    [self.view addSubview:label2];
    
//    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(48,480,100,100)];
    label3.text = @"空鼠";
    [label3 setFont:[UIFont fontWithName:@"Courier New" size:10]];
    [label3 setTextColor:[UIColor whiteColor]];
    
//    UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(147,480,100,100)];
    label4.text = @"键盘";
    [label4 setFont:[UIFont fontWithName:@"Courier New" size:10]];
    [label4 setTextColor:[UIColor whiteColor]];
    
//    UILabel* label5 = [[UILabel alloc] initWithFrame:CGRectMake(235,460,100,100)];
    label5.text = @"加速电视";
    [label5 setFont:[UIFont fontWithName:@"Courier New" size:10]];
    [label5 setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:label4];
    [self.view addSubview:label5];
    if(label1 != nil && label2!=nil && label3!=nil && label4!=nil && label5!=nil)
    {
        [label1 release];
        [label2 release];
        [label3 release];
        [label4 release];
        [label5 release];
    }
    [iv1 release];
    [iv2 release];
    [iv3 release];
    [iv4 release];
    [iv5 release];
}
- (void)addButton
{
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.tag = 21;
    btn1.frame = CGRectMake(0, 386*h_rate+20, 320, 140*h_rate);
    [btn1 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(142*w_rate, 100, 100, 50)];
    label1.text = @"玩转电视游戏";
    [label1 sizeToFit];
    label1.center = CGPointMake(282*w_rate, 456*h_rate+20);
    [self.view addSubview:label1];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.tag = 22;
    btn2.frame = CGRectMake(0, 526*h_rate+20, 320, 140*h_rate);
    [btn2 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(142*w_rate, 100, 100, 50)];
    label2.text = @"同步安装软件";
    [label2 sizeToFit];
    label2.center = CGPointMake(282*w_rate, 600*h_rate+20);
    [self.view addSubview:label2];
    [label2 release];

    if([[AllUrl getInstance] tvu_showgame_switch] == 1)
    {
        UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn3.tag = 23;
        btn3.frame = CGRectMake(0, 666*h_rate+20, 320, 140*h_rate);
        [btn3 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn3];
    
        UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(142*w_rate, 100, 100, 50)];
        label3.text = @"热门手游专区";
        [label3 sizeToFit];
        label3.center = CGPointMake(282*w_rate, 740*h_rate+20);
        [self.view addSubview:label3];
        [label3 release];
    }
    
    
    UIImageView* uv1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_dians.png"]];
    uv1.frame = CGRectMake(30*w_rate, 500, 84*w_rate, 84*h_rate);
    uv1.center = CGPointMake(72*w_rate,456*h_rate+20);
    [self.view addSubview:uv1];
    
    
    UIImageView* uv2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_tongbu.png"]];
    uv2.frame = CGRectMake(30*w_rate, 230, 84*w_rate, 84*h_rate);
    uv2.center = CGPointMake(72*w_rate, 596*h_rate+20);
    [self.view addSubview:uv2];
    

//    if(self.single.switcher.tvu_showgame_switch != 0)
    if([[AllUrl getInstance] tvu_showgame_switch] == 1)
    {
        UIImageView* uv3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_remen.png"]];
        uv3.frame = CGRectMake(30*w_rate, 300, 84*w_rate, 84*h_rate);
        uv3.center = CGPointMake(72*w_rate, 736*h_rate+20);
        [self.view addSubview:uv3];
        [uv3 release];
    }
    
    [label1 release];
    [uv1 release];
    [uv2 release];
}

- (void) pressBtn:(id)sender
{
    NSInteger tag = [(UIButton*)sender tag];
    switch(tag)
    {
        case 21:
        {
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.5];
//            [animation setType:kCATransitionFade]; //淡入淡出
//            [animation setType:@"cube"];
            [animation setType:@"suckEffect"];
            [animation setSubtype:kCATransitionFromLeft];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
            
            [self.navigationController.view.layer addAnimation:animation forKey:nil];
            PlayTvGameViewController* playTvGameViewController = [[PlayTvGameViewController alloc] initWithNibName:@"PlayTvGameViewController" bundle:nil];
            [self.navigationController pushViewController:playTvGameViewController animated:YES];
            [playTvGameViewController release];
            break;
        }
        case 22:
            [self asynInstallApp];
            break;
        case 23:
        {
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.5];
            //            [animation setType:kCATransitionFade]; //淡入淡出
            //            [animation setType:@"cube"];
//            [animation setType:@"suckEffect"];
            [animation setType:@"suckEffect"];
            [animation setSubtype:kCATransitionFromLeft];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
            
            [self.navigationController.view.layer addAnimation:animation forKey:nil];
            HotGameViewController* hotGameViewController = [[HotGameViewController alloc] initWithNibName:@"HotGameViewController" bundle:nil];
            [self.navigationController pushViewController:hotGameViewController animated:YES];
            [hotGameViewController release];
        }
            break;
        default:
            return;
    }
}
- (void)drawLine
{
    UIImageView* lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 526*h_rate+20, 320, 2*h_rate)];
    lineView.backgroundColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
    [self.view addSubview:lineView];
    
    UIImageView* lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 666*h_rate+20, 320, 2*h_rate)];
    lineView1.backgroundColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
    [self.view addSubview:lineView1];
    
//    if(self.single.switcher.tvu_showgame_switch != 0)
    if([[AllUrl getInstance] tvu_showgame_switch] == 1)
    {
        UIImageView* lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 806*h_rate+20, 320, 2*h_rate)];
        lineView2.backgroundColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
        [self.view addSubview:lineView2];
        [lineView2 release];
    }
    
    [lineView release];
    [lineView1 release];
    
}
- (void) pressSearch: (id)sender
{
    if(self.single.conn_statue == 0)
    {
        //搜索不到
        HelpViewController* helpVc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
        [self.navigationController pushViewController:helpVc animated:YES];
        [helpVc release];
    }
    else
    {
        //发现连接， 开始连接
        
        
        [self.navigationController pushViewController:self.connVC animated:YES];
    }
}


- (void) rotateImage
{
    static float radian =0;
    radian += 0.1f;
    self.connIV.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.01f animations:^{
        self.connIV.transform = CGAffineTransformMakeRotation(radian);
    }];
}

- (void)pressMoreBtn
{
    AboutViewController* about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:about animated:NO];
    [about release];
}



- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"hud is 隐藏!");
}

- (void) updateDeviceList
{
    
    for(TvInfo* tvInfo in self.single.tvArray)
    {
        int deltTime = [[NSDate date] timeIntervalSinceDate:tvInfo.date];
        if(abs(deltTime) > 200)
        {
            [self.single.tvArray removeObject:tvInfo];
            break;
        }
    }
    
    for(TvInfo* tvInfo in self.single.sdkArray)
    {
        int deltTime = [[NSDate date] timeIntervalSinceDate:tvInfo.date];
        if(abs(deltTime) > 200)
        {
            [self.single.sdkArray removeObject:tvInfo];
            break;
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _updateDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateDeviceList) userInfo:nil repeats:YES];
    
    NSLog(@"home Path: %@", NSHomeDirectory());
    self.single = [Singleton getSingle];
    self.single.myDelegate = self;
    self.single.mySdkConnDelegate = self;
//    self.single.myConnDelegate = self;
    self.single.myFindSdkGameDelegate = self;
    self.single.myStartGameDelegate = self;
    
    
    self.connVC = [[QuickConnViewController alloc] initWithNibName:@"QuickConnViewController" bundle:nil];

    w_rate = self.single.width_rate;
    h_rate = self.single.height_rate;
    
    self.searchBtn = [[UIButton alloc] init];
    [self.searchBtn setBackgroundColor:[UIColor whiteColor]];
    [self.searchBtn.layer setCornerRadius:3.0];
    [self.searchBtn setTitle:@"搜不到?" forState:UIControlStateNormal];
    [self.searchBtn sizeToFit];
    [self.searchBtn setTitleColor:blueColor forState:UIControlStateNormal];
    if(iPhone4)
    {
        self.searchBtn.frame = CGRectMake(200, 120, 80, 40);
    }
    else
    {
        self.searchBtn.frame = CGRectMake(200, 130, 80, 40);
    }
    
    UIImageView* hint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_tixing.png"]];
    self.hintIv = hint;
    [hint release];
//    self.hintIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zy_tixing.png"]];
    CGFloat x = self.searchBtn.frame.origin.x + 80;
    CGFloat y = self.searchBtn.frame.origin.y;
    self.hintIv.frame = CGRectMake(0, 0, 20, 20);
    self.hintIv.center = CGPointMake(x,y);
    
    self.nLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    self.nLabel.textAlignment = NSTextAlignmentCenter;
    self.nLabel.text = @"0";
    self.nLabel.textColor = [UIColor whiteColor];
    self.nLabel.center = self.hintIv.center;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 386*h_rate)];
    imageView.backgroundColor = [UIColor colorWithRed:24/255.0 green:180/255.0 blue:237/255.0 alpha:1];
    [self.view addSubview:imageView];
    [imageView release];
    
    UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 386*h_rate+20, 320, 824*h_rate)];
    imageView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView2];
    [imageView2 release];
    
    UIImageView* tvuooIV = [[UIImageView alloc] initWithFrame:CGRectMake(30*w_rate, 20*h_rate+20, 260*w_rate, 61*h_rate)];
    tvuooIV.contentMode = UIViewContentModeScaleAspectFill;
    tvuooIV.image = [UIImage imageNamed:@"zy_logo.png"];
    [self.view addSubview:tvuooIV];
    [tvuooIV release];
    
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(659*w_rate, 40*h_rate+20, 40*w_rate, 40*h_rate)];
    [btn1 addTarget:self action:@selector(pressMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"zy_gengduo1.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 release];
    
    
    
    self.connIV = [[UIImageView alloc] initWithFrame:CGRectMake(72*w_rate, 169*h_rate+20, 182*w_rate,182*h_rate)];
    
    //加三个主要按钮
    [self addButton];
    
    //绘制主页的三根线条
    [self drawLine];
    
    [self addControl];
//    ControlView* control = [[ControlView alloc] initWithFrame:CGRectMake(20, 300, 280, 200)];
//    [self.view addSubview:control];
    [self addJianTou];
    
    schLabel = [[UILabel alloc] initWithFrame:CGRectMake(185,105,70,21)];
    schLabel.text = @"正在搜索设备中";
    [schLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    schLabel.textColor = [UIColor whiteColor];
    schLabel.textAlignment = NSTextAlignmentCenter;
    [schLabel sizeToFit];
    
    
//    self.navigationController.navigationBarHidden = YES;  //关闭导航栏
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizerTarget)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    [self updateHint];
}

//更新提示
- (void) updateHint
{
    if(self.single.updateInfo.isNeedUpdate == 1)
    {
        if(self.single.updateInfo.update_model == 1 || self.single.updateInfo.update_model == 2)
        {
            NSLog(@"有新版本 %@", self.single.updateInfo.update_url);
            if([self.single.updateInfo.update_url isEqualToString:@""])
                return;
            NSString* cancelBtnTitle = [[NSString alloc] init];
            if(self.single.updateInfo.update_model == 1)
            {
                cancelBtnTitle = @"暂不升级";
            }
            if(self.single.updateInfo.update_model == 2)
            {
                cancelBtnTitle = @"退出";
            }
            _upgradeAlertView = [[UIAlertView alloc] initWithTitle:self.single.updateInfo.update_title
                                                           message:self.single.updateInfo.update_memo
                                                          delegate:self
                                                 cancelButtonTitle:cancelBtnTitle otherButtonTitles:@"现在升级", nil];
            _upgradeAlertView.tag = 334;
            [self.view addSubview:_upgradeAlertView];
            [_upgradeAlertView show];
            [cancelBtnTitle release];
            
        }
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 334)
    {
        UpdateInfo* updateInfo = [Singleton getSingle].updateInfo;
        if(buttonIndex == 0)
        {
            NSLog(@"暂不升级被按下了");
            if(updateInfo.update_model == 1)
            {
            }
            else if(updateInfo.update_model == 2)
            {
                NSLog(@"退出程序被按下了");
                if(_upgradeAlertView != nil)
                {
                    [_upgradeAlertView release];
                    _upgradeAlertView = nil;
                }
                exit(0);
            }
        }
        if(buttonIndex == 1)
        {
            //跳转到app store中指定的应用
//            NSString *str = [NSString stringWithFormat:
//                             @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
//                             52];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateInfo.update_url]];
            
        }
        [_upgradeAlertView removeFromSuperview];
        if(alertView != nil)
        {
            [_upgradeAlertView release];
            _upgradeAlertView = nil;
        }
        return;
    }
}



#pragma ip 进行连接但连接失败的ip
- (void) connFailed:(int)ip
{
    //连接失败的回调
    NSLog(@"连接SDK失败的回调");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_startSdk != nil)
        {
            [_startSdk removeFromSuperview];
            [_startSdk release];
            _startSdk = nil;
        }
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"启动SDK游戏失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    });
}


#pragma data 连接成功传回来的数据
- (void) connSuccess:(NSData *)data
{
    //连接成功的回调
    NSLog(@"连接SDK成功的回调");
    if(_startSdk != nil)
    {
        [_startSdk removeFromSuperview];
        [_startSdk release];
        _startSdk = nil;
    }
    
    
  
    TvInfo* tvInfo = _sdkGameTvInfo;
//    self.single.current_tv = _sdkGameTvInfo;
    self.single.current_sdk = _sdkGameTvInfo;
    NSMutableString* url = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] gameInfoUrl]];
    [url appendString:@"?gamepkg="];
    [url appendString:tvInfo.pkgName];
    GameInfo* gameInfo = [ParseJson createGameInfoFromJson:url];
    MouseControlViewController* mouseVc = [[MouseControlViewController alloc] initWithNibName:@"MouseControlViewController" bundle:nil];
    mouseVc.currentGameInfo = gameInfo;
    [self.navigationController presentViewController:mouseVc animated:YES completion:nil];
//    [self.navigationController pushViewController:mouseVc animated:YES];
    [mouseVc release];
    [url release];
}

- (void) recognizerTarget
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"cube"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    AboutViewController* about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:about animated:YES];
    [about release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)asynInstallApp          //同步安装软件
{
    TvAppCenterViewController* asynVC = [[TvAppCenterViewController alloc] initWithNibName:@"TvAppCenterViewController" bundle:nil];
    asynVC.quickConn = self.connVC;
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"suckEffect"];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    /*
     animation.type = kCATransitionFade;
     animation.type = kCATransitionPush;
     animation.type = kCATransitionReveal;
     animation.type = kCATransitionMoveIn;
     animation.type = @"cube";
     animation.type = @"suckEffect";
     animation.type = @"oglFlip";
     animation.type = @"rippleEffect";
     animation.type = @"pageCurl";
     animation.type = @"pageUnCurl"; 
     animation.type = @"cameraIrisHollowOpen";
     animation.type = @"cameraIrisHollowClose";
     */
    [self.navigationController pushViewController:asynVC animated:YES];
    [asynVC release];
}



- (void)goRemoteControl         //远程遥控
{
    self.single.tag = 1;
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    if (self.single.conn_statue != 2)
    {
        NoConnViewController* noConnVc = [[NoConnViewController alloc] initWithNibName:@"NoConnViewController" bundle:nil];
        noConnVc.quickConnVc = self.connVC;
        [self.navigationController pushViewController:noConnVc animated:YES];
        [noConnVc release];
    }
    else
    {
        if(self.single.current_tvInfo.canadb==1 || self.single.current_tvInfo.deviceId==2 || (self.single.current_tvInfo.canadb==0 && self.single.current_tvInfo.deviceId==1))
        {
            RemoteControlViewController* remoteControlViewController = [[RemoteControlViewController alloc] initWithNibName:@"RemoteControlViewController" bundle:nil];
            [self.navigationController pushViewController:remoteControlViewController animated:NO];
            [UIView commitAnimations];
            [remoteControlViewController release];
        }
        else
        {
            GetTvStateViewController* rootVc = [[GetTvStateViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:rootVc  animated:YES];
            [rootVc release];
        }
    }
}

- (void)goMouseControl          //鼠标操作
{
    self.single.tag = 2;
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    if (self.single.conn_statue != 2)
    {
        NoConnViewController* noConnVc = [[NoConnViewController alloc] initWithNibName:@"NoConnViewController" bundle:nil];
        noConnVc.quickConnVc = self.connVC;
        [self.navigationController pushViewController:noConnVc animated:YES];
        [noConnVc release];
    }
    else
    {
        if(self.single.current_tvInfo.canadb==1 || self.single.current_tvInfo.deviceId==2)
        {
            CusMouseViewController* customVc = [[CusMouseViewController alloc] initWithNibName:@"CusMouseViewController" bundle:nil];
//            [self.navigationController presentViewController:customVc animated:NO completion:nil];
//            [self presentViewController:customVc animated:NO completion:nil];
            [self.navigationController pushViewController:customVc animated:YES];
            [customVc release];
        }
        else
        {
            GetTvStateViewController* rootVc = [[GetTvStateViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:rootVc  animated:YES];
            [rootVc release];
        }
    }
}

- (void)goNullMouseControl          //手机空鼠
{
    self.single.tag = 3;
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    if(self.single.conn_statue != 2)
    {
        NoConnViewController* noConnVc = [[NoConnViewController alloc] initWithNibName:@"NoConnViewController" bundle:nil];
        noConnVc.quickConnVc = self.connVC;
        [self.navigationController pushViewController:noConnVc animated:YES];
        [noConnVc release];
    }
    else
    {
        if(self.single.current_tvInfo.canadb==1 || self.single.current_tvInfo.deviceId==2)
        {
            NullMouseViewController* nullMouseViewController = [[NullMouseViewController alloc] initWithNibName:@"NullMouseViewController" bundle:nil];
            [self.navigationController pushViewController:nullMouseViewController animated:YES];
            [nullMouseViewController release];
        }
        else
        {
            GetTvStateViewController* rootVc = [[GetTvStateViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:rootVc  animated:YES];
            [rootVc release];
        }
    }
}

- (void)goClearMemoryControl        //电视加速
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    if(self.single.conn_statue != 2)
    {
        NoConnViewController* noConnVc = [[NoConnViewController alloc] initWithNibName:@"NoConnViewController" bundle:nil];
        noConnVc.quickConnVc = self.connVC;
        [self.navigationController pushViewController:noConnVc animated:YES];
        [noConnVc release];
    }
    else
    {
        if(self.single.current_tvInfo.canadb==1 || self.single.current_tvInfo.deviceId==2)
        {
            ClearMemoryViewController* cmVC = [[ClearMemoryViewController alloc] initWithNibName:@"ClearMemory" bundle:nil];
            [self.navigationController pushViewController:cmVC animated:YES];
            [cmVC release];
        }
        else
        {
            GetTvStateViewController* rootVc = [[GetTvStateViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:rootVc  animated:YES];
            [rootVc release];
        }
    }
}

- (void)goKeyPadControl         //键盘
{
    self.single.tag = 4;

    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    if(self.single.conn_statue != 2)
    {
        NoConnViewController* noConnVc = [[NoConnViewController alloc] initWithNibName:@"NoConnViewController" bundle:nil];
        noConnVc.quickConnVc = self.connVC;
        [self.navigationController pushViewController:noConnVc animated:YES];
        [noConnVc release];
    }
    else
    {
        
        if(self.single.current_tvInfo.canadb==1 || self.single.current_tvInfo.deviceId==2)
        {
            KeyPadViewController* keyPadViewController = [[KeyPadViewController alloc] initWithNibName:@"KeyPadViewController" bundle:nil];
            [self.navigationController pushViewController:keyPadViewController animated:YES];
            [keyPadViewController release];
        }
        else
        {
            GetTvStateViewController* rootVc = [[GetTvStateViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:rootVc  animated:YES];
            [rootVc release];
        }
        
    }

}
- (void)dealloc {
    [_updateDeviceTimer invalidate];
    self.sdkArray = nil;
    self.tvArray = nil;
    [super dealloc];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}


// 控制屏幕方向
- (BOOL) shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

//控制状态栏的显隐
- (BOOL) prefersStatusBarHidden
{
//    return YES;       //隐藏
    return NO;          //显示
}


//及时刷新UI----根据可以连接的TV 数量
- (void)updateAvalibleTv
{
    /*
    if([self.single.tvArray count] != 0)
    {
        if([self.timer isValid])
        {
            [self.timer invalidate];
        }
        self.connIV.transform = CGAffineTransformIdentity;
        [self.searchBtn setTitle:@"开始连接" forState:UIControlStateNormal];
        single.conn_statue = 1;
        [self.connIV setImage:[UIImage imageNamed:@"zy_faxian.png"]];
        
        self.nLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[self.tvArray count]];
        [self.view addSubview:self.nLabel];
        self.nLabel.hidden = NO;
        self.hintIv.hidden = NO;
        single.conn_statue = 1;
    }
    else
    {
        if(![self.timer isValid])
        {
            [self.timer fire];
        }
        [self.searchBtn setTitle:@"搜不到" forState:UIControlStateNormal];
        [self.connIV setImage:[UIImage imageNamed:@"zy_sousuo.png"]];
        single.conn_statue = 0;
    }
     */
    if([Singleton getSingle].conn_statue == 0)
    {
//        [self.connIV setImage:[UIImage imageNamed:@"zy_sousuo.png"]];
//        if(![self.timer isValid])
//        {
//            [self.timer fire];
//        }
//        [self.searchBtn setTitle:@"搜不到" forState:UIControlStateNormal];
        
        schLabel.text = @"正在搜索设备";
        self.nLabel.hidden = YES;
        self.hintIv.hidden = YES;
        if(![self.timer isValid])
        {
            [self.timer fire];
        }
        [self.searchBtn setTitle:@"搜不到" forState:UIControlStateNormal];
    }
    else if([Singleton getSingle].conn_statue == 1)
    {
        if([self.timer isValid])
        {
            [self.timer invalidate];
        }
        self.connIV.transform = CGAffineTransformIdentity;
        self.schLabel.text = @"发现可连接设备";
        [self.searchBtn setTitle:@"开始连接" forState:UIControlStateNormal];
        [self.connIV setImage:[UIImage imageNamed:@"zy_faxian.png"]];
        
//        self.nLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[self.tvArray count]];
        self.nLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[[Singleton getSingle].tvArray count]];
        [self.view addSubview:self.nLabel];
        self.nLabel.hidden = NO;
        self.hintIv.hidden = NO;
    }
    else if([Singleton getSingle].conn_statue == 2)
    {
        self.connIV.transform = CGAffineTransformIdentity;
        self.schLabel.text = single.current_tv.tvName;
        [self.searchBtn setTitle:@"更换设备" forState:UIControlStateNormal];
        [self.connIV setImage:[UIImage imageNamed:@"zy_lianjieok.png"]];
        
//        self.nLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[self.tvArray count]];
        [self.nLabel removeFromSuperview];
        self.nLabel.hidden = YES;
        self.hintIv.hidden = YES;
    }
}
 
@end
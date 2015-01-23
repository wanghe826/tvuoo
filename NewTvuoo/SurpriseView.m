//
//  SurpriseView.m
//  NewTvuoo
//
//  Created by xubo on 10/22 Wednesday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "SurpriseView.h"
#import "CommonBtn.h"
#import "DEFINE.h"
#import "ParseJson.h"
#import "GameIntroViewController.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "MouseControlViewController.h"
#import "PSPViewController.h"
#import "AllUrl.h"
#import "MBProgressHUD.h"
@implementation SurpriseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Singleton getSingle].myBreakDownDelegate = self;
}

#pragma callback 连接异常断开了
- (void) disconnectedWithTv
{
    //    int iP = [ip intValue];
    //    const char* disConnIp = parseIp(iP);
    //    NSString* str = [NSString stringWithFormat:@"%s", disConnIp];
    if([[Singleton getSingle].tvArray count] != 0)
    {
        [Singleton getSingle].conn_statue = 1;
    }
    else
    {
        [Singleton getSingle].conn_statue = 0;
    }
    
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"很抱歉已经断开连接, 请重连!";
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:3];
    [hud release];
    return;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
        UIImageView* topIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
        topIv.backgroundColor = blueColor;
        [self.view addSubview:topIv];
        [topIv release];
        
        ReturnBtn* goBackBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        goBackBtn.center = CGPointMake(40, topIv.center.y);
        [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:goBackBtn];
        [goBackBtn release];
        
        UILabel* topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        topTitleLabel.text = @"惊喜即将呈现";
        topTitleLabel.textAlignment = NSTextAlignmentCenter;
        topTitleLabel.textColor = [UIColor whiteColor];
        topTitleLabel.center = topIv.center;
        [self.view addSubview:topTitleLabel];
        [topTitleLabel release];
        
        UIImageView* daojishiIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 320, 250)];
        daojishiIv.image = [UIImage imageNamed:@"daojishi.png"];
        [self.view addSubview:daojishiIv];
        [daojishiIv release];
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
    
}

- (void) gotoHandle:(NSNotification*)notification
{
    NSDictionary* dic = [notification userInfo];
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


- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

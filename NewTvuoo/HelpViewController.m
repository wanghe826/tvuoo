//
//  HelpViewController.m
//  NewTvuoo
//
//  Created by xubo on 11/13 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "HelpViewController.h"
#import "CommonBtn.h"
#import "DEFINE.h"
#import "MouseControlViewController.h"
#import "GameIntroViewController.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "PSPViewController.h"
#import "AllUrl.h"
#import "ParseJson.h"
#import "MBProgressHUD.h"
@interface HelpViewController ()

@end

@implementation HelpViewController

- (void) returnBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* topIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    topIv.backgroundColor = blueColor;
    [self.view addSubview:topIv];
    
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(10, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    
    UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    topLabel.center = CGPointMake(self.view.center.x, retBtn.center.y);
    topLabel.text = @"使用帮助";
    topLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:topLabel];
    [topLabel release];
    
    UILabel* title1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 200, 40)];
    title1.text = @"搜索不到可连接设备";
//    [title1 sizeToFit];
    title1.textColor = [UIColor blackColor];
    [self.view addSubview:title1];
    UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, title1.center.y+25, 280, 1)];
    line1.backgroundColor = blueColor;
    [self.view addSubview:line1];
    [line1 release];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(34, title1.center.y+30, 280, 50)];
    [label1 setNumberOfLines:0];
    label1.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    label1.font = [UIFont fontWithName:@"Courier New" size:15];
    label1.text = @"· 请确认您安装的是厅游最新TV版，最新版可在厅游官网(www.tvuoo.com)下载";
    [self.view addSubview:label1];
    [label1 release];
    
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(34, title1.center.y+80, 280, 30)];
    label2.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    [label2 setNumberOfLines:0];
    label2.font = [UIFont fontWithName:@"Courier New" size:15];
    label2.text = @"· 确认手机与电视处于同个路由器网络上";
    [self.view addSubview:label2];
    [label2 release];
    
    
    UILabel* title2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, 200, 40)];
    title2.text = @"游戏操作出现延迟";
    //    [title1 sizeToFit];
    title2.textColor = [UIColor blackColor];
    [self.view addSubview:title2];
    UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(30, title2.center.y+25, 280, 1)];
    line2.backgroundColor = blueColor;
    [self.view addSubview:line2];
    [line2 release];
    
    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(34, title2.center.y+30, 280, 100)];
    [label3 setNumberOfLines:0];
    label3.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    label3.font = [UIFont fontWithName:@"Courier New" size:15];
    label3.text = @"· 厅游手机版与电视版的连接是基于网络连接实现的，出现延迟是因为网络阻塞导致。请您在游戏过程中，不要使用其他网络设备进行大文件下载或者在线电视等操作";
    [self.view addSubview:label3];
    [label3 release];
    
    UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(34, title2.center.y+120, 280, 60)];
    [label4 setNumberOfLines:0];
    label4.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    label4.font = [UIFont fontWithName:@"Courier New" size:15];
    label4.text = @"· 建议你的路由器不要与电视、手机距离太远，WIFI在空阔的地方（不含隔墙）的有效距离仅有30米";
    [self.view addSubview:label4];
    [label4 release];
    
    
    UILabel* title3 = [[UILabel alloc] initWithFrame:CGRectMake(30, 400, 200, 40)];
    title3.text = @"游戏过程显示卡顿";
    //    [title1 sizeToFit];
    title3.textColor = [UIColor blackColor];
    [self.view addSubview:title3];
    UIImageView* line3 = [[UIImageView alloc] initWithFrame:CGRectMake(30, title3.center.y+25, 280, 1)];
    line3.backgroundColor = blueColor;
    [self.view addSubview:line3];
    [line3 release];
    
    UILabel* label5 = [[UILabel alloc] initWithFrame:CGRectMake(34, title3.center.y+30, 280, 60)];
    [label5 setNumberOfLines:0];
    label5.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    label5.font = [UIFont fontWithName:@"Courier New" size:15];
    label5.text = @"· 此情况可能是因为您的电视或机顶盒硬件配置导致，建议您选择文件较小的游戏再次尝试";
    [self.view addSubview:label5];
    [label5 release];
    
    UILabel* label6 = [[UILabel alloc] initWithFrame:CGRectMake(34, title3.center.y+90, 280, 60)];
    [label6 setNumberOfLines:0];
    label6.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    label6.font = [UIFont fontWithName:@"Courier New" size:15];
    label6.text = @"· 建议您的路由器不要与电视、手机距离太远，WIFI在空阔的地方（不含隔墙）的有效距离仅有30米";
    [self.view addSubview:label6];
    [label6 release];
    [title1 release];
    [title2 release];
    [title3 release];
    [topIv release];
    [retBtn release];
    
    NSNotificationCenter* notifi = [NSNotificationCenter defaultCenter];
    [notifi addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    hud.labelText = @"网络异常,手机与电视连接断开,请您重新连接!";
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:3];
    [hud release];
    return;
}
@end

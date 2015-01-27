//
//  CusMouseViewController.m
//  NewTvuoo
//
//  Created by wanghe on 14-10-14.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import "CusMouseViewController.h"
#import "DEFINE.h"
#import "domain/MyJniTransport.h"
#import "RemoteControlViewController.h"
#import "CommonBtn.h"
#import "MouseControlViewController.h"
#import "JiejiViewController.h"
#import "HongbaijiViewController.h"
#import "ParseJson.h"
#import "PSPViewController.h"
#import "AllUrl.h"
#import "LordViewController.h"
#import "AppDelegate.h"
@interface CusMouseViewController ()

@end

@implementation CusMouseViewController

@synthesize single;
@synthesize h_rate;
@synthesize w_rate;
@synthesize mouseIV;
@synthesize moshiLabel;
@synthesize customBtn;
@synthesize doubleClickBtn;

@synthesize mouseOpBtn;
@synthesize mouseIvOnBtn;
@synthesize gameOpBtn;
@synthesize gameIvOnBtn;
@synthesize mouseIV2;
@synthesize doubleClickIv;
@synthesize doubleClickIv2;
@synthesize doubleClickLabel;
@synthesize isDoubleClick;
@synthesize doubleClickHuituiBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1];
        if(iPhone5)
        {
        }
        if(iPhone4)
        {
            NSLog(@"is iphone4");
        }
        
    }
    return self;
}
- (void) pressMouseBtn
{
    [gameIvOnBtn setImage:[UIImage imageNamed:@"sbcz_shoubing1.png"]];
    [gameOpBtn setBackgroundColor:[UIColor blackColor]];
    
    [mouseIvOnBtn setImage:[UIImage imageNamed:@"sbcz_shubiao2.png"]];
    [mouseOpBtn setBackgroundColor:[UIColor whiteColor]];
}

- (void) pressGameBtn
{
    [gameIvOnBtn setImage:[UIImage imageNamed:@"sbcz_shoubing2.png"]];
    [gameOpBtn setBackgroundColor:[UIColor whiteColor]];
    
    [mouseIvOnBtn setImage:[UIImage imageNamed:@"sbcz_shubiao1.png"]];
    [mouseOpBtn setBackgroundColor:[UIColor blackColor]];
}


- (void) addCusBtnAndDoubleClickBtn
{
    UIButton* retBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retBtn.frame = CGRectMake(20, 10, 40, 40);
    [retBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [retBtn setImage:[UIImage imageNamed:@"ty_fanhui1.png"] forState:UIControlStateNormal];
    [retBtn setImage:[UIImage imageNamed:@"ty_fanhui2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:retBtn];
    
    UIImageView* frameUV = [[UIImageView alloc] initWithFrame:CGRectMake(230, 10, 108, 40)];
    [frameUV setBackgroundColor:[UIColor colorWithRed:24.0/255.0 green:130.0/255.0 blue:237.0/255.0 alpha:1]];
    [frameUV.layer setBorderWidth:1.0];
    [frameUV.layer setCornerRadius:20.0];
    [frameUV.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:frameUV];
    
    customBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [customBtn addTarget:self action:@selector(pressCustomBtn) forControlEvents:UIControlEventTouchUpInside];
    customBtn.frame = CGRectMake(235, 13, 49, 35);
    customBtn.layer.cornerRadius = 17.0;
    [customBtn setBackgroundColor:[UIColor whiteColor]];
    [customBtn setTitle:@"传统" forState:UIControlStateNormal];
    [self.view addSubview:customBtn];
    
    doubleClickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doubleClickBtn addTarget:self action:@selector(pressDoubleClickBtn) forControlEvents:UIControlEventTouchUpInside];
    doubleClickBtn.frame = CGRectMake(285, 13, 49, 35);
    doubleClickBtn.layer.cornerRadius = 17.0;
    [doubleClickBtn setTitle:@"双击" forState:UIControlStateNormal];
    [doubleClickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:doubleClickBtn];
    [frameUV release];
    
    UIButton* zhuyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zhuyeBtn addTarget:self action:@selector(zhuyeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    zhuyeBtn.frame = CGRectMake(354, 10, 40, 40);
    [zhuyeBtn setImage:[UIImage imageNamed:@"sbsj_zhuye1.png"] forState:UIControlStateNormal];
    [zhuyeBtn setImage:[UIImage imageNamed:@"sbsj_zhuye2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:zhuyeBtn];
    
    UIButton* gongnengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gongnengBtn addTarget:self action:@selector(menuBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    gongnengBtn.frame = CGRectMake(414, 10, 40, 40);
    [gongnengBtn setImage:[UIImage imageNamed:@"sbsj_gongneng1.png"] forState:UIControlStateNormal];
    [gongnengBtn setImage:[UIImage imageNamed:@"sbsj_gongneng2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:gongnengBtn];
    
    UIButton* yaokongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yaokongBtn addTarget:self action:@selector(gotoYaokongVc) forControlEvents:UIControlEventTouchUpInside];
    yaokongBtn.frame = CGRectMake(474, 10, 80, 40);
    [yaokongBtn setImage:[UIImage imageNamed:@"sbcz_yaokong1.png"] forState:UIControlStateNormal];
    [yaokongBtn setImage:[UIImage imageNamed:@"sbcz_yaokong2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:yaokongBtn];
    
    UILabel* yaokongLabel = [[UILabel alloc] initWithFrame:CGRectMake(510, 20, 20, 20)];
    yaokongLabel.text = @"遥控";
    yaokongLabel.textColor = [UIColor whiteColor];
    [yaokongLabel sizeToFit];
    [self.view addSubview:yaokongLabel];
    [yaokongLabel release];
}

- (void) zhuyeBtnPressed
{
    NSLog(@"主页按钮");
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 3, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 3, 0);
}

- (void) menuBtnPressed
{
    NSLog(@"菜单按钮");
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 82, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 82, 0);
}

- (void) gotoYaokongVc
{
    RemoteControlViewController* remoteView = [[RemoteControlViewController alloc] initWithNibName:@"RemoteControlViewController" bundle:nil];
    //    [self.navigationController pushViewController:remoteView animated:YES];00
    //    [self presentModalViewController:remoteView animated:YES];
    //    [self presentViewController:remoteView animated:NO completion:nil];
    [self.navigationController pushViewController:remoteView animated:YES];
    [remoteView release];
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
    hud.labelText = @"很抱歉已经断开连接, 请重连!";
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:3];
    [hud release];
    return;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    /***
     旋转屏幕
     **/
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    [UIView commitAnimations];
    
    
    
    //添加背景图片
    UIImageView* backIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 568, 60)];
    backIv.backgroundColor = blueColor;
    [self.view addSubview:backIv];
    [backIv release];
    
    self.isDoubleClick = NO;
    self.single = [Singleton getSingle];
    
    self.h_rate = self.single.current_tvInfo.height/self.view.frame.size.height;
    self.w_rate = self.single.current_tvInfo.width/self.view.frame.size.width;
    
    [self addCusBtnAndDoubleClickBtn];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];  //隐藏状态栏
    
    
    
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    // Do any additional setup after loading the view from its nib.
    
    UIImageView* uv1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 68, 98, 86)];
//    [uv1 setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:255.0/255.0 alpha:0]];
    [uv1 setBackgroundColor:[UIColor whiteColor]];
    [uv1.layer setBorderWidth:1.0];
    [uv1.layer setCornerRadius:4.0];
    [uv1.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:uv1];
    [uv1 release];
    UIButton* huituiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    huituiBtn.frame = CGRectMake(36,80, 45,45);
    [huituiBtn addTarget:self action:@selector(pressHuituiBtn) forControlEvents:UIControlEventTouchUpInside];
    [huituiBtn setImage:[UIImage imageNamed:@"sbcz_huitui3.png"] forState:UIControlStateNormal];
    [huituiBtn setImage:[UIImage imageNamed:@"sbcz_huitui2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:huituiBtn];
    UILabel* huituiLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 115, 35, 45)];
    huituiLabel.text = @"回退";
    huituiLabel.textColor = [UIColor blackColor];
    [self.view addSubview:huituiLabel];
    [huituiLabel release];
    
    UIButton* uv2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 162, 98, 140)];
//    UIImageView* uv2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 162, 98, 140)];
    [uv2 addTarget:self action:@selector(pressSelected) forControlEvents:UIControlEventTouchUpInside];
    [uv2 setBackgroundColor:[UIColor whiteColor]];
    [uv2.layer setBorderWidth:1.0];
    [uv2.layer setCornerRadius:4.0];
    [uv2.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:uv2];
    [uv2 release];
    
    UIButton* xuanzhongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xuanzhongBtn.frame = CGRectMake(36,200, 45,45);
    [xuanzhongBtn addTarget:self action:@selector(pressSelected) forControlEvents:UIControlEventTouchUpInside];
    [xuanzhongBtn setImage:[UIImage imageNamed:@"sbcz_xuanzhong3.png"] forState:UIControlStateNormal];
    [xuanzhongBtn setImage:[UIImage imageNamed:@"sbcz_xuanzhong2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:xuanzhongBtn];
    UILabel* xuanzhongLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 240, 35, 45)];
    xuanzhongLabel.text = @"选中";
    xuanzhongLabel.textColor = [UIColor blackColor];
    [self.view addSubview:xuanzhongLabel];
    [xuanzhongLabel release];
    
    UIImageView* uv3 = [[UIImageView alloc] initWithFrame:CGRectMake(128, 68, 428, 234)];
    [uv3 setBackgroundColor:[UIColor whiteColor]];
    [uv3.layer setBorderWidth:1.0];
    [uv3.layer setCornerRadius:4.0];
    [uv3.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:uv3];
    [uv3 release];
    
    UIImageView* moshiIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbcz_moshi.png"]];
    moshiIV.frame = CGRectMake(470,270,80,30);
    [self.view addSubview:moshiIV];
    [moshiIV release];
    moshiLabel = [[UILabel alloc] initWithFrame:CGRectMake(486, 275, 60, 25)];
    moshiLabel.text = @"传统模式";
    moshiLabel.textColor = blueColor;
    [moshiLabel setFont:[UIFont fontWithName:@"Courier New" size:13]];
    [self.view addSubview:moshiLabel];
    
    mouseIV = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbcz_shou.png"]] autorelease];
    [mouseIV setBackgroundColor:[UIColor whiteColor]];
    mouseIV.frame = CGRectMake(340,170, 40, 40);
    [self.view addSubview:mouseIV];
    
    
    self.doubleClickIv = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 68, 546, 234)] autorelease];
    [self.doubleClickIv setBackgroundColor:[UIColor whiteColor]];
    [self.doubleClickIv.layer setBorderWidth:1.0];
    [self.doubleClickIv.layer setCornerRadius:4.0];
    [self.doubleClickIv.layer setBorderColor:[blueColor CGColor]];
    
    self.doubleClickIv2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbsj_tishi.png"]] autorelease];
    self.doubleClickIv2.frame = CGRectMake(400, 260, 150, 35);
    
    self.doubleClickLabel = [[[UILabel alloc] initWithFrame:CGRectMake(425, 271, 80, 35)] autorelease];
    self.doubleClickLabel.text = @"双击任意位置选中";
    self.doubleClickLabel.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    [self.doubleClickLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    [self.doubleClickLabel sizeToFit];
    
    self.doubleClickHuituiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doubleClickHuituiBtn addTarget:self action:@selector(doubleClickHuituiPressed) forControlEvents:UIControlEventTouchUpInside];
    self.doubleClickHuituiBtn.frame = CGRectMake(20, 245, 50, 50);
    [self.doubleClickHuituiBtn setImage:[UIImage imageNamed:@"sbsj_huitui1.png"] forState:UIControlStateNormal];
    [self.doubleClickHuituiBtn setImage:[UIImage imageNamed:@"sbsj_huitui2.png"] forState:UIControlStateHighlighted];
    
    self.mouseIV2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbcz_shou.png"]] autorelease];
    [self.mouseIV2 setBackgroundColor:[UIColor whiteColor]];
    self.mouseIV2.frame = CGRectMake(340,170, 40, 40);
    
    NSNotificationCenter* notif = [NSNotificationCenter defaultCenter];
    [notif addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
}

- (void) doubleClickHuituiPressed
{
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 4, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 4, 0);
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
                        [self presentViewController:mouseControlVC animated:NO completion:nil];
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
                [self presentViewController:hongbaiVc animated:NO completion:nil];
                [hongbaiVc release];
            });
            break;
        }
        case 3:                     //启动接机游戏的手柄
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                JiejiViewController* jiejiVc = [[JiejiViewController alloc] initWithNibName:@"JiejiViewController" bundle:nil];
                [self presentViewController:jiejiVc animated:NO completion:nil];
                [jiejiVc release];
            });
            break;
        }
        case 4:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                PSPViewController* pspVc = [[PSPViewController alloc] initWithNibName:@"PSPViewController" bundle:nil];
                [self presentViewController:pspVc animated:NO completion:nil];
                [pspVc release];
            });
            break;
        }
        default:
            break;
    }
    [url release];
}

- (void) pressCustomBtn
{
    if (self.isDoubleClick == NO)
    {
        return;
    }
    
    doubleClickBtn.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:130.0/255.0 blue:237.0/255.0 alpha:1];
    [doubleClickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customBtn.backgroundColor = [UIColor whiteColor];
    [customBtn setTitleColor:blueColor forState:UIControlStateNormal];
    
 
    [self.doubleClickIv removeFromSuperview];


    [self.mouseIV2 removeFromSuperview];

  
    [self.doubleClickHuituiBtn removeFromSuperview];

  
    [self.doubleClickLabel removeFromSuperview];

  
    [self.doubleClickIv2 removeFromSuperview];

    self.isDoubleClick = NO;

}

- (void) pressDoubleClickBtn
{
    if(self.isDoubleClick)
    {
        return;
    }
    doubleClickBtn.backgroundColor = [UIColor whiteColor];
    [doubleClickBtn setTitleColor:blueColor forState:UIControlStateNormal];
    customBtn.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:130.0/255.0 blue:237.0/255.0 alpha:1];
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.doubleClickIv];
    [self.view addSubview:self.doubleClickIv2];
    [self.view addSubview:self.doubleClickLabel];
    [self.view addSubview:self.doubleClickHuituiBtn];
    [self.view addSubview:self.mouseIV2];
    self.isDoubleClick = YES;
}

- (void) pressSelected
{
    mouseEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 0, 0, 0);
    mouseEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 0, 0, 0);
}
- (void) pressHuituiBtn
{
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 4, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 4, 0);
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) returnBack
{
//    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
//    [self dismissViewControllerAnimated:NO completion:nil];
    LordViewController* lord = self.single.viewController;
//    [self.navigationController popToViewController:lord animated:YES];
//    [self.navigationController presentViewController:lord animated:NO completion:nil];
//    [self presentModalViewController:lord animated:NO];
//    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if(self.presentationController == nil)
//    [self presentViewController:lord animated:NO completion:nil];
//
//    UINavigationController* navi = appDelegate.navController;
//    [navi presentViewController:lord animated:NO completion:nil];
//    [self presentViewController:lord animated:NO completion:nil];
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToViewController:lord animated:YES];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.doubleClickLabel = nil;
    self.doubleClickIv2 = nil;
    self.doubleClickIv = nil;
    self.mouseIV2 = nil;
    [super dealloc];
}


//控制屏幕方向     横屏

//- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}
//- (NSUInteger) supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
//- (BOOL) shouldAutorotate
//{
//    return NO;
//}

//屏幕触摸处理

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    //边界处理
    if(loc.x < 128 || loc.x > 556 || loc.y < 68 || loc.y > 302)
    {
        return;
    }
    if(touch.phase == 0)
    {
        if (isDoubleClick)
        {
            if([touch tapCount] >= 2)
            {
                mouseEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 0, 0, 0);
                mouseEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 0, 0, 0);
            }
        }
    }
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    CGPoint preLoc = [touch previousLocationInView:self.view];
    //边界处理
    if(isDoubleClick)
    {
        if(loc.x < 10 || loc.x > 516 || loc.y < 68 || loc.y > 262)
        {
            return;
        }
    }
    else
    {
        if(loc.x < 128 || loc.x > 516 || loc.y < 68 || loc.y > 262)
        {
            return;
        }
    }
    if(touch.phase == 1)
    {
        //在这里发送鼠标坐标
        TvInfo* tv = single.current_tv;
        int ip = tv.tvIp;
        int port = tv.tvUdpPort;
        if(isDoubleClick)
        {
            self.mouseIV2.frame = CGRectMake(loc.x, loc.y, 40, 40);
        }
        else
        {
           mouseIV.frame = CGRectMake(loc.x, loc.y, 40, 40);
        }
        mouseMove(ip, port, (loc.x-preLoc.x+0.5)*self.w_rate, (loc.y-preLoc.y)*2.8*self.h_rate);
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}


@end

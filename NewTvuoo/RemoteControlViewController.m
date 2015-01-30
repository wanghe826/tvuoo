//
//  RemoteControlViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//
#import "AllUrl.h"
#import "LordViewController.h"
#import "RemoteControlViewController.h"
#import "CommonBtn.h"
#import "domain/MyJniTransport.h"
#import "DEFINE.h"
#import "SurpriseView.h"
#import "DownloadRemoteViewController.h"
#import "PSPViewController.h"
#import "MouseControlViewController.h"
#import "HongbaijiViewController.h"
#import "ParseJson.h"
#import "JiejiViewController.h"
#define myBlackColor [UIColor colorWithRed:69.0/255.0 green:73.0/255.0 blue:75.0/255.0 alpha:1];

@interface RemoteControlViewController ()

@end

@implementation RemoteControlViewController
@synthesize simpleRemote;
@synthesize simpleLabel;
@synthesize gestureRemote;
@synthesize gestureLabel;
@synthesize controlView;
@synthesize single;

@synthesize mouseLabel = _mouseLabel;
@synthesize menuLabel = _menuLabel;
@synthesize lordLabel = _lordLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    single = [Singleton getSingle];
    _btnFlag = YES;
    
    float w_rate = single.width_rate;
    float h_rate = single.height_rate;
    
    /*
    UIImageView* whiteView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568-h_rate*119)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView release];   */
    
    
    UIImageView* iv = [[UIImageView alloc] init];
    iv.frame = CGRectMake(0,20, 320, 131);
    iv.backgroundColor = blueColor;
    [self.view addSubview:iv];
    [iv release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(30*w_rate, 40*h_rate+20, 30, 30)];
    [self.view addSubview:retBtn];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(240.0*w_rate, 36.33*h_rate+20, 80, 30)];
    label.text = @"无线遥控";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.center = CGPointMake(self.view.center.x, 56.33*h_rate+20);
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
    // Do any additional setup after loading the view from its nib.
    
    //两个按钮的外边框
    UIImageView* listUv = [[UIImageView alloc] initWithFrame:CGRectMake(52*w_rate, 146*h_rate+20, 616*w_rate, 94*h_rate)];
    //        [listUv setImage:[UIImage imageNamed:@"ty_bai1.png"]];
    [listUv setBackgroundColor:blueColor];
    [listUv.layer setBorderWidth:1.0];
    [listUv.layer setCornerRadius:4.0];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){24,180,237,1});
    [listUv.layer setBorderColor:colorref];
    [self.view addSubview:listUv];
    [listUv release];
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    
    
    self.simpleRemote = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.simpleRemote.frame = CGRectMake(30, 148*h_rate+25, 130, 30);
    [self.simpleRemote addTarget:self action:@selector(pressSimpleBtn) forControlEvents:UIControlEventTouchUpInside];
    //    devBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 148*h_rate+25, 130,30)];
    //    [devBtn setBackgroundImage:[UIImage imageNamed:@"ty_bai2.png"] forState:UIControlStateNormal];
    [self.simpleRemote setBackgroundColor:[UIColor whiteColor]];
    
//    UILabel* simpleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 20, 20)];
    UILabel* simLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 20, 20)];
    self.simpleLabel = simLabel;
    self.simpleLabel.text = @"简约遥控";
    [self.simpleLabel sizeToFit];
    [self.simpleLabel setTextColor:blueColor];
    [self.view addSubview:self.simpleRemote];
    [self.simpleRemote addSubview:simpleLabel];
    //内存泄露修改
//    [self.simpleLabel release];
    [simLabel release];
    
    gestureRemote = [[UIButton alloc] initWithFrame:CGRectMake(162, 148*h_rate+25, 130, 30)];
    [gestureRemote addTarget:self action:@selector(pressGestureBtn) forControlEvents:UIControlEventTouchUpInside];
    

    UILabel* gesLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 20, 20)];
    self.gestureLabel = gesLabel;
    self.gestureLabel.text = @"手势遥控";
    [self.gestureLabel sizeToFit];
    [self.gestureLabel setTextColor:[UIColor whiteColor]];
    [gestureRemote addSubview:self.gestureLabel];
    [self.view addSubview:gestureRemote];
    [gestureRemote release];
    [gesLabel release];
    
    [self addControlButton];
    
    self.controlView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yk_1.png"]] autorelease];
    self.controlView.frame = CGRectMake(50, 200, 230, 230);
    self.controlView.center = CGPointMake(self.view.center.x, 330);
    [self.view addSubview:self.controlView];
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
                NSLog(@"从遥控处启动接机游戏!");
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


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
}

- (void) pressSimpleBtn
{
    if(_btnFlag == NO)
    {
        [self.simpleRemote setBackgroundColor:[UIColor whiteColor]];
        [self.simpleLabel setTextColor:blueColor];
        [self.gestureLabel setTextColor:[UIColor whiteColor]];
        [self.gestureRemote setBackgroundColor:blueColor];
        _btnFlag = YES;
    }
}

- (void) pressGestureBtn
{
    if(_btnFlag == YES)
    {
        _btnFlag = NO;
        [self.simpleRemote setBackgroundColor:blueColor];
        [self.simpleLabel setTextColor:[UIColor whiteColor]];
        [self.gestureLabel setTextColor:blueColor];
        [self.gestureRemote setBackgroundColor:[UIColor whiteColor]];
        
//        if(single.switcher.tvu_showremote_switch == 0)
//        NSLog(@"是否显示超级遥控:%d", [AllUrl getInstance] tvu_s)
        if([[AllUrl getInstance] tvu_showremote_switch] == 1)
        {
            DownloadRemoteViewController* downRemote = [[DownloadRemoteViewController alloc] initWithNibName:@"DownloadRemoteViewController" bundle:nil];
            [self.navigationController pushViewController:downRemote animated:NO];
            [downRemote release];
        }
        else
        {
            SurpriseView* surprise = [[SurpriseView alloc] initWithNibName:@"SurpriseView" bundle:nil];
            [self.navigationController pushViewController:surprise animated:NO];
            [surprise release];
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self pressSimpleBtn];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) goBack
{
//    [self.navigationController popViewControllerAnimated:YES];
//    LordViewController* lordVC = [[LordViewController alloc] initWithNibName:@"LordViewController" bundle:nil];
//    [self presentViewController:lordVC animated:YES completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    if(!self.navigationController)
    [self dismissViewControllerAnimated:YES completion:nil];
    else
    {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:@"oglFlip"];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
//        [self.navigationController popViewControllerAnimated:YES];
        LordViewController* lord = self.single.viewController;
//        [self.navigationController pushViewController:lord animated:YES];
        [self.navigationController popToViewController:lord animated:YES];
    }
//    [lordVC release];
}

- (void)pressMute
{
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 164, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 164, 0);
}

- (void)pressLowerVoice
{
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 25, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 25, 0);
}

- (void)pressUpperVoice
{
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 24, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 24, 0);
}

- (void)pressShutdown
{
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 26, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 26, 0);
}

- (void)pressLord
{
    _lordLabel.textColor = myBlackColor;
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 3, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 3, 0);
}

- (void)pressReturn
{
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 4, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 4, 0);
}

- (void)pressMouse
{
    _mouseLabel.textColor = myBlackColor;
    CusMouseViewController* mouseVC = [[CusMouseViewController alloc] initWithNibName:@"CusMouseViewController" bundle:nil];
//    [self.navigationController pushViewController:mouseVC animated:YES completion:nil];
    [self.navigationController pushViewController:mouseVC animated:YES];
    [mouseVC release];
}

- (void)pressMenu
{
    _menuLabel.textColor = myBlackColor;
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 82, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 82, 0);
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.gestureLabel = nil;
    self.simpleLabel = nil;
    [super dealloc];
}

- (void) addControlButton
{
    UIButton* shutdownBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shutdownBtn addTarget:self action:@selector(pressShutdown) forControlEvents:UIControlEventTouchUpInside];
    shutdownBtn.frame = CGRectMake(11, 158, 64, 30);
    [shutdownBtn setBackgroundImage:[UIImage imageNamed:@"yk_chumo1.png"] forState:UIControlStateNormal];
    [shutdownBtn setBackgroundImage:[UIImage imageNamed:@"yk_chumo2.png"] forState:UIControlStateHighlighted];
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yk_guanji.png"]];
    iv.frame = CGRectMake(14,161,24,24);
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(35, 164, 38, 21)];
    label.text = @"关机";
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:shutdownBtn];
    [self.view addSubview:iv];
    [self.view addSubview:label];
    [iv release];
    [label release];
    
    
    UIButton* muteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [muteBtn addTarget:self action:@selector(pressMute) forControlEvents:UIControlEventTouchUpInside];
    muteBtn.frame = CGRectMake(86, 158, 64, 30);
    [muteBtn setBackgroundImage:[UIImage imageNamed:@"yk_chumo1.png"] forState:UIControlStateNormal];
    [muteBtn setBackgroundImage:[UIImage imageNamed:@"yk_chumo2.png"] forState:UIControlStateHighlighted];
    UIImageView* iv1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yk_jingyin.png"]];
    iv1.frame = CGRectMake(89,161,24,24);
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(110,164,38,21)];
    label1.text = @"静音";
    label1.textColor = [UIColor whiteColor];
    [self.view addSubview:muteBtn];
    [self.view addSubview:iv1];
    [self.view addSubview:label1];
    [iv1 release];
    [label1 release];
    
    UIButton* lowerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lowerBtn addTarget:self action:@selector(pressLowerVoice) forControlEvents:UIControlEventTouchUpInside];
    lowerBtn.frame = CGRectMake(163, 158, 64, 30);
    [lowerBtn setBackgroundImage:[UIImage imageNamed:@"yk_chumo1.png"] forState:UIControlStateNormal];
    [lowerBtn setBackgroundImage:[UIImage imageNamed:@"yk_chumo2.png"] forState:UIControlStateHighlighted];
    UIImageView* iv2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yk_yinjian.png"]];
    iv2.frame = CGRectMake(166,161,24,24);
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(191,164,38,21)];
    label2.text = @"减小";
    label2.textColor = [UIColor whiteColor];
    [self.view addSubview:lowerBtn];
    [self.view addSubview:iv2];
    [self.view addSubview:label2];
    [iv2 release];
    [label2 release];
    
    UIButton* upperBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [upperBtn addTarget:self action:@selector(pressUpperVoice) forControlEvents:UIControlEventTouchUpInside];
    upperBtn.frame = CGRectMake(239, 158, 64, 30);
    [upperBtn setBackgroundImage:[UIImage imageNamed:@"yk_chumo1.png"] forState:UIControlStateNormal];
    [upperBtn setBackgroundImage:[UIImage imageNamed:@"yk_chumo2.png"] forState:UIControlStateHighlighted];
    UIImageView* iv3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yk_yinjia.png"]];
    iv3.frame = CGRectMake(242,161,24,24);
    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(267,164,38,21)];
    label3.text = @"加大";
    label3.textColor = [UIColor whiteColor];
    [self.view addSubview:upperBtn];
    [self.view addSubview:iv3];
    [self.view addSubview:label3];
    [iv3 release];
    [label3 release];
    
    [self addBottomBtn];
    
    UIButton* fanhuiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fanhuiBtn addTarget:self action:@selector(pressReturn) forControlEvents:UIControlEventTouchUpInside];
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"yk_fanhui1.png"] forState:UIControlStateNormal];
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"yk_fanhui2.png"] forState:UIControlStateHighlighted];
    fanhuiBtn.frame = CGRectMake(233, 480, 85, 85);
    [self.view addSubview:fanhuiBtn];
    
    UIImageView* fanhuiIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yk_tuichu.png"]];
    fanhuiIV.frame = CGRectMake(28,20, 30,30);
    UILabel* fanhuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(28,55,30,30)];
    fanhuiLabel.text = @"返回";
    [fanhuiLabel sizeToFit];
    fanhuiLabel.textColor = [UIColor whiteColor];
    [fanhuiBtn addSubview:fanhuiLabel];
    [fanhuiBtn addSubview:fanhuiIV];
    
    [fanhuiIV release];
    [fanhuiLabel release];
}

- (void) pressMouseDown
{
    _mouseLabel.textColor = blueColor;
}

- (void) pressMenuDown
{
    _menuLabel.textColor = blueColor;
}

- (void) pressLordDown
{
    _lordLabel.textColor = blueColor;
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

- (void) addBottomBtn
{
    UIButton* mouseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mouseBtn addTarget:self action:@selector(pressMouse) forControlEvents:UIControlEventTouchUpInside];
    [mouseBtn addTarget:self action:@selector(pressMouseDown) forControlEvents:UIControlEventTouchDown];
    [mouseBtn setBackgroundImage:[UIImage imageNamed:@"yk_shubiao1.png"] forState:UIControlStateNormal];
    [mouseBtn setBackgroundImage:[UIImage imageNamed:@"yk_shubiao2.png"] forState:UIControlStateHighlighted];
    mouseBtn.frame = CGRectMake(28,507,35,35);
    [self.view addSubview:mouseBtn];
    _mouseLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 542, 50, 20)] autorelease];
    [_mouseLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    _mouseLabel.textColor = myBlackColor;
    _mouseLabel.text = @"鼠标";
    [self.view addSubview:_mouseLabel];
    
    UIButton* menuBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [menuBtn addTarget:self action:@selector(pressMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn addTarget:self action:@selector(pressMenuDown) forControlEvents:UIControlEventTouchDown];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"yk_caidan1.png"] forState:UIControlStateNormal];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"yk_caidan2.png"] forState:UIControlStateHighlighted];
    menuBtn.frame = CGRectMake(98,507,35,35);
    [self.view addSubview:menuBtn];
    _menuLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, 542, 50, 20)] autorelease];
    [_menuLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    _menuLabel.textColor = myBlackColor;
    _menuLabel.text = @"菜单";
    [self.view addSubview:_menuLabel];
    
    UIButton* lordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lordBtn addTarget:self action:@selector(pressLordDown) forControlEvents:UIControlEventTouchDown];
    [lordBtn addTarget:self action:@selector(pressLord) forControlEvents:UIControlEventTouchUpInside];
    [lordBtn setBackgroundImage:[UIImage imageNamed:@"yk_zhuye1.png"] forState:UIControlStateNormal];
    [lordBtn setBackgroundImage:[UIImage imageNamed:@"yk_zhuye2.png"] forState:UIControlStateHighlighted];
    lordBtn.frame = CGRectMake(168,507,35,35);
    [self.view addSubview:lordBtn];
    _lordLabel = [[[UILabel alloc] initWithFrame:CGRectMake(170, 542, 50, 20)] autorelease];
    [_lordLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    _lordLabel.textColor = myBlackColor;
    _lordLabel.text = @"主页";
    [self.view addSubview:_lordLabel];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UIBezierPath *tempPath = [[UIBezierPath alloc] init];
//    [tempPath moveToPoint:CGPointMake(0, 221)];
//    [tempPath addLineToPoint:CGPointMake(45, 240)];
//    [tempPath addLineToPoint:CGPointMake(50, 140)];
//    [tempPath addLineToPoint:CGPointMake(8, 113)];
//    [tempPath addLineToPoint:CGPointMake(0, 221)];
//    [tempPath closePath];
    
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(controlView.frame, currentPoint))
    {
        /*
        CGRect okRect = CGRectMake(controlView.center.x-57.5, controlView.center.y-57.5, 115,115);
        CGRect leftRect = CGRectMake(controlView.center.x-115, controlView.center.y-57.5, 115,115);
        CGRect rightRect = CGRectMake(controlView.center.x+57.5, controlView.center.y-57.5, 115,115);
        CGRect topRect = CGRectMake(controlView.center.x-57.5, controlView.center.y-57.5-115,115,115);
        CGRect bottomRect = CGRectMake(controlView.center.x-57.5, controlView.center.y+57.5, 115,115);
         */
//        NSLog(@"方向控制");
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-57.5, controlView.center.y-57.5, 115,115), currentPoint))
        {
//            NSLog(@"按下ok");
            self.controlView.image = [UIImage imageNamed:@"yk_2.png"];
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 23, 0);
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 23, 0);
            
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-115, controlView.center.y-57.5, 57.5,115), currentPoint))
        {
            self.controlView.image = [UIImage imageNamed:@"yk_3.png"];
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 21, 0);
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 21, 0);
//            NSLog(@"按下左");
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x+57.5, controlView.center.y-57.5, 115,115), currentPoint))
        {
            self.controlView.image = [UIImage imageNamed:@"yk_5.png"];
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 22, 0);
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 22, 0);
//            NSLog(@"按下右");
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-57.5, controlView.center.y+57.5, 115,115), currentPoint))
        {
            self.controlView.image = [UIImage imageNamed:@"yk_4.png"];
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 20, 0);
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 20, 0);
//            NSLog(@"按了下");
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-57.5, controlView.center.y-57.5-115,115,115), currentPoint))
        {
            self.controlView.image = [UIImage imageNamed:@"yk_6.png"];
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 19, 0);
//            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 19, 0);
//            NSLog(@"按下上");
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.controlView.image = [UIImage imageNamed:@"yk_1.png"];
    
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(controlView.frame, currentPoint))
    {
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-57.5, controlView.center.y-57.5, 115,115), currentPoint))
        {
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 23, 0);
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 23, 0);
            
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-115, controlView.center.y-57.5, 57.5,115), currentPoint))
        {
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 21, 0);
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 21, 0);
            //            NSLog(@"按下左");
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x+57.5, controlView.center.y-57.5, 115,115), currentPoint))
        {
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 22, 0);
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 22, 0);
            //            NSLog(@"按下右");
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-57.5, controlView.center.y+57.5, 115,115), currentPoint))
        {
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 20, 0);
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 20, 0);
            //            NSLog(@"按了下");
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-57.5, controlView.center.y-57.5-115,115,115), currentPoint))
        {
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 19, 0);
            keyEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 19, 0);
            //            NSLog(@"按下上");
        }
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end

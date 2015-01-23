//
//  KeyPadViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/9 星期二.
//  Copyright (c) 2014年 wap3. All rights reserved.
//
#import "MBProgressHUD.h"
#import "KeyPadViewController.h"
#import "DEFINE.h"
#import "CommonBtn.h"
#import "domain/MyJniTransport.h"
#import "DownloadRemoteViewController.h"
#import "SurpriseView.h"
#import "AllUrl.h"
#import "MouseControlViewController.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "GameIntroViewController.h"
#import "ParseJson.h"
#import "PSPViewController.h"
#import "LordViewController.h"

@interface KeyPadViewController ()

@end

@implementation KeyPadViewController
@synthesize controlView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self pressVKeyPadBtn];
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
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(disconnectedWithTv) name:@"breakDown" object:nil];
    _btnFlag = YES;
    
    _single = [Singleton getSingle];
    
    float w_rate = _single.width_rate;
    float h_rate = _single.height_rate;
    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 131)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(30*w_rate, 40*h_rate+20, 30, 30)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(240.0*w_rate, 36.33*h_rate+20, 80, 30)];
    label.text = @"连接您的设备";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
    
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
    
    _vKeyPadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _vKeyPadBtn.frame = CGRectMake(30, 148*h_rate+25, 130, 30);
    [_vKeyPadBtn addTarget:self action:@selector(pressVKeyPadBtn) forControlEvents:UIControlEventTouchUpInside];
    [_vKeyPadBtn setBackgroundColor:[UIColor whiteColor]];
    
    _vKeyPadLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 20, 20)];
    _vKeyPadLabel.text = @"竖全键盘";
    [_vKeyPadLabel sizeToFit];
    [_vKeyPadLabel setTextColor:blueColor];
    [_vKeyPadBtn addSubview:_vKeyPadLabel];
    [self.view addSubview:_vKeyPadBtn];
    
    _hKeyPadBtn= [[UIButton alloc] initWithFrame:CGRectMake(162, 148*h_rate+25, 130, 30)];
    [_hKeyPadBtn addTarget:self action:@selector(pressHKeyPadBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hKeyPadBtn];
    
    _hKeyPadLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 20, 20)];
    _hKeyPadLabel.text = @"横全键盘";
    [_hKeyPadLabel sizeToFit];
    [_hKeyPadLabel setTextColor:[UIColor whiteColor]];
    [_hKeyPadBtn addSubview:_hKeyPadLabel];
    [self.view addSubview:_hKeyPadBtn];
    
    _flag = YES;
    
    [self addKeyPad];
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

-(void) pressBtn123
{
    NSLog(@"pressBtn123");
    if(_flag == YES)
    {
        _flag = NO;
        [_btn1 setText:@"."];
        [_btn2 setText:@","];
        [_btn3 setText:@"/"];
        [_btn4 setText:@"!"];
        [_btn5 setText:@"@ "];
        [_btn6 setText:@"#"];
        [_btn7 setText:@"("];
        [_btn8 setText:@")"];
        [_btn9 setText:@"*"];
        [_btn0 setText:@":"];
        [_btn01 setText:@"_"];
        [_btn02 setText:@"&"];
    }
    else
    {
        [_btn1 setText:@"1"];
        [_btn2 setText:@"2"];
        [_btn3 setText:@"3"];
        [_btn4 setText:@"4"];
        [_btn5 setText:@"5"];
        [_btn6 setText:@"6"];
        [_btn7 setText:@"7"];
        [_btn8 setText:@"8"];
        [_btn9 setText:@"9"];
        [_btn0 setText:@"0"];
        [_btn01 setText:@","];
        [_btn02 setText:@"."];
        _flag = YES;
    }
}

- (void) addKeyPad
{
    int x = 10;
    int y = 160;
    
    _btn1 = [[KeyBtn alloc] init];
    _btn1.frame = CGRectMake(x, y, 35, 35);
    [_btn1 setText:@"1"];
    [self.view addSubview:_btn1];
    
    _btn2 = [[KeyBtn alloc] init];
    _btn2.frame = CGRectMake(x+=45, y, 35, 35);
    [_btn2 setText:@"2"];
    [self.view addSubview:_btn2];
    
    _btn3 = [[KeyBtn alloc] init];
    _btn3.frame = CGRectMake(x+=45, y, 35, 35);
    [_btn3 setText:@"3"];
    [self.view addSubview:_btn3];
    
    _keyBtn123 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_keyBtn123 addTarget:self action:@selector(pressBtn123) forControlEvents:UIControlEventTouchUpInside];
    _label123 = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 30, 20)];
    _label123.text = @"123";
    _label123.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
    [_keyBtn123 addSubview:_label123];
    
    [_keyBtn123.layer setBorderColor:[[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor]];
    [_keyBtn123.layer setBorderWidth:1];
    [_keyBtn123.layer setCornerRadius:8];
    _keyBtn123.frame = CGRectMake(x+=45, y, 55, 35);
    
    [_keyBtn123 addTarget:self action:@selector(keyBtn123TouchDown) forControlEvents:UIControlEventTouchDown];
    [_keyBtn123 addTarget:self action:@selector(keyBtn123TouchUp) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:_keyBtn123];
 
    _keyBtnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    _labelDelete = [[UILabel alloc] initWithFrame:CGRectMake(32, 8, 50, 20)];
    _labelDelete.text = @"删除";
    _labelDelete.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
    [_keyBtnDelete addSubview:_labelDelete];
    
    [_keyBtnDelete.layer setBorderColor:[[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor]];
    [_keyBtnDelete.layer setBorderWidth:1];
    [_keyBtnDelete.layer setCornerRadius:8];
    _keyBtnDelete.frame = CGRectMake(x+=65, y, 95, 35);
    [_keyBtnDelete addTarget:self action:@selector(keyBtnDeleteDown) forControlEvents:UIControlEventTouchDown];
    [_keyBtnDelete addTarget:self action:@selector(keyBtnDeleteUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_keyBtnDelete];
    
    x = 10;
    _btn4 = [[KeyBtn alloc] init];
    _btn4.frame = CGRectMake(x, y+=45, 35, 35);
    [_btn4 setText:@"4"];
    [self.view addSubview:_btn4];
    
    _btn5 = [[KeyBtn alloc] init];
    _btn5.frame = CGRectMake(x+=45, y, 35, 35);
    [_btn5 setText:@"5"];
    [self.view addSubview:_btn5];
    
    _btn6 = [[KeyBtn alloc] init];
    _btn6.frame = CGRectMake(x+=45, y, 35, 35);
    [_btn6 setText:@"6"];
    [self.view addSubview:_btn6];
    
    //内存泄露修改
    UIImageView* conView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"srf_yk1.png"]];
    self.controlView = conView;
    self.controlView.frame = CGRectMake(x+=45, y, 170, 170);
    [self.view addSubview:self.controlView];
    
    [conView release];
    
    x = 10;
    
    _btn7 = [[KeyBtn alloc] init];
    _btn7.frame = CGRectMake(x, y+=45, 35, 35);
    [_btn7 setText:@"7"];
    [self.view addSubview:_btn7];
    
    _btn8 = [[KeyBtn alloc] init];
    _btn8.frame = CGRectMake(x+=45, y, 35, 35);
    [_btn8 setText:@"8"];
    [self.view addSubview:_btn8];
    
    _btn9 = [[KeyBtn alloc] init];
    _btn9.frame = CGRectMake(x+=45, y, 35, 35);
    [_btn9 setText:@"9"];
    [self.view addSubview:_btn9];
    
    x = 10;
    
    _btn0 = [[KeyBtn alloc] init];
    _btn0.frame = CGRectMake(x, y+=45, 35, 35);
    [_btn0 setText:@"0"];
    [self.view addSubview:_btn0];
    
    _btn01 = [[KeyBtn alloc] init];
    _btn01.frame = CGRectMake(x+=45, y, 35, 35);
    [_btn01 setText:@","];
    [self.view addSubview:_btn01];
    
    _btn02 = [[KeyBtn alloc] init];
    _btn02.frame = CGRectMake(x+=45, y, 35, 35);
    [_btn02 setText:@"."];
    [self.view addSubview:_btn02];
    
    x = 10;
    UIButton* fanhuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fanhuiBtn.frame = CGRectMake(x, y+=45, 125, 35);
    [fanhuiBtn setImage:[UIImage imageNamed:@"srf_fanhui1.png"] forState:UIControlStateNormal];
    [fanhuiBtn setImage:[UIImage imageNamed:@"srf_fanhui2.png"] forState:UIControlEventTouchDown];
    [self.view addSubview:fanhuiBtn];
    
    _btnA = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnA.frame = CGRectMake(x, y+=45, 35, 35);
    [_btnA setText:@"A"];
    [self.view addSubview:_btnA];
    
    _btnB = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnB.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnB setText:@"B"];
    [self.view addSubview:_btnB];
    
    _btnC = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnC.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnC setText:@"C"];
    [self.view addSubview:_btnC];
    
    _btnD = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnD.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnD setText:@"D"];
    [self.view addSubview:_btnD];
    
    _btnE = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnE.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnE setText:@"E"];
    [self.view addSubview:_btnE];
    
    _btnF = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnF.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnF setText:@"F"];
    [self.view addSubview:_btnF];
    
    _btnG = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnG.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnG setText:@"G"];
    [self.view addSubview:_btnG];
    
    x = 10;

    _btnH = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnH.frame = CGRectMake(x, y+=45, 35, 35);
    [_btnH setText:@"H"];
    [self.view addSubview:_btnH];
    
    _btnI = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnI.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnI setText:@"I"];
    [self.view addSubview:_btnI];
    
    _btnJ = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnJ.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnJ setText:@"J"];
    [self.view addSubview:_btnJ];
    
    _btnK = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnK.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnK setText:@"K"];
    [self.view addSubview:_btnK];
    
    _btnL = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnL.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnL setText:@"L"];
    [self.view addSubview:_btnL];
    
    _btnM = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnM.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnM setText:@"M"];
    [self.view addSubview:_btnM];
    
    _btnN = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnN.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnN setText:@"N"];
    [self.view addSubview:_btnN];
    
    x = 10;
    
    _btnO = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnO.frame = CGRectMake(x, y+=45, 35, 35);
    [_btnO setText:@"O"];
    [self.view addSubview:_btnO];
    
    _btnP = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnP.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnP setText:@"P"];
    [self.view addSubview:_btnP];
    
    _btnQ = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnQ.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnQ setText:@"Q"];
    [self.view addSubview:_btnQ];
    
    _btnR = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnR.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnR setText:@"R"];
    [self.view addSubview:_btnR];
    
    _btnS = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnS.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnS setText:@"S"];
    [self.view addSubview:_btnS];
    
    _btnT = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnT.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnT setText:@"T"];
    [self.view addSubview:_btnT];
    
    _btnU = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnU.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnU setText:@"U"];
    [self.view addSubview:_btnU];
    
    x = 10;
    _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _upBtn.frame = CGRectMake(x, y+=45, 35, 35);
    _upBtn.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor];
    _upBtn.layer.borderWidth = 1;
    _upBtn.layer.cornerRadius = 8;
    [_upBtn addTarget:self action:@selector(upBtnTouchDown) forControlEvents:UIControlEventTouchDown];
    [_upBtn addTarget:self action:@selector(upBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [_upBtn setImage:[UIImage imageNamed:@"srf_shang1.png"] forState:UIControlStateNormal];
    [_upBtn setImage:[UIImage imageNamed:@"srf_shang2.png"] forState:UIControlEventTouchDown];
    [self.view addSubview:_upBtn];
    
    
    _btnV = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnV.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnV setText:@"V"];
    [self.view addSubview:_btnV];
    
    _btnW = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnW.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnW setText:@"W"];
    [self.view addSubview:_btnW];
    
    _btnX = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnX.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnX setText:@"X"];
    [self.view addSubview:_btnX];
    
    _btnY = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnY.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnY setText:@"Y"];
    [self.view addSubview:_btnY];
    
    _btnZ = [KeyBtn buttonWithType:UIButtonTypeCustom];
    _btnZ.frame = CGRectMake(x+=45, y, 35, 35);
    [_btnZ setText:@"Z"];
    [self.view addSubview:_btnZ];
    
    _spaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _spaceBtn.frame = CGRectMake(x+=45, y, 35, 35);
    _spaceBtn.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor];
    _spaceBtn.layer.borderWidth = 1;
    _spaceBtn.layer.cornerRadius = 8;
    [_spaceBtn addTarget:self action:@selector(spaceBtnTouchDown) forControlEvents:UIControlEventTouchDown];
    [_spaceBtn addTarget:self action:@selector(spaceBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [_spaceBtn setImage:[UIImage imageNamed:@"srf_kong1.png"] forState:UIControlStateNormal];
    [_spaceBtn setImage:[UIImage imageNamed:@"srf_kong2.png"] forState:UIControlEventTouchDown];
    [self.view addSubview:_spaceBtn];
    
}

- (void)upBtnTouchDown
{
    _upBtn.layer.borderColor = [blueColor CGColor];
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 115, 0);
}
- (void)upBtnPress
{
    _upBtn.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor];
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 115, 0);
}

- (void) spaceBtnTouchDown
{
    _spaceBtn.layer.borderColor = [blueColor CGColor];
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 62, 0);
}
- (void) spaceBtnPress
{
    _spaceBtn.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor];
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 62, 0);
}

- (void) keyBtn123TouchDown
{
    _keyBtn123.layer.borderColor = [blueColor CGColor];
    _label123.textColor =  blueColor;
}
- (void) keyBtn123TouchUp
{
    _keyBtn123.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor];
    _label123.textColor =  [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
}


- (void) keyBtnDeleteDown
{
    _keyBtnDelete.layer.borderColor = [blueColor CGColor];
    _labelDelete.textColor =  blueColor;
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 67, 0);
}
- (void) keyBtnDeleteUp
{
    _keyBtnDelete.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor];
    _labelDelete.textColor =  [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 67, 0);
}

- (void) pressVKeyPadBtn
{
    if(_btnFlag == NO)
    {
        _btnFlag = YES;
        [_vKeyPadBtn setBackgroundColor:[UIColor whiteColor]];
        _vKeyPadLabel.textColor = blueColor;
        
        [_hKeyPadBtn setBackgroundColor:blueColor];
        _hKeyPadLabel.textColor = [UIColor whiteColor];
    }
}
- (void) pressHKeyPadBtn
{
    if(_btnFlag == YES)
    {
        _btnFlag = NO;
        [_vKeyPadBtn setBackgroundColor:blueColor];
        _vKeyPadLabel.textColor = [UIColor whiteColor];
        
        [_hKeyPadBtn setBackgroundColor:[UIColor whiteColor]];
        _hKeyPadLabel.textColor = blueColor;
    }
//    if([Singleton getSingle].switcher.tvu_showremote_switch == 0)
    if([[AllUrl getInstance] tvu_showgame_switch] != 0)
    {
        SurpriseView* surprise = [[SurpriseView alloc] initWithNibName:@"SurpriseView" bundle:nil];
        [self.navigationController pushViewController:surprise animated:NO];
        [surprise release];
    }
    else
    {
        DownloadRemoteViewController* download = [[DownloadRemoteViewController alloc] initWithNibName:@"DownloadRemoteViewController" bundle:nil];
        [self.navigationController pushViewController:download animated:NO];
        [download release];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    LordViewController* lord = [Singleton getSingle].viewController;
    //        [self.navigationController pushViewController:lord animated:YES];
    [self.navigationController popToViewController:lord animated:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-42.5, controlView.center.y-42.5, 85,85), currentPoint))
        {
            //            NSLog(@"按下ok");
            self.controlView.image = [UIImage imageNamed:@"srf_yk2.png"];
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 0, 23, 0);
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 1, 23, 0);
            
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-85, controlView.center.y-42.5, 42.5,85), currentPoint))
        {
            self.controlView.image = [UIImage imageNamed:@"srf_yk3.png"];
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 0, 21, 0);
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 1, 21, 0);
            //            NSLog(@"按下左");
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x+42.5, controlView.center.y-42.5, 85,85), currentPoint))
        {
            self.controlView.image = [UIImage imageNamed:@"srf_yk5.png"];
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 0, 22, 0);
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 1, 22, 0);
            //            NSLog(@"按下右");
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-42.5, controlView.center.y+42.5, 85,85), currentPoint))
        {
            self.controlView.image = [UIImage imageNamed:@"srf_yk4.png"];
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 0, 20, 0);
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 1, 20, 0);
            //            NSLog(@"按了下");
        }
        if(CGRectContainsPoint(CGRectMake(controlView.center.x-42.5, controlView.center.y-42.5-85,85,85), currentPoint))
        {
            self.controlView.image = [UIImage imageNamed:@"srf_yk6.png"];
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 0, 19, 0);
            keyEvent(_single.current_tv.tvIp, _single.current_tv.tvServerport, 1, 19, 0);
            //            NSLog(@"按下上");
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.controlView.image = [UIImage imageNamed:@"srf_yk1.png"];
}
@end

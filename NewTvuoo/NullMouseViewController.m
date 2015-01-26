//
//  NullMouseViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/9 星期二.
//  Copyright (c) 2014年 wap3. All rights reserved.
//
#import "MBProgressHUD.h"
#import "NullMouseViewController.h"
#import "domain/MyJniTransport.h"
#import "CommonBtn.h"
#import "DEFINE.h"
#import "ParseJson.h"
#import "AllUrl.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "PSPViewController.h"
#import "LordViewController.h"
#define myBlackColor [UIColor colorWithRed:69.0/255.0 green:73.0/255.0 blue:75.0/255.0 alpha:1];
//#define myBlueColor [UIColor colorWithRed:24.0/255.0 green:73.0/255.0 blue:75.0/255.0 alpha:1]

@interface NullMouseViewController ()

@end

@implementation NullMouseViewController
@synthesize single = _single;
@synthesize menuLabel = _menuLabel;
@synthesize lordLabel = _lordLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor grayColor];
        if(iPhone5)
        {
            self.view.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
           
        }
    }
    return self;
}

- (void) goBack
{
    [_motionManager stopGyroUpdates];
    [_motionManager stopAccelerometerUpdates];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    LordViewController* lord = self.single.viewController;
    //        [self.navigationController pushViewController:lord animated:YES];
    [self.navigationController popToViewController:lord animated:YES];
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
    _single = [Singleton getSingle];
    
    _x = 0;
    _y = 0;
    _z = 0;
    
    _motionManager = [[CMMotionManager alloc] init];
    [self startAcelerate];
    
    //注意释放内存
    
    float w_rate = _single.width_rate;
    float h_rate = _single.height_rate;
    
    UIImageView* iv = [[UIImageView alloc] init];
    iv.frame = CGRectMake(0, 20, 320, 120);
    iv.backgroundColor = blueColor;
    [self.view addSubview:iv];
    [iv release];
    UIImageView* iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, 320, 360)];
    iv2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:iv2];
    [iv2 release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(30*w_rate, 40*h_rate+15, 30, 30)];
    [self.view addSubview:retBtn];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(240.0*w_rate, 36.33*h_rate+20, 80, 30)];
    label.text = @"无线免费空鼠";
    [label setFont:[UIFont fontWithName:@"Courier New" size:20]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.center = CGPointMake(self.view.center.x, 56.33*h_rate+20);
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];

    // Do any additional setup after loading the view from its nib.
    
    //外边框
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
    //内存泄露修改
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    
    UILabel* titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    titileLabel.center = listUv.center;
    titileLabel.text = @"左右轻晃手机可移动空鼠";
    titileLabel.textAlignment = NSTextAlignmentCenter;
    titileLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titileLabel];
    [titileLabel release];
    
    UIButton* fanhuiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fanhuiBtn addTarget:self action:@selector(pressReturn) forControlEvents:UIControlEventTouchUpInside];
    [fanhuiBtn addTarget:self action:@selector(pressReturnOut) forControlEvents:UIControlEventTouchDown];
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"yk_fanhui1.png"] forState:UIControlStateNormal];
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"yk_fanhui2.png"] forState:UIControlStateHighlighted];
    fanhuiBtn.frame = CGRectMake(203, 450, 115,115);
    [self.view addSubview:fanhuiBtn];
    
    
    
    UIImageView* fanhuiIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yk_tuichu.png"]];
    fanhuiIV.frame = CGRectMake(28,20, 40,40);
    fanhuiIV.center = CGPointMake(fanhuiBtn.center.x, fanhuiBtn.center.y-10);
    UILabel* fanhuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(28,55,30,30)];
    fanhuiLabel.text = @"返回";
    fanhuiLabel.center = CGPointMake(fanhuiBtn.center.x, fanhuiBtn.center.y+30);
    [fanhuiLabel sizeToFit];
    fanhuiLabel.textColor = [UIColor whiteColor];
//    [fanhuiBtn addSubview:fanhuiLabel];
//    [fanhuiBtn addSubview:fanhuiIV];
    [self.view addSubview:fanhuiIV];
    [self.view addSubview:fanhuiLabel];
    [fanhuiIV release];
    [fanhuiLabel release];
    
    [self addBottomBtn];
    
    UIButton* mouseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mouseBtn addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchDown];
    [mouseBtn addTarget:self action:@selector(pressConfirmUp) forControlEvents:UIControlEventTouchUpInside];
    mouseBtn.frame = CGRectMake(200, 300, 250, 250);
    [mouseBtn setBackgroundImage:[UIImage imageNamed:@"ks_queren.png"] forState:UIControlStateNormal];
    [mouseBtn setBackgroundImage:[UIImage imageNamed:@"ks_queren.png"] forState:UIControlStateHighlighted];
    mouseBtn.center = iv2.center;
    [self.view addSubview:mouseBtn];
    
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(disconnectedWithTv) name:@"breakDown" object:nil];
    [notification addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
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

- (void) pressConfirm
{
//    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 23, 0);
//    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 23, 0);
    mouseEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 0, 0, 0);
//    mouseEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 0, 0, 0);
}

- (void) pressConfirmUp
{
    mouseEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 0, 0, 0);
}


- (void) pressReturn
{
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 4, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 4, 0);
}
- (void) pressReturnOut
{
    
}

- (void) becomeBlueColor: (UIButton*)sender
{
    int tag = [(UIView*)sender tag];
    if (tag == 11)
    {
        _mouseLabel.textColor = blueColor;       //鼠标单击事件
    }
    else if(tag == 12)
    {
        _menuLabel.textColor = blueColor;        //菜单单击事件
    }
    else
    {
        _lordLabel.textColor = blueColor;        //主页单击事件
    }
}

- (void) pressBtn: (UIButton*)sender
{
    int tag = [(UIView*)sender tag];
    if (tag == 11)
    {
        _mouseLabel.textColor = myBlackColor;       //鼠标单击事件
        [_motionManager stopGyroUpdates];
        [_motionManager stopAccelerometerUpdates];
        CusMouseViewController* cusVc = [[CusMouseViewController alloc] initWithNibName:@"CusMouseViewController" bundle:nil];
        [self.navigationController pushViewController:cusVc animated:YES];
        [cusVc release];
    }
    else if(tag == 12)
    {
        _menuLabel.textColor = myBlackColor;        //菜单单击事件
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 82, 0);
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 82, 0);
    }
    else if(tag == 13)
    {
        _lordLabel.textColor = myBlackColor;        //主页单击事件
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 3, 0);
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 3, 0);
    }
    
}

- (void) addBottomBtn
{
    UIButton* mouseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mouseBtn.tag = 11;
    [mouseBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mouseBtn addTarget:self action:@selector(becomeBlueColor:) forControlEvents:UIControlEventTouchDown];
//    mouseBtn addTarget:self action:@selector(becomeRed) forControlEvents:UIControlEventTouchU
    [mouseBtn setBackgroundImage:[UIImage imageNamed:@"yk_shubiao1.png"] forState:UIControlStateNormal];
    [mouseBtn setBackgroundImage:[UIImage imageNamed:@"yk_shubiao2.png"] forState:UIControlStateHighlighted];
    mouseBtn.frame = CGRectMake(18,507,35,35);
    [self.view addSubview:mouseBtn];
    _mouseLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 542, 50, 20)] autorelease];
    [_mouseLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    _mouseLabel.textColor = myBlackColor;
    _mouseLabel.text = @"鼠标";
    [self.view addSubview:_mouseLabel];
    
    UIButton* menuBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    menuBtn.tag = 12;
    [menuBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn addTarget:self action:@selector(becomeBlueColor:) forControlEvents:UIControlEventTouchDown];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"yk_caidan1.png"] forState:UIControlStateNormal];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"yk_caidan2.png"] forState:UIControlStateHighlighted];
    menuBtn.frame = CGRectMake(88,507,35,35);
    [self.view addSubview:menuBtn];
    _menuLabel = [[[UILabel alloc] initWithFrame:CGRectMake(90, 542, 50, 20)] autorelease];
    [_menuLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    _menuLabel.textColor = myBlackColor;
    _menuLabel.text = @"菜单";
    [self.view addSubview:_menuLabel];
    
    UIButton* lordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lordBtn.tag = 13;
    [lordBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [lordBtn addTarget:self action:@selector(becomeBlueColor:) forControlEvents:UIControlEventTouchDown];
    [lordBtn setBackgroundImage:[UIImage imageNamed:@"yk_zhuye1.png"] forState:UIControlStateNormal];
    [lordBtn setBackgroundImage:[UIImage imageNamed:@"yk_zhuye2.png"] forState:UIControlStateHighlighted];
    lordBtn.frame = CGRectMake(158,507,35,35);
    [self.view addSubview:lordBtn];
    _lordLabel = [[[UILabel alloc] initWithFrame:CGRectMake(160, 542, 50, 20)] autorelease];
    [_lordLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    _lordLabel.textColor = myBlackColor;
    _lordLabel.text = @"主页";
    [self.view addSubview:_lordLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    NSLog(@"关闭加速计");
//    [_motionManager stopGyroUpdates];
//    [_motionManager stopAccelerometerUpdates];
    [_motionManager release];
    [super dealloc];
}

- (void) startAcelerate
{
    NSOperationQueue* queue = [[[NSOperationQueue alloc] init] autorelease];
    if(_motionManager.accelerometerAvailable)
    {
        _motionManager.accelerometerUpdateInterval = 1.0/100.0;
        [_motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData* accelerometerData, NSError* error)
        {
           if(error)
           {
               [_motionManager stopAccelerometerUpdates];
           }
           else
           {
               static float v0_x = 0;
               static float v0_y = 0;
               static float v0_z = 0;
               
               float x = accelerometerData.acceleration.x;
               float y = accelerometerData.acceleration.y;
               float z = accelerometerData.acceleration.z;
               
               float distanceX = v0_x*1.0/60.0 + (1.0/6.0)*x*(1.0/60.0);
               float distanceY = v0_y*1.0/60.0 + (1.0/6.0)*y*(1.0/60.0);
//               float distanceZ = v0_z*1.0/60.0 + (1.0/6.0)*z*(1.0/60.0);
               v0_x = x * 1.0/60.0;
               v0_y = y * 1.0/60.0;
               v0_z = z * 1.0/60.0;

               int dx = abs(int(distanceX*10000-_x));
               int dy = abs(int(distanceY*10000-_y));
               
               if(dx>-15.5 && dx<15.5)
               {
                   distanceX = 0;
               }
               if(dy>-15.5 && dy<15.5)
               {
                   distanceY = 0;
               }
               
               _x = distanceX*10000;
               _y = distanceY*10000;
//                   mouseMove([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvUdpPort, distanceX*10000,distanceY*10000);
           }
        }];
    }
    else
    {
        NSLog(@"设备不支持加速计");
    }
    
    if(_motionManager.gyroAvailable)
    {
        _motionManager.gyroUpdateInterval = 0.03;
        [_motionManager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData* gyroData, NSError* error)
        {
           if(error)
           {
               [_motionManager stopGyroUpdates];
           }
           else
           {
               float x = gyroData.rotationRate.x*5*9.8;
               float y = gyroData.rotationRate.y*5*9.8;
               float z = gyroData.rotationRate.z*5*9.8;
               if(abs((int)x) <= 35)
               {
                   x = 0;
               }
               if(abs((int)z) <= 35)
               {
                   z = 0;
               }
               
               NSLog(@"x=%d--y=%d--z=%d", (int)x, (int)y, (int)z);
               mouseMove([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvUdpPort, -z,-x);
           }
        }];
    }
}

@end

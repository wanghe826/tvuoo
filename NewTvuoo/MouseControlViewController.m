//
//  MouseControlViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//
#import "MBProgressHUD.h"
#import "NullMouseViewController.h"
#import "MouseControlViewController.h"
#import "RemoteControlViewController.h"
#import "DEFINE.h"
#import "CommonBtn.h"
#import "domain/MyJniTransport.h"
#import "ParseJson.h"
#import "ZipArchive.h"
#import "AllUrl.h"
#import "NSTvuPoint.h"


@interface MouseControlViewController ()

@end

@implementation MouseControlViewController

@synthesize keyBeanArray;
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
@synthesize currentGameInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor grayColor];
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

#pragma sdk 游戏异常断开的回调
- (void) disconnectedWithSdk
{
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"很抱歉,SDK已经断开连接, 请重连!";
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:3];
    [hud release];
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}


- (void) pressMouseBtn
{
    if(_btn2Flag == YES)
    {
        return;
    }
    _btn2Flag = YES;
    
    [self addSomeViews];      //显示响应的控件
    
    UIView* yaoganIv = [self.view viewWithTag:827];
    if(yaoganIv)
    {
        yaoganIv.hidden = YES;
    }
    
    UIView* yaoganBall = [self.view viewWithTag:826];
    if(yaoganBall)
    {
        yaoganBall.hidden = YES;
    }
    
    [gameIvOnBtn setImage:[UIImage imageNamed:@"sbcz_shoubing1.png"]];
    [gameOpBtn setBackgroundColor:[UIColor blackColor]];
    
    [mouseIvOnBtn setImage:[UIImage imageNamed:@"sbcz_shubiao2.png"]];
    [mouseOpBtn setBackgroundColor:[UIColor whiteColor]];
    if(_btnFlag == NO)
    {
        [_uv1 removeFromSuperview];
        [_huituiLabel removeFromSuperview];
        [_huituiBtn removeFromSuperview];
        
        [_uv2 removeFromSuperview];
        [_xuanzhongLabel removeFromSuperview];
        [_xuanzhongBtn removeFromSuperview];
        
        [self.view addSubview:_dbHuituiLabel];
        [self.view addSubview:_dbHuituiBtn];
        
    }
}

- (void) pressGameBtn
{
    if(_btn2Flag == NO)
    {
        return;
    }
    _btn2Flag = NO;

    if(_btnFlag == NO)
    {
        [_dbHuituiBtn removeFromSuperview];
        [_dbHuituiLabel removeFromSuperview];
    }
    
    [self removeSomeViews];    //移除不需要显示的控件
    
    [gameIvOnBtn setImage:[UIImage imageNamed:@"sbcz_shoubing2.png"]];
    [gameOpBtn setBackgroundColor:[UIColor whiteColor]];
    
    [mouseIvOnBtn setImage:[UIImage imageNamed:@"sbcz_shubiao1.png"]];
    [mouseOpBtn setBackgroundColor:[UIColor blackColor]];
    
    //重力相关
    if(self.currentGameInfo.gravity == 1)
    {
        [self.view addSubview:_uvGes];
        [self.view addSubview:_gesBtnOn];
        [self.view addSubview:_gesBtnOff];
    }
    
    //手势相关
    if(self.currentGameInfo.bgTouch == 1)
    {
        [self.view addSubview:_gesFrame];
        [self.view addSubview:_gesBtn];
    }
    [self beginInitgameOptUI];
}

- (void) addSomeViews
{
    
    [_uvGes removeFromSuperview];
    [_gesBtnOff removeFromSuperview];
    [_gesBtnOn removeFromSuperview];
    
    [_gesFrame removeFromSuperview];
    [_gesBtn removeFromSuperview];
    
    if([_androidGameBtnArray count] > 0)
    {
        for(UIButton* btn in _androidGameBtnArray)
        {
            [btn removeFromSuperview];
        }
    }
    [self.view addSubview:_uv1];
    [self.view addSubview:_huituiLabel];
    [self.view addSubview:_huituiBtn];
    [self.view addSubview:_uv2];
    [self.view addSubview:_xuanzhongBtn];
    [self.view addSubview:_xuanzhongLabel];
    [self.view addSubview:_uv3];
    [self.view addSubview:self.moshiLabel];
    [self.view addSubview:_moshiIV];
    [self.view addSubview:self.mouseIV];
    [self.view addSubview:_frameUV];
    [self.view addSubview:self.customBtn];
    [self.view addSubview:self.doubleClickBtn];
}

- (void) removeSomeViews
{
    
    [_uv1 removeFromSuperview];
    [_huituiBtn removeFromSuperview];
    [_huituiLabel removeFromSuperview];
    [_uv2 removeFromSuperview];
    [_xuanzhongBtn removeFromSuperview];
    [_xuanzhongLabel removeFromSuperview];
    [_uv3 removeFromSuperview];
    [self.moshiLabel removeFromSuperview];
    [_moshiIV removeFromSuperview];
    [self.mouseIV removeFromSuperview];
    [_frameUV removeFromSuperview];
    [self.customBtn removeFromSuperview];
    [self.doubleClickBtn removeFromSuperview];
}

- (void) beginInitgameOptUI
{
    if(self.currentGameInfo == nil)
    {
        NSLog(@"返回了");
        return;
    }
    UIView* yaoganIv = [self.view viewWithTag:827];
    UIView* yaoganBall = [self.view viewWithTag:826];
    if(yaoganIv != nil)
    {
        yaoganIv.hidden = NO;
    }
    
    if(yaoganBall != nil)
    {
        yaoganBall.hidden = NO;
    }
    
    if([_androidGameBtnArray count] > 0)
    {
        for(UIButton* button in _androidGameBtnArray)
        {
            NSLog(@"增加按钮lllll %@", button);
            
            [self.view addSubview:button];
        }
        return;
    }
    
    int locRatX=1300/568,locRatY=768/320;
    int locRatX1 = 1920/568, locRatY1 = 1080/320;
    
    /****增加摇杆****/
    if(_rockerArray == nil)
    {
        NSLog(@"rocker是空得");
    }
    else
    {
        for(Rocker* rocker in _rockerArray)
        {
            UIImageView* yaoganIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaogan.png"]];
            yaoganIv.tag = 827;
            yaoganIv.frame = CGRectMake(0, 0, 80, 80);
            yaoganIv.center = CGPointMake(rocker.centerX/locRatX1*0.9, rocker.centerY/locRatY1*0.9-15);
            [self.view addSubview:yaoganIv];
            NSLog(@"摇杆中心点是:%@", NSStringFromCGPoint(CGPointMake(rocker.centerX/locRatX*0.9-5, rocker.centerY/locRatY*0.9)));
            
            UIImageView* ballIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball.png"]];
            ballIv.tag = 826;
            ballIv.frame = CGRectMake(0, 0, 50, 50);
            ballIv.center = yaoganIv.center;
            [self.view addSubview:ballIv];
            
            //设置摇杆的范围
            _yaoganRange = CGRectMake(ballIv.center.x-ballIv.frame.size.width/2-35, ballIv.center.y-ballIv.frame.size.height/2-35, 70+ballIv.frame.size.width, 70+ballIv.frame.size.height);
            
            _yaoganCenter = ballIv.center;
            [_rockerImageArray addObject:ballIv];
            [ballIv release];
            [yaoganIv release];
        }
    }
    
    for(KeyBean* keyBean in self.keyBeanArray)
    {
        int btnId = keyBean.idd;
        
        NSArray* array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString* path = [array objectAtIndex:0];
        
        
        UIImage *image1 = nil;
        if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_up.jpg",btnId]] isDirectory:NO])
        {
            image1 = [[UIImage alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_up.jpg",btnId]]];
        }
        else
        {
            image1 = [[UIImage alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_up.png",btnId]]];
        }
        
        
        CGImageRef imageRef = [image1 CGImage];
        NSUInteger height = CGImageGetHeight(imageRef);
        NSUInteger width = CGImageGetWidth(imageRef);
        AndroidGameButton* btn = [[AndroidGameButton alloc] initWithFrame:CGRectMake(keyBean.mobX/locRatX, keyBean.mobY/locRatY, width/locRatX*0.7, height/locRatY*0.7)];
        btn.imageUp = image1;
//        btn.center = CGPointMake(keyBean.mobX/locRatX*0.9, keyBean.mobY/locRatY*0.9);
        //修改安卓游戏按钮的图标位置
        btn.center = CGPointMake(keyBean.mobX/locRatX*0.9-5, keyBean.mobY/locRatY*0.9-15);
        
        [btn setImage:image1 forState:UIControlStateNormal];
        [image1 release];
        
        
        
        
        UIImage* image2 = nil;
        if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_down.jpg",btnId]] isDirectory:NO])
        {
            image2 = [[UIImage alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_down.jpg",btnId]]];
        }
        else
        {
            image2 = [[UIImage alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_down.png",btnId]]];
        }
        [btn setImage:image2 forState:UIControlStateHighlighted];
        [image2 release];
        [self.view addSubview:btn];
        btn.imageDown = image2;
        btn.tag = btnId;
        btn.userInteractionEnabled = NO;
        [_androidGameBtnArray addObject:btn];
        [btn release];
    }
}


#pragma mark diy delegate
- (void) closeHandle
{
    NSLog(@"close Handler");
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void) tryBtnPressed
{
    [_loadFailed removeFromSuperview];
//    [self beginInitgameOptUI];
    [self loadingAndroidGameBtn];
    
}
- (void) exitBtnPressed
{
    NSLog(@"exitBtnPressed");
    [_loadFailed removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void) addCusBtnAndDoubleClickBtn
{
    _frameUV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 108, 40)];
    [_frameUV setBackgroundColor:[UIColor blackColor]];
    [_frameUV.layer setBorderWidth:1.0];
    [_frameUV.layer setCornerRadius:20.0];
    [_frameUV.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:_frameUV];
    
    self.customBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.customBtn addTarget:self action:@selector(pressCustomBtn) forControlEvents:UIControlEventTouchUpInside];
    self.customBtn.frame = CGRectMake(15, 13, 49, 35);
    self.customBtn.layer.cornerRadius = 17.0;
    [self.customBtn setBackgroundColor:[UIColor whiteColor]];
    [self.customBtn setTitle:@"传统" forState:UIControlStateNormal];
    [self.view addSubview:self.customBtn];
    
    self.doubleClickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.doubleClickBtn addTarget:self action:@selector(pressDoubleClickBtn) forControlEvents:UIControlEventTouchUpInside];
    self.doubleClickBtn.frame = CGRectMake(65, 13, 49, 35);
    self.doubleClickBtn.layer.cornerRadius = 17.0;
    [self.doubleClickBtn setTitle:@"双击" forState:UIControlStateNormal];
    [self.doubleClickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.doubleClickBtn];
}

- (void) addTwoBtn
{
    UIImageView* frameUV = [[UIImageView alloc] initWithFrame:CGRectMake(380, 10, 108, 40)];
    [frameUV setBackgroundColor:[UIColor blackColor]];
    [frameUV.layer setBorderWidth:1.0];
    [frameUV.layer setCornerRadius:20.0];
    [frameUV.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:frameUV];
    
    mouseOpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mouseOpBtn addTarget:self action:@selector(pressMouseBtn) forControlEvents:UIControlEventTouchUpInside];
    mouseOpBtn.frame = CGRectMake(385, 13, 49, 35);
    mouseOpBtn.layer.cornerRadius = 17.0;
    [mouseOpBtn setBackgroundColor:[UIColor whiteColor]];
    mouseIvOnBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbcz_shubiao2.png"]];
    mouseIvOnBtn.center = CGPointMake(410, 30);
    [self.view addSubview:mouseOpBtn];
    [self.view addSubview:mouseIvOnBtn];
    [mouseIvOnBtn release];
    
    gameOpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [gameOpBtn addTarget:self action:@selector(pressGameBtn) forControlEvents:UIControlEventTouchUpInside];
    gameOpBtn.frame = CGRectMake(435, 13, 49, 35);
    gameOpBtn.layer.cornerRadius = 17.0;
    gameIvOnBtn = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"sbcz_shoubing1.png"]];
    gameIvOnBtn.center = CGPointMake(458,30);
    [self.view addSubview:gameOpBtn];
    [self.view addSubview:gameIvOnBtn];
    [gameIvOnBtn release];
    [frameUV release];
    
//    _uvGes = [[UIImageView alloc] initWithFrame:CGRectMake(150, 10, 118, 40)];
    _uvGes = [[UIImageView alloc] initWithFrame:CGRectMake(150, 8, 118, 44)];
    [_uvGes setBackgroundColor:[UIColor blackColor]];
    [_uvGes.layer setBorderWidth:2.0];
    [_uvGes.layer setCornerRadius:20.0];
    [_uvGes.layer setBorderColor:[blueColor CGColor]];
    
    
//    _gesBtnOn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _gesBtnOn = [[UIButton alloc] init];
    [_gesBtnOn setTitle:@"重力关" forState:UIControlStateNormal];
    _gesBtnOn.titleLabel.font = [UIFont fontWithName:@"Courier New" size:16];
    [_gesBtnOn setTitleColor:blueColor forState:UIControlStateNormal];
    [_gesBtnOn addTarget:self action:@selector(pressGesBtnOn) forControlEvents:UIControlEventTouchUpInside];
    _gesBtnOn.frame = CGRectMake(155, 13, 49, 35);
    _gesBtnOn.layer.cornerRadius = 17.0;
//    [_gesBtnOn setBackgroundColor:[UIColor whiteColor]];
    
    
//    _gesBtnOff = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _gesBtnOff = [[UIButton alloc] init];
//    [_gesBtnOff setTitle:@"重力关" forState:UIControlStateNormal];
    [_gesBtnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _gesBtnOff.titleLabel.font = [UIFont fontWithName:@"Courier New" size:16];
    _gesBtnOff.backgroundColor = [UIColor whiteColor];
    [_gesBtnOff setImage:[UIImage imageNamed:@"czyx_zhongliguan.png"] forState:UIControlStateNormal];
    [_gesBtnOff addTarget:self action:@selector(pressGesBtnOff) forControlEvents:UIControlEventTouchUpInside];
    _gesBtnOff.frame = CGRectMake(209, 13, 49, 35);
    _gesBtnOff.layer.cornerRadius = 17.0;
    
}



- (void) pressGesBtnOn
{
    if(_btn3Flag == YES)
    {
        return;
    }
    _btn3Flag = YES;
    
    [_gesBtnOn setTitle:nil forState:UIControlStateNormal];
    _gesBtnOn.backgroundColor = [UIColor whiteColor];
    [_gesBtnOn setImage:[UIImage imageNamed:@"czyx_zhonglikai.png"] forState:UIControlStateNormal];
    _gesBtnOff.backgroundColor = [UIColor blackColor];
    [_gesBtnOff setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_gesBtnOff setTitle:@"重力开" forState:UIControlStateNormal];
    [_gesBtnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_motionManager startAccelerometerUpdates];
    [self startGravity];
    
}
- (void) pressGesBtnOff
{
    if(_btn3Flag == NO)
    {
        return;
    }
    _btn3Flag = NO;
    _gesBtnOn.backgroundColor = [UIColor blackColor];
    [_gesBtnOn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_gesBtnOn setTitle:@"重力关" forState:UIControlStateNormal];
    [_gesBtnOn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _gesBtnOff.backgroundColor = [UIColor whiteColor];
    [_gesBtnOff setTitle:nil forState:UIControlStateNormal];
    [_gesBtnOff setImage:[UIImage imageNamed:@"czyx_zhongliguan.png"] forState:UIControlStateNormal];
    [_motionManager stopAccelerometerUpdates];
}

- (void) startGravity
{
    NSOperationQueue* queue = [[[NSOperationQueue alloc] init] autorelease];
    if(_motionManager.accelerometerAvailable)
    {
        _motionManager.accelerometerUpdateInterval = 9.0/100.0;
        [_motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData* accelerometerData, NSError* error)
         {
             if(error)
             {
                 [_motionManager stopAccelerometerUpdates];
             }
             else
             {
                 float x = (accelerometerData.acceleration.x * 9.8);
                 float y = (accelerometerData.acceleration.y * 9.8);
                 float z = accelerometerData.acceleration.z * 9.8;
                 if(self.single.tvType != 1)
                 {
                     sendSensor([Singleton getSingle].current_sdk.tvIp, [Singleton getSingle].current_sdk.tvUdpPort,  1, -x , -y,  z );
                 }
                 else
                 {
                     sendSensor([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvUdpPort,  1, -x , -y,  z );
                 }
             }
         }];
    }
    else
    {
        NSLog(@"设备不支持加速计");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _numOfPoint = 0;
    _touchMessArray = [[NSMutableArray alloc] initWithCapacity:5];
    _mutilPointArray = [[NSMutableArray alloc] initWithCapacity:5];
    _keyEventArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    _isMutilplePoint = NO;
    _avalibaleTouchNum = 0;
    _motionManager = [[CMMotionManager alloc] init];
//    [self startGravity];
    
    _btnFlag = YES; 
    _btn2Flag = YES;
    _btn3Flag = YES;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.center = self.view.center;
    _activityView.color = blueColor;
    
    
    _androidGameBtnArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    //添加背景图片
    UIImageView* heidi = [[UIImageView alloc] initWithFrame:self.view.frame];
    heidi.image = [UIImage imageNamed:@"sbcz_heidi.png"];
    [self.view addSubview:heidi];
    [heidi release];
    
    _backgroundImage = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sbcz_heidi.png"]];
    _backgroundImage.alpha = 0.5;
    
    _rockerImageArray = [[NSMutableArray alloc] init];
    
    if(iPhone4)
    {
        _backgroundImage.frame = CGRectMake(0, 0, 480, 320);
    }
    else if(iPhone5)
    {
        _backgroundImage.frame = CGRectMake(0, 0, 568, 320);
    }

    [self.view addSubview:_backgroundImage];
    
    
    self.single = [Singleton getSingle];
    if(self.single.tvType != 1)
    {
        h_rate = self.single.current_sdkTvInfo.height/self.view.frame.size.height;
        w_rate = self.single.current_sdkTvInfo.width/self.view.frame.size.width;
    }
    else
    {
        h_rate = self.single.current_tvInfo.height/self.view.frame.size.height;
        w_rate = self.single.current_tvInfo.width/self.view.frame.size.width;
    }
    
    
    [self addCusBtnAndDoubleClickBtn];
    [self addTwoBtn];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];  //隐藏状态栏
    
    //内存泄露修改
    UIImageView* mIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbcz_shou.png"]];
    self.mouseIV = mIv;
    self.mouseIV.frame = CGRectMake(340,170, 40, 40);
    [self.view addSubview:self.mouseIV];
    
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [mIv release];
    
    _uv1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 68, 98, 86)];
    [_uv1.layer setBorderWidth:1.0];
    [_uv1.layer setCornerRadius:4.0];
    [_uv1.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:_uv1];

//    _huituiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _huituiBtn = [[UIButton alloc] init];
    _huituiBtn.frame = CGRectMake(36,80, 45,45);
    [_huituiBtn addTarget:self action:@selector(pressHuituiBtn) forControlEvents:UIControlEventTouchUpInside];
    [_huituiBtn setBackgroundImage:[UIImage imageNamed:@"sbcz_huitui1.png"] forState:UIControlStateNormal];
    [_huituiBtn setBackgroundImage:[UIImage imageNamed:@"sbcz_huitui2.png"] forState:UIControlStateSelected];
    [self.view addSubview:_huituiBtn];
    
    _huituiLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 115, 35, 45)];
    _huituiLabel.text = @"回退";
    _huituiLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_huituiLabel];
    
    _uv2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 162, 98, 140)];
    [_uv2 addTarget:self action:@selector(pressSelected) forControlEvents:UIControlEventTouchUpInside];
//    [_uv2 setBackgroundColor:[UIColor blackColor]];
    [_uv2.layer setBorderWidth:1.0];
    [_uv2.layer setCornerRadius:4.0];
    [_uv2.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:_uv2];
    
//    _xuanzhongBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _xuanzhongBtn = [[UIButton alloc] init];
    _xuanzhongBtn.frame = CGRectMake(36,200, 45,45);
    [_xuanzhongBtn addTarget:self action:@selector(pressSelected) forControlEvents:UIControlEventTouchUpInside];
    [_xuanzhongBtn setBackgroundImage:[UIImage imageNamed:@"sbcz_xuanzhong1.png"] forState:UIControlStateNormal];
    [_xuanzhongBtn setBackgroundImage:[UIImage imageNamed:@"sbcz_xuanzhong2.png"] forState:UIControlStateSelected];
    [self.view addSubview:_xuanzhongBtn];
    _xuanzhongLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 240, 35, 45)];
    _xuanzhongLabel.text = @"选中";
    _xuanzhongLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_xuanzhongLabel];
    
    
    //(10,68,546,234)
    _uv3 = [[UIImageView alloc] initWithFrame:CGRectMake(128, 68, 428, 234)];
    [_uv3 setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:255.0/255.0 alpha:0]];
    [_uv3.layer setBorderWidth:1.0];
    [_uv3.layer setCornerRadius:4.0];
    [_uv3.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:_uv3];
    
    _moshiIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbcz_moshi.png"]];
    _moshiIV.frame = CGRectMake(470,270,80,30);
    [self.view addSubview:_moshiIV];
    //内存泄露修改
    UILabel* msLabel = [[UILabel alloc] initWithFrame:CGRectMake(486, 275, 60, 25)];
    self.moshiLabel = msLabel;
    self.moshiLabel.text = @"传统模式";
    self.moshiLabel.textColor = blueColor;
    [self.moshiLabel setFont:[UIFont fontWithName:@"Courier New" size:13]];
    [self.view addSubview:self.moshiLabel];
    [msLabel release];
    
    UIButton* setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setBtn.frame = CGRectMake(513, 10, 40, 40);
    [setBtn addTarget:self action:@selector(pressShezhiBtn) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"sbcz_sshezhi1.png"] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"sbcz_sshezhi2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:setBtn];
//
    _dbHuituiBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 190, 100, 100)];
    [_dbHuituiBtn setImage:[UIImage imageNamed:@"sbcz_fanhui1.png"] forState:UIControlStateNormal];
    [_dbHuituiBtn setImage:[UIImage imageNamed:@"sbcz_fanhui2.png"] forState:UIControlStateHighlighted];
    
    [_dbHuituiBtn addTarget:self action:@selector(dbHuituiBtnDown) forControlEvents:UIControlEventTouchDown];
    [_dbHuituiBtn addTarget:self action:@selector(dbHuituiBtnUp) forControlEvents:UIControlEventTouchUpInside];
    
    _dbHuituiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    _dbHuituiLabel.textColor = [UIColor whiteColor];
    _dbHuituiLabel.center = CGPointMake(_dbHuituiBtn.center.x+10, 270);
    _dbHuituiLabel.text = @"回退";
    self.view.multipleTouchEnabled = YES;
    
    _gesFlag = NO;
    
    //手势
    _gesFrame = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 60, 45)];
    [_gesFrame.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [_gesFrame.layer setBorderWidth:1];
    [_gesFrame.layer setCornerRadius:16.0];
    
    _gesBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, 11, 54, 39)];
    _gesBtn.backgroundColor = [UIColor whiteColor];
    [_gesBtn.layer setCornerRadius:16.0];
    [_gesBtn addTarget:self action:@selector(gesBtnTouch:) forControlEvents:UIControlEventTouchDown];
    [_gesBtn addTarget:self action:@selector(gesBtnUp:) forControlEvents:UIControlEventTouchUpInside];
    [_gesBtn addTarget:self action:@selector(gesBtnUp:) forControlEvents:UIControlEventTouchUpOutside];
    [_gesBtn setImage:[UIImage imageNamed:@"czyx_shoushiguan.png"] forState:UIControlStateNormal];
    
//    _gesView = [[GestureView alloc] initWithFrame:CGRectMake(0, 28, 568, 292)];
    
}

- (void) gesBtnTouch:(UIButton*)btn
{
    _gesFlag = YES;
    [btn setImage:[UIImage imageNamed:@"czyx_shoushikai.png"] forState:UIControlStateNormal];
    
    _gesView = [[GestureView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:_gesView];
}

- (void) gesBtnUp:(UIButton*)btn
{
    _gesFlag = NO;
    [btn setImage:[UIImage imageNamed:@"czyx_shoushiguan.png"] forState:UIControlStateNormal];
    
    if(_gesView != nil)
    {
        [_gesView removeFromSuperview];
        [_gesView release];
    }
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_motionManager stopAccelerometerUpdates];
    [Singleton getSingle].isInProtrait = NO;
    [Singleton getSingle].myExitGameDelegate = nil;
    [Singleton getSingle].mySdkBreakDownDelegate = nil;
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"MouseViewController view Will Appear");
    [Singleton getSingle].isInProtrait = YES;
    [Singleton getSingle].myBreakDownDelegate = self;
    [Singleton getSingle].myExitGameDelegate = self;
    [Singleton getSingle].mySdkBreakDownDelegate = self;
    
    
    
    _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_loadingView];
    [self loadingAndroidGameBtn];
}
- (void) loadingAndroidGameBtn
{
    if (self.currentGameInfo != nil)
    {
        NSLog(@"设置图片");
        [_backgroundImage setImageURL:[NSURL URLWithString:self.currentGameInfo.loadingUrl]];
    }
    
     NSMutableString* jsonStr = [[NSMutableString alloc] init];
     [jsonStr appendString:[[AllUrl getInstance] gameInfoUrl]];
     [jsonStr appendString:@"?gamepkg="];
     [jsonStr appendString:self.currentGameInfo.tvPkgName];

     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_async(queue, ^{
     
     //进行第一次网络请求;
     NSError* error = nil;
         NSLog(@"jsssssjjjjj %@", jsonStr);
     GameInfo* gameInfo = [ParseJson createGameInfoFromJson:jsonStr];
     if (gameInfo)
     {
         NSLog(@"是否支持背景触摸, %d", gameInfo.bgTouch);
         self.currentGameInfo.bgTouch = gameInfo.bgTouch;
         self.currentGameInfo.gravity = gameInfo.gravity;
         self.currentGameInfo.itunesPath = gameInfo.itunesPath;
         
         if(gameInfo.gravity == 1)
         {
             _btn3Flag = NO;
//             [self pressGesBtnOn];
             [self performSelectorOnMainThread:@selector(pressGesBtnOn) withObject:nil waitUntilDone:YES];
             
             NSLog(@"支持重力");
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [_uvGes removeFromSuperview];
                 [_gesBtnOn removeFromSuperview];
                 [_gesBtnOff removeFromSuperview];
             });
             
             NSLog(@"不支持重力");
         }
         
         
         _rockerArray = gameInfo.rockers;
         [_rockerArray retain];
         if([gameInfo.imgZipUrl isEqualToString:@""])
         {
             //该游戏没有按键， 比如   神庙逃亡
             dispatch_async(dispatch_get_main_queue(), ^{
                 [_loadingView removeFromSuperview];
                 [_loadingView release];
                 _loadingView = nil;
             });
             return ;
         }
         NSData* imgZipData = [NSData dataWithContentsOfURL:[NSURL URLWithString:gameInfo.imgZipUrl] options:kNilOptions error:&error];
         if (!error)
         {
             //zip 获取成功;
//             /var/mobile/Containers/Data/Application/23ACCF06-E85E-4814-874E-917078E72262/Library/Caches/myZipFile.zip
             NSArray* array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
             NSString* path = [array objectAtIndex:0];
             NSString* zipPath = [path stringByAppendingPathComponent:@"myZipFile.zip"];
             [imgZipData writeToFile:zipPath options:kNilOptions error:&error];
             if (!error)
             {
                 //zip 文件保存成功， 这里可以进行解压
                 ZipArchive* zipArchive = [[ZipArchive alloc] init];
                 if([zipArchive UnzipOpenFile:zipPath])
                 {
                     BOOL ret = [zipArchive UnzipFileTo:path overWrite:YES];
                     if(ret == NO)
                     {
                         [zipArchive UnzipCloseFile];
                     }
                 }
                 self.keyBeanArray = [gameInfo keyBeans];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [_loadingView removeFromSuperview];
                     [_loadingView release];
                     _loadingView = nil;
                 });
                 [zipArchive release];
             }
             else
             {
                 // save failed! 载入资源失败
                 _loadFailed = [[LoadFailed alloc] initWithFrame:CGRectMake(0, 0, 568, 320)];
                 _loadFailed.delegate = self;
                 [self.view addSubview:_loadFailed];
             }
         }
         else
         {
             NSLog(@"error downloading zip file! ");
             dispatch_async(dispatch_get_main_queue(), ^{
//                 [_activityView stopAnimating];
//                 [_activityView removeFromSuperview];
                 
                 //获取失败!!!
                 //开始
//                 _loadFailed = [[LoadFailed alloc] initWithFrame:CGRectMake(0, 0, 568, 320)];
//                 _loadFailed.delegate = self;
//                 [self.view addSubview:_loadFailed];
                 
                 [_loadingView removeFromSuperview];
                 [_loadingView release];
                 _loadingView = nil;
             });
         }
     }
     
     });
}

- (void) dbHuituiBtnDown
{
    _dbHuituiLabel.textColor = blueColor;
}

- (void) dbHuituiBtnUp
{
    _dbHuituiLabel.textColor = [UIColor whiteColor];
    if(self.currentGameInfo.gameRoot == 0)
    {
        keyEvent([Singleton getSingle].current_sdk.tvIp, [Singleton getSingle].current_sdk.tvServerport, 0, 4, 0);
        keyEvent([Singleton getSingle].current_sdk.tvIp, [Singleton getSingle].current_sdk.tvServerport, 1, 4, 0);
    }
    else
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 4, 0);
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 4, 0);
    }
    //发送电视回退信息;
}

- (void) pressShezhiBtn
{
    SettingView* setView = [[SettingView alloc] initWithFrame:CGRectMake(0, 0, 200, 320)];
    setView.center = CGPointMake(468, self.view.center.y);
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView  setAnimationCurve: UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view  cache:YES];
    [UIView commitAnimations];
    setView.exitDelegate = self;
    [self.view addSubview:setView];
    [self.view bringSubviewToFront:setView];
    [setView release];
}
- (void) pressCustomBtn
{
    if (_btnFlag == YES) {
        return;
    }
    _btnFlag = YES;
    doubleClickBtn.backgroundColor = [UIColor blackColor];
    [doubleClickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customBtn.backgroundColor = [UIColor whiteColor];
    [customBtn setTitleColor:blueColor forState:UIControlStateNormal];
    
    [self addCustomUI];
}
- (void) addCustomUI
{
    [self.view addSubview:_uv1];
    [self.view addSubview:_huituiBtn];
    [self.view addSubview:_huituiLabel];
    
    [self.view addSubview:_uv2];
    [self.view addSubview:_xuanzhongBtn];
    [self.view addSubview:_xuanzhongLabel];
    _uv3.frame = CGRectMake(128, 68, 428, 234);

    [_dbHuituiLabel removeFromSuperview];
    [_dbHuituiBtn removeFromSuperview];
}

- (void) pressDoubleClickBtn
{
    if(_btnFlag == NO)
    {
        return;
    }
    _btnFlag = NO;
    doubleClickBtn.backgroundColor = [UIColor whiteColor];
    [doubleClickBtn setTitleColor:blueColor forState:UIControlStateNormal];
    customBtn.backgroundColor = [UIColor blackColor];
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addDoubleClickUI];
}

- (void) addDoubleClickUI
{
    [_uv1 removeFromSuperview];
    [_huituiBtn removeFromSuperview];
    [_huituiLabel removeFromSuperview];
    
    [_uv2 removeFromSuperview];
    [_xuanzhongBtn removeFromSuperview];
    [_xuanzhongLabel removeFromSuperview];
    _uv3.frame = CGRectMake(10, 68, 546, 234);
    
    [self.view addSubview:_dbHuituiBtn];
    [self.view addSubview:_dbHuituiLabel];
}

- (void) pressSelected
{
    if(self.currentGameInfo.gameRoot == 0)
    {
        mouseEvent(single.current_sdk.tvIp, single.current_sdk.tvServerport, 0, 0, 0, 0);
        mouseEvent(single.current_sdk.tvIp, single.current_sdk.tvServerport, 1, 0, 0, 0);
    }
    else
    {
        mouseEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 0, 0, 0);
        mouseEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 0, 0, 0);
    }
}
- (void) pressHuituiBtn
{
    if(self.currentGameInfo.gameRoot == 0)
    {
        keyEvent([Singleton getSingle].current_sdk.tvIp, [Singleton getSingle].current_sdk.tvServerport, 0, 4, 0);
        keyEvent([Singleton getSingle].current_sdk.tvIp, [Singleton getSingle].current_sdk.tvServerport, 1, 4, 0);
    }
    else
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 4, 0);
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 4, 0);
    }
    
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
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)dealloc
{
    [_keyEventArray release];
    [_touchMessArray release];
    [_rockerArray release];
    [_rockerImageArray release];
    [_loadFailed release];
    [_backgroundImage release];
    [_frameUV release];
    [_uv1 release];
    [_huituiBtn release];
    [_huituiLabel release];
    [_uv2 release];
    [_xuanzhongBtn release] ;
    [_xuanzhongLabel release] ;
    [_uv3 release];
    [_dbHuituiBtn release];
    [_dbHuituiLabel release];
    [_moshiIV release];
    [_androidGameBtnArray release];
    [_activityView release];
    [_gesBtnOff release];
    [_gesBtnOn release];
    [_uvGes release];
//    [_gesView release];
    [super dealloc];
}


//控制屏幕方向     横屏
- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}
- (BOOL) shouldAutorotate
{
    return NO;
}


- (void) yaogan_move_in:(UITouch*)everyTouch withAction:(int)action
{

    
}


- (void) backgroundTouchBegan:(UIEvent*)event
{
    for(UITouch* touch in  [event allTouches])
    {
        if(touch.phase == 0)
        {
            CGPoint point = [touch locationInView:self.view];
            int width = 0, height = 0;
            if(self.single.tvType != 1)
            {
                width = self.single.current_sdkTvInfo.width*point.x/self.view.frame.size.width;
                height = self.single.current_sdkTvInfo.width*point.y/self.view.frame.size.height;
            }
            else
            {
                width = self.single.current_tvInfo.width*point.x/self.view.frame.size.width;
                height = self.single.current_tvInfo.height*point.y/self.view.frame.size.height;
            }
            NSTvuPoint* tvuPoint = [[NSTvuPoint alloc] init];
            tvuPoint.p_x = width;
            tvuPoint.p_y = height;
            tvuPoint.p_id = 0;
            tvuPoint.current_touch = touch;
            [_mutilPointArray addObject:tvuPoint];
            [tvuPoint release];
            if(self.single.tvType == 1)
            {
                sendMutiEvent(self.single.current_tv.tvIp,self.single.current_tv.tvServerport,self.single.current_tv.tvUdpPort, 0, [_mutilPointArray count], _mutilPointArray);
            }
            else
            {
                sendMutiEvent(self.single.current_sdk.tvIp,self.single.current_sdk.tvServerport,self.single.current_sdk.tvUdpPort, 0, [_mutilPointArray count], _mutilPointArray);
            }
        }
    }
}

- (void) backgroundTouchMove:(UIEvent*)event
{
    for(UITouch* everyTouch in [event allTouches])
    {
        if(everyTouch.phase == 1)
        {
            for(NSTvuPoint* point in _mutilPointArray)
            {
                if([everyTouch isEqual:point.current_touch])
                {
                    CGPoint locPoint = [everyTouch locationInView:self.view];
                    int width = 0, height = 0;
                    
                    if(self.single.tvType != 1)
                    {
                        width = self.single.current_sdkTvInfo.width*locPoint.x/self.view.frame.size.width;
                        height = self.single.current_sdkTvInfo.width*locPoint.y/self.view.frame.size.height;
                    }
                    else
                    {
                        width = self.single.current_tvInfo.width*locPoint.x/self.view.frame.size.width;
                        height = self.single.current_tvInfo.height*locPoint.y/self.view.frame.size.height;
                    }
                    point.p_x = width;
                    point.p_y = height;
                    
                    if(self.single.tvType == 1)
                    {
                        sendMutiEvent(single.current_tv.tvIp,single.current_tv.tvServerport,single.current_tv.tvUdpPort, 2, [_mutilPointArray count], _mutilPointArray);
                    }
                    else
                    {
                        sendMutiEvent(self.single.current_sdk.tvIp,single.current_sdk.tvServerport,self.single.current_sdk.tvUdpPort, 2, [_mutilPointArray count], _mutilPointArray);
                    }
                    break;
                }
            }
        }
    }
}

//屏幕触摸处理            // n*256+5（第n个手指按下，n>=0）     n*256+6（第n个手指抬起, n>=0)

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL isInButton = NO;
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    if(_btn2Flag != NO)
    {
        //边界处理
        if(loc.x < 128 || loc.x > 556 || loc.y < 68 || loc.y > 302)
        {
            return;
        }
        
        if(touch.phase == 0)
        {
            if(_btnFlag == NO)
            {
                if([touch tapCount] >= 2)
                {
                    if(self.currentGameInfo.gameRoot == 0)
                    {
                        mouseEvent(single.current_sdk.tvIp, single.current_sdk.tvServerport, 0, 0, 0, 0);
                        mouseEvent(single.current_sdk.tvIp, single.current_sdk.tvServerport, 1, 0, 0, 0);
                    }
                    else
                    {
                        mouseEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 0, 0, 0, 0);
                        mouseEvent(single.current_tv.tvIp, single.current_tv.tvServerport, 1, 0, 0, 0);
                    }
                    
                }
            }
            
        }
    }
    else
    {
        NSSet* touchSet = [event allTouches];
//        NSInteger numOfPoint = 0;
        
        int action = 0;
        for(UITouch* everyTouch in touchSet)
        {
            for(AndroidGameButton* button in _androidGameBtnArray)
            {
                if(CGRectContainsPoint(button.frame, [everyTouch locationInView:self.view]))
                {
                    if(everyTouch.phase == 0)
                    {
                        ++_numOfPoint;       //是否多点触摸
                        _avalibaleTouchNum++;
                        isInButton = YES;       //该touch 是否在button上面
                        [button setImage:button.imageDown forState:UIControlStateNormal];
                        int tag = button.tag;
                        for(KeyBean* keyBean in self.keyBeanArray)
                        {
                            if (keyBean.idd == tag)
                            {
                                int width = 0, height = 0;
                                
                                if(keyBean.type == 1)
                                {
                                    if(self.single.tvType != 1)
                                    {
                                        width = [Singleton getSingle].current_sdkTvInfo.width*keyBean.tvX/1920;
                                        height = [Singleton getSingle].current_sdkTvInfo.height*keyBean.tvY/1080;
                                        NSLog(@"sdk宽度: %d", keyBean.idd);
                                        NSLog(@"sdk-keyBean.x == %d", keyBean.tvX);
                                        NSLog(@"sdk--tv.x == %d", [Singleton getSingle].current_sdkTvInfo.width);
                                        NSLog(@"sdk高度: %d", height);
                                    }
                                    else
                                    {
                                        width = [Singleton getSingle].current_tvInfo.width*keyBean.tvX/1920;
                                        height = [Singleton getSingle].current_tvInfo.height*keyBean.tvY/1080;
                                    }
                                }
                                else if(keyBean.type == 2)
                                {
                                    if(self.single.tvType == 1)
                                    {
                                        keyEvent(self.single.current_tv.tvIp, self.single.current_tv.tvServerport, 0, keyBean.targetKey, 0);
                                        
                                    }
                                    else
                                    {
                                        keyEvent(self.single.current_sdk.tvIp, self.single.current_sdk.tvServerport, 0, keyBean.targetKey, 0);
                                    }
                                    
                                    NSTvuPoint* tvuPoint = [[NSTvuPoint alloc] init];
                                    tvuPoint.current_touch = everyTouch;
                                    tvuPoint.button = button;
                                    tvuPoint.keyBean = keyBean;
                                    [_keyEventArray addObject:tvuPoint];
                                    [tvuPoint release];
                                    
                                    return;
                                }
                                
                                
                                
                                NSTvuPoint* point = [[NSTvuPoint alloc] init];
                                point.button = button;
                                NSLog(@"发送%d",[_mutilPointArray count]);
                                switch ([_mutilPointArray count])
                                {
                                    case 0:
                                    {
                                        point.p_id = 0;
                                        action = 0;
                                    }
                                        break;
                                    case 1:
                                    {
                                        switch (((NSTvuPoint*)[_mutilPointArray objectAtIndex:0]).p_id)
                                        {
                                            case 0:
                                                point.p_id = 1;
                                                action = 261;
                                                break;
                                            case 1:
                                            case 2:
                                            case 3:
                                                point.p_id = 0;
                                                action = 5;
                                                break;
                                            default:
                                                break;
                                        }
                                        
                                    }
                                        break;
                                    default:
                                        break;
                                }
                                point.p_x = width;
                                point.p_y = height;
                                NSLog(@"id: %d", point.p_id);
                                NSLog(@"xx: %f", point.p_x);
                                NSLog(@"yy: %f", point.p_y);
                                NSLog(@"action: %d", action);
                                if([[event allTouches] count] == 1)
                                {
                                    [_mutilPointArray removeAllObjects];
                                }
                                point.current_touch = everyTouch;
                                [_mutilPointArray addObject:point];
                                [point release];
                                
                                break;
                                
                            }
                        }

                        NSLog(@"按下要发送的数组是：%@", _mutilPointArray);
                        if(self.single.tvType == 1)
                        {
                            sendMutiEvent(self.single.current_tv.tvIp, self.single.current_tv.tvServerport, self.single.current_tv.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                        }
                        else
                        {
                            sendMutiEvent(self.single.current_sdk.tvIp, self.single.current_sdk.tvServerport, self.single.current_sdk.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                        }
                    }
                    
                }
            }
            
            //处理摇杆
            for(UIImageView* iv in _rockerImageArray)
            {
                if(CGRectContainsPoint(_yaoganRange, [everyTouch locationInView:self.view]))
                {
                    if(everyTouch.phase == 0)
                    {
                        _numOfPoint++;
                        isInButton = YES;       //该touch是否在摇杆上面
                        CGPoint currentPoint = [everyTouch locationInView:self.view];
                        Rocker* rocker = [_rockerArray objectAtIndex:0];
                        
                        int width = 0, height = 0;
                        
                        float ratX = 0, ratY = 0;
                        
                        if(self.single.tvType != 1)
                        {
                            width = [Singleton getSingle].current_sdkTvInfo.width*rocker.centerX/1920;
                            height = [Singleton getSingle].current_sdkTvInfo.height*rocker.centerY/1080;
                        }
                        else
                        {
                            width = [Singleton getSingle].current_tvInfo.width*rocker.centerX/1920;
                            height = [Singleton getSingle].current_tvInfo.height*rocker.centerY/1080;
                        }
                        ratX = width/_yaoganCenter.x;
                        ratY = height/_yaoganCenter.y;
                        
                        int action = 0;
                        
                        NSTvuPoint* point = [[NSTvuPoint alloc] init];
                        switch ([_mutilPointArray count])
                        {
                            case 0:
                            {
                                point.p_id = 0;
                                action = 0;
                            }
                                break;
                            case 1:
                            {
                                switch (((NSTvuPoint*)[_mutilPointArray objectAtIndex:0]).p_id)
                                {
                                    case 0:
                                        point.p_id = 1;
                                        action = 261;
                                        break;
                                    case 1:
                                    case 2:
                                    case 3:
                                        point.p_id = 0;
                                        action = 5;
                                        break;
                                    default:
                                        break;
                                }
                                
                            }
                                break;
                            default:
                                break;
                        }
                        point.p_x = currentPoint.x*ratX;
                        point.p_y = currentPoint.y*ratY;
                        point.current_touch = everyTouch;
                        [_mutilPointArray addObject:point];
                        [point release];
                        
                        iv.center = [everyTouch locationInView:self.view];
                        NSLog(@"摇杆按下了---- ");
                        if(self.single.tvType == 1)
                        {
                            sendMutiEvent(self.single.current_tv.tvIp, self.single.current_tv.tvServerport, self.single.current_tv.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                        }
                        else
                        {
                            sendMutiEvent(self.single.current_sdk.tvIp, self.single.current_sdk.tvServerport, self.single.current_sdk.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                        }
                    }
                    
                }
                
            }
        }
        
        
        if(isInButton == NO)
        {
            _numOfPoint++;
            [self backgroundTouchBegan:event];
        }
        
        
        if(_numOfPoint > 1)
        {
            _isMutilplePoint = YES;     //多点
        }
        else
        {
            _isMutilplePoint = NO;      //单点
        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL isInButton = NO;
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    CGPoint preLoc = [touch previousLocationInView:self.view];

    if(_btn2Flag != NO)
    {
        if(_btnFlag == YES)
        {
            //边界处理(传统模式)
            if(loc.x < 128 || loc.x > 516 || loc.y < 68 || loc.y > 262)
            {
                return;
            }
        }
        if(_btnFlag == NO)
        {
            //边界处理(双击模式)
            if(loc.x < 10 || loc.x > 516 || loc.y < 68 || loc.y > 262)
            {
                return;
            }
        }
        
        if(touch.phase == 1)
        {
            //在这里发送鼠标坐标
            TvInfo* tv = nil;
            if(self.currentGameInfo.gameRoot == 0)
            {
                tv = self.single.current_sdk;
            }
            else
            {
                tv = self.single.current_tv;
            }
            int ip = tv.tvIp;
            int port = tv.tvUdpPort;

            mouseIV.frame = CGRectMake(loc.x, loc.y, 40, 40);
            mouseMove(ip, port, (loc.x-preLoc.x)*1.5*w_rate, (loc.y-preLoc.y)*1.5*h_rate);
        }
    }
    else
    {
        NSSet* touchSet = [event allTouches];
        int action = 0;
        for(UITouch* everyTouch in touchSet)
        {
            
            for(AndroidGameButton* button in _androidGameBtnArray)
            {
                if(everyTouch.phase == 1)
                {
                    if(CGRectContainsPoint(button.frame, [everyTouch locationInView:self.view]))
                    {
                        isInButton = YES;
                        return;
                    }
                }
            }
            //手指从摇杆移出
            //处理摇杆
            
            //手指滑动摇杆
//            [self yaogan_move_in:everyTouch withAction:action];
            //处理摇杆
            for(UIImageView* iv in _rockerImageArray)
            {
                if(everyTouch.phase == 1)
                {
                    if(CGRectContainsPoint(_yaoganRange, [everyTouch locationInView:self.view]))
                    {
                        isInButton = YES;
                        //手指刚刚进入摇杆区域
                        if(!CGRectContainsPoint(_yaoganRange, [everyTouch previousLocationInView:self.view]))
                        {
                            CGPoint currentPoint = [everyTouch locationInView:self.view];
                            Rocker* rocker = [_rockerArray objectAtIndex:0];
                            int width = 0, height = 0;
                            
                            float ratX = 0, ratY = 0;
                            
                            if(self.single.tvType != 1)
                            {
                                width = [Singleton getSingle].current_sdkTvInfo.width*rocker.centerX/1920;
                                height = [Singleton getSingle].current_sdkTvInfo.height*rocker.centerY/1080;
                            }
                            else
                            {
                                width = [Singleton getSingle].current_tvInfo.width*rocker.centerX/1920;
                                height = [Singleton getSingle].current_tvInfo.height*rocker.centerY/1080;
                            }
                            ratX = width/_yaoganCenter.x;
                            ratY = height/_yaoganCenter.y;
                            
                            BOOL haveTouch = NO;
                            NSUInteger index = 0;
                            for(NSTvuPoint* point in _mutilPointArray)
                            {
                                if([everyTouch isEqual:point.current_touch])
                                {
                                    haveTouch = YES;
                                    index =  [_mutilPointArray indexOfObject:point];
                                    break;
                                }
                            }
                            
                            if(haveTouch == YES)
                            {
                                ((NSTvuPoint*)[_mutilPointArray objectAtIndex:index]).button = nil;
                                ((NSTvuPoint*)[_mutilPointArray objectAtIndex:index]).p_x = currentPoint.x*ratX;
                                ((NSTvuPoint*)[_mutilPointArray objectAtIndex:index]).p_y = currentPoint.y*ratY;
                                switch ([_mutilPointArray count])
                                {
                                    case 0:
                                    {
                                        ((NSTvuPoint*)[_mutilPointArray objectAtIndex:index]).p_id = 0;
                                        action = 0;
                                    }
                                        break;
                                    case 1:
                                    {
                                        if([[event allTouches] count] == 1)
                                            ((NSTvuPoint*)[_mutilPointArray objectAtIndex:index]).p_id = 0;
                                        else
                                        switch (((NSTvuPoint*)[_mutilPointArray objectAtIndex:0]).p_id)
                                        {
                                            case 0:
                                                ((NSTvuPoint*)[_mutilPointArray objectAtIndex:index]).p_id = 1;
                                                action = 261;
                                                break;
                                            case 1:
                                            case 2:
                                            case 3:
                                                ((NSTvuPoint*)[_mutilPointArray objectAtIndex:index]).p_id = 0;
                                                action = 5;
                                                break;
                                            default:
                                                break;
                                        }
                                        
                                    }
                                        break;
                                    default:
                                        break;
                                }

                            }
                            else
                            {
                                NSTvuPoint* point = [[NSTvuPoint alloc] init];
                                point.button = nil;
                                point.p_x = currentPoint.x*ratX;
                                point.p_y = currentPoint.y*ratY;
                                point.current_touch = everyTouch;
                                
                                switch ([_mutilPointArray count])
                                {
                                    case 0:
                                    {
                                        point.p_id = 0;
                                        action = 0;
                                    }
                                        break;
                                    case 1:
                                    {
                                        if([[event allTouches] count] == 1)
                                            ((NSTvuPoint*)[_mutilPointArray objectAtIndex:index]).p_id = 0;
                                        else
                                        switch (((NSTvuPoint*)[_mutilPointArray objectAtIndex:0]).p_id)
                                        {
                                            case 0:
                                                point.p_id = 1;
                                                action = 261;
                                                break;
                                            case 1:
                                            case 2:
                                            case 3:
                                                point.p_id = 0;
                                                action = 5;
                                                break;
                                            default:
                                                break;
                                        }
                                        
                                    }
                                        break;
                                    default:
                                        break;
                                }
                                [point release];
                                [_mutilPointArray addObject:point];
                            }
                            iv.center = [everyTouch locationInView:self.view];
                            if(self.single.tvType == 1)
                            {
                                sendMutiEvent(self.single.current_tv.tvIp, self.single.current_tv.tvServerport, self.single.current_tv.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                                return;
                            }
                            else
                            {
                                sendMutiEvent(self.single.current_sdk.tvIp, self.single.current_sdk.tvServerport, self.single.current_sdk.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                                return;
                            }
                        }
                        //手指在摇杆区域内移动
                        else
                        {
                             CGPoint currentPoint = [everyTouch locationInView:self.view];
                             Rocker* rocker = [_rockerArray objectAtIndex:0];
                             
                             int width = 0, height = 0;
                             
                             float ratX = 0, ratY = 0;
                             
                             if(self.single.tvType != 1)
                             {
                                 width = [Singleton getSingle].current_sdkTvInfo.width*rocker.centerX/1920;
                                 height = [Singleton getSingle].current_sdkTvInfo.height*rocker.centerY/1080;
                             }
                             else
                             {
                                 width = [Singleton getSingle].current_tvInfo.width*rocker.centerX/1920;
                                 height = [Singleton getSingle].current_tvInfo.height*rocker.centerY/1080;
                             }
                             ratX = width/_yaoganCenter.x;
                             ratY = height/_yaoganCenter.y;
                             
                            for(NSTvuPoint* point in _mutilPointArray)
                            {
                                if([point.current_touch isEqual:everyTouch])
                                {
                                    point.button = nil;
                                    point.p_x = currentPoint.x*ratX;
                                    point.p_y = currentPoint.y*ratY;
                                    point.current_touch = everyTouch;
                                    switch ([_mutilPointArray count])
                                    {
                                        case 0:
                                        {
                                            point.p_id = 0;
                                            action = 0;
                                        }
                                            break;
                                        case 1:
                                        {
                                            if([[event allTouches] count] == 1)
                                                point.p_id = 0;
                                            else
                                            switch (((NSTvuPoint*)[_mutilPointArray objectAtIndex:0]).p_id)
                                            {
                                                case 0:
                                                    point.p_id = 1;
                                                    action = 261;
                                                    break;
                                                case 1:
                                                case 2:
                                                case 3:
                                                    point.p_id = 0;
                                                    action = 5;
                                                    break;
                                                default:
                                                    break;
                                            }
                                            
                                        }
                                            break;
                                        default:
                                            break;
                                    }
                                    break;
                                }
                            }
                             
                             iv.center = [everyTouch locationInView:self.view];
                             if(self.single.tvType == 1)
                             {
                             sendMutiEvent(self.single.current_tv.tvIp, self.single.current_tv.tvServerport, self.single.current_tv.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                                 return;
                             }
                             else
                             {
                             sendMutiEvent(self.single.current_sdk.tvIp, self.single.current_sdk.tvServerport, self.single.current_sdk.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                                 return;
                             }
                            
                        }
                    }
                }
            }
        }
    [self backgroundTouchMove:event];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
 
    NSSet* touchSet = [event allTouches];
    
    if(_btn2Flag == YES)
    {
        return;
    }
    for(UITouch* touch in [event allTouches])
    {
        for(NSTvuPoint* tvuPoint in _keyEventArray)
        {
            if([touch isEqual:tvuPoint.current_touch])
            {
                if(tvuPoint.keyBean != nil)
                {
                    [tvuPoint.button setImage:tvuPoint.button.imageUp forState:UIControlStateNormal];
                    if(self.single.tvType == 1)
                    {
                        NSLog(@"发送keyTarget: %d", tvuPoint.keyBean.targetKey);
                        NSLog(@"发送idd: %d", tvuPoint.keyBean.idd);
                        keyEvent(self.single.current_tv.tvIp, self.single.current_tv.tvServerport, 1, tvuPoint.keyBean.targetKey, 0);
                    }
                    else
                    {
                        keyEvent(self.single.current_sdk.tvIp, self.single.current_sdk.tvServerport, 1, tvuPoint.keyBean.targetKey, 0);
                    }
                    [_keyEventArray removeObject:tvuPoint];
                    return;
                }
            }
        }
    }
    
    for(UITouch* everyTouch in touchSet)
    {
        if(everyTouch.phase == 3)
        {
            
            for(NSTvuPoint* point in _mutilPointArray)
            {
                if([everyTouch isEqual: point.current_touch])
                {
                    if(point.button != nil)
                    {
                        [point.button setImage:point.button.imageUp forState:UIControlStateNormal];
                        NSLog(@"普通按钮抬起");
                    }
                    else
                    {
                        NSLog(@"摇杆的抬起事件");
                        if([_rockerImageArray count] != 0)
                        ((UIImageView*)[_rockerImageArray objectAtIndex:0]).center = _yaoganCenter;
                    }
                    int action = 0;
                    if(_isMutilplePoint)
                    {
                        if([[event allTouches] count] == 1)
                        {
                            action = 1;
                        }
                        else
                        {
                            action = point.p_id*256+6;
                        }
                    }
                    else
                    {
                        action = 1;
                    }
                    
                    NSLog(@"抬起,id %d", point.p_id);
                    NSLog(@"抬起，xx %f", point.p_x);
                    NSLog(@"抬起, yy %f", point.p_y);
                    NSLog(@"抬起, action %d",action);
                    NSLog(@"抬起要发送的数组是：%@", _mutilPointArray);
                    if(self.single.tvType == 1)
                    {
                        sendMutiEvent(self.single.current_tv.tvIp, self.single.current_tv.tvServerport, self.single.current_tv.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                    }
                    else
                    {
                        sendMutiEvent(self.single.current_sdk.tvIp, self.single.current_sdk.tvServerport, self.single.current_sdk.tvUdpPort, action, [_mutilPointArray count], _mutilPointArray);
                    }
                    [_mutilPointArray removeObject:point];
                    _numOfPoint--;
                    return;
                }
            }
            
        }
    }
    return;
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"TouchesCancelled");
//    UITouch* touch = [touches anyObject];
//    NSLog(@"touch phase : %ld", (long)touch.phase);
}

#pragma exitHandler
- (void) exitHandler
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) exitGame
{
//    if(self.single.switcher.exitgame_switch == 0)
    if([[AllUrl getInstance] tvu_showgame_switch] != 0)
    {
//        self.view addSubview:自定义view;
        ADView* adView = [[ADView alloc] initWithFrame:CGRectMake(74, 20, 420, 280)];
        adView.delegate = self;
        [self.view addSubview:adView];
        
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setImage:[UIImage imageNamed:@"xiazaiguanbi1.png"] forState:UIControlStateNormal];
        [closeBtn setImage:[UIImage imageNamed:@"xiazaiguanbi2.png"] forState:UIControlEventTouchDown];
        closeBtn.frame = CGRectMake(450, 25, 40, 40);
        [self.view addSubview:closeBtn];
        [adView release];
    }
    else
    {
        if(self.single.current_sdk != nil)
        {
            closeTcpClient(self.single.current_sdk.tvIp, self.single.current_sdk.tvServerport);
            self.single.current_sdk = nil;
        }
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
        if(self.currentGameInfo.gameRoot == 0)
        {
            return;
        }
        NSString* pkgName = self.currentGameInfo.tvPkgName;
        if(pkgName != nil)
        {
            sendExitGame([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, [pkgName UTF8String]);
        }
        
        
    }
}

-(void) closeView
{
//    [self removeFromSuperview];
    if(self.single.current_sdk != nil)
    {
        closeTcpClient(self.single.current_sdk.tvIp, self.single.current_sdk.tvServerport);
        self.single.current_sdk = nil;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
    if(self.currentGameInfo.gameRoot == 0)
    {
        return;
    }
    NSString* pkgName = self.currentGameInfo.tvPkgName;
    if(pkgName != nil)
    {
        sendExitGame([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, [pkgName UTF8String]);
    }
    
}

- (void) closeWebView:(UIButton*)btn
{
    [btn removeFromSuperview];
    UIWebView* webView = (UIWebView*)[self.view viewWithTag:1010];
    if(webView != nil)
    {
        [webView removeFromSuperview];
        [webView release];
    }
}

#pragma mark
- (void) leftBtnPressed
{
    //获取超值手柄
    NSLog(@"leftBtnPressed: %@", [[AllUrl getInstance] handshangkBuyUrl]);
    if([[[AllUrl getInstance] handshangkBuyUrl] isEqualToString:@""])
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"暂无" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    webView.center = self.view.center;
    webView.tag = 1010;
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    webView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [UIView commitAnimations];
    webView.delegate = self;
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[[AllUrl getInstance] handshangkBuyUrl] ]];
    [self.view addSubview:webView];
    
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, 50, 50);
    [closeBtn addTarget:self action:@selector(closeWebView:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"xiazaiguanbi1.png"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"xiazaiguanbi2.png"] forState:UIControlEventTouchDown];
    closeBtn.frame = CGRectMake(450, 25, 40, 40);
    [self.view addSubview:closeBtn];
    
    [webView loadRequest:request];
//    [webView release];
}

#pragma 加载网页
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"网络不给力哦！O(∩_∩)O~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    //webView开始加载
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = self.view.center;
    activity.tag = 1114;
    [self.view addSubview:activity];
    activity.hidden = NO;
    [activity startAnimating];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    //webView加载完成
    UIActivityIndicatorView* activity = (UIActivityIndicatorView*)[self.view viewWithTag:1114];
    if(activity != nil)
    {
        [activity stopAnimating];
        [activity removeFromSuperview];
        [activity release];
    }
}
- (void) rightBtnPressed
{
    //免费下载游戏
    NSLog(@"rightBtnPressed");
    if([self.currentGameInfo.itunesPath isEqualToString:@""])
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"暂无" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.currentGameInfo.itunesPath]];
}

@end

@implementation LoadFailed
@synthesize delegate;

-(id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* loadFailedIv = [[UIImageView alloc] initWithFrame:CGRectMake(200, 80, 80, 80)];
        loadFailedIv.image = [UIImage imageNamed:@"ty_ku.png"];
        [self addSubview:loadFailedIv];
        [loadFailedIv release];
        
        UILabel* netError = [[UILabel alloc] initWithFrame:CGRectMake(322, 80, 120, 40)];
        netError.text = @"网络出现异常";
        netError.textColor = blueColor;
        [self addSubview:netError];
        [netError release];
        
        UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(315, 125, 130, 1)];
        line.backgroundColor = greyColor;
        [self addSubview:line];
        [line release];
        
        UILabel* tryLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 130, 120, 40)];
        tryLabel.text = @"重新再来一次吧";
        tryLabel.textColor = greyColor;
        [self addSubview:tryLabel];
        [tryLabel release];
        
        //    _tryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tryBtn = [[UIButton alloc] init];
        [_tryBtn addTarget:self action:@selector(tryBtnTouch) forControlEvents:UIControlEventTouchDown];
        [_tryBtn addTarget:self action:@selector(tryBtnUp) forControlEvents:UIControlEventTouchUpInside];
        [_tryBtn.layer setBorderColor:[greyColor CGColor]];
        [_tryBtn setTitle:@"再试一次" forState:UIControlStateNormal];
        [_tryBtn setTitleColor:greyColor forState:UIControlStateNormal];
        [_tryBtn.layer setBorderWidth:1.0];
        [_tryBtn.layer setCornerRadius:8.0];
        _tryBtn.frame = CGRectMake(160, 240, 100, 50);
        [self addSubview:_tryBtn];
        
        //    _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn = [[UIButton alloc] init];
        [_exitBtn addTarget:self action:@selector(exitBtnTouch) forControlEvents:UIControlEventTouchDown];
        [_exitBtn addTarget:self action:@selector(exitBtnUp) forControlEvents:UIControlEventTouchUpInside];
        [_exitBtn.layer setBorderColor:[greyColor CGColor]];
        [_exitBtn setTitle:@"退出" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:greyColor forState:UIControlStateNormal];
        [_exitBtn.layer setBorderWidth:1.0];
        [_exitBtn.layer setCornerRadius:8.0];
        _exitBtn.frame = CGRectMake(350, 240, 70, 50);
        [self addSubview:_exitBtn];
    }
    return self;
}
- (void) tryBtnTouch
{
    _tryBtn.layer.borderColor = [greenColor CGColor];
    [_tryBtn setTitleColor:greenColor forState:UIControlStateNormal];
}
- (void) tryBtnUp
{
    _tryBtn.layer.borderColor = [greyColor CGColor];
    [_tryBtn setTitleColor:greyColor forState:UIControlStateNormal];
    if(self.delegate != nil)
    {
        if([self.delegate respondsToSelector:@selector(tryBtnPressed)])
        {
            [self.delegate tryBtnPressed];
        }
    }
}
- (void) exitBtnTouch
{
    _exitBtn.layer.borderColor = [greenColor CGColor];
    [_exitBtn setTitleColor:greenColor forState:UIControlStateNormal];
}
- (void) exitBtnUp
{
    _exitBtn.layer.borderColor = [greyColor CGColor];
    [_exitBtn setTitleColor:greyColor forState:UIControlStateNormal];
    if(self.delegate != nil)
    {
        if([self.delegate respondsToSelector:@selector(exitBtnPressed)])
        {
            [self.delegate exitBtnPressed];
        }
    }
}

- (void) dealloc
{
    [_exitBtn release];
    [_tryBtn release];
    self.delegate = nil;
    [super dealloc];
}

@end




/*
420
280
*/
@implementation ADView
@synthesize delegate;

-(id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        int x = 0;
        for(int i=0; i<28; ++i)
        {
            UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 15, 50)];
            iv.image = [UIImage imageNamed:@"tuichulan.png"];
            [self addSubview:iv];
            [iv release];
            x += 15;
        }
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 360, 40)];
        titleLabel.text = @"Hi 获得更好游戏体验很简单O（*-△-*）";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.center = CGPointMake(self.center.x-60, 25);
        [self addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView* leftIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        leftIv.image = [UIImage imageNamed:@"xiazai1.png"];
        leftIv.center = CGPointMake(105, 130);
        [self addSubview:leftIv];
        
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 30)];
        label1.font = [UIFont fontWithName:@"Courier New" size:12];
        label1.center = CGPointMake(leftIv.center.x, leftIv.center.y+70);
        label1.text = @"使用游戏专业手柄 效果杠杠的";
        label1.textColor = [UIColor colorWithRed:92.0/255.0 green:118.0/255.0 blue:147.0/255.0 alpha:1];
        [self addSubview:label1];
    
//        [leftIv release];
        
        UIImageView* rightIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        rightIv.image = [UIImage imageNamed:@"xiazai2.png"];
        rightIv.center = CGPointMake(315, 130);
        [self addSubview:rightIv];
        
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
        label2.font = [UIFont fontWithName:@"Courier New" size:12];
        label2.center = CGPointMake(rightIv.center.x, label1.center.y);
        label2.text = @"下载游戏到手机 欢乐随身带";
        label2.textColor = [UIColor colorWithRed:92.0/255.0 green:118.0/255.0 blue:147.0/255.0 alpha:1];
        [self addSubview:label2];
        
        [label2 release];
        [label1 release];
//        [rightIv release];
        
        UIButton* leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 40)];
        leftBtn.center = CGPointMake(leftIv.center.x, 245);
        [leftBtn.layer setBorderWidth:1];
        [leftBtn setTitle:@"获取超值手柄" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithRed:248.0/255.0 green:161.0/255.0 blue:49.0/255.0 alpha:1] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnTouch:) forControlEvents:UIControlEventTouchDown];
        [leftBtn addTarget:self action:@selector(leftBtnUp:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn.layer setCornerRadius:8];
        [leftBtn.layer setBorderColor:[[UIColor colorWithRed:248.0/255.0 green:161.0/255.0 blue:49.0/255.0 alpha:1] CGColor]];
        [self addSubview:leftBtn];
        
        
        UIButton* rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 40)];
        [rightBtn addTarget:self action:@selector(rightBtnTouch:) forControlEvents:UIControlEventTouchDown];
        [rightBtn addTarget:self action:@selector(rightBtnUp:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn.layer setBorderWidth:1];
        rightBtn.center = CGPointMake(rightIv.center.x, 245);
        [rightBtn setTitle:@"免费下载游戏" forState:UIControlStateNormal];
        [rightBtn setTitleColor:blueColor forState:UIControlStateNormal];
        [rightBtn.layer setCornerRadius:8];
        [rightBtn.layer setBorderColor:[blueColor CGColor]];
        [self addSubview:rightBtn];
        
        [leftIv release];
        [rightIv release];
        [leftBtn release];
        [rightBtn release];
    }
    return self;
}

- (void)leftBtnTouch:(UIButton*)sender
{
    [sender setTitleColor:blueColor forState:UIControlStateNormal];
    [sender.layer setBorderColor:[blueColor CGColor]];
}

- (void)leftBtnUp:(UIButton*)sender
{
    [sender setTitleColor:[UIColor colorWithRed:248.0/255.0 green:161.0/255.0 blue:49.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sender.layer setBorderColor:[[UIColor colorWithRed:248.0/255.0 green:161.0/255.0 blue:49.0/255.0 alpha:1] CGColor]];
    
    if(self.delegate != nil)
    {
        if([self.delegate respondsToSelector:@selector(leftBtnPressed)])
        {
            [self.delegate leftBtnPressed];
        }
    }
}
- (void)rightBtnTouch:(UIButton*)sender
{
    [sender setTitleColor:[UIColor colorWithRed:248.0/255.0 green:161.0/255.0 blue:49.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sender.layer setBorderColor:[[UIColor colorWithRed:248.0/255.0 green:161.0/255.0 blue:49.0/255.0 alpha:1] CGColor]];
}
- (void)rightBtnUp:(UIButton*)sender
{
    [sender setTitleColor:blueColor forState:UIControlStateNormal];
    [sender.layer setBorderColor:[blueColor CGColor]];
    
    if(self.delegate != nil)
    {
        if([self.delegate respondsToSelector:@selector(rightBtnPressed)])
        {
            [self.delegate rightBtnPressed];
        }
    }
}



-(void) dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end

@implementation GestureView
- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIImageView* backIv = [[UIImageView alloc] initWithFrame:frame];
//        backIv.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:0.7];
        backIv.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
        [self addSubview:backIv];
        [backIv release];
        
        UIImageView* jiantouIv = [[UIImageView alloc] initWithFrame:CGRectMake(50, 23, 70, 70)];
        jiantouIv.image = [UIImage imageNamed:@"xuxiankuangjiantou.png"];
        [self addSubview:jiantouIv];
        [jiantouIv release];
        
        UIImageView* hintIv = [[UIImageView alloc] initWithFrame:CGRectMake(120, 90, 220, 50)];
        hintIv.image = [UIImage imageNamed:@"xuxiankuang.png"];
        [self addSubview:hintIv];
        
        UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
        hintLabel.textColor = [UIColor whiteColor];
        hintLabel.text = @"松开手指退出手势模式";
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.center = hintIv.center;
        [self addSubview:hintLabel];
        [hintLabel release];
        [hintIv release];
        
        UIImageView* hintIv2 = [[UIImageView alloc] initWithFrame:CGRectMake(300, 220, 220, 50)];
        hintIv2.image = [UIImage imageNamed:@"xuxiankuang.png"];
        [self addSubview:hintIv2];
        
        UIImageView* shouIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        shouIv.image = [UIImage imageNamed:@"shou1.png"];
        [hintIv2 addSubview:shouIv];
        
        UILabel* hintLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 160, 40)];
        hintLabel2.text = @"请在屏幕上滑动手势";
        hintLabel2.textColor = [UIColor whiteColor];
        [hintIv2 addSubview:hintLabel2];
        [hintIv2 release];
        [shouIv release];
        [hintLabel2 release];
        _mutilPoint = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[event allTouches] count] > 2)
        return;

    for(UITouch* touch in  [event allTouches])
    {
        if(touch.phase == 0)
        {
            CGPoint point = [touch locationInView:self];
            int width = 0, height = 0;
            if([Singleton getSingle].tvType != 1)
            {
                width = [Singleton getSingle].current_sdkTvInfo.width*point.x/self.frame.size.width;
                height = [Singleton getSingle].current_sdkTvInfo.height*point.y/self.frame.size.height;
            }
            else
            {
                width = [Singleton getSingle].current_tvInfo.width*point.x/self.frame.size.width;
                height = [Singleton getSingle].current_tvInfo.height*point.y/self.frame.size.height;
            }
            NSTvuPoint* tvuPoint = [[NSTvuPoint alloc] init];
            tvuPoint.p_x = width;
            tvuPoint.p_y = height;
            tvuPoint.p_id = 0;
            tvuPoint.tag = 1234;
            tvuPoint.current_touch = touch;
            
            [_mutilPoint addObject:tvuPoint];
            NSLog(@"手势按下: %@", _mutilPoint);
            NSLog(@"px-- %f", tvuPoint.p_x);
            NSLog(@"py-- %f", tvuPoint.p_y);
            
            [tvuPoint release];
            Singleton* single = [Singleton getSingle];
            if(single.tvType == 1)
            {
                sendMutiEvent(single.current_tv.tvIp,single.current_tv.tvServerport,single.current_tv.tvUdpPort, 0, [_mutilPoint count], _mutilPoint);
            }
            else
            {
                
                sendMutiEvent(single.current_sdk.tvIp,single.current_sdk.tvServerport,single.current_sdk.tvUdpPort, 0, [_mutilPoint count], _mutilPoint);
            }
        }
    }
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[event allTouches] count] > 2)
    {
        return;
    }
    
    for(UITouch* everyTouch in [event allTouches])
    {
        if(everyTouch.phase == 1)
        {
            for(NSTvuPoint* point in _mutilPoint)
            {
                if([everyTouch isEqual:point.current_touch] && point.tag == 1234)
                {
                    CGPoint locPoint = [everyTouch locationInView:self];
                    int width = 0, height = 0;
                    
                    Singleton* single = [Singleton getSingle];
                    
                    if(single.tvType != 1)
                    {
                        width = single.current_sdkTvInfo.width*locPoint.x/self.frame.size.width;
                        height = single.current_sdkTvInfo.height*locPoint.y/self.frame.size.height;
                    }
                    else
                    {
                        width = single.current_tvInfo.width*locPoint.x/self.frame.size.width;
                        height = single.current_tvInfo.height*locPoint.y/self.frame.size.height;
                    }
                    point.p_x = width;
                    point.p_y = height;
                    
                    if(single.tvType == 1)
                    {
                        sendMutiEvent(single.current_tv.tvIp,single.current_tv.tvServerport,single.current_tv.tvUdpPort, 2, [_mutilPoint count], _mutilPoint);
                    }
                    else
                    {
                        sendMutiEvent(single.current_sdk.tvIp,single.current_sdk.tvServerport,single.current_sdk.tvUdpPort, 2, [_mutilPoint count], _mutilPoint);
                    }
                    break;
                }
            }
        }
    }
    
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    Singleton* single = [Singleton getSingle];
    
    if(single.tvType == 1)
    {
        sendMutiEvent(single.current_tv.tvIp,single.current_tv.tvServerport,single.current_tv.tvUdpPort, 1, [_mutilPoint count], _mutilPoint);
    }
    else
    {
        sendMutiEvent(single.current_sdk.tvIp,single.current_sdk.tvServerport,single.current_sdk.tvUdpPort, 1, [_mutilPoint count], _mutilPoint);
    }
    
    UITouch* touch = [touches anyObject];
    for(NSTvuPoint* point in _mutilPoint)
    {
        if([point.current_touch isEqual:touch])
        {
            [_mutilPoint removeObject:point];
        }
    }
}



- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


- (void) dealloc
{
    [_mutilPoint release];
    [super dealloc];
}
@end

@implementation LoadingView

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIImageView* bacImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 568, 320)];
        bacImage.backgroundColor = [UIColor grayColor];
        [self addSubview:bacImage];
        
        _activityView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_jiazai.png"]];
        _activityView.frame = CGRectMake(0, 0, 150, 150);
        _activityView.center = bacImage.center;
        [self addSubview:_activityView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        label.font = [UIFont fontWithName:@"Courier New" size:20];
        label.text = @"载入中.......";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.center = CGPointMake(bacImage.center.x, _activityView.center.y+100);
        [self addSubview:label];
        [label release];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.003f target:self selector:@selector(rotateImage) userInfo:nil repeats:YES];
        [_timer fire];
        [bacImage release];
    }
    return self;
}

- (void) rotateImage
{
    //    CGAffineTransform transform = CGAffineTransformMakeRotation(90*M_PI/180);
    static int n = 10;
    _activityView.transform = CGAffineTransformMakeRotation((n+=1)*M_PI/180);
}
- (void) removeFromSuperview
{
    [super removeFromSuperview];
    [_timer invalidate];
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
}

- (void) dealloc
{
    [_activityView release];
//    [_timer invalidate];
    [super dealloc];
}

@end


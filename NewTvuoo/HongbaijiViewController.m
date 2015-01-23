//
//  HongbaijiViewController.m
//  NewTvuoo
//
//  Created by xubo on 10/20 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//



#import "HongbaijiViewController.h"
#import "DEFINE.h"
#import "CommonBtn.h"
#import "MBProgressHUD.h"
#define yuanUp [UIImage imageNamed:@"ty_anniu1.png"];
#define yuanDown [UIImage imageNamed:@"ty_anniu2.png"];

@implementation HongbaijiViewController
@synthesize player1 = _player1;
@synthesize player2 = _player2;
@synthesize gameParam;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1];
        
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [Singleton getSingle].isInProtrait = NO;
    [Singleton getSingle].myExitGameDelegate = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Singleton getSingle].myBreakDownDelegate = self;
    [Singleton getSingle].isInProtrait = YES;
    NSLog(@"self.gameParam %d", self.gameParam);
    [Singleton getSingle].myExitGameDelegate = self;
    if(self.gameParam == 1 )
    {
        [self.leftUp removeFromSuperview];
        [self.rightUp removeFromSuperview];
        [self.leftDown removeFromSuperview];
        [self.rightDown removeFromSuperview];
    }
}

#pragma exitHandler
- (void) exitHandler
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
    UIImageView* frameUV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 18, 108, 41)];
    //    [frameUV setBackgroundColor:[UIColor colorWithRed:24.0/255.0 green:130.0/255.0 blue:237.0/255.0 alpha:1]];
    [frameUV.layer setBorderWidth:1.0];
    [frameUV.layer setCornerRadius:20.0];
    [frameUV.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:frameUV];
    
    _single = [Singleton getSingle];
    
    _btnFlag = YES;
    
    _player1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_player1 addTarget:self action:@selector(pressPlayer1Btn) forControlEvents:UIControlEventTouchUpInside];
    _player1.frame = CGRectMake(35, 21, 49, 35);
    _player1.layer.cornerRadius = 17.0;
    [_player1 setBackgroundColor:[UIColor whiteColor]];
    [_player1 setTitle:@"玩家①" forState:UIControlStateNormal];
    [self.view addSubview:_player1];
    
    _player2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_player2 addTarget:self action:@selector(pressPlayer2Btn) forControlEvents:UIControlEventTouchUpInside];
    _player2.frame = CGRectMake(85, 21, 49, 35);
    _player2.layer.cornerRadius = 17.0;
    [_player2 setTitle:@"玩家②" forState:UIControlStateNormal];
    [_player2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_player2];
    [frameUV release];
    
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.frame = CGRectMake(300, 10, 85, 47);
    selectBtn.tag = 75;
    [selectBtn setImage:[UIImage imageNamed:@"ty_xaunzhe1.png"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"ty_xaunzhe2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:selectBtn];
    
    UIButton* startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(410, 10, 80, 47);
    startBtn.tag = 76;
    [startBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setImage:[UIImage imageNamed:@"ty_start1.png"] forState:UIControlStateNormal];
    [startBtn setImage:[UIImage imageNamed:@"ty_start2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:startBtn];
    
    UIButton* settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.tag = 77;
    settingBtn.frame = CGRectMake(500, 10, 47, 47);
    [settingBtn setImage:[UIImage imageNamed:@"sbcz_sshezhi1.png"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"sbcz_sshezhi2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:settingBtn];
    
    self.view.multipleTouchEnabled = YES;
    
    
    
    _viewArray = [[NSMutableArray alloc] initWithCapacity:5];
//    _viewArray = [[NSMutableArray alloc] initWithObjects:self.up,self.down,self.left,self.right,self.leftUp,self.rightUp,self.leftDown,self.rightDown,self.upYuan,self.downYuan,self.leftYuan,self.rightYuan, nil];
    _touchArray = [[NSMutableArray alloc] initWithCapacity:5];
    

    /*  if(CGRectContainsPoint(self.up.frame, currentPoint))            //上
     {
     self.up.image = [UIImage imageNamed:@"psp_fx22.png"];
     [_viewArray addObject:self.up];
     sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 19);
     }
     if(CGRectContainsPoint(self.down.frame, currentPoint))     //下
     {
     [_viewArray addObject:self.down];
     self.down.image = [UIImage imageNamed:@"psp_fx82.png"];
     sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 20);
     }
     if (CGRectContainsPoint(self.left.frame, currentPoint))         //左
     {
     [_viewArray addObject:self.left];
     self.left.image = [UIImage imageNamed:@"psp_fx42.png"];
     sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 21);
     }
     if(CGRectContainsPoint(self.right.frame, currentPoint))    //右
     {
     [_viewArray addObject:self.right];
     self.right.image = [UIImage imageNamed:@"psp_fx62.png"];
     sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 22);
     }
     if(CGRectContainsPoint(self.leftUp.frame, currentPoint))   //左上
     {
     [_viewArray addObject:self.leftUp];
     self.leftUp.image = [UIImage imageNamed:@"psp_fx12.png"];
     sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 44);
     }
     if(CGRectContainsPoint(self.rightUp.frame, currentPoint))  //右上
     {
     [_viewArray addObject:self.rightUp];
     self.rightUp.image = [UIImage imageNamed:@"psp_fx32.png"];
     sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 29);
     }
     if(CGRectContainsPoint(self.leftDown.frame, currentPoint))  //左下
     {
     [_viewArray addObject:self.leftDown];
     self.leftDown.image = [UIImage imageNamed:@"psp_fx72.png"];
     sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 47);
     }
     if (CGRectContainsPoint(self.rightDown.frame, currentPoint))     //右下
     {
     [_viewArray addObject:self.rightDown];
     self.rightDown.image = [UIImage imageNamed:@"psp_fx92.png"];
     sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 32);
     */
    
    
    self.right.upImage = [UIImage imageNamed:@"psp_fx61.png"];
    self.right.downImage = [UIImage imageNamed:@"psp_fx62.png"];
    self.right.gameType = 2;
    self.right.keyCode = 22;
    
    self.left.upImage = [UIImage imageNamed:@"psp_fx41.png"];
    self.left.downImage = [UIImage imageNamed:@"psp_fx42.png"];
    self.left.gameType = 2;
    self.left.keyCode = 21;
    
    self.up.upImage = [UIImage imageNamed:@"psp_fx21.png"];
    self.up.downImage = [UIImage imageNamed:@"psp_fx22.png"];
    self.up.keyCode = 19;
    self.up.gameType = 2;
    
    self.down.upImage = [UIImage imageNamed:@"psp_fx81.png"];
    self.down.downImage = [UIImage imageNamed:@"psp_fx82.png"];
    self.down.gameType = 2;
    self.down.keyCode = 20;
    
    self.leftUp.upImage = [UIImage imageNamed:@"psp_fx11.png"];
    self.leftUp.downImage = [UIImage imageNamed:@"psp_fx12.png"];
    self.leftUp.gameType = 2;
    self.leftUp.keyCode = 44;
    
    self.rightUp.upImage = [UIImage imageNamed:@"psp_fx31.png"];
    self.rightUp.downImage = [UIImage imageNamed:@"psp_fx32.png"];
    self.rightUp.keyCode = 29;
    self.rightUp.gameType = 2;
    
    self.leftDown.upImage = [UIImage imageNamed:@"psp_fx71.png"];
    self.leftDown.downImage = [UIImage imageNamed:@"psp_fx72.png"];
    self.leftDown.keyCode = 47;
    self.leftDown.gameType = 2;
    
    self.rightDown.upImage = [UIImage imageNamed:@"psp_fx91.png"];
    self.rightDown.downImage = [UIImage imageNamed:@"psp_fx92.png"];
    self.rightDown.keyCode = 32;
    self.rightDown.gameType = 2;
    
    self.upYuan.upImage = yuanUp;
    self.upYuan.downImage = yuanDown;
    self.upYuan.gameType = 2;
    self.upYuan.keyCode = 100;
    
    self.downYuan.upImage = yuanUp;
    self.downYuan.downImage = yuanDown;
    self.downYuan.gameType = 2;
    self.downYuan.keyCode = 96;
    
    self.leftYuan.upImage = yuanUp;
    self.leftYuan.downImage = yuanDown;
    self.leftYuan.gameType = 2;
    self.leftYuan.keyCode = 99;
    
    self.rightYuan.upImage = yuanUp;
    self.rightYuan.downImage = yuanDown;
    self.rightYuan.gameType = 2;
    self.rightYuan.keyCode = 97;
    
    
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(disConn) name:@"breakDownInProtrait" object:nil];
}

- (void) disConn
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"连接断开" message:@"与电视的连接已经断开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [self.view addSubview:alertView];
    //    alertView.transform = CGAffineTransformMakeRotation(M_PI/2);        //顺时针旋转90度
    [alertView show];
}



- (void) pressPlayer1Btn
{
    if(self.btnFlag == NO)
    {
        self.btnFlag = YES;
        self.player1.backgroundColor = [UIColor whiteColor];
        self.player1.titleLabel.textColor = blueColor;
        
        self.player2.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:23.0/255.0 blue:12.0/255.0 alpha:0];
        self.player2.titleLabel.textColor = [UIColor whiteColor];
        
        self.right.keyCode = 22;
        self.left.keyCode = 21;
        self.up.keyCode = 19;
        self.down.keyCode = 20;
        self.leftUp.keyCode = 44;
        self.rightUp.keyCode = 29;
        self.leftDown.keyCode = 47;
        self.rightDown.keyCode = 32;
        self.upYuan.keyCode = 100;
        self.downYuan.keyCode = 96;
        self.leftYuan.keyCode = 99;
        self.rightYuan.keyCode = 97;
        self.right.gameType = 2;
        self.left.gameType = 2;
        self.up.gameType = 2;
        self.down.gameType = 2;
        self.leftUp.gameType = 2;
        self.rightUp.gameType = 2;
        self.leftDown.gameType = 2;
        self.rightDown.gameType = 2;
        self.upYuan.gameType = 2;
        self.downYuan.gameType = 2;
        self.leftYuan.gameType = 2;
        self.rightYuan.gameType = 2;
        
    }
}

- (void) pressPlayer2Btn
{
    if(self.btnFlag == YES)
    {
        self.btnFlag = NO;
        self.player1.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:23.0/255.0 blue:12.0/255.0 alpha:0];
        self.player1.titleLabel.textColor = [UIColor whiteColor];
        
        self.player2.backgroundColor = [UIColor whiteColor];
        [self.player2 setTitleColor:blueColor forState:UIControlStateNormal];
        
        self.right.keyCode = 10;
        self.right.gameType = 2;
        self.left.keyCode = 9;
        self.left.gameType = 2;
        self.up.keyCode = 7;
        self.up.gameType = 2;
        self.down.keyCode = 8;
        self.down.gameType = 2;
        self.leftUp.keyCode = 11;
        self.leftUp.gameType = 2;
        self.rightUp.keyCode = 12;
        self.rightUp.gameType = 2;
        self.leftDown.keyCode = 13;
        self.leftDown.gameType = 2;
        self.rightDown.keyCode = 14;
        self.rightDown.gameType = 2;
        self.upYuan.keyCode = 46;
        self.upYuan.gameType = 2;
        self.downYuan.keyCode = 45;
        self.downYuan.gameType = 2;
        self.leftYuan.keyCode = 51;
        self.leftYuan.gameType = 2;
        self.rightYuan.keyCode = 33;
        self.rightYuan.gameType = 2;
    }
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

-(void) dealloc
{
    [_viewArray release];
    [_leftUp release];
    [_up release];
    [_rightUp release];
    [_left release];
    [_right release];
    [_leftDown release];
    [_down release];
    [_rightDown release];
    [_upYuan release];
    [_downYuan release];
    [_leftYuan release];
    [_rightYuan release];
    [_y release];
    [_a release];
    [_x release];
    [_b release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

/*
 tag说明
 上下左右  51，52，53，54
 左上 右上 左下 右下 61, 62, 63, 64
 x 71
 y 72
 a 73
 b 74
 选择 75
 开始 76
 
 */
- (void)btnPress:(id)sender
{
    int tag = [(UIView*)sender tag];
    switch (tag) {
        case 75:
            NSLog(@"选择");
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 15);
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 1, 15);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 109);
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 1, 109);
            }
            break;
        case 76:
            NSLog(@"开始");
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 16);
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 1, 16);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 0, 108);
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 2, 1, 108);
            }
            break;
        case 77:
        {
            
            SettingView* setView = [[SettingView alloc] initWithFrame:CGRectMake(0, 0, 200, 320)];
            setView.center = CGPointMake(468, self.view.center.y);
//            [UIView beginAnimations:@"View Flip" context:nil];
//            [UIView setAnimationDuration:0.5];
//            [UIView  setAnimationCurve: UIViewAnimationCurveEaseInOut];
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
//            [UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:self.view cache:NO];
            [self.view addSubview:setView];
//            [UIView commitAnimations];
            setView.exitDelegate = self;
            

            [setView release];
        }
        default:
            break;
    }
}




- (void) exitGame
{
    NSLog(@"disMissView");
    NSString* game = @"game";
    const char* param = [game UTF8String];
    //    string param = gam
    sendExitGame([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 2, param);
    [self dismissViewControllerAnimated:NO completion:nil];
}



@end



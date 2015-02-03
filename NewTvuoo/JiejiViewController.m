//
//  JiejiViewController.m
//  NewTvuoo
//
//  Created by xubo on 10/16 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//
#import "MBProgressHUD.h"
#import "JiejiViewController.h"
#import "DEFINE.h"
#import "CommonBtn.h"
#import "domain/MyJniTransport.h"

@interface JiejiViewController ()

@end

@implementation JiejiViewController
@synthesize player1;
@synthesize player2;
@synthesize btnFlag;
@synthesize yaoganIv;
@synthesize yuanImageView;

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [Singleton getSingle].isInProtrait = NO;
    [Singleton getSingle].myExitGameDelegate = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Singleton getSingle].isInProtrait = YES;
    [Singleton getSingle].myBreakDownDelegate = self;
    [Singleton getSingle].myExitGameDelegate = self;
}

#pragma exithandler
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
    hud.labelText = @"网络异常,手机与电视连接断开,请您重新连接!";
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:3];
    [hud release];
    return;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _single = [Singleton getSingle];
    
    self.btnFlag = YES;
    UIImageView* backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jj_di.png"]];
    if(iPhone4)
    {
        backgroundImage.frame = CGRectMake(0,0,480,320);
    }
    else if(iPhone5)
    {
        backgroundImage.frame = CGRectMake(0, 0, 568, 320);
    }
    [self.view addSubview:backgroundImage];
    
    [backgroundImage release];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];   //隐藏状态栏

    [self addPlayerView];
    
    UIImageView* yuanView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jj_yuan.png"]];
//    self.yuanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jj_yuan.png"]];
    self.yuanImageView = yuanView ;
    self.yuanImageView.frame = CGRectMake(55, 135, 150,150);
    [self.view addSubview:self.yuanImageView];
    [yuanView release];
    
    UIImageView* yaogan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jj_yaogan.png"]];
    yaogan.frame = CGRectMake(0, 0, 80, 80);
//    self.yaoganIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jj_yaogan.png"]];
    self.yaoganIv = yaogan;
//    self.yaoganIv.frame = CGRectMake(0, 0, 80, 80);
    self.yaoganIv.center = yuanImageView.center;
    [self.view addSubview:self.yaoganIv];
//    [self.yaoganIv release];
    [yaogan release];
    
    UIButton* coinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [coinBtn addTarget:self action:@selector(putCoin) forControlEvents:UIControlEventTouchDown];
    [coinBtn addTarget:self action:@selector(putCoinUp) forControlEvents:UIControlEventTouchUpInside];
    coinBtn.frame = CGRectMake(310, 18, 75, 40);
    [coinBtn setImage:[UIImage imageNamed:@"ty_toubi1.png"] forState:UIControlStateNormal];
    [coinBtn setImage:[UIImage imageNamed:@"ty_toubi2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:coinBtn];
    
    UIButton* startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchDown];
    [startBtn addTarget:self action:@selector(startGameUp) forControlEvents:UIControlEventTouchUpInside];
    startBtn.frame = CGRectMake(400, 18, 90, 40);
    [startBtn setImage:[UIImage imageNamed:@"ty_start1.png"] forState:UIControlStateNormal];
    [startBtn setImage:[UIImage imageNamed:@"ty_start2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:startBtn];
    
    UIButton* settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(pressSetting) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.frame = CGRectMake(510, 18, 40, 40);
    [settingBtn setImage:[UIImage imageNamed:@"sbcz_sshezhi1.png"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"sbcz_sshezhi2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:settingBtn];
    
    _upYuan = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"ty_anniu1.png"]];
    
    
    _upYuan.keyCode = 100;
    _upYuan.gameType = 3;
    _upYuan.userInteractionEnabled = YES;
    _upYuan.frame = CGRectMake(381, 106, 70, 70);
    UILabel* yLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    yLabel.text = @"Y";
    yLabel.textColor = [UIColor whiteColor];
    yLabel.center = CGPointMake(_upYuan.bounds.size.width/2+_upYuan.frame.origin.x, _upYuan.bounds.size.height/2+_upYuan.frame.origin.y);
    _upYuan.upImage = [UIImage imageNamed:@"ty_anniu1.png"];
    _upYuan.downImage = [UIImage imageNamed:@"ty_anniu2.png"];
    [self.view addSubview:_upYuan];
    [self.view addSubview:yLabel];
    [yLabel release];
    
    _downYuan = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"ty_anniu1.png"]];
    
    _downYuan.keyCode = 96;
    _downYuan.gameType = 3;
    _downYuan.userInteractionEnabled = YES;
    _downYuan.frame = CGRectMake(388, 212, 70, 70);
    UILabel* aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    aLabel.text = @"A";
    aLabel.textColor = [UIColor whiteColor];
    aLabel.center = _downYuan.center;
    _downYuan.upImage = [UIImage imageNamed:@"ty_anniu1.png"];
    _downYuan.downImage = [UIImage imageNamed:@"ty_anniu2.png"];
    [self.view addSubview:_downYuan];
    [self.view addSubview:aLabel];
    [aLabel release];
    
    _leftYuan = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"ty_anniu1.png"]];
    
    _leftYuan.userInteractionEnabled = YES;
    _leftYuan.keyCode = 99;
    _leftYuan.gameType = 3;
    _leftYuan.frame = CGRectMake(325, 157, 70, 70);
    UILabel* xLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    xLabel.text = @"X";
    xLabel.textColor = [UIColor whiteColor];
    xLabel.center = _leftYuan.center;
    _leftYuan.upImage = [UIImage imageNamed:@"ty_anniu1.png"];
    _leftYuan.downImage = [UIImage imageNamed:@"ty_anniu2.png"];
    [self.view addSubview:_leftYuan];
    [self.view addSubview:xLabel];
    [xLabel release];
    
    _rightYuan = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"ty_anniu1.png"]];
    
    _rightYuan.userInteractionEnabled = YES;
    _rightYuan.keyCode = 97;
    _rightYuan.gameType = 3;
    _rightYuan.frame = CGRectMake(445, 157, 70, 70);
    UILabel* bLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    bLabel.text = @"B";
    bLabel.textColor = [UIColor whiteColor];
    bLabel.center = _rightYuan.center;
    _rightYuan.upImage = [UIImage imageNamed:@"ty_anniu1.png"];
    _rightYuan.downImage = [UIImage imageNamed:@"ty_anniu2.png"];
    [self.view addSubview:_rightYuan];
    [self.view addSubview:bLabel];
    [bLabel release];
    
    _leftUpFlag = NO;           //no表示抬起
    _upFlag = NO;
    _rightUpFlag = NO;
    _leftFlag = NO;
    _rightFlag = NO;
    _leftDownFlag = NO;
    _downFlag = NO;
    _rightDownFlag = NO;
    
    _leftUp = CGRectMake(55, 135, 50, 50);
    _up = CGRectMake(105, 135, 50, 50);
    _rightUp = CGRectMake(155, 135, 50, 50);
    _left = CGRectMake(55, 185, 50, 50);
    _right = CGRectMake(155, 185, 50, 50);
    _leftBottom = CGRectMake(55, 235, 50, 50);
    _bottom = CGRectMake(105, 235, 50, 50);
    _rightBottom = CGRectMake(155, 235, 50, 50);
    
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

- (void) pressSetting
{
    SettingView* setView = [[SettingView alloc] initWithFrame:CGRectMake(0, 0, 200, 320)];
    setView.center = CGPointMake(468, self.view.center.y);
//    [UIView beginAnimations:@"View Flip" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView  setAnimationCurve: UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view  cache:YES];
//    [UIView commitAnimations];
    setView.exitDelegate = self;
    [self.view addSubview:setView];
    
    [setView release];
}

- (void) putCoin
{
    if(self.btnFlag == NO)
    {
        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 35);
    }
    else
    {

        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 109);
    }
}

- (void) putCoinUp
{
    if(self.btnFlag == NO)          //p2
    {
        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 35);
    }
    else                            //p1
    {
        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 109);
    }
}

- (void) startGame
{
    if(self.btnFlag == NO)
    {
        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 36);
//        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 36);
    }
    else
    {
        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 108);
//        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 108);
    }
}

- (void) startGameUp
{
    if(self.btnFlag == NO)
    {
//        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 36);
        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 36);
    }
    else
    {
//        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 108);
        sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 108);
    }
}
- (void) addPlayerView
{
    UIImageView* frameUV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 18, 108, 40)];
//    [frameUV setBackgroundColor:[UIColor colorWithRed:24.0/255.0 green:130.0/255.0 blue:237.0/255.0 alpha:1]];
    [frameUV.layer setBorderWidth:1.0];
    [frameUV.layer setCornerRadius:20.0];
    [frameUV.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:frameUV];
    
    self.player1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.player1 addTarget:self action:@selector(pressPlayer1Btn) forControlEvents:UIControlEventTouchUpInside];
    self.player1.frame = CGRectMake(35, 21, 49, 35);
    self.player1.layer.cornerRadius = 17.0;
    [self.player1 setBackgroundColor:[UIColor whiteColor]];
    [self.player1 setTitle:@"玩家①" forState:UIControlStateNormal];
    [self.view addSubview:self.player1];
    
    self.player2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.player2 addTarget:self action:@selector(pressPlayer2Btn) forControlEvents:UIControlEventTouchUpInside];
    self.player2.frame = CGRectMake(85, 21, 49, 35);
    self.player2.layer.cornerRadius = 17.0;
    [self.player2 setTitle:@"玩家②" forState:UIControlStateNormal];
    [self.player2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.player2];
    [frameUV release];
}

- (void) pressPlayer1Btn
{
    if(self.btnFlag == NO)
    {
        self.btnFlag = YES;             //玩家1
        self.player1.backgroundColor = [UIColor whiteColor];
        self.player1.titleLabel.textColor = blueColor;
        
        self.player2.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:23.0/255.0 blue:12.0/255.0 alpha:0];
        self.player2.titleLabel.textColor = [UIColor whiteColor];
        
        _upYuan.keyCode = 100;
        _downYuan.keyCode = 96;
        _leftYuan.keyCode = 99;
        _rightYuan.keyCode = 97;
        
    }
}

- (void) pressPlayer2Btn
{
    if(self.btnFlag == YES)
    {
        self.btnFlag = NO;              //玩家2
        self.player1.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:23.0/255.0 blue:12.0/255.0 alpha:0];
        self.player1.titleLabel.textColor = [UIColor whiteColor];
        
        self.player2.backgroundColor = [UIColor whiteColor];
        [self.player2 setTitleColor:blueColor forState:UIControlStateNormal];
        
        _upYuan.keyCode = 29;
        _downYuan.keyCode = 44;
        _leftYuan.keyCode = 43;
        _rightYuan.keyCode = 47;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (void) dealloc
{
    self.player2 = nil;
    self.player1 = nil;
    self.yaoganIv = nil;
    self.yuanImageView = nil;
    self.yaoganIv = nil;
    
    [super dealloc];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    

    CGRect range = CGRectMake(70, 150, 120, 120);
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    if(CGRectContainsPoint(range, currentPoint))
    {
        self.yaoganIv.center = currentPoint;
    }
    
    if(CGRectContainsPoint(_up, currentPoint))
    {
        if(_upFlag != YES)
        {
            //发送事件
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 48);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 19);
            }
            _upFlag = YES;
        }
    }
    if(CGRectContainsPoint(_bottom, currentPoint))
    {
        if(_downFlag != YES)
        {
            _downFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 53);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 20);
            }
        }
    }
    if(CGRectContainsPoint(_left, currentPoint))
    {
        if(_leftFlag != YES)
        {
            _leftFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 49);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 21);
            }
        }
    }
    if(CGRectContainsPoint(_right, currentPoint))
    {
        if(_rightFlag != YES)
        {
            _rightFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 37);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 22);
            }
        }
    }
    
    if(CGRectContainsPoint(_leftUp, currentPoint))
    {
        if(_leftUpFlag != YES)
        {
            _leftUpFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -3);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -2);
            }
        }
    }
    if(CGRectContainsPoint(_leftBottom, currentPoint))
    {
        if(_leftDownFlag != YES)
        {
            _leftDownFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -5);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -4);
            }
        }
    }
    if(CGRectContainsPoint(_rightUp, currentPoint))
    {
        if(_rightUpFlag != YES)
        {
            _rightUpFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -9);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -8);
            }
        }
    }
    if(CGRectContainsPoint(_rightBottom, currentPoint))
    {
        if(_rightDownFlag != YES)
        {
            _rightDownFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -7);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -6);
            }

        }
    }
    
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect range = CGRectMake(70, 150, 120, 120);
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prePoint = [[touches anyObject] previousLocationInView:self.view];
    
    if(CGRectContainsPoint(range, currentPoint))
    {
        self.yaoganIv.center = currentPoint;
    }
    
    //摇杆离开方向盘，归位
    if(!CGRectContainsPoint(range, currentPoint))
    {
//        self.yaoganIv.center = self.yuanImageView.center;
        return;
    }
    
    if(CGRectContainsPoint(_up, currentPoint))
    {
        if(_upFlag != YES)
        {
            //发送事件
            _upFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 48);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 19);
            }
        }
    }
    if(!CGRectContainsPoint(_up, currentPoint) && CGRectContainsPoint(_up, prePoint))
    {
        if(_upFlag != NO)
        {
            //发送事件
            _upFlag = NO;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 48);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 19);
            }
        }
    }
    
    if(CGRectContainsPoint(_bottom, currentPoint))
    {
        if(_downFlag != YES)
        {
            //发送事件
            _downFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 53);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 20);
            }
        }
    }
    if(!CGRectContainsPoint(_bottom, currentPoint) && CGRectContainsPoint(_bottom, prePoint))
    {
        if(_downFlag != NO)
        {
            //发送事件
            _downFlag = NO;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 53);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 20);
            }
        }
    }
    
    if(CGRectContainsPoint(_left, currentPoint))
    {
        if(_leftFlag != YES)
        {
            _leftFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 49);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 21);
            }
        }
    }
    if(!CGRectContainsPoint(_left, currentPoint) && CGRectContainsPoint(_left, prePoint))
    {
        if(_leftFlag != NO)
        {
            _leftFlag = NO;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 49);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 21);
            }
        }
    }
    if(CGRectContainsPoint(_right, currentPoint))
    {
        if(_rightFlag != YES)
        {
            //发送事件
            _rightFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 37);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, 22);
            }
        }
    }
    if(!CGRectContainsPoint(_right, currentPoint) && CGRectContainsPoint(_right, prePoint))
    {
        if(_rightFlag != NO)
        {
            //发送事件
            _rightFlag = NO;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 37);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, 22);
            }
        }
    }
    
    
    if(CGRectContainsPoint(_leftUp, currentPoint))
    {
        if(_leftUpFlag != YES)
        {
            _leftUpFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -3);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -2);
            }
        }
    }
    if(!CGRectContainsPoint(_leftUp, currentPoint) && CGRectContainsPoint(_leftUp, prePoint))
    {
        if(_leftUpFlag != NO)
        {
            _leftUpFlag = NO;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, -3);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, -2);
            }
        }
    }
    if(CGRectContainsPoint(_leftBottom, currentPoint))
    {
        if(_leftDownFlag != YES)
        {
            _leftDownFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -5);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -4);
            }
        }
    }
    if(!CGRectContainsPoint(_leftBottom, currentPoint) && CGRectContainsPoint(_leftBottom, prePoint))
    {
        if(_leftDownFlag != NO)
        {
            _leftDownFlag = NO;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, -5);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, -4);
            }
        }
    }
    if(CGRectContainsPoint(_rightUp, currentPoint))
    {
        if(_rightUpFlag != YES)
        {
            _rightUpFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -9);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -8);
            }
        }
    }
    if(!CGRectContainsPoint(_rightUp, currentPoint) && CGRectContainsPoint(_rightUp, prePoint))
    {
        if(_rightUpFlag != NO)
        {
            _rightUpFlag = NO;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, -9);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, -8);
            }
        }
    }
    
    
    
    if(CGRectContainsPoint(_rightBottom, currentPoint))
    {
        if(_rightDownFlag != YES)
        {
            _rightDownFlag = YES;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -7);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 0, -6);
            }
        }
    }
    
    if(!CGRectContainsPoint(_rightBottom, currentPoint) && CGRectContainsPoint(_rightBottom, prePoint))
    {
        if(_rightDownFlag != NO)
        {
            _rightDownFlag = NO;
            if(self.btnFlag == NO)
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, -7);
            }
            else
            {
                sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport, 3, 1, -6);
            }
        }
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.yaoganIv.center = self.yuanImageView.center;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.yaoganIv.center = self.yuanImageView.center;
    if(_upFlag == YES)
    {
        //发送上 抬起事件
        _upFlag = NO;
        if(self.btnFlag == NO)
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, 48);
        }
        else
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, 19);
        }
    }
    
    if(_leftUpFlag == YES)
    {
        _leftUpFlag = NO;
        if(self.btnFlag == NO)
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, -3);
        }
        else
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, -2);
        }
    }
    
    if(_rightUpFlag == YES)
    {
        _rightUpFlag = NO;
        if(self.btnFlag == NO)
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, -9);
        }
        else
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, -8);
        }
    }
    
    if(_leftFlag == YES)
    {
        _leftFlag = NO;
        if(self.btnFlag == NO)
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, 49);
        }
        else
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, 21);
        }
    }
    
    if(_rightFlag == YES)
    {
        _rightFlag = NO;
        if(self.btnFlag == NO)
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, 37);
        }
        else
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, 22);
        }
    }
    
    if(_leftDownFlag == YES)
    {
        _leftDownFlag = NO;
        if(self.btnFlag == NO)
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, -5);
        }
        else
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, -4);
        }
    }
    
    if(_downFlag == YES)
    {
        _downFlag = NO;
        if(self.btnFlag == NO)
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, 53);
        }
        else
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, 20);
        }
    }
    
    if(_rightDownFlag == YES)
    {
        _rightDownFlag = NO;
        if(self.btnFlag == NO)
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, -7);
        }
        else
        {
            sendSimulator(_single.current_tv.tvIp, _single.current_tv.tvServerport,3, 1, -6);
        }
    }
}

//退出游戏
- (void) exitGame
{
    NSString* game = @"game";
    const char* param = [game UTF8String];
//    string param = gam
    sendExitGame([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 3, param);
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end

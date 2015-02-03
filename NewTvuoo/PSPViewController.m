//
//  PSPViewController.m
//  NewTvuoo
//
//  Created by xubo on 10/20 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//
#import "MBProgressHUD.h"
#import "PSPViewController.h"
#import "Singleton.h"
#import "domain/MyJniTransport.h"
#import <AudioToolbox/AudioToolbox.h>
#import "domain/MyJniTransport.h"

static SystemSoundID shake_sound_male_id = 0;
#define DIRCT_SIZE 57

@interface PSPViewController ()

@end


/*
 private static final int PSP_CODE_UP = 0x0010;
	private static final int PSP_CODE_DOWN = 0x0040;
	private static final int PSP_CODE_LEFT = 0x0080;
	private static final int PSP_CODE_RIGHT = 0x0020;
	private static final int PSP_CODE_L = 0x0100;
	private static final int PSP_CODE_R = 0x0200;
	private static final int PSP_CODE_SANJIAO = 0x1000;
	private static final int PSP_CODE_FANG = 0x8000;
	private static final int PSP_CODE_YUAN = 0x2000;
	private static final int PSP_CODE_CHA = 0x4000;
	private static final int PSP_CODE_SELECT = 0x0001;
	private static final int PSP_CODE_START = 0x0008;
 */
@implementation PSPViewController

- (void) initDirectionUI
{
    
    _leftUp = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"psp_fx11.png"]];
    _leftUp.keyCode = 1245;
    _leftUp.gameType = 4;
    _leftUp.frame = CGRectMake(22, 75, DIRCT_SIZE, DIRCT_SIZE);
    _leftUp.upImage = [UIImage imageNamed:@"psp_fx11.png"];
    _leftUp.downImage = [UIImage imageNamed:@"psp_fx12.png"];
    [self.view addSubview:_leftUp];
    
    _up = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"psp_fx21.png"]];
    _up.keyCode = 0x0010;
    _up.gameType = 4;
    _up.frame = CGRectMake(_leftUp.frame.origin.x+DIRCT_SIZE, _leftUp.frame.origin.y, DIRCT_SIZE, DIRCT_SIZE);
    _up.upImage = [UIImage imageNamed:@"psp_fx21.png"];
    _up.downImage = [UIImage imageNamed:@"psp_fx22.png"];
    [self.view addSubview:_up];
    
    _rightUp = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"psp_fx31.png"]];
    _rightUp.keyCode = 1246;
    _rightUp.gameType = 4;
    _rightUp.frame = CGRectMake(_up.frame.origin.x+DIRCT_SIZE, _up.frame.origin.y, DIRCT_SIZE, DIRCT_SIZE);
    _rightUp.upImage = [UIImage imageNamed:@"psp_fx31.png"];
    _rightUp.downImage = [UIImage imageNamed:@"psp_fx32.png"];
    [self.view addSubview:_rightUp];
    
    _left = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"psp_fx41.png"]];
    _left.keyCode = 0x0080;
    _left.gameType = 4;
    _left.frame = CGRectMake(_leftUp.frame.origin.x, _leftUp.frame.origin.y+DIRCT_SIZE, DIRCT_SIZE, DIRCT_SIZE);
    _left.upImage = [UIImage imageNamed:@"psp_fx41.png"];
    _left.downImage = [UIImage imageNamed:@"psp_fx42.png"];
    [self.view addSubview:_left];
    
    _center = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"psp_fx5.png"]];
    _center.frame = CGRectMake(_left.frame.origin.x+DIRCT_SIZE, _left.frame.origin.y, DIRCT_SIZE, DIRCT_SIZE);
    [self.view addSubview:_center];
    
    _right = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"psp_fx61.png"]];
    _right.keyCode = 0x0020;
    _right.gameType = 4;
    _right.frame = CGRectMake(_center.frame.origin.x+DIRCT_SIZE, _center.frame.origin.y, DIRCT_SIZE, DIRCT_SIZE);
    _right.upImage = [UIImage imageNamed:@"psp_fx61.png"];
    _right.downImage = [UIImage imageNamed:@"psp_fx62.png"];
    [self.view addSubview:_right];
    
    _leftDown = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"psp_fx71.png"]];
    _leftDown.keyCode = 1247;
    _leftDown.gameType = 4;
    _leftDown.frame = CGRectMake(_left.frame.origin.x, _left.frame.origin.y+DIRCT_SIZE, DIRCT_SIZE, DIRCT_SIZE);
    _leftDown.upImage = [UIImage imageNamed:@"psp_fx71.png"];
    _leftDown.downImage = [UIImage imageNamed:@"psp_fx72.png"];
    [self.view addSubview:_leftDown];
    
    _down = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"psp_fx81.png"]];
    _down.keyCode = 0x0040;
    _down.gameType = 4;
    _down.frame = CGRectMake(_leftDown.frame.origin.x+DIRCT_SIZE, _leftDown.frame.origin.y, DIRCT_SIZE, DIRCT_SIZE);
    _down.upImage = [UIImage imageNamed:@"psp_fx81.png"];
    _down.downImage = [UIImage imageNamed:@"psp_fx82.png"];
    [self.view addSubview:_down];
    
    _rightDown = [[MyImageView alloc] initWithImage:[UIImage imageNamed:@"psp_fx91.png"]];
    _rightDown.keyCode = 1248;
    _rightDown.gameType = 4;
    _rightDown.frame = CGRectMake(_down.frame.origin.x+DIRCT_SIZE, _down.frame.origin.y, DIRCT_SIZE, DIRCT_SIZE);
    _rightDown.upImage = [UIImage imageNamed:@"psp_fx91.png"];
    _rightDown.downImage = [UIImage imageNamed:@"psp_fx92.png"];
    [self.view addSubview:_rightDown];
    
}

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
    hud.labelText = @"很抱歉已经断开连接, 请重连!";
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:3];
    [hud release];
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _upFlag = NO;
    _downFlag = NO;
    _leftFlag = NO;
    _rightFlag = NO;
    
    self.yuanUp = [[[PSPView alloc] initWithImage:[UIImage imageNamed:@"psp_sanjiao1.png"]] autorelease];
    self.yuanUp.keyCode = 0x1000;
    self.yuanUp.frame = CGRectMake(428, 85, 53, 53);
    self.yuanUp.downImage = [UIImage imageNamed:@"psp_sanjiao2.png"];
    self.yuanUp.upImage = [UIImage imageNamed:@"psp_sanjiao1.png"];
    [self.view addSubview:self.yuanUp];
    
    self.yuanRight = [[[PSPView alloc] initWithImage:[UIImage imageNamed:@"psp_yuan1.png"]] autorelease];
    self.yuanRight.keyCode = 0x2000;
    self.yuanRight.frame = CGRectMake(480, 132, 53, 53);
    self.yuanRight.downImage = [UIImage imageNamed:@"psp_yuan2.png"];
    self.yuanRight.upImage = [UIImage imageNamed:@"psp_yuan1.png"];
    [self.view addSubview:self.yuanRight];
//    [self.yuanRight release];
    
    self.yuanLeft = [[[PSPView alloc] initWithImage:[UIImage imageNamed:@"psp_fang1.png"]] autorelease];
    self.yuanLeft.keyCode = 0x8000;
    self.yuanLeft.frame = CGRectMake(373, 132, 53, 53);
    self.yuanLeft.downImage = [UIImage imageNamed:@"psp_fang2.png"];
    self.yuanLeft.upImage = [UIImage imageNamed:@"psp_fang1.png"];
    [self.view addSubview:self.yuanLeft];
//    [self.yuanLeft release];
    
    self.chacha = [[[PSPView alloc] initWithImage:[UIImage imageNamed:@"psp_cha1.png"]] autorelease];
    self.chacha.keyCode = 0x4000;
    self.chacha.frame = CGRectMake(428, 175, 53, 53);
    self.chacha.downImage = [UIImage imageNamed:@"psp_cha2.png"];
    self.chacha.upImage = [UIImage imageNamed:@"psp_cha1.png"];
    [self.view addSubview:self.chacha];
//    [self.chacha release];
    
    [self initDirectionUI];
    _yaoganCenterPoint = self.yaogan.center;
    _avalibleRange = CGRectMake(_yaoganCenterPoint.x-30, _yaoganCenterPoint.y-30, 60, 60);
    
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(disConn) name:@"breakDownInProtrait" object:nil];
    
    UIButton* settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(btnPress) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.frame = CGRectMake(515, 6, 47, 47);
    [settingBtn setImage:[UIImage imageNamed:@"sbcz_sshezhi1.png"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"sbcz_sshezhi2.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:settingBtn];
    [self.view bringSubviewToFront:settingBtn];
}
- (void) disConn
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"连接断开" message:@"与电视的连接已经断开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [self.view addSubview:alertView];
//    alertView.transform = CGAffineTransformMakeRotation(M_PI/2);        //顺时针旋转90度
    [alertView show];
    
    
}
- (void) btnPress
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

- (void) exitGame
{
    NSString* game = @"game";
    const char* param = [game UTF8String];
    //    string param = gam
    sendExitGame([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, param);
    [self dismissViewControllerAnimated:YES completion:nil];
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


- (void)dealloc {
    [_chacha release];
    [_yaogan release];
    [_up release];
    [_down release];
    [_left release];
    [_right release];
    [_leftUp release];
    [_rightUp release];
    [_leftDown release];
    [_rightDown release];
    [_yuanUp release];
    [_yuanLeft release];
    [_yuanRight release];
    [_chacha release];
    self.yuanUp = nil;
    self.yuanLeft = nil;
    self.yuanRight = nil;
    self.chacha = nil;
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

/*
 按钮tag 说明
 上下左右: 131, 132, 133, 134
 左上， 右上， 左下， 右下: 141, 142, 143, 144
 三角， 叉叉， 方框， 圆形: 151, 152, 153, 154
 L 和 R ：  155， 156
 
 */
- (IBAction)pressStartBtn:(id)sender
{
    sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0008);
    sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0008);
}

- (IBAction)pressSelectBtn:(id)sender
{
    sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0001);
    sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0001);
}

- (IBAction)pressBtn:(id)sender
{
    if([(UIButton*)sender tag] == 155)
    {
        //L按钮被按
    }
    else if([(UIButton*)sender tag] == 156)
    {
        //R按钮被按
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    CGPoint prePoint = [touch previousLocationInView:self.view];
    if(CGRectContainsPoint(_avalibleRange, currentPoint))
    {
        self.yaogan.center = currentPoint;
        float x = (currentPoint.x - _yaoganCenterPoint.x)/30;
        float y = (currentPoint.y - _yaoganCenterPoint.y)/30;
        if((x<0.1 || x>-0.1) && (y>0.1 || y<-0.1))
        {
            pspMove([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvUdpPort, 0, -y);
        }
        else if((x>0.1 || x<-0.1) && (y<0.1 || y>-0.1))
        {
            pspMove([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvUdpPort, x, 0);
        }
        else
        {
            pspMove([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvUdpPort, x, -y);
        }
    }
    if(CGRectContainsPoint(self.yuanUp.frame, currentPoint))
    {
         if(_upFlag == NO)
         {
             self.yuanUp.image = [UIImage imageNamed:@"ty_anniu2.png"];
             self.yuanUp.centView.image = self.yuanUp.downImage;
             _upFlag = YES;
         }
    }
    else if(CGRectContainsPoint(self.yuanLeft.frame, currentPoint))
    {
        if(_leftFlag == NO)
        {
            self.yuanLeft.image = [UIImage imageNamed:@"ty_anniu2.png"];
            self.yuanLeft.centView.image = self.yuanLeft.downImage;
            _leftFlag = YES;
        }
    }
    else if(CGRectContainsPoint(self.yuanRight.frame, currentPoint))
    {
        if(_rightFlag == NO)
        {
            self.yuanRight.image = [UIImage imageNamed:@"ty_anniu2.png"];
            self.yuanRight.centView.image = self.yuanRight.downImage;
            _rightFlag = YES;
        }
    }
    else if(CGRectContainsPoint(self.chacha.frame, currentPoint))
    {
        if(_downFlag == NO)
        {
            self.chacha.image = [UIImage imageNamed:@"ty_anniu2.png"];
            self.chacha.centView.image = self.chacha.downImage;
            _downFlag = YES;
        }
    }
    
    if(CGRectContainsPoint(self.yuanUp.frame, prePoint) && !CGRectContainsPoint(self.yuanUp.frame, currentPoint))
    {
        _upFlag = NO;
        self.yuanUp.image = [UIImage imageNamed:@"ty_anniu1.png"];
        self.yuanUp.centView.image = self.yuanUp.upImage;
    }
    else if(CGRectContainsPoint(self.yuanLeft.frame, prePoint) && !CGRectContainsPoint(self.yuanLeft.frame, currentPoint))
    {
        _leftFlag = NO;
        self.yuanLeft.image = [UIImage imageNamed:@"ty_anniu1.png"];
        self.yuanLeft.centView.image = self.yuanLeft.upImage;
    }
    else if(CGRectContainsPoint(self.yuanRight.frame, prePoint) && !CGRectContainsPoint(self.yuanRight.frame, currentPoint))
    {
        _rightFlag = NO;
        self.yuanRight.image = [UIImage imageNamed:@"ty_anniu1.png"];
        self.yuanRight.centView.image = self.yuanRight.upImage;
    }
    else if(CGRectContainsPoint(self.chacha.frame, prePoint) && !CGRectContainsPoint(self.chacha.frame, currentPoint))
    {
        _downFlag = NO;
        self.chacha.image = [UIImage imageNamed:@"ty_anniu1.png"];
        self.chacha.centView.image = self.chacha.upImage;
    }
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.yaogan.center = _yaoganCenterPoint;
    _leftFlag = NO;
    _rightFlag = NO;
    _downFlag = NO;
    _upFlag = NO;
    self.yuanUp.image = [UIImage imageNamed:@"ty_anniu1.png"];
    self.yuanUp.centView.image = self.yuanUp.upImage;
    self.yuanLeft.image = [UIImage imageNamed:@"ty_anniu1.png"];
    self.yuanLeft.centView.image = self.yuanLeft.upImage;
    self.yuanRight.image = [UIImage imageNamed:@"ty_anniu1.png"];
    self.yuanRight.centView.image = self.yuanRight.upImage;
    self.chacha.image = [UIImage imageNamed:@"ty_anniu1.png"];
    self.chacha.centView.image = self.chacha.upImage;
    
    //发送摇杆抬起
    pspMove([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvUdpPort, 0, 0);
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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
@end



@implementation PSPView
@synthesize downImage;
@synthesize upImage;
@synthesize keyCode;
@synthesize flag;

- (id) initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if(self)
    {
        self.userInteractionEnabled = YES;
        self.flag = NO;
//        self.downImage = image;
//        self.upImage = image;
        self.image = [UIImage imageNamed:@"ty_anniu1.png"];
        self.centView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)] autorelease];
        self.centView.image = image;
        self.centView.center = CGPointMake(self.center.x+4, self.center.y+3);
        [self addSubview:self.centView];
    }
    return self;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.image = [UIImage imageNamed:@"ty_anniu2.png"];
    
    self.flag = YES;
    self.centView.image = self.downImage;
    if([[Singleton getSingle].isVoiceOn intValue] == 1)
    {
        [self playSound];
    }
    if([[Singleton getSingle].isValidateOn intValue] == 1)
    {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, self.keyCode);
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch* touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    if(CGRectContainsPoint(self.frame, currentPoint))
    {
    }
    else
    {
    }
    if(self.flag == YES)
    {
        return;
    }
    else
    {
        self.image = self.downImage;
        sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, self.keyCode);
        self.flag = YES;
    }
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
    
    if(self.flag == YES)
    {
        self.image = [UIImage imageNamed:@"ty_anniu1.png"];
        self.centView.image = self.upImage;
        sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, self.keyCode);
        self.flag = NO;
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void) playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"btn" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (void) dealloc
{
    self.downImage = nil;
    self.upImage = nil;
    self.centView = nil;

    [super dealloc];
}

@end


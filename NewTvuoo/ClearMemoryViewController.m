//
//  ClearMemoryViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/22 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "ClearMemoryViewController.h"
#import "CommonBtn.h"
#import "DEFINE.h"
#import "domain/MyJniTransport.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "GameIntroViewController.h"
#import "PSPViewController.h"
#import "AllUrl.h"
#import "MouseControlViewController.h"
#import "PSPViewController.h"
#import "ParseJson.h"
#import "LordViewController.h"
#import "MBProgressHUD.h"

@interface ClearMemoryViewController ()

@end

@implementation ClearMemoryViewController
@synthesize btnFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

-(void) goBack
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _single = [Singleton getSingle];
    _single.myDelegate = self;
    
    float w_rate = _single.width_rate;
    float h_rate = _single.height_rate;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        getSpeedInfo(_single.current_tv.tvIp, _single.current_tv.tvServerport, 0);
    });
    
    
    UIImageView* iv = [[UIImageView alloc] init];
    iv.frame = CGRectMake(0,20, 320, 120);
    iv.backgroundColor = blueColor;
    [self.view addSubview:iv];
    [iv release];
    UIImageView* iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, 320, 360)];
    iv2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:iv2];
    [iv2 release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(30*w_rate, 40*h_rate+20, 30, 30)];
    [self.view addSubview:retBtn];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(240.0*w_rate, 36.33*h_rate+20, 80, 30)];
    label.text = @"电视加速";
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
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    
    UILabel* titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    titileLabel.center = listUv.center;
    titileLabel.text = @"深度清理可深度加速电视";
    titileLabel.textAlignment = NSTextAlignmentCenter;
    titileLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titileLabel];
    [titileLabel release];
    
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(disconnectedWithTv) name:@"breakDown" object:nil];
    [notification addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
    
    _circleIv = [[UIImageView alloc] initWithFrame:CGRectMake(200, 300, 200, 200)];
    _circleIv.center = CGPointMake(iv2.center.x, iv2.center.y-30);
    _circleIv.image = [UIImage imageNamed:@"js_qingli.png"];
    [self.view addSubview:_circleIv];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    _numberLabel.text = @"86";
//    [_numberLabel sizeThatFits:CGSizeMake(120, 100)];
    _numberLabel.textColor = blueColor;
    _numberLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:100];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.center = CGPointMake(self.view.center.x, _circleIv.center.y + 20);
    [self.view addSubview:_numberLabel];
    
    _alreadyMemoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    _alreadyMemoLabel.center = CGPointMake(self.view.center.x, _numberLabel.center.y-80);
    _alreadyMemoLabel.textColor = blueColor;
    _alreadyMemoLabel.text = @"已使用内存";
    _alreadyMemoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_alreadyMemoLabel];
    
    _lineIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 2)];
    _lineIv.backgroundColor = blueColor;
    _lineIv.center = CGPointMake(_alreadyMemoLabel.center.x, _alreadyMemoLabel.center.y+20);
    [self.view addSubview:_lineIv];
    
    _numberLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _numberLabel2.text = @"%";
//    _numberLabel2.font = [UIFont fontWithName:@"Courier New" size:30];
    _numberLabel2.textColor = blueColor;
    _numberLabel2.center = CGPointMake(_numberLabel.center.x+80, _numberLabel.center.y+20);
    [self.view addSubview:_numberLabel2];
    
    self.btnFlag = YES;     //蓝色UI
    
    [self addButton];
    
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

- (void) passMemoValue:(int)memory withAction:(int)action
{
    if(action == 0)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _circleIv.image = [UIImage imageNamed:@"js_qingli.png"];
            [self.view addSubview:_circleIv];
            
            _alreadyMemoLabel.text = @"已使用内存";
            _alreadyMemoLabel.textColor = blueColor;
            [self.view addSubview:_alreadyMemoLabel];
            
            _lineIv.backgroundColor = blueColor;
            [self.view addSubview:_lineIv];
            _numberLabel.text = [NSString stringWithFormat:@"%d", memory];
            _numberLabel.textColor = blueColor;
            [self.view addSubview:_numberLabel];
            
            _numberLabel2.textColor = blueColor;
            [self.view addSubview:_numberLabel2];
            
            [_btnFrame.layer setBorderColor:[blueColor CGColor]];
            
            [_quickClearBtn setTitleColor:blueColor forState:UIControlStateNormal];
            [_quickClearBtn setTitle:@"快速清理" forState:UIControlStateNormal];
            [self.view addSubview:_quickClearBtn];
            
            [_saobaIv stopAnimating];
            [_saobaIv removeFromSuperview];

        });
        
    }
    if(action == 1)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_saobaIv stopAnimating];
            [_saobaIv removeFromSuperview];
            
            _alreadyMemoLabel.text = @"为您提速";
            _alreadyMemoLabel.textColor = greenColor;
            
            _circleIv.image = [UIImage imageNamed:@"js_wancheng.png"];
            _lineIv.backgroundColor = greenColor;
            [self.view addSubview:_lineIv];
            
            NSLog(@"显示2");
            _numberLabel.text = [NSString stringWithFormat:@"%d", memory];
            _numberLabel.textColor = greenColor;
            _numberLabel2.textColor = greenColor;
            [self.view addSubview:_numberLabel];
            [self.view addSubview:_numberLabel2];
            
            [_btnFrame.layer setBorderColor:[greenColor CGColor]];
            [_quickClearBtn setTitle:@"完成加速" forState:UIControlStateNormal];
            [_quickClearBtn setTitleColor:greenColor forState:UIControlStateNormal];
            self.btnFlag = NO;
            
//            [_quickClearBtn removeFromSuperview];
            /*
            UILabel* label = [[UILabel alloc] initWithFrame:_quickClearBtn.frame];
            label.text = @"完成加速";
            label.textColor = [UIColor greenColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = _btnFrame.center;
            [self.view addSubview:label];
            [label release];
             */
        });
        
    }
}

- (void) addButton
{
    _btnFrame = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _circleIv.frame.size.width, 40)];
    //        [listUv setImage:[UIImage imageNamed:@"ty_bai1.png"]];
    //    [listUv setBackgroundColor:blueColor];
    [_btnFrame.layer setBorderWidth:1.0];
    [_btnFrame.layer setCornerRadius:4.0];
    [_btnFrame.layer setBorderColor:[blueColor CGColor]];
    _btnFrame.center = CGPointMake(self.view.center.x, _circleIv.center.y+150);
    [self.view addSubview:_btnFrame];
    
//    _quickClearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _quickClearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
//    _quickClearBtn.frame = CGRectMake(0, 0, 120, 40);
    [_quickClearBtn setTitle:@"快速清理" forState:UIControlStateNormal];
    [_quickClearBtn setTitleColor:blueColor forState:UIControlStateNormal];
    _quickClearBtn.center = _btnFrame.center;
    [_quickClearBtn addTarget:self action:@selector(quickClear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_quickClearBtn];
    
}

- (void) quickClear
{
    if(self.btnFlag == YES)
    {
        _alreadyMemoLabel.text = @"正在清理中";
        [_lineIv removeFromSuperview];
        [_numberLabel removeFromSuperview];
        [_numberLabel2 removeFromSuperview];
        
        NSArray* imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"js_saoba1.png"], [UIImage imageNamed:@"js_saoba2.png"], [UIImage imageNamed:@"js_saoba3.png"], nil];
        _saobaIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _saobaIv.center = CGPointMake(self.view.center.x, _circleIv.center.y + 20);
        _saobaIv.animationImages = imageArray;
        _saobaIv.animationDuration = 0.6;
        _saobaIv.animationRepeatCount = 0;
        [_saobaIv startAnimating];
        [self.view addSubview:_saobaIv];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            getSpeedInfo(_single.current_tv.tvIp, _single.current_tv.tvServerport, 1);
        });
        self.btnFlag = NO;
        [imageArray release];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.btnFlag = YES;
            getSpeedInfo(_single.current_tv.tvIp, _single.current_tv.tvServerport, 0);
        });
    }
}

     
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) pressReturn
{
    
}

- (void) pressReturnOut
{
    
}



@end

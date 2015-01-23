//
//  AboutViewController.m
//  NewTvuoo
//
//  Created by xubo on 11/12 Wednesday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "AboutViewController.h"
#import "DEFINE.h"
#import "CommonBtn.h"
#import "HelpViewController.h"
#import "ContactViewController.h"
#import "Singleton.h"
#import "AllUrl.h"
#import "GameIntroViewController.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "PSPViewController.h"
#import "MouseControlViewController.h"
#import "ParseJson.h"
#import "UMFeedback.h"
#import "MBProgressHUD.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* topIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    topIv.backgroundColor = blueColor;
    [self.view addSubview:topIv];
    
    UISwipeGestureRecognizer* gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(returnBack)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    
    
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(10, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    
    
    
    UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    topLabel.center = CGPointMake(self.view.center.x, retBtn.center.y);
    topLabel.text = @"关于合作";
    topLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:topLabel];
    
    
    UIImageView* logoIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 80)];
    logoIv.image = [UIImage imageNamed:@"logo.png"];
    logoIv.center = CGPointMake(self.view.center.x, topIv.center.y+90);
    [self.view addSubview:logoIv];
    
    UILabel* tuvLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    tuvLabel.text = @"厅游助手";
    tuvLabel.font = [UIFont fontWithName:@"Courier New" size:27];
    [tuvLabel sizeToFit];
    tuvLabel.textColor = [UIColor colorWithRed:66.0/255.0 green:78.0/255.0 blue:95.0/255.0 alpha:1];
    tuvLabel.center = CGPointMake(self.view.center.x, logoIv.center.y+70);
    [self.view addSubview:tuvLabel];
    
    UILabel* verLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 45)];
    verLabel.text = @"Ver:1.0 For IOS";
    verLabel.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    verLabel.font = [UIFont fontWithName:@"Courier New" size:18];
    verLabel.center = CGPointMake(tuvLabel.center.x, tuvLabel.center.y+28);
    [self.view addSubview:verLabel];
    
    [tuvLabel release];
    [retBtn release];
    [topLabel release];
    [topIv release];
    [logoIv release];
    [verLabel release];
    
    UILabel* bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    bottomLabel.text = @"TVUOO 2014";
    bottomLabel.textColor = blueColor;
    bottomLabel.center = CGPointMake(self.view.center.x, 538);
    [self.view addSubview:bottomLabel];
    [bottomLabel release];
    
    [self addFourButton];
    
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

- (void) addFourButton
{
    UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 280, 320, 1)];
    line1.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line1];
    UIButton* updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateBtn addTarget:self action:@selector(pressVer) forControlEvents:UIControlEventTouchUpInside];
    [updateBtn setTitle:@"版本更新检测" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1] forState:UIControlStateNormal];
    updateBtn.frame = CGRectMake(line1.frame.origin.x + 40, line1.frame.origin.y+5, 120, 40);
    [self.view addSubview:updateBtn];
    UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, updateBtn.center.y+25, 320, 1)];
    line2.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line2];
    
    UIImageView* line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, line2.center.y+10, 320, 1)];
    line3.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line3];
    
    UIButton* helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpBtn addTarget:self action:@selector(pressHelp) forControlEvents:UIControlEventTouchUpInside];
    [helpBtn setTitle:@"使用帮助      " forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1] forState:UIControlStateNormal];
    helpBtn.frame = CGRectMake(updateBtn.frame.origin.x, line3.frame.origin.y+5, 120, 40);
    [self.view addSubview:helpBtn];
    
    UIImageView* line4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, helpBtn.center.y+25, 320, 1)];
    line4.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line4];
    
    UIImageView* line5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, line4.center.y+10, 320, 1)];
    line5.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line5];
    
    UIButton* jianyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jianyiBtn addTarget:self action:@selector(pressJianyi) forControlEvents:UIControlEventTouchUpInside];
    [jianyiBtn setTitle:@"建议反馈      " forState:UIControlStateNormal];
    [jianyiBtn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1] forState:UIControlStateNormal];
    jianyiBtn.frame = CGRectMake(updateBtn.frame.origin.x, line5.frame.origin.y+5, 120, 40);
    [self.view addSubview:jianyiBtn];
    
    UIImageView* line6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, jianyiBtn.center.y+25, 320, 1)];
    line6.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line6];
    
    UIButton* contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactBtn addTarget:self action:@selector(pressContact) forControlEvents:UIControlEventTouchUpInside];
    [contactBtn setTitle:@"联系我们      " forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1] forState:UIControlStateNormal];
    contactBtn.frame = CGRectMake(updateBtn.frame.origin.x, line6.frame.origin.y+5, 120, 40);
    [self.view addSubview:contactBtn];
    
    UIImageView* line7 = [[UIImageView alloc] initWithFrame:CGRectMake(0, contactBtn.center.y+25, 320, 1)];
    line7.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line7];
    
    [line1 release];
    [line2 release];
    [line3 release];
    [line4 release];
    [line5 release];
    [line6 release];
    [line7 release];
}

-(void)pressVer
{
    if([Singleton getSingle].updateInfo.isNeedUpdate == 1)
    {
        if([Singleton getSingle].updateInfo.update_model == 3)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[Singleton getSingle].updateInfo.update_title
                                                                message:[Singleton getSingle].updateInfo.update_memo
                                                               delegate:self
                                                      cancelButtonTitle:@"暂不升级" otherButtonTitles:@"现在升级", nil];
            [alertView show];
            [alertView release];
        }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"暂不升级");
        [alertView removeFromSuperview];
    }
    
    if(buttonIndex == 1)
    {
        NSLog(@"现在升级");
        //跳转到app store中指定的应用
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                         52];
        
        /*
          进入到首页
         NSString *str = [NSString stringWithFormat:
         
         @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",
         m_myAppID ];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
         */
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(void)pressHelp
{
    HelpViewController* helpVc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    [self.navigationController pushViewController:helpVc animated:NO];
    [helpVc release];
}
-(void)pressJianyi
{
//    [self.navigationController pushViewController:[UMFeedback feedbackViewController]
//                                         animated:YES];
//    self.navigationController.navigationBarHidden = NO;
    [self presentModalViewController:[UMFeedback feedbackModalViewController] animated:YES];

}
-(void)pressContact
{
    ContactViewController* contactVc = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
    [self.navigationController pushViewController:contactVc animated:NO];
    [contactVc release];
}

- (void) returnBack
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"cube"];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
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

@end


@implementation HelpRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* topIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    topIv.backgroundColor = blueColor;
    [self.view addSubview:topIv];
    
    UISwipeGestureRecognizer* gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(returnBack)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    
    
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(10, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    
    
    
    UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    topLabel.center = CGPointMake(self.view.center.x, retBtn.center.y);
    topLabel.text = @"关于合作";
    topLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:topLabel];
    
    
    UIImageView* logoIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 80)];
    logoIv.image = [UIImage imageNamed:@"logo.png"];
    logoIv.center = CGPointMake(self.view.center.x, topIv.center.y+90);
    [self.view addSubview:logoIv];
    
    UILabel* tuvLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    tuvLabel.text = @"厅游助手";
    tuvLabel.font = [UIFont fontWithName:@"Courier New" size:27];
    [tuvLabel sizeToFit];
    tuvLabel.textColor = [UIColor colorWithRed:66.0/255.0 green:78.0/255.0 blue:95.0/255.0 alpha:1];
    tuvLabel.center = CGPointMake(self.view.center.x, logoIv.center.y+70);
    [self.view addSubview:tuvLabel];
    
    UILabel* verLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 45)];
    verLabel.text = @"Ver:1.0 For IOS";
    verLabel.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    verLabel.font = [UIFont fontWithName:@"Courier New" size:18];
    verLabel.center = CGPointMake(tuvLabel.center.x, tuvLabel.center.y+28);
    [self.view addSubview:verLabel];
    
    [tuvLabel release];
    [retBtn release];
    [topLabel release];
    [topIv release];
    [logoIv release];
    [verLabel release];
    
    UILabel* bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    bottomLabel.text = @"TVUOO 2014";
    bottomLabel.textColor = blueColor;
    bottomLabel.center = CGPointMake(self.view.center.x, 538);
    [self.view addSubview:bottomLabel];
    [bottomLabel release];
    
    [self addFourButton];
    
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

- (void) addFourButton
{
    UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 280, 320, 1)];
    line1.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line1];
    UIButton* updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateBtn addTarget:self action:@selector(pressVer) forControlEvents:UIControlEventTouchUpInside];
    [updateBtn setTitle:@"版本更新检测" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1] forState:UIControlStateNormal];
    updateBtn.frame = CGRectMake(line1.frame.origin.x + 40, line1.frame.origin.y+5, 120, 40);
    [self.view addSubview:updateBtn];
    UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, updateBtn.center.y+25, 320, 1)];
    line2.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line2];
    
    UIImageView* line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, line2.center.y+10, 320, 1)];
    line3.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line3];
    
    UIButton* helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpBtn addTarget:self action:@selector(pressHelp) forControlEvents:UIControlEventTouchUpInside];
    [helpBtn setTitle:@"使用帮助      " forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1] forState:UIControlStateNormal];
    helpBtn.frame = CGRectMake(updateBtn.frame.origin.x, line3.frame.origin.y+5, 120, 40);
    [self.view addSubview:helpBtn];
    
    UIImageView* line4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, helpBtn.center.y+25, 320, 1)];
    line4.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line4];
    
    UIImageView* line5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, line4.center.y+10, 320, 1)];
    line5.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line5];
    
    UIButton* jianyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jianyiBtn addTarget:self action:@selector(pressJianyi) forControlEvents:UIControlEventTouchUpInside];
    [jianyiBtn setTitle:@"建议反馈      " forState:UIControlStateNormal];
    [jianyiBtn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1] forState:UIControlStateNormal];
    jianyiBtn.frame = CGRectMake(updateBtn.frame.origin.x, line5.frame.origin.y+5, 120, 40);
    [self.view addSubview:jianyiBtn];
    
    UIImageView* line6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, jianyiBtn.center.y+25, 320, 1)];
    line6.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line6];
    
    UIButton* contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactBtn addTarget:self action:@selector(pressContact) forControlEvents:UIControlEventTouchUpInside];
    [contactBtn setTitle:@"联系我们      " forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1] forState:UIControlStateNormal];
    contactBtn.frame = CGRectMake(updateBtn.frame.origin.x, line6.frame.origin.y+5, 120, 40);
    [self.view addSubview:contactBtn];
    
    UIImageView* line7 = [[UIImageView alloc] initWithFrame:CGRectMake(0, contactBtn.center.y+25, 320, 1)];
    line7.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:line7];
    
    [line1 release];
    [line2 release];
    [line3 release];
    [line4 release];
    [line5 release];
    [line6 release];
    [line7 release];
}

-(void)pressVer
{
    if([Singleton getSingle].updateInfo.isNeedUpdate == 1)
    {
        if([Singleton getSingle].updateInfo.update_model == 3)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[Singleton getSingle].updateInfo.update_title
                                                                message:[Singleton getSingle].updateInfo.update_memo
                                                               delegate:self
                                                      cancelButtonTitle:@"暂不升级" otherButtonTitles:@"现在升级", nil];
            [alertView show];
            [alertView release];
        }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"暂不升级");
        [alertView removeFromSuperview];
    }
    
    if(buttonIndex == 1)
    {
        NSLog(@"现在升级");
        //跳转到app store中指定的应用
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                         52];
        
        /*
         进入到首页
         NSString *str = [NSString stringWithFormat:
         
         @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",
         m_myAppID ];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
         */
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(void)pressHelp
{
    HelpViewController* helpVc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    [self.navigationController pushViewController:helpVc animated:NO];
    [helpVc release];
}
-(void)pressJianyi
{
    
}
-(void)pressContact
{
    ContactViewController* contactVc = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
    [self.navigationController pushViewController:contactVc animated:NO];
    [contactVc release];
}

- (void) returnBack
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"cube"];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
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
    hud.labelText = @"很抱歉已经断开连接, 请重连!";
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:3];
    [hud release];
    return;
}
@end

//
//  GameIntroViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import "GameIntroViewController.h"
#import "DEFINE.h"
#import "CommonBtn.h"
#import "Singleton.h"
#import "domain/MyJniTransport.h"
#import "RemoteControlViewController.h"
#import "CusMouseViewController.h"
#import "MouseControlViewController.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "PSPViewController.h"
#import "ParseJson.h"
#import "AllUrl.h"
#import "MBProgressHUD.h"

@interface GameIntroViewController ()

@end

@implementation GameIntroViewController

@synthesize gameName = _gameName;
@synthesize gameCapa = _gameCapa;
@synthesize gameDescription = _gameDescription;
@synthesize gameImage = _gameImage;
@synthesize gameType = _gameType;
@synthesize gameInfo = _gameInfo;
@synthesize gameTextView = _gameTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    _haveInstalled = NO;
    [Singleton getSingle].myDelegate = self;
    
    if(self.gameInfo.tvPkgName == nil)
    {
        NSLog(@"tvPkgName is nil");
        isInstalled([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, self.gameInfo.game_id, self.gameInfo.appType, [@"" UTF8String]);
    }
    else
    {
        NSLog(@"tvuPkgName : %@", self.gameInfo.tvPkgName);
        NSLog(@"tvPkgName isn't nil");
        if([self.gameInfo.tvPkgName isEqualToString:@""])
        {
            isInstalled([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, self.gameInfo.game_id, self.gameInfo.appType, [@"pkg" UTF8String]);
        }
        else
        {
            isInstalled([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, self.gameInfo.game_id, self.gameInfo.appType, [self.gameInfo.tvPkgName UTF8String]);
        }
    }
    UIImageView* backIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 60)];
    backIv.backgroundColor = blueColor;
    [self.view addSubview: backIv];
    [backIv release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 30, 40, 40)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    [self addGameProperty];
    
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

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addGameProperty
{
    UILabel* scrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    [scrLabel setFont:[UIFont fontWithName:@"Courier New" size:20]];
    scrLabel.textColor = [UIColor whiteColor];
    scrLabel.center = CGPointMake(self.view.center.x, 50);
    scrLabel.text = @"游戏介绍";
    [self.view addSubview:scrLabel];
    [scrLabel release];
    
    _gameImage = [[EGOImageView alloc] initWithFrame:CGRectMake(20, 90, 70, 70)];
    _gameImage.placeholderImage = [UIImage imageNamed:@"tb_morenren2.png"];
    _gameImage.imageURL = [NSURL URLWithString:_gameInfo.iconUrl];
    [_gameImage.layer setCornerRadius:6.0];
    _gameImage.backgroundColor = blueColor;
    [self.view addSubview:_gameImage];
    
    _gameName = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    //    _gameName.text = @"游戏名字";
    _gameName.text = _gameInfo.name;
    _gameName.textAlignment = NSTextAlignmentLeft;
    _gameName.textColor = [UIColor blackColor];
    [_gameName setFont:[UIFont fontWithName:@"Courier New" size:19]];
    [self.view addSubview:_gameName];
    
    UILabel* typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 135, 40, 30)];
    typeLabel.text = @"类型";
    [typeLabel setFont:[UIFont fontWithName:@"Courier New" size:17]];
    typeLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]; //灰色
    [self.view addSubview:typeLabel];
    [typeLabel release];
    
    _gameType = [[UILabel alloc] initWithFrame:CGRectMake(140, 135, 100, 30)];
    [_gameType setFont:[UIFont fontWithName:@"Courier New" size:17]];
//    _gameType.text = @"经营策略";
    _gameType.text = _gameInfo.gameTypeName;
    _gameType.textColor = greenColor;
    [self.view addSubview:_gameType];
    
    UILabel* capaLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 135, 40, 30)];
    [capaLabel setFont:[UIFont fontWithName:@"Courier New" size:17]];
    capaLabel.text = @"大小";
    capaLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]; //灰色
    [self.view addSubview:capaLabel];
    [capaLabel release];
    
    _gameCapa = [[UILabel alloc] initWithFrame:CGRectMake(250, 135, 100, 30)];
    [_gameCapa setFont:[UIFont fontWithName:@"Courier New" size:17]];
//    _gameCapa.text = @"1024Mb";
    _gameCapa.text = [NSString stringWithFormat:@"%ldMb",self.gameInfo.androidPkgSize/1024/1024];
    _gameCapa.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]; //灰色
    [self.view addSubview:_gameCapa];
    
    UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 178, 280, 2)];
    line1.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [self.view addSubview:line1];
    [line1 release];
    
    UILabel* introLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, 80, 30)];
    introLabel.text = @"游戏介绍";
    introLabel.textColor = [UIColor blackColor];
//    introLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [introLabel setFont:[UIFont fontWithName:@"Courier New" size:19]];
    [self.view addSubview:introLabel];
    [introLabel release];
    
//    _gameTextView = [UITextView alloc] initWithFrame:(CGRect)
//    _gameTextView.text = _gameInfo.text;
//    _gameTextView.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    
    //游戏介绍
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 212, 280, 120)];
//    scrollView.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
    [label setNumberOfLines:20];
    label.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    label.text = self.gameInfo.allText;
//    [scrollView addSubview:label];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.contentSize = CGSizeMake(280, 220);
    scrollView.bounces = YES;
//    [self.view addSubview:label];
    [scrollView addSubview:label];
    [self.view addSubview:scrollView];
    [scrollView release];
    [label release];
    
    UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 340, 280, 2)];
    line2.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [self.view addSubview:line2];
    [line2 release];
    
    UILabel* screenShot = [[UILabel alloc] initWithFrame:CGRectMake(20, 345, 80, 30)];
    screenShot.text = @"游戏截图";
    screenShot.textColor = [UIColor blackColor];
    //    introLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [screenShot setFont:[UIFont fontWithName:@"Courier New" size:19]];
    [self.view addSubview:screenShot];
    [screenShot release];
    
    int wid = 0;
    //游戏截图
    UIScrollView* somePic = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 365, 280, 160)];
    NSArray* gssArray = _gameInfo.gameScrShoot;
    for(int i=0; i<[gssArray count]; ++i)
    {

        GameScrShoot* gss = [gssArray objectAtIndex:i];
//        EGOImageView* imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(wid,10, 140, 160)];
        EGOImageView* imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"tb_morenren2.png"]];
        imageView.frame = CGRectMake(wid,10, 200, 160);
        wid += 210;
        imageView.imageURL = [NSURL URLWithString:gss.imgUrl];
        [somePic addSubview:imageView];
        [imageView release];
    }
    

    somePic.pagingEnabled = YES;
    somePic.scrollEnabled = YES;
    somePic.showsHorizontalScrollIndicator = YES;
    somePic.contentSize = CGSizeMake(630, 160);
    [self.view addSubview:somePic];
    [somePic release];
    
    UIImageView* bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 528, 320, 40)];
    bottomView.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [self.view addSubview: bottomView];
    [bottomView release];
    
    _btn1 = [[UIButton alloc] init];
    if([self.gameInfo.itunesPath isEqualToString:@""])
    {
        _btn1.frame = CGRectMake(50, 538, 100, 20);
        _btn1.center = CGPointMake(self.view.center.x, 548);
        [_btn1 setTitle:@"推送到电视" forState:UIControlStateNormal];
        [_btn1 addTarget:self action:@selector(playInTv) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btn1];
    }
    else
    {
        _btn1.frame = CGRectMake(50, 538, 100, 20);
        [_btn1 setTitle:@"推送到电视" forState:UIControlStateNormal];
        [_btn1 addTarget:self action:@selector(playInTv) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btn1];
        
        UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 addTarget:self action:@selector(playInPhone) forControlEvents:UIControlEventTouchUpInside];
        btn2.frame = CGRectMake(180, 538, 100, 20);
        [btn2 setTitle:@"在手机上玩" forState:UIControlStateNormal];
        [self.view addSubview:btn2];
    }
    
    
    
    //安卓游戏是1   安卓游戏
    //魂斗罗是2    红白机游戏
    //恐龙快打是3  接机游戏
}

- (void) playInTv
{
    if([Singleton getSingle].conn_statue != 2)
    {
        //没有连接电视
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"未连接" message:@"请先连接电视" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }

    TvInfo* tvInfo = [Singleton getSingle].current_tv;
    NSMutableString* jsonString = [[NSMutableString alloc] init];
    [jsonString appendString:@"{"];
    [jsonString appendString:@"\"bgtouch\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.bgTouch]];
    [jsonString appendString:@"\"androidphoneusetvapk\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.androidPhoneUseTvApk]];
    [jsonString appendString:@"\"gametypename\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.gameTypeName]];
    [jsonString appendString:@"\"game_type\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",[self.gameInfo.gameType intValue]]];
    [jsonString appendString:@"\"text\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.text]];
    [jsonString appendString:@"\"gameparam\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.gameParam]];
    [jsonString appendString:@"\"android_pkg_name\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.androidPkgName]];
    [jsonString appendString:@"\"img_zip_url\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.imgZipUrl]];
    [jsonString appendString:@"\"icon_url\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.iconUrl]];
    [jsonString appendString:@"\"ios_package_size\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%lu,",self.gameInfo.iosPkgSize]];
    [jsonString appendString:@"\"loading_url\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.loadingUrl]];
    [jsonString appendString:@"\"game_capability\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.gameCapability]];
    [jsonString appendString:@"\"android_pkg_size\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%lu,",self.gameInfo.androidPkgSize]];
    [jsonString appendString:@"\"tv_sizes\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%lu,",self.gameInfo.tvSize]];
    [jsonString appendString:@"\"tv_target\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.tvTarget ]];
    [jsonString appendString:@"\"level\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.level]];
    [jsonString appendString:@"\"allText\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.allText]];
    [jsonString appendString:@"\"tv_pkgname\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.tvPkgName]];
    [jsonString appendString:@"\"game_plays\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.gamePlays]];
    [jsonString appendString:@"\"game_id\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.game_id]];
    [jsonString appendString:@"\"name\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.name]];
    [jsonString appendString:@"\"howtoplay\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"\","]];
    [jsonString appendString:@"\"tvusupport\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.tvuSupport]];
    [jsonString appendString:@"\"supportdpad\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.supportDpad]];
    [jsonString appendString:@"\"apptype\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.appType]];
    [jsonString appendString:@"\"big_icon\":"];
    [jsonString appendString:[NSString stringWithFormat:@"\"%@\",",self.gameInfo.bigIcon]];
    [jsonString appendString:@"\"vcode\":"];
    [jsonString appendString:[NSString stringWithFormat:@"%d}",self.gameInfo.vCode]];
    
    
    const char* c_jsonString = [jsonString UTF8String];
    
    string str = c_jsonString;
    
    sendGame(tvInfo.tvIp, tvInfo.tvServerport, self.gameInfo.appType, c_jsonString);
    
    if(_haveInstalled == YES)       //电视已经安装了这个游戏
    {
        if(self.gameInfo.appType == 1)
        {
            if(self.gameInfo.gameRoot == 0)      //gameRoot == 0  不需要root     该游戏是sdk游戏
            {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"请等待连接游戏" message:@"请耐心等待，如果无法连接，请在厅游大厅里重新下载安装" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [self.view addSubview:alertView];
                [alertView show];
                [alertView release];
                return;
            }
            else                                    //  非sdk游戏
            {
                
            }
        }
    }
    else                            //电视尚未安装这个游戏
    {
        if(self.gameInfo.appType == 1)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"电视正在安装游戏" message:@"电视已接到游戏安装请求，是否立即切换到遥控界面进行安装操作" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"切换到遥控", nil];
            [self.view addSubview:alertView];
            [alertView show];
            [alertView release];
            return;
        }
    }
    
    
    switch (self.gameInfo.appType)
    {
        case 1:                     //启动安卓游戏的手柄
        {
            if(self.gameInfo.gameRoot == 0)
                return;
            MouseControlViewController* mouseControlVC = [[MouseControlViewController alloc] initWithNibName:@"MouseControlViewController" bundle:nil];
            mouseControlVC.currentGameInfo = self.gameInfo;
            [self.navigationController presentViewController:mouseControlVC animated:NO completion:nil];
            [mouseControlVC release];
            break;
        }
        case 2:                     //启动红白机游戏的手柄
        {
            HongbaijiViewController* hongbaiVc = [[HongbaijiViewController alloc] initWithNibName:@"HongbaijiViewController" bundle:nil];
            hongbaiVc.gameParam = self.gameInfo.gameParam;
            NSLog(@"self.gameino.gralks: %d", self.gameInfo.gameParam);
            [self.navigationController presentViewController:hongbaiVc animated:NO completion:nil];
            [hongbaiVc release];
            break;
        }
        case 3:                     //启动接机游戏的手柄
        {
            JiejiViewController* jiejiVc = [[JiejiViewController alloc] initWithNibName:@"JiejiViewController" bundle:nil];
            [self.navigationController presentViewController:jiejiVc animated:NO completion:nil];
            [jiejiVc release];
            break;
        }
        case 4:
        {
            PSPViewController* pspVc = [[PSPViewController alloc] initWithNibName:@"PSPViewController" bundle:nil];
            [self.navigationController presentViewController:pspVc animated:NO completion:nil];
            [pspVc release];
            break;
        }
        default:
            break;
    }
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        //按下了“切换到鼠标“按钮
        RemoteControlViewController* cusVc = [[RemoteControlViewController alloc] initWithNibName:@"RemoteControlViewController" bundle:nil];
//        [self.navigationController presentViewController:cusVc animated:YES completion:nil];
        [self.navigationController pushViewController:cusVc animated:YES];
        [cusVc release];
    }
}

- (void) playInPhone
{
    //跳转到应用页面
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.gameInfo.itunesPath]];
    
    //跳转到评价页面
//    NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id;=%d",
//                     appid ];
//    [[UIApplication sharedApplication] openURL:[NSURL urlWithString:str]];
}

- (void) passValue:(GameInfo *)gameInfo
{
    _gameName.text = gameInfo.name;
    [self.view addSubview:_gameName];
}
- (void)dealloc {
    [_gameInfo release];
    [_gameType release];
    [_gameName  release];
    [_gameImage release];
    [_gameDescription release];
    [_gameCapa release];
    [_gameTextView release];
    [super dealloc];
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

- (void) haveInstalled:(int)ip withPkgName:(NSString *)pkgName withStatue:(int)statue withId:(int)gameId
{
//    if((self.gameInfo.game_id == gameId) && ([self.gameInfo.androidPkgName isEqualToString:pkgName]) && statue==1)
    if((self.gameInfo.game_id == gameId) && (statue == 1))
    {
        NSLog(@"电视上已经安装了这个游戏");
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_btn1 setTitle:@"启动游戏" forState:UIControlStateNormal];
        });
        _haveInstalled = YES;
    }
    else
    {
        _haveInstalled = NO;
        NSLog(@"电视上没有安装这个游戏");
    }
}

@end

//
//  PlayTvGameViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//
#import "MBProgressHUD.h"
#import "LordViewController.h"
#import "PlayTvGameViewController.h"
#import "ParseJson.h"
#import "GameInfo.h"
#import "DEFINE.h"
#import "MyGameVc.h"
#import "GameIntroViewController.h"
#import "Singleton.h"
#import "CommonBtn.h"
#import "JiejiViewController.h"
#import "EGOImageLoader/EGOCache.h"
#import "MyCell.h"
#import "MyGameVc.h"
#import "CateGameViewController.h"
#import "HongbaijiViewController.h"
#import "PSPViewController.h"
#import "AllUrl.h"
#define myGrayColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];

@interface MyGameVc ()
@property (retain, nonatomic) UIButton* pspGameBtn;
@property (retain, nonatomic) UILabel* pspGameLabel;
@property (retain, nonatomic) UIImageView* pspGameIv;
@end

@implementation MyGameVc
@synthesize pspGameBtn;
@synthesize pspGameIv;
@synthesize pspGameLabel;
@synthesize touchFlag = _touchFlag;



//页面之间传值的delegate
@synthesize passValueDelegate;
@synthesize tvHomeIv = _tvHomeIv;
@synthesize tvHomeLabel = _tvHomeLabel;
@synthesize myGameIv = _myGameIv;
@synthesize myGameLabel = _myGameLabel;

@synthesize gameList;
@synthesize flag;
//数据源
@synthesize hotGameArray;
@synthesize niceGameArray;
@synthesize cateGameArray;
@synthesize pspGameArray;
@synthesize hotBtn;
@synthesize hotIv;
@synthesize hotLabel;
@synthesize niceBtn;
@synthesize niceIv;
@synthesize niceLabel;
@synthesize cateBtn;
@synthesize cateIv;
@synthesize cateLabel;
@synthesize failedIv = _failedIv;
@synthesize failedLabel = _failedLabel;
@synthesize listUv = _listUv;
@synthesize reloadBtn = _reloadBtn;
@synthesize hotPageNum = _hotPageNum;
@synthesize nicePageNum = _nicePageNum;
@synthesize catePageNum = _catePageNum;
@synthesize pspPageNum;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //   [self fetchDataIng];
    //    [self addBottomBtn];
    [super viewWillAppear:YES];
    _touchFlag = YES;
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

- (void) addTitleLabel
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(240.0*[Singleton getSingle].width_rate, 36.33*([Singleton getSingle].height_rate)+20, 80, 30)];
    label.text = @"我的游戏中心";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hotPageNum = 1;
    self.nicePageNum = 1;
    self.catePageNum = 1;
    
    getMyGame([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport);
    
    footView = [[FootView alloc] init];
    
    self.hotGameArray = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
    self.niceGameArray = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
    self.pspGameArray = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
    self.cateGameArray = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
    
    Singleton* single = [Singleton getSingle];
    single.myDelegate = self;
    float w_rate = single.width_rate;
    float h_rate = single.height_rate;
    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 121)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    UIImageView* whiteIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 141, 320, 380)];
    whiteIv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteIv];
    [whiteIv release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(30*w_rate, 40*h_rate+10, 30, 30)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    [self addTitleLabel];
    
    //三个按钮的外边框
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
    [self addThreeBtn];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = CGPointMake(160, 284);
    self.activityIndicator.hidden = NO;
    self.activityIndicator.color = blueColor;
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    [self initFailedUI];
    
    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timerTarget) userInfo:nil repeats:YES];
    
    self.gameList = [[UITableView alloc] initWithFrame:CGRectMake(0,141,320,380) style:UITableViewStylePlain];
    self.flag = HOT;
    [self.gameList setDelegate:self];
    [self.gameList setDataSource:self];
    
//    [self loadFailed];
//    [self fetchDataIng];
    [self addBottomBtn];
    
    NSNotificationCenter* notifi = [NSNotificationCenter defaultCenter];
    [notifi addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
}
- (void) timerTarget
{
    if(self.activityIndicator.hidden == NO)
    {
        NSLog(@"定时器!");
        if(self.flag == HOT)
        {
            if([self.hotGameArray count] == 0)
            {
                self.activityIndicator.hidden = YES;
                [self loadFailed];
            }
        }
        else if(self.flag == NEW)
        {
            if([self.niceGameArray count] == 0)
            {
                self.activityIndicator.hidden = YES;
                [self loadFailed];
            }
        }
        else if(self.flag == CATE)
        {
            if([self.cateGameArray count] == 0)
            {
                self.activityIndicator.hidden = YES;
                [self loadFailed];
            }
        }
        else
        {
            if([self.pspGameArray count] == 0)
            {
                self.activityIndicator.hidden = YES;
                [self loadFailed];
            }
        }
    }
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

- (void) addBottomBtn
{
    self.tvHomeIv = [[UIImageView alloc] initWithFrame:CGRectMake(65, 523, 30, 30)];
    self.tvHomeIv.image = [UIImage imageNamed:@"yk_zhuye1.png"];
    [self.view addSubview:self.tvHomeIv];
    
    self.tvHomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 545, 100, 30)];
    self.tvHomeLabel.text = @"电视大厅";
    [self.tvHomeLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
        self.tvHomeLabel.textColor = myGrayColor;
//    self.tvHomeLabel.textColor = blueColor;
    [self.view addSubview:self.tvHomeLabel];
    
    self.myGameIv = [[UIImageView alloc] initWithFrame:CGRectMake(215, 523, 30, 30)];
    self.myGameIv.image = [UIImage imageNamed:@"sjyx_shouyou2.png"];
    [self.view addSubview:self.myGameIv];
    
    self.myGameLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 545, 100, 30)];
    self.myGameLabel.text = @"我的游戏";
    [self.myGameLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    self.myGameLabel.textColor = blueColor;
    [self.view addSubview:self.myGameLabel];
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
- (void) initFailedUI
{
    _failedIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        _failedIv.center = self.view.center;
    _failedIv.center = CGPointMake(self.view.center.x, self.view.center.y  - 30);
    _failedIv.image = [UIImage imageNamed:@"ty_ku.png"];
    
    _failedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    _failedLabel.center = CGPointMake(self.view.center.x+10, 330);
    _failedLabel.text = @"抱歉 数据获取失败";
    [_failedLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    _failedLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    
    _listUv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _listUv.center = CGPointMake(self.view.center.x,370);
    [_listUv.layer setBorderWidth:1.0];
    [_listUv.layer setCornerRadius:4.0];
    [_listUv.layer setBorderColor:[greenColor CGColor]];
    
    _reloadBtn = [[UIButton alloc] init];
    //    reloadBtn.backgroundColor = [UIColor blackColor];
    [_reloadBtn addTarget:self action:@selector(fetchDataIng) forControlEvents:UIControlEventTouchUpInside];
    [_reloadBtn.titleLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    _reloadBtn.frame = CGRectMake(100, 450, 100, 50);
    _reloadBtn.center = _listUv.center;
    [_reloadBtn setTitle:@"重新载入" forState:UIControlStateNormal];
    [_reloadBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [_reloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (void) fetchDataIng
{
    //    [self.gameList removeFromSuperview];
    
    [_failedIv removeFromSuperview];
    [_failedLabel removeFromSuperview];
    [_listUv removeFromSuperview];
    [_reloadBtn removeFromSuperview];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    
    //    [NSThread detachNewThreadSelector:@selector(initMyDataSource) toTarget:self withObject:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self initMyDataSource];
    });
}

- (void) addThreeBtn
{
    self.hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hotBtn addTarget:self action:@selector(pressHot) forControlEvents:UIControlEventTouchUpInside];
    self.hotBtn.backgroundColor = [UIColor whiteColor];
    [self.hotBtn.layer setCornerRadius:4.0];
    self.hotBtn.frame = CGRectMake(30,89, 60,30);
    [self.view addSubview:self.hotBtn];
    self.hotIv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_remen2.png"]] autorelease];
    self.hotIv.frame = CGRectMake(35, 94, 20,20);
    [self.view addSubview:self.hotIv];
    self.hotLabel = [[[UILabel alloc] initWithFrame:CGRectMake(55, 92, 40, 25)] autorelease];
    self.hotLabel.text = @"安卓";
    self.hotLabel.textColor = blueColor;
    [self.hotLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    [self.view addSubview:self.hotLabel];
    
    self.niceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.niceBtn addTarget:self action:@selector(pressNew) forControlEvents:UIControlEventTouchUpInside];
    [self.niceBtn.layer setCornerRadius:4.0];
    self.niceBtn.frame = CGRectMake(100,89, 65,30);
    [self.view addSubview:self.niceBtn];
    self.niceIv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_xinpin1.png"]]  autorelease];
    self.niceIv.frame = CGRectMake(100, 94, 20,20);
    [self.view addSubview:self.niceIv];
    self.niceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 92, 45, 25)] autorelease];
    self.niceLabel.text = @"红白机";
    self.niceLabel.textColor = [UIColor whiteColor];
    [self.niceLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    [self.view addSubview:self.niceLabel];
    
    self.cateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cateBtn addTarget:self action:@selector(pressCatogary) forControlEvents:UIControlEventTouchUpInside];
    [self.cateBtn.layer setCornerRadius:4.0];
    self.cateBtn.frame = CGRectMake(165,89, 60,30);
    [self.view addSubview:self.cateBtn];
    self.cateIv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_fenlei1.png"]] autorelease];
    self.cateIv.frame = CGRectMake(175, 94, 20,20);
    [self.view addSubview:self.cateIv];
    self.cateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(195, 92, 40, 25)] autorelease];
    self.cateLabel.text = @"街机";
    self.cateLabel.textColor = [UIColor whiteColor];
    [self.cateLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    [self.view addSubview:self.cateLabel];
    
    self.pspGameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pspGameBtn addTarget:self action:@selector(pressPSP) forControlEvents:UIControlEventTouchUpInside];
    [self.pspGameBtn.layer setCornerRadius:4.0];
    self.pspGameBtn.frame = CGRectMake(230,89, 60,30);
    [self.view addSubview:self.pspGameBtn];
    self.pspGameIv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_fenlei1.png"]] autorelease];
    self.pspGameIv.frame = CGRectMake(240, 94, 20,20);
    [self.view addSubview:self.pspGameIv];
    self.pspGameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(260, 92, 40, 25)] autorelease];
    self.pspGameLabel.text = @"PSP";
    self.pspGameLabel.textColor = [UIColor whiteColor];
    [self.pspGameLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    [self.view addSubview:self.pspGameLabel];
    
    
}

- (void) pressPSP
{
    if (self.flag != PSP)
    {
        self.flag = PSP;
        [self.gameList removeFromSuperview];
        
        self.hotBtn.backgroundColor = blueColor;
        self.hotIv.image = [UIImage imageNamed:@"ty_remen1.png"];
        self.hotLabel.textColor = [UIColor whiteColor];
        
        self.niceBtn.backgroundColor = blueColor;
        self.niceIv.image = [UIImage imageNamed:@"ty_xinpin1.png"];
        self.niceLabel.textColor = [UIColor whiteColor];
        
        self.cateBtn.backgroundColor = blueColor;
        self.cateIv.image = [UIImage imageNamed:@"ty_fenlei1.png"];
        self.cateLabel.textColor = [UIColor whiteColor];
        
        self.pspGameBtn.backgroundColor = [UIColor whiteColor];
        self.pspGameIv.image = [UIImage imageNamed:@"ty_fenlei2.png"];
        self.pspGameLabel.textColor = blueColor;
        
        if ([self.pspGameArray count] != 0)
        {
            [self connSuccRemoveSomeView];
            [self.view addSubview:self.gameList];
            [self.gameList reloadData];
        }
        else
        {
//            [self fetchDataIng];
            [self loadFailed];
        }
    }
}


- (void) initMyDataSource
{
    if (self.flag == HOT)
    {
        if(self.hotPageNum <= [self.hotGameArray count]/20)
        {
            
            return;
        }
        if(self.hotPageNum == 1)       //第一次加载
        {
            self.hotGameArray = [ParseJson createGameInfoArrayFromJson:HOT_PHONE_GAME];
            if([self.hotGameArray count] > 0)
            {
                
//                [self fetchImage:self.hotGameArray];
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            }
            else
            {
                [self.gameList performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(loadFailed) withObject:nil waitUntilDone:YES];
            }
        }
        else                    //第pageNum次加载 pageNum>1
        {
            NSMutableString* jsonString = [[NSMutableString alloc] init];
            [jsonString appendString:HOT_JSON];
            [jsonString appendString:[NSString stringWithFormat:@"&page=%d",self.hotPageNum]];
            NSMutableArray* newGameInfoArray = [[NSMutableArray alloc] initWithCapacity:5];
            newGameInfoArray = [ParseJson createGameInfoArrayFromJson:jsonString];
            if(newGameInfoArray != nil && [newGameInfoArray count]!=0)
            {
                [self.hotGameArray addObjectsFromArray:newGameInfoArray];
                [footView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                [self.gameList performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            else
            {
                self.hotPageNum--;
            }
            [jsonString release];
            //            [newGameInfoArray release];
            
        }
    }
    else if(self.flag == NEW)
    {
        if(self.nicePageNum <= [self.niceGameArray count]/20)
        {
            return;
        }
        if (self.nicePageNum == 1)
        {
            self.niceGameArray = [ParseJson createGameInfoArrayFromJson:NEW_JSON];
            if([self.niceGameArray count] > 0)
            {
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                
            }
            else
            {
                [self performSelectorOnMainThread:@selector(loadFailed) withObject:nil waitUntilDone:YES];
            }
        }
        else
        {
            NSMutableString* jsonString = [[NSMutableString alloc] init];
            [jsonString appendString:NEW_JSON];
            [jsonString appendString:[NSString stringWithFormat:@"&page=%d",self.nicePageNum]];
            NSMutableArray* newGameInfoArray = [[NSMutableArray alloc] initWithCapacity:5];
            newGameInfoArray = [ParseJson createGameInfoArrayFromJson:jsonString];
            if(newGameInfoArray!=nil && [newGameInfoArray count]!=0)
            {
                [self.niceGameArray addObjectsFromArray:newGameInfoArray];
                [footView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                [self.gameList performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            {
                self.nicePageNum--;
            }
            [jsonString release];
            //            [newGameInfoArray release];
            
        }
    }
    else if(self.flag == CATE)
    {
        if(self.catePageNum <= [self.cateGameArray count]/20)
        {
            return;
        }
        if (self.catePageNum == 1)
        {
            self.cateGameArray = [ParseJson createCategoryArrayFromJson:CATE_CATE];
            if([self.cateGameArray count] > 0)
            {
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                
            }
            else
            {
                [self performSelectorOnMainThread:@selector(loadFailed) withObject:nil waitUntilDone:YES];
            }
        }
        else
        {
            NSMutableString* jsonString = [[NSMutableString alloc] init];
            [jsonString appendString:CATE_CATE];
            [jsonString appendString:[NSString stringWithFormat:@"&page=%d",self.catePageNum]];
            NSMutableArray* newGameInfoArray = [[NSMutableArray alloc] initWithCapacity:5];
            newGameInfoArray = [ParseJson createCategoryArrayFromJson:jsonString];
            if(newGameInfoArray!=nil && [newGameInfoArray count]!=0)
            {
                [self.cateGameArray addObjectsFromArray:newGameInfoArray];
                [footView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                [self.gameList performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            {
                self.catePageNum--;
            }
            [jsonString release];
        }
        
    }
    else
    {
        if(self.pspPageNum <= [self.pspGameArray count]/20)
        {
            
            return;
        }
        if(self.pspPageNum == 1)       //第一次加载
        {
            self.pspGameArray = [ParseJson createGameInfoArrayFromJson:HOT_PHONE_GAME];
            if([self.pspGameArray count] > 0)
            {
                
                //                [self fetchImage:self.hotGameArray];
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            }
            else
            {
                [self.gameList performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(loadFailed) withObject:nil waitUntilDone:YES];
            }
        }
        else                    //第pageNum次加载 pageNum>1
        {
            NSMutableString* jsonString = [[NSMutableString alloc] init];
            [jsonString appendString:HOT_JSON];
            [jsonString appendString:[NSString stringWithFormat:@"&page=%d",self.hotPageNum]];
            NSMutableArray* newGameInfoArray = [[NSMutableArray alloc] initWithCapacity:5];
            newGameInfoArray = [ParseJson createGameInfoArrayFromJson:jsonString];
            if(newGameInfoArray != nil && [newGameInfoArray count]!=0)
            {
                [self.hotGameArray addObjectsFromArray:newGameInfoArray];
                [footView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                [self.gameList performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            else
            {
                self.pspPageNum--;
            }
            [jsonString release];
            //            [newGameInfoArray release];
            
        }

    }
}

-(void) loadFailed
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
    [self.gameList removeFromSuperview];
    
    [self.view addSubview:_failedIv];
    //    [_failedIv release];
    [self.view addSubview:_failedLabel];
    //    [_failedLabel release];
    [self.view addSubview:_listUv];
    [self.view addSubview:_reloadBtn];
    
    
}

- (void) reloadTableView
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    [_failedLabel removeFromSuperview];
    [_failedIv removeFromSuperview];
    [_reloadBtn removeFromSuperview];
    [_listUv removeFromSuperview];
    [self.view addSubview:self.gameList];
    [self.gameList reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    LordViewController* lordView = (LordViewController*)[Singleton getSingle].viewController;
    [self.navigationController popToViewController:lordView animated:NO];
}



- (void) connSuccRemoveSomeView
{
    [_failedIv removeFromSuperview];
    [_failedLabel removeFromSuperview];
    [_listUv removeFromSuperview];
    [_reloadBtn removeFromSuperview];
    
    [self.activityIndicator stopAnimating];
    //    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator removeFromSuperview];
}


- (void)pressHot
{
    if (self.flag != HOT)
    {
        self.flag = HOT;
        [self.gameList removeFromSuperview];
        
        self.hotBtn.backgroundColor = [UIColor whiteColor];
        self.hotIv.image = [UIImage imageNamed:@"ty_remen2.png"];
        self.hotLabel.textColor = blueColor;
        
        self.niceBtn.backgroundColor = blueColor;
        self.niceIv.image = [UIImage imageNamed:@"ty_xinpin1.png"];
        self.niceLabel.textColor = [UIColor whiteColor];
        
        self.cateBtn.backgroundColor = blueColor;
        self.cateIv.image = [UIImage imageNamed:@"ty_fenlei1.png"];
        self.cateLabel.textColor = [UIColor whiteColor];
        
        self.pspGameBtn.backgroundColor = blueColor;
        self.pspGameIv.image = [UIImage imageNamed:@"ty_fenlei1.png"];
        self.pspGameLabel.textColor = [UIColor whiteColor];
        
        if ([self.hotGameArray count] != 0)
        {
            [self connSuccRemoveSomeView];
            [self.view addSubview:self.gameList];
            [self.gameList reloadData];
        }
        else
        {
//            [self fetchDataIng];
            [self loadFailed];
        }
    }
}

- (void)pressNew
{
    if(self.flag != NEW)
    {
        self.flag = NEW;
        [self.gameList removeFromSuperview];
        
        self.hotBtn.backgroundColor = blueColor;
        self.hotIv.image = [UIImage imageNamed:@"ty_remen1.png"];
        self.hotLabel.textColor = [UIColor whiteColor];
        
        self.niceBtn.backgroundColor = [UIColor whiteColor];
        self.niceIv.image = [UIImage imageNamed:@"ty_xinpin2.png"];
        self.niceLabel.textColor = blueColor;
        
        self.cateBtn.backgroundColor = blueColor;
        self.cateIv.image = [UIImage imageNamed:@"ty_fenlei1.png"];
        self.cateLabel.textColor = [UIColor whiteColor];
        
        self.pspGameBtn.backgroundColor = blueColor;
        self.pspGameIv.image = [UIImage imageNamed:@"ty_fenlei1.png"];
        self.pspGameLabel.textColor = [UIColor whiteColor];
        
        if ([self.niceGameArray count] != 0)
        {
            [self connSuccRemoveSomeView];
            [self.view addSubview:self.gameList];
            [self.gameList reloadData];
        }
        else
        {
//            [self fetchDataIng];
            [self loadFailed];
        }
    }
}

- (void)pressCatogary
{
    if(self.flag != CATE)
    {
        [self.gameList removeFromSuperview];
        self.flag = CATE;
        
        self.hotBtn.backgroundColor = blueColor;
        self.hotIv.image = [UIImage imageNamed:@"ty_remen1.png"];
        self.hotLabel.textColor = [UIColor whiteColor];
        
        self.niceBtn.backgroundColor = blueColor;
        self.niceIv.image = [UIImage imageNamed:@"ty_xinpin1.png"];
        self.niceLabel.textColor = [UIColor whiteColor];
        
        self.cateBtn.backgroundColor = [UIColor whiteColor];
        self.cateIv.image = [UIImage imageNamed:@"ty_fenlei2.png"];
        self.cateLabel.textColor = blueColor;
        
        self.pspGameBtn.backgroundColor = blueColor;
        self.pspGameIv.image = [UIImage imageNamed:@"ty_fenlei1.png"];
        self.pspGameLabel.textColor = [UIColor whiteColor];
        
        if ([self.cateGameArray count] != 0)
        {
            [self connSuccRemoveSomeView];
            [self.view addSubview:self.gameList];
            [self.gameList reloadData];
        }
        else
        {
//            [self fetchDataIng];
            [self loadFailed];
        }
    }
}


- (void)pressMyGame
{
}

- (void)pressVirtualHandle
{
}

- (void)pressTvHome
{
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}
- (void) dealloc
{
    self.hotBtn = nil;
    self.hotIv = nil;
    self.hotLabel = nil;
    
    self.niceBtn = nil;
    self.niceIv = nil;
    self.niceLabel = nil;
    
    self.cateBtn = nil;
    self.cateIv = nil;
    self.cateLabel = nil;
    
    //    [_hotImgArray release];
    //    [_cateImgArray release];
    //    [_niceImgArray release];
    [_searchGameViewController release];
    
    [super dealloc];
}

#pragma mark-
#pragma mark Table View Data Source Methods
- (NSInteger) tableView:(UITableView*) tableView            //一个分区有多少行
  numberOfRowsInSection:(NSInteger)section
{
    if(self.flag == HOT)          //安卓游戏
    {
        return [self.hotGameArray count];
    }
    else if(self.flag == NEW)     //红白机游戏
    {
        return [self.niceGameArray count];
    }
    else if(self.flag == CATE)    //街机游戏
    {
        return [self.cateGameArray count];
    }
    else                          //psp游戏
    {
        return [self.pspGameArray count];
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView       //设置每一行显示的内容
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell* cell = nil;
    static NSString* cellTableViewIdentifier = @"HotCellTableViewIdentifier";
    static NSString* cellTableViewIdentifier1 = @"NewCellTableViewIdentifier";
    static NSString* cellTableViewIDentifier2 = @"CatogoryCellTableViewIdentifier";
    if(flag == NEW)
    {
        NSUInteger row = [indexPath row];
        GameInfo* gameInfo = [self.niceGameArray objectAtIndex:row];
        cell = [tableView dequeueReusableCellWithIdentifier:cellTableViewIdentifier1];
        if(cell == nil)
        {
            cell = [[[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableViewIdentifier1] autorelease];
        }
        else
        {
            [cell clear];
        }
        
        [cell setImage:gameInfo.iconUrl];
        cell.nameLabel.text = gameInfo.name ;
        cell.typeName.text = gameInfo.gameTypeName;
        int mb = (int)(gameInfo.tvSize)/1024/1024;
        if(mb <= 0)
        {
            cell.capa.text = [NSString stringWithFormat:@"%ldKb", (gameInfo.tvSize)/1024];
        }
        else
        {
            cell.capa.text = [NSString stringWithFormat:@"%ldMb", (gameInfo.tvSize)/1024/1024];
        }
//        cell.capa.text = [NSString stringWithFormat:@"%ldMb",(gameInfo.tvSize)/1024/1024];
        return cell;
    }
    else if(flag == CATE)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellTableViewIDentifier2];
        NSUInteger row = [indexPath row];
        GameInfo* gameInfo = [self.cateGameArray objectAtIndex:row];
        
        if(cell == nil)
        {
            cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableViewIDentifier2];
        }
        else
        {
            [cell clear];
        }
        [cell setImage:gameInfo.iconUrl];
        cell.nameLabel.text = gameInfo.name ;
        cell.typeName.text = gameInfo.gameTypeName;
//        cell.capa.text = [NSString stringWithFormat:@"%ldMb",(gameInfo.tvSize)/1024/1024];
        int mb = (int)(gameInfo.tvSize)/1024/1024;
        if(mb <= 0)
        {
            cell.capa.text = [NSString stringWithFormat:@"%ldKb", (gameInfo.tvSize)/1024];
        }
        else
        {
            cell.capa.text = [NSString stringWithFormat:@"%ldMb", (gameInfo.tvSize)/1024/1024];
        }
        return cell;
    }
    else if(self.flag == HOT)
    {            // hot
        NSUInteger row = [indexPath row];
        GameInfo* gameInfo = [self.hotGameArray objectAtIndex:row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellTableViewIdentifier];
        if(cell == nil)
        {
            cell = [[[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableViewIdentifier] autorelease];
        }
        else
        {
            [cell clear];
        }
        [cell setImage:gameInfo.iconUrl];
        cell.nameLabel.text = gameInfo.name ;
        cell.typeName.text = gameInfo.gameTypeName;
//        cell.capa.text = [NSString stringWithFormat:@"%ldMb",(gameInfo.tvSize)/1024/1024];
        int mb = (int)(gameInfo.tvSize)/1024/1024;
        if(mb <= 0)
        {
            cell.capa.text = [NSString stringWithFormat:@"%ldKb", (gameInfo.tvSize)/1024];
        }
        else
        {
            cell.capa.text = [NSString stringWithFormat:@"%ldMb", (gameInfo.tvSize)/1024/1024];
        }
        return cell;
    }
    else
    {
        NSUInteger row = [indexPath row];
        NSLog(@"befor!---");
        GameInfo* gameInfo = [self.pspGameArray objectAtIndex:row];
        NSLog(@"after!---");
        cell = [tableView dequeueReusableCellWithIdentifier:cellTableViewIdentifier];
        if(cell == nil)
        {
            cell = [[[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableViewIdentifier] autorelease];
        }
        else
        {
            [cell clear];
        }
        [cell setImage:gameInfo.iconUrl];
        cell.nameLabel.text = gameInfo.name ;
        cell.typeName.text = gameInfo.gameTypeName;
//        cell.capa.text = [NSString stringWithFormat:@"%ldMb",(gameInfo.tvSize)/1024/1024];
        int mb = (int)(gameInfo.tvSize)/1024/1024;
        if(mb <= 0)
        {
            cell.capa.text = [NSString stringWithFormat:@"%ldKb", (gameInfo.tvSize)/1024];
        }
        else
        {
            cell.capa.text = [NSString stringWithFormat:@"%ldMb", (gameInfo.tvSize)/1024/1024];
        }
        return cell;
    }
}





#pragma mark-
#pragma mark Table Delegate Methods

//每一行缩进多少
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSUInteger row = [indexPath row];
    //    return row;
    return 0;
}


//获取所在的行
- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    
    if(self.flag == NEW)
    {
        GameIntroViewController* gameIntroduce = [[GameIntroViewController alloc] initWithNibName:@"GameIntroViewController" bundle:nil];
        
        //设置delegate
//        self.passValueDelegate = gameIntroduce;
        
        //页面传值
        GameInfo* gameInfo = [self.niceGameArray objectAtIndex:row];
//        [self.passValueDelegate passValue:gameInfo];
        gameIntroduce.gameInfo = gameInfo;
        
        [self.navigationController pushViewController:gameIntroduce animated:YES];
        [gameIntroduce release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if(self.flag == HOT)
    {
        GameIntroViewController* gameIntroduce = [[GameIntroViewController alloc] initWithNibName:@"GameIntroViewController" bundle:nil];
        
        //        self.passValueDelegate = gameIntroduce;
        
        GameInfo* gameInfo = [self.hotGameArray objectAtIndex:row];
        //        [self.passValueDelegate passValue:gameInfo];
        gameIntroduce.gameInfo = gameInfo;
        
        [self.navigationController pushViewController:gameIntroduce animated:YES];
        [gameIntroduce release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if(self.flag == CATE)
    {
        GameIntroViewController* gameIntroduce = [[GameIntroViewController alloc] initWithNibName:@"GameIntroViewController" bundle:nil];
        
        //        self.passValueDelegate = gameIntroduce;
        
        GameInfo* gameInfo = [self.cateGameArray objectAtIndex:row];
        //        [self.passValueDelegate passValue:gameInfo];
        gameIntroduce.gameInfo = gameInfo;
        
        [self.navigationController pushViewController:gameIntroduce animated:YES];
        [gameIntroduce release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        GameIntroViewController* gameIntroduce = [[GameIntroViewController alloc] initWithNibName:@"GameIntroViewController" bundle:nil];
        
        //        self.passValueDelegate = gameIntroduce;
        
        GameInfo* gameInfo = [self.pspGameArray objectAtIndex:row];
        //        [self.passValueDelegate passValue:gameInfo];
        gameIntroduce.gameInfo = gameInfo;
        
        [self.navigationController pushViewController:gameIntroduce animated:YES];
        [gameIntroduce release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.flag == HOT)
    {
        return 80;
    }
    else if(self.flag == NEW)
    {
        return 80;
    }
    else
    {
        return 80;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPt = [[touches anyObject] locationInView:self.view];
    
    if(CGRectContainsPoint(self.tvHomeLabel.frame, currentPt) || CGRectContainsPoint(self.tvHomeIv.frame, currentPt))
    {
//        if(_touchFlag == NO)
//        {
//            _touchFlag = YES;
            [self.navigationController popViewControllerAnimated:NO];
//        }
    }
    /*
    if(CGRectContainsPoint(self.myGameLabel.frame, currentPt) || CGRectContainsPoint(self.myGameIv.frame, currentPt))
    {
        if(_touchFlag == YES)
        {
            _touchFlag = NO;
            
            static MyGameViewController* myGameVc = [[MyGameViewController alloc] initWithNibName:@"MyGameViewController" bundle:nil];
            
            //            MyGameVc* myGameVc = [[MyGameVc alloc] initWithNibName:@"MyGameVc" bundle:nil];
            [self.navigationController pushViewController:myGameVc animated:NO];
        }
    }
    //    self.tvHomeIv.image = [UIImage imageNamed:@"yk_zhuye1.png"];
    //    self.tvHomeLabel.textColor = myGrayColor;
    //    self.myGameLabel.textColor = myGrayColor;
    //    self.myGameIv.image = [UIImage imageNamed:@"sjyx_shouyou1.png"];
     */
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

/*
//当滑动结束时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float height = scrollView.contentSize.height > self.gameList.frame.size.height ? self.gameList.frame.size.height : scrollView.contentSize.height;
    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2)
    {
        // 调用上拉刷新方法
        NSLog(@"上拉");
        
        if (self.flag == HOT)
        {
            if([self.hotGameArray count]%20 != 0)
            {
                return;
            }
            
            self.hotPageNum = [self.hotGameArray count]/20 + 1;
            footView.frame = CGRectMake(0,self.hotGameArray.count*80, 320,50);
            
            [self.gameList addSubview:footView];
            //正在加载
            [NSThread detachNewThreadSelector:@selector(initMyDataSource) toTarget:self withObject:nil];
        }
        else if(self.flag == NEW)
        {
            if([self.niceGameArray count]%20 != 0)
            {
                return;
            }
            
            self.nicePageNum = [self.niceGameArray count]/20 + 1;
            footView.frame = CGRectMake(0,self.niceGameArray.count*80, 320,50);
            
            [self.gameList addSubview:footView];
            //正在加载
            [NSThread detachNewThreadSelector:@selector(initMyDataSource) toTarget:self withObject:nil];
        }
        else if(self.flag == CATE)
        {
            if([self.cateGameArray count]%20 != 0)
            {
                return;
            }
            
            self.catePageNum = [self.cateGameArray count]/20 + 1;
            footView.frame = CGRectMake(0,self.cateGameArray.count*80, 320,50);
            
            [self.gameList addSubview:footView];
            //正在加载
            [NSThread detachNewThreadSelector:@selector(initMyDataSource) toTarget:self withObject:nil];
            
        }
        else
        {
            if([self.pspGameArray count]%20 != 0)
            {
                return;
            }
            
            self.pspPageNum = [self.pspGameArray count]/20 + 1;
            footView.frame = CGRectMake(0,self.pspGameArray.count*80, 320,50);
            
            [self.gameList addSubview:footView];
            //正在加载
            [NSThread detachNewThreadSelector:@selector(initMyDataSource) toTarget:self withObject:nil];
        }
    }
}
 */

#pragma passGameInfoArray delegate
- (void) passGameInfoArray:(NSMutableArray *)gameInfoArray
{
    for(GameInfo* gameInfo in gameInfoArray)
    {
        switch (gameInfo.appType) {
            case 1:                 //安卓游戏
                NSLog(@"gameRoot %d", gameInfo.gameRoot);
                [self.hotGameArray addObject:gameInfo];
                break;
            case 2:                 //红白机游戏
                [self.niceGameArray addObject:gameInfo];
                break;
            case 3:                 //街机游戏
                [self.cateGameArray addObject:gameInfo];
                break;
            case 4:                 //psp游戏
                [self.pspGameArray addObject:gameInfo];
                break;
            default:
                break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.activityIndicator isAnimating])
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        
        [self.view addSubview:self.gameList];
        
        [_failedIv removeFromSuperview];
        //    [_failedIv release];
        [_failedLabel removeFromSuperview];
        //    [_failedLabel release];
        [_listUv removeFromSuperview];
        [_reloadBtn removeFromSuperview];
    });
    
    
//    [self.view performSelectorOnMainThread:@selector(addSubview:) withObject:self.gameList waitUntilDone:YES];
//    [self.gameList performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
}

@end


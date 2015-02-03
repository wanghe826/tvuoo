//
//  PlayTvGameViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//
#import "LordViewController.h"
#import "PlayTvGameViewController.h"
#import "ParseJson.h"
#import "GameInfo.h"
#import "DEFINE.h"
#import "GameIntroViewController.h"
#import "Singleton.h"
#import "CommonBtn.h"
#import "JiejiViewController.h"
#import "EGOImageLoader/EGOCache.h"
#import "MyCell.h"
#import "MyGameVc.h"
#import "CateGameViewController.h"
#import "AllUrl.h"
#import "HongbaijiViewController.h"
#import "PSPViewController.h"
#define myGrayColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];

@interface PlayTvGameViewController ()
@end

@implementation PlayTvGameViewController
@synthesize touchFlag = _touchFlag;


//三个图片数组的缓存
@synthesize hotImgArray;
@synthesize niceImgArray;
@synthesize cateImgArray;


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
@synthesize hotBtn;
@synthesize hotIv;
@synthesize hotLabel;
@synthesize niceBtn;
@synthesize niceIv;
@synthesize niceLabel;
@synthesize cateBtn;
@synthesize cateIv;
@synthesize cateLabel;
@synthesize hotPageNum = _hotPageNum;
@synthesize nicePageNum = _nicePageNum;
@synthesize catePageNum = _catePageNum;



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
    label.text = @"电视游戏中心";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
}

- (void) addSearchBtn
{
    UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(649*[Singleton getSingle].width_rate-10, 40*([Singleton getSingle].height_rate)+5, 40, 40);
    [searchBtn setImage:[UIImage imageNamed:@"ty_sousuo1.png"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"ty_sousuo2.png"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(pressSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
}

-(void) gestureTargetFromLeft
{
    if(self.flag == HOT)
    {
        [self pressNew];
    }
    else if(self.flag == NEW)
    {
        [self pressCatogary];
    }
}

-(void) gestureTargetFromRight
{
    if(self.flag == CATE)
    {
        [self pressNew];
    }
    else if(self.flag == NEW)
    {
        [self pressHot];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //为列表增加手势
    UISwipeGestureRecognizer* gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTargetFromLeft)];
    gestureRecognizerLeft.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureRecognizerLeft];
    [gestureRecognizerLeft release];
    
    UISwipeGestureRecognizer* gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTargetFromRight)];
    gestureRecognizerRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:gestureRecognizerRight];
    [gestureRecognizerRight release];
    
    
    self.hotPageNum = 1;
    self.nicePageNum = 1;
    self.catePageNum = 1;
    
    footView = [[FootView alloc] init];
    
//    _hotImgArray = [[NSMutableArray alloc] initWithCapacity:5];
//    _niceImgArray = [[NSMutableArray alloc] initWithCapacity:5];
//    _cateImgArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    self.hotImgArray = [[NSMutableArray alloc] initWithCapacity:5];
    self.niceImgArray = [[NSMutableArray alloc] initWithCapacity:5];
    self.cateImgArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    Singleton* single = [Singleton getSingle];
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
    
    
    [self addSearchBtn];
    
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
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,141,320,380) style:UITableViewStylePlain];
    self.gameList = tableView;
    self.flag = HOT;
    [self.gameList setDelegate:self];
    [self.gameList setDataSource:self];
    [tableView release];
    
    [self initFailedUI];
    
    _hotGameUrl = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] topicUrl]];
    [_hotGameUrl appendString:[NSString stringWithFormat:@"?topicid=1"]];
    _newGameUrl = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] topicUrl]];
    [_newGameUrl appendString:[NSString stringWithFormat:@"?topicid=2"]];
    _categoryUrl = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] gameTypeUrl]];
    [self fetchDataIng];
    [self addBottomBtn];
    
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
    self.tvHomeIv.image = [UIImage imageNamed:@"yk_zhuye2.png"];
    [self.view addSubview:self.tvHomeIv];
    
    self.tvHomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 545, 100, 30)];
    self.tvHomeLabel.text = @"电视大厅";
    [self.tvHomeLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
//    self.tvHomeLabel.textColor = myGrayColor;
    self.tvHomeLabel.textColor = blueColor;
    [self.view addSubview:self.tvHomeLabel];
    
    self.myGameIv = [[UIImageView alloc] initWithFrame:CGRectMake(215, 523, 30, 30)];
    self.myGameIv.image = [UIImage imageNamed:@"sjyx_shouyou1.png"];
    [self.view addSubview:self.myGameIv];
    
    self.myGameLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 545, 100, 30)];
    self.myGameLabel.text = @"我的游戏";
    [self.myGameLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    self.myGameLabel.textColor = myGrayColor;
    [self.view addSubview:self.myGameLabel];
}

- (void) initFailedUI
{
    _failedIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //    failedIv.center = self.view.center;
    _failedIv.center = CGPointMake(self.view.center.x, self.view.center.y  - 30);
    _failedIv.image = [UIImage imageNamed:@"ty_ku.png"];
    _failedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    _failedLabel.center = CGPointMake(self.view.center.x+10, 330);
    _failedLabel.text = @"抱歉 内容载入失败";
    [_failedLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    _failedLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    _listUv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _listUv.center = CGPointMake(self.view.center.x,370);
    [_listUv.layer setBorderWidth:1.0];
    [_listUv.layer setCornerRadius:4.0];
    [_listUv.layer setBorderColor:[greenColor CGColor]];
    
//    _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    [_failedIv removeFromSuperview];
    if(_failedLabel != nil);
    [_failedLabel removeFromSuperview];
    [_listUv removeFromSuperview];
    [_reloadBtn removeFromSuperview];
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    [self.view addSubview:self.activityIndicator];
    
//    [NSThread detachNewThreadSelector:@selector(initMyDataSource) toTarget:self withObject:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self initMyDataSource];
    });
}

- (void) addThreeBtn
{
    self.hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hotBtn addTarget:self action:@selector(pressHot) forControlEvents:UIControlEventTouchUpInside];
    self.hotBtn.backgroundColor = [UIColor whiteColor];
    [self.hotBtn.layer setCornerRadius:4.0];
    self.hotBtn.frame = CGRectMake(30,89, 80,30);
    [self.view addSubview:self.hotBtn];
    self.hotIv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_remen2.png"]] autorelease];
    self.hotIv.frame = CGRectMake(45, 94, 20,20);
    [self.view addSubview:self.hotIv];
    self.hotLabel = [[[UILabel alloc] initWithFrame:CGRectMake(65, 92, 40, 25)] autorelease];
    self.hotLabel.text = @"热门";
    self.hotLabel.textColor = blueColor;
    [self.hotLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    [self.view addSubview:self.hotLabel];
    
    self.niceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.niceBtn addTarget:self action:@selector(pressNew) forControlEvents:UIControlEventTouchUpInside];
    [self.niceBtn.layer setCornerRadius:4.0];
    self.niceBtn.frame = CGRectMake(120,89, 80,30);
    [self.view addSubview:self.niceBtn];
    self.niceIv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_xinpin1.png"]]  autorelease];
    self.niceIv.frame = CGRectMake(135, 94, 20,20);
    [self.view addSubview:self.niceIv];
    self.niceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(155, 92, 40, 25)] autorelease];
    self.niceLabel.text = @"新品";
    self.niceLabel.textColor = [UIColor whiteColor];
    [self.niceLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    [self.view addSubview:self.niceLabel];
    
    self.cateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cateBtn addTarget:self action:@selector(pressCatogary) forControlEvents:UIControlEventTouchUpInside];
    [self.cateBtn.layer setCornerRadius:4.0];
    self.cateBtn.frame = CGRectMake(210,89, 80,30);
    [self.view addSubview:self.cateBtn];
    self.cateIv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_fenlei1.png"]] autorelease];
    self.cateIv.frame = CGRectMake(225, 94, 20,20);
    [self.view addSubview:self.cateIv];
    self.cateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(245, 92, 40, 25)] autorelease];
    self.cateLabel.text = @"分类";
    self.cateLabel.textColor = [UIColor whiteColor];
    [self.cateLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    [self.view addSubview:self.cateLabel];
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
//            _hotGameUrl = [_hotGameUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            self.hotGameArray = [ParseJson createGameInfoArrayFromJson:_hotGameUrl];
            
            if([self.hotGameArray count] > 0)
            {
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
            [jsonString appendString:_hotGameUrl];
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
            self.niceGameArray = [ParseJson createGameInfoArrayFromJson:_newGameUrl];
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
            [jsonString appendString:_newGameUrl];
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
            
        }
    }
    else
    {
        if(self.catePageNum <= [self.cateGameArray count]/20)
        {
            return;
        }
        if (self.catePageNum == 1)
        {
            [_categoryUrl appendString:[NSString stringWithFormat:@"?action=1"]];
            self.cateGameArray = [ParseJson createCategoryArrayFromJson:_categoryUrl];
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
            [jsonString appendString:_categoryUrl];
            [jsonString appendString:[NSString stringWithFormat:@"&page=%d",self.catePageNum]];
            
            NSMutableArray* newGameInfoArray = [[NSMutableArray alloc] initWithCapacity:5];
            newGameInfoArray = [ParseJson createCategoryArrayFromJson:jsonString];
            if(newGameInfoArray!=nil && [newGameInfoArray count]!=0)
            {
                [self.cateGameArray addObjectsFromArray:newGameInfoArray];
//                [self fetchImage:newGameInfoArray];
                [footView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                [self.gameList performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            {
                self.catePageNum--;
            }
            [jsonString release];
        }
        
    }
}

-(void) loadFailed
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
    [self.gameList removeFromSuperview];
    
    [self.view addSubview:_failedIv];
    [self.view addSubview:_failedLabel];
    [self.view addSubview:_listUv];
    [self.view addSubview:_reloadBtn];
    
}

- (void) reloadTableView
{
//    [self.activityIndicator stopAnimating];
//    [self.activityIndicator removeFromSuperview];
    self.activityIndicator.hidden = YES;
    [_failedLabel removeFromSuperview];
    [_failedIv removeFromSuperview];
    [_reloadBtn removeFromSuperview];
    [_listUv removeFromSuperview];
    
    [self.gameList reloadData];
    [self.view addSubview:self.gameList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressSearch
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithArray:self.hotGameArray];
    [array addObjectsFromArray:self.niceGameArray];
    _searchGameViewController = [[SearchGameViewController alloc] initWithNibName:@"SearchGameViewController" bundle:nil];
    _searchGameViewController.sourceArray = array;
    [self.navigationController pushViewController:_searchGameViewController animated:YES];
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
        
        if ([self.hotGameArray count] != 0)
        {
            [self connSuccRemoveSomeView];
            [self.view addSubview:self.gameList];
            [self.gameList reloadData];
        }
        else
        {
            [self fetchDataIng];
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
        
        if ([self.niceGameArray count] != 0)
        {
            [self connSuccRemoveSomeView];
            [self.view addSubview:self.gameList];
            [self.gameList reloadData];
        }
        else
        {
            [self fetchDataIng];
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
        
        if ([self.cateGameArray count] != 0)
        {
            [self connSuccRemoveSomeView];
            [self.view addSubview:self.gameList];
            [self.gameList reloadData];
        }
        else
        {
            [self fetchDataIng];
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
    [_myGame release];
    _myGame = nil;
    self.hotBtn = nil;
    self.hotIv = nil;
    self.hotLabel = nil;
    
    self.niceBtn = nil;
    self.niceIv = nil;
    self.niceLabel = nil;
    
    self.cateBtn = nil;
    self.cateIv = nil;
    self.cateLabel = nil;
    [_searchGameViewController release];
    
    [_failedIv release];
    [_failedLabel release];
    [_listUv release];
    [_reloadBtn release];

    [super dealloc];
}

#pragma mark- 
#pragma mark Table View Data Source Methods
- (NSInteger) tableView:(UITableView*) tableView            //一个分区有多少行
  numberOfRowsInSection:(NSInteger)section
{
    if(self.flag == HOT)          //热门
    {
        return [self.hotGameArray count];
    }
    else if(self.flag == NEW)     //新品
    {
        return [self.niceGameArray count];
    }
    else                        //类别
    {
        return [self.cateGameArray count];
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
       return cell;
   }
   else if(flag == CATE)
   {
       cell = [tableView dequeueReusableCellWithIdentifier:cellTableViewIDentifier2];
       NSUInteger row = [indexPath row];
       CategoryGameInfo* gameInfo = [self.cateGameArray objectAtIndex:row];
       
       if(cell == nil)
       {
           cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableViewIDentifier2];
       }
       else
       {
           [cell clear];
       }
       cell.typeLabel.hidden = YES;
       cell.typeName.hidden = YES;
       cell.capaLabel.hidden = YES;
       cell.nameLabel.frame = CGRectMake(100, 10, 150, 60);
       
       [cell setImage:gameInfo.imgUrl];
       cell.nameLabel.text = gameInfo.typeName ;
       cell.typeName.text = gameInfo.typeMemo;
//       cell.capa.text = [NSString stringWithFormat:@"%ldMb",(gameInfo.)/1024/1024];
        return cell;
   }
    else
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
//       cell.capa.text = [NSString stringWithFormat:@"%ldMb",(gameInfo.tvSize)/1024/1024];
       
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
//- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return indexPath;
//}
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    
    if(flag == NEW)
    {
        GameIntroViewController* gameIntroduce = [[GameIntroViewController alloc] initWithNibName:@"GameIntroViewController" bundle:nil];
        //页面传值
        GameInfo* gameInfo = [niceGameArray objectAtIndex:row];
        gameIntroduce.gameInfo = gameInfo;
        
        [self.navigationController pushViewController:gameIntroduce animated:YES];
        [gameIntroduce release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if(flag == HOT)
    {
        GameIntroViewController* gameIntroduce = [[GameIntroViewController alloc] initWithNibName:@"GameIntroViewController" bundle:nil];
        GameInfo* gameInfo = [hotGameArray objectAtIndex:row];
        gameIntroduce.gameInfo = gameInfo;
        
        [self.navigationController pushViewController:gameIntroduce animated:YES];
        [gameIntroduce release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        CategoryGameInfo* cate = [self.cateGameArray objectAtIndex:row];
        int cateNum = cate.gameType;
        
        NSMutableString* str = [[NSMutableString alloc] init];
//        http://tvuent.wap3.cn/tvuoo/json/gamelist.jsp?gametype=
//        [str appendString:CATEGORY];
        [str appendString:[[AllUrl getInstance] gameListUrl]];
        [str appendString:@"?gametype="];
        [str appendString:[NSString stringWithFormat:@"%d", cateNum]];
        CateGameViewController* cateVc = [[CateGameViewController alloc] initWithNibName:@"CateGameViewController" bundle:nil];
        cateVc.titleName = cate.typeName;
        cateVc.jsonString = str;
        [self.navigationController pushViewController:cateVc animated:YES];
        [str release];
        [cateVc release];
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
        if(_touchFlag == NO)
        {
            _touchFlag = YES;
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    if(CGRectContainsPoint(self.myGameLabel.frame, currentPt) || CGRectContainsPoint(self.myGameIv.frame, currentPt))
    {
        if(_touchFlag == YES)
        {
            _touchFlag = NO;
            
//            static MyGameViewController* myGameVc = [[MyGameViewController alloc] initWithNibName:@"MyGameViewController" bundle:nil];
            if([Singleton getSingle].conn_statue != 2)
            {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"尚未连接电视" message:@"请连接电视" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
                return;
            }
//            static MyGameVc* myGameVc = [[MyGameVc alloc] initWithNibName:@"MyGameVc" bundle:nil];
            if(_myGame != nil)
            {
                [self.navigationController pushViewController:_myGame animated:NO];
            }
            else
            {
                _myGame = [[MyGameVc alloc] initWithNibName:@"MyGameVc" bundle:nil];
                [self.navigationController pushViewController:_myGame animated:NO];
            }
        }
    }
//    self.tvHomeIv.image = [UIImage imageNamed:@"yk_zhuye1.png"];
//    self.tvHomeLabel.textColor = myGrayColor;
//    self.myGameLabel.textColor = myGrayColor;
//    self.myGameIv.image = [UIImage imageNamed:@"sjyx_shouyou1.png"];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


//当滑动结束时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float height = scrollView.contentSize.height > self.gameList.frame.size.height ? self.gameList.frame.size.height : scrollView.contentSize.height;
    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2)
    {
        // 调用上拉刷新方法
        
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
        else
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
    }
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
@end


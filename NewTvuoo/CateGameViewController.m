//
//  CateGameViewController.m
//  NewTvuoo
//
//  Created by xubo on 10/22 Wednesday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "CateGameViewController.h"
#import "CommonBtn.h"
#import "DEFINE.h"
#import "ParseJson.h"
#import "MyCell.h"
#import "EGOImageLoader/EGOImageView.h"
#import "GameIntroViewController.h"
#import "MouseControlViewController.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "PSPViewController.h"
#import "AllUrl.h"
#import "MBProgressHUD.h"

@interface CateGameViewController ()

@end

@implementation CateGameViewController

@synthesize titleName;
@synthesize pageNum = _pageNum;
@synthesize imageArray = _imageArray;
@synthesize gameList = _gameList;
@synthesize jsonString = _jsonString;
@synthesize array = _array;
@synthesize scrollFlag = _scrollFlag;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollFlag = NO;
    
    UIImageView* topIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    topIv.backgroundColor = blueColor;
    [self.view addSubview:topIv];
    [topIv release];
    
    ReturnBtn* goBackBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
    goBackBtn.center = CGPointMake(40, topIv.center.y);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    [goBackBtn release];
    
    UILabel* topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
//    topTitleLabel.text = @"惊喜即将呈现";
    topTitleLabel.text = self.titleName;
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    topTitleLabel.textColor = [UIColor whiteColor];
    topTitleLabel.center = topIv.center;
    [self.view addSubview:topTitleLabel];
    [topTitleLabel release];
    
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, 450) style:UITableViewStylePlain];
//    self.gameList = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, 450) style:UITableViewStylePlain];
    self.gameList = tableView;
    self.gameList.delegate = self;
    self.gameList.dataSource = self;
//    [self.view addSubview:self.gameList];
    [tableView release];
    
    _imageArray = [[NSMutableArray alloc] initWithCapacity:5];
    self.pageNum = 1;
    
    footView = [[FootView alloc] init];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    _activityView.color = [UIColor blackColor];
    _activityView.center = self.view.center;
//    [_activityView startAnimating];
//    [self.view addSubview:_activityView];
    [self initFailedUI];
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
    [_reloadBtn addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventTouchUpInside];
    [_reloadBtn.titleLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    _reloadBtn.frame = CGRectMake(100, 450, 100, 50);
    _reloadBtn.center = _listUv.center;
    [_reloadBtn setTitle:@"重新载入" forState:UIControlStateNormal];
    [_reloadBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [_reloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
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


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [NSThread detachNewThreadSelector:@selector(fetchData) toTarget:self withObject:nil];
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

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) reloadCateTableView
{
    [footView removeFromSuperview];
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    [self.view addSubview:self.gameList];
    [self.gameList reloadData];
    
}

- (void) loadFailed
{
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    [self.view addSubview:_failedIv];
    [self.view addSubview:_failedLabel];
    [self.view addSubview:_reloadBtn];
    [self.view addSubview:_listUv];
}


- (void) removeSomeFailedUI
{
    [_failedLabel removeFromSuperview];
    [_failedIv removeFromSuperview];
    [_reloadBtn removeFromSuperview];
    [_listUv removeFromSuperview];
    [_activityView startAnimating];
    [self.view addSubview:_activityView];
}
- (void) fetchData
{

    if (self.pageNum <= [self.array count]/20)
    {
        return;
    }
    
    
    
    NSMutableString* jsonString = [[NSMutableString alloc] init];
    [jsonString appendString:self.jsonString];
    [jsonString appendString:[NSString stringWithFormat:@"&pageid=%d",self.pageNum]];
    if (self.pageNum == 1)
    {
        [self performSelectorOnMainThread:@selector(removeSomeFailedUI) withObject:nil waitUntilDone:YES];
        self.array = [ParseJson createGameInfoArrayFromCategory:jsonString];
        if([self.array count] ==0 || self.array == nil)
        {
            [jsonString release];
            [self loadFailed];
            return;
        }
    }
    else
    {
        NSMutableArray* newPageArray = [ParseJson createGameInfoArrayFromCategory:jsonString];
        if (newPageArray != nil && ([newPageArray count] >0))
        {
            [self.array addObjectsFromArray:newPageArray];
        }
        else
        {
            self.pageNum--;
        }
        
    }
    
    [jsonString release];
    [self performSelectorOnMainThread:@selector(reloadCateTableView) withObject:nil waitUntilDone:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"MyCell";
    MyCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    else
    {
        [cell clear];
    }
    GameInfo* gameInfo = [self.array objectAtIndex:[indexPath row]];
    [cell setImage:gameInfo.iconUrl];
    cell.nameLabel.text = gameInfo.name ;
    cell.typeName.text = gameInfo.gameTypeName;
//    cell.capa.text = [NSString stringWithFormat:@"%ldMb",(gameInfo.androidPkgSize)/1024/1024];
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void) putImageToArray:(GameInfo*)gameInfo
{
    if ([self.imageArray count] < [self.array count])
    {
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:gameInfo.iconUrl]];
        UIImage* image = [UIImage imageWithData:data];
        [self.imageArray addObject:image];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameIntroViewController* gameIntroduce = [[GameIntroViewController alloc] initWithNibName:@"GameIntroViewController" bundle:nil];
    
    //页面传值
    GameInfo* gameInfo = [self.array objectAtIndex:[indexPath row]];
    gameIntroduce.gameInfo = gameInfo;
    
    [self.navigationController pushViewController:gameIntroduce animated:YES];
    [gameIntroduce release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//当scroller滑动时调用
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
}

//当滑动结束时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([self.array count]%20 != 0)
    {
        return;
    }
    
    float height = scrollView.contentSize.height > self.gameList.frame.size.height ? self.gameList.frame.size.height : scrollView.contentSize.height;
    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2)
    {
        self.pageNum = (int)[self.array count]/20+1;
        footView.frame = CGRectMake(0,self.array.count*80, 320,50);
        [self.gameList addSubview:footView];
        [NSThread detachNewThreadSelector:@selector(fetchData) toTarget:self withObject:nil];
        
        // 调用上拉刷新方法
        NSLog(@"上拉");
        
    }
    
}

- (void)dealloc
{
    [super dealloc];
}

@end

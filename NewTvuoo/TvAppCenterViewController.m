//
//  TvAppCenterViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/22 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//
#import "TvAppCenterViewController.h"
#import "CommonBtn.h"
#import "MyCell.h"
#import "ParseJson.h"
#import "DEFINE.h"
#import "Singleton.h"
#import "SurpriseView.h"
#import "AllUrl.h"
#import "GameIntroViewController.h"
#import "MouseControlViewController.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "PSPViewController.h"
#import "domain/MyJniTransport.h"
#import "MBProgressHUD.h"
#import "NoConnViewController.h"
#define myGrayColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];

@interface TvAppCenterViewController ()

@end

@implementation TvAppCenterViewController
@synthesize btnFlag = _btnFlag;
@synthesize gameList;
@synthesize flag;
@synthesize bizhuangBtn = _bizhuangBtn;
@synthesize bizhuangIv = _bizhuangIv;
@synthesize bizhuangLabel = _bizhuangLabel;

@synthesize jingxuanBtn = _jingxuanBtn;
@synthesize jingxuanIv = _jingxuanIv;
@synthesize jingxuanLabel = _jingxuanLabel;

@synthesize failedLabel = _failedLabel;
@synthesize failedIv = _failedIv;
@synthesize listUv = _listUv;
@synthesize reloadBtn = _reloadBtn;
@synthesize activityIndicator = _activityIndicator;
@synthesize array1 = _array1;
@synthesize array2 = _array2;

@synthesize btn1 = _btn1;
@synthesize btn2 = _btn2;
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize quickConn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}
- (void) pressBtn: (id)sender
{
    NSInteger tag = [(UIButton*)sender tag];
    switch (tag) {
        case 1:         //精选商品
            flag = 1;
            if(_btnFlag == NO)
            {
                _btnFlag = YES;
                
                _bizhuangBtn.backgroundColor = blueColor;
                _bizhuangIv.image = [UIImage imageNamed:@"ty_xin1.png"];
                _bizhuangLabel.textColor = [UIColor whiteColor];
                
                _jingxuanBtn.backgroundColor = [UIColor whiteColor];
                _jingxuanIv.image = [UIImage imageNamed:@"ty_xinpin2.png"];
                _jingxuanLabel.textColor = blueColor;
            }
            if ([self.array1 count] > 0)
            {
                [self.gameList reloadData];
            }
            else
            {
                [self fetchDataIng];
            }
            
            break;
        case 2:
            flag = 2;   //电视必装
            if(_btnFlag == YES)
            {
                _btnFlag = NO;
                
                _bizhuangBtn.backgroundColor = [UIColor whiteColor];
                _bizhuangIv.image = [UIImage imageNamed:@"ty_xin2.png"];
                _bizhuangLabel.textColor = blueColor;
                
                _jingxuanBtn.backgroundColor = blueColor;
                _jingxuanIv.image = [UIImage imageNamed:@"ty_xinpin1.png"];
                _jingxuanLabel.textColor = [UIColor whiteColor];
            }
            if ([self.array2 count] > 0)
            {
                [self.gameList reloadData];
            }
            else
            {
                [self.gameList removeFromSuperview];
                [self fetchDataIng];
            }
            break;
        default:
            break;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _btnFlag = YES;
    
    Singleton* single = [Singleton getSingle];
    float w_rate = single.width_rate;
    float h_rate = single.height_rate;
    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 120)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    UIImageView* whiteIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 141, 320, 350)];
    whiteIv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteIv];
    [whiteIv release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(30*w_rate, 40*h_rate+20, 30, 30)];
    [retBtn addTarget:self action:@selector(retBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(240.0*w_rate, 36.33*h_rate+20, 80, 30)];
    label.text = @"电视应用中心";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
    flag = 1;
    gameList = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, 320, 380) style:UITableViewStylePlain];
    [gameList setDelegate:self];
    [gameList setDataSource:self];
    
    [self initFailedUI];
    
    [self addBottomBtn];
    
    [self addTwoBtn];
    
    
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityIndicator = activity;
    self.activityIndicator.center = CGPointMake(160, 284);
    self.activityIndicator.hidden = YES;
    self.activityIndicator.color = blueColor;
    [activity release];
    [self fetchDataIng];
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

- (void) disconnectedWithTv
{
    //    int iP = [ip intValue];
    //    const char* disConnIp = parseIp(iP);
    //    NSString* str = [NSString stringWithFormat:@"%s", disConnIp];
    [Singleton getSingle].conn_statue = 1;
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"与电视的连接断开了" message:@"断开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [self.view addSubview:alertView];
    [alertView show];
    [alertView release];
    
}
- (void) addBottomBtn
{
    UIImageView* bottomIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 520, 320, 48)];
    bottomIv.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
    [self.view addSubview:bottomIv];
    [bottomIv release];
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.frame = CGRectMake(50,525,100, 20);
    [_btn1 setImage:[UIImage imageNamed:@"sjyx_shouyou2.png"] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(btn1PressDown) forControlEvents:UIControlEventTouchDown];
    [_btn1 addTarget:self action:@selector(btn1Press) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn1];
    
    _label1 = [[UILabel alloc] init];
    _label1.frame = CGRectMake(65,545, 100, 20);
    _label1.text = @"电视软件";
    _label1.textColor = blueColor;
    [self.view addSubview:_label1];
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn2.frame = CGRectMake(210,525,40, 20);
    [_btn2 setImage:[UIImage imageNamed:@"dsyy_guanli1.png"] forState:UIControlStateNormal];
    [_btn2 addTarget:self action:@selector(btn2PressDown) forControlEvents:UIControlEventTouchDown];
    [_btn2 addTarget:self action:@selector(btn2Press) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn2];
    
    _label2 = [[UILabel alloc] init];
    _label2.frame = CGRectMake(195,545, 100, 20);
    _label2.text = @"应用管理";
    _label2.textColor = myGrayColor;
    [self.view addSubview:_label2];
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
- (void) btn2PressDown
{
    [_btn2 setImage:[UIImage imageNamed:@"dsyy_guanli2.png"] forState:UIControlStateNormal];
    _label2.textColor = blueColor;
}

- (void) btn2Press
{
    [_btn2 setImage:[UIImage imageNamed:@"dsyy_guanli1.png"] forState:UIControlStateNormal];
    _label2.textColor = myGrayColor;
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionFade]; //淡入淡出
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];

    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    /*
    animation.type = kCATransitionFade;
    animation.type = kCATransitionPush;
    animation.type = kCATransitionReveal;
    animation.type = kCATransitionMoveIn;
    animation.type = @"cube";
    animation.type = @"suckEffect";
    animation.type = @"oglFlip";
    animation.type = @"rippleEffect";
    animation.type = @"pageCurl";
    animation.type = @"pageUnCurl";
    animation.type = @"cameraIrisHollowOpen";
    animation.type = @"cameraIrisHollowClose";
     */
    
    SurpriseView* myView = [[SurpriseView alloc] initWithNibName:@"SurpriseView" bundle:nil];
    [self.navigationController pushViewController:myView animated:YES];
    
    [myView release];
}


- (void) btn1PressDown
{
    return;
    [_btn1 setImage:[UIImage imageNamed:@"sjyx_shouyou2.png"] forState:UIControlStateNormal];
    _label1.textColor = blueColor;
}

- (void) btn1Press
{
    return;
    [_btn1 setImage:[UIImage imageNamed:@"sjyx_shouyou1.png"] forState:UIControlStateNormal];
    _label1.textColor = myGrayColor;
}


- (void) fetchDataIng
{
    [_failedIv removeFromSuperview];
    [_failedLabel removeFromSuperview];
    [_listUv removeFromSuperview];
    [_reloadBtn removeFromSuperview];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    
    [NSThread detachNewThreadSelector:@selector(initAppDataSource) toTarget:self withObject:nil];
}

- (void) initAppDataSource
{
    if (self.flag == 1)
    {
        NSMutableString* jsonUrl = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] topicUrl]];
        [jsonUrl appendString:@"?topicid=3"];
//        self.array1 = [ParseJson createGameInfoArrayFromJson:NEW_SOFT];
        self.array1 = [ParseJson createGameInfoArrayFromJson:jsonUrl];
        [jsonUrl release];
        if([self.array1 count] > 0)
        {
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(loadFailed) withObject:nil waitUntilDone:YES];
        }
    }
    if (self.flag == 2)
    {
        NSMutableString* jsonUrl = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] topicUrl]];
        [jsonUrl appendString:@"?topicid=4"];
        self.array2 = [ParseJson createGameInfoArrayFromJson:jsonUrl];
        [jsonUrl release];
        if([self.array2 count] > 0)
        {
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(loadFailed) withObject:nil waitUntilDone:YES];
        }
    }
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

- (void) loadFailed
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
    [self.view addSubview:_failedIv];
    //    [_failedIv release];
    NSLog(@"_failedLabel");
    [self.view addSubview:_failedLabel];
    NSLog(@"_leateter:");
    //    [_failedLabel release];
    [self.view addSubview:_listUv];
    [self.view addSubview:_reloadBtn];
}

- (void) addTwoBtn
{
    //两个按钮的外边框
    UIImageView* listUv = [[UIImageView alloc] initWithFrame:CGRectMake(52*[Singleton getSingle].width_rate, 146*([Singleton getSingle].height_rate)+20, 616*([Singleton getSingle].width_rate), 94*([Singleton getSingle].height_rate))];
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
    
    _jingxuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _jingxuanBtn.tag = 1;
    [_jingxuanBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    _jingxuanBtn.frame = CGRectMake(0, 0, 125, 30);
    _jingxuanBtn.backgroundColor = [UIColor whiteColor];
    [_jingxuanBtn.layer setCornerRadius:4.0];
    _jingxuanBtn.center = CGPointMake(95,listUv.center.y);
    [self.view addSubview:_jingxuanBtn];
    _jingxuanIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _jingxuanIv.image = [UIImage imageNamed:@"ty_xinpin2.png"];
    _jingxuanIv.center = CGPointMake(65,_jingxuanBtn.center.y);
    [self.view addSubview:_jingxuanIv];
    _jingxuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    _jingxuanLabel.text = @"精选新品";
    _jingxuanLabel.textColor = blueColor;
    _jingxuanLabel.center = CGPointMake(115,_jingxuanBtn.center.y);
    [self.view addSubview:_jingxuanLabel];
    
    _bizhuangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bizhuangBtn.tag = 2;
    [_bizhuangBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    _bizhuangBtn.frame = CGRectMake(0, 0, 125, 30);
//    _bizhuangBtn.backgroundColor = [UIColor whiteColor];
    [_bizhuangBtn.layer setCornerRadius:4.0];
    _bizhuangBtn.center = CGPointMake(225,listUv.center.y);
    [self.view addSubview:_bizhuangBtn];
    _bizhuangIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _bizhuangIv.image = [UIImage imageNamed:@"ty_xin1.png"];
    _bizhuangIv.center = CGPointMake(195, _bizhuangBtn.center.y);
    [self.view addSubview:_bizhuangIv];
    _bizhuangLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    _bizhuangLabel.textColor = [UIColor whiteColor];
    _bizhuangLabel.text = @"电视必装";
    _bizhuangLabel.center = CGPointMake(245, _bizhuangBtn.center.y);
    [self.view addSubview:_bizhuangLabel];
}


//实现UITableView协议的回调
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell* cell = nil;
    static NSString* str1 = @"hot";
    static NSString* str2 = @"nice";
    //按下 "精选新品"  按钮
    if(flag == 1)
    {
        NSUInteger row = [indexPath row];
        GameInfo* gameInfo = (GameInfo*)[self.array1 objectAtIndex:row];
        cell = [tableView dequeueReusableCellWithIdentifier:str1];
        if(cell == nil)
        {
            cell = [[[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str1] autorelease];
        }
        else
        {
            [cell clear];
        }
        [cell setImage:gameInfo.largeAppIcon];
        cell.nameLabel.text = gameInfo.name ;
//        cell.typeName.text = gameInfo.gameTypeName;
//        cell.typeName.hidden = YES;
        cell.typeLabel.hidden = YES;
        cell.capa.text = [NSString stringWithFormat:@"%dMb",(gameInfo.tvFileSize)/1024/1024];
        return cell;
        
    }
    //按下 "电视必装"  按钮
    else
    {
        NSUInteger row = [indexPath row];
        GameInfo* gameInfo = [self.array2 objectAtIndex:row];
        cell = [tableView dequeueReusableCellWithIdentifier:str2];
        if(cell == nil)
        {
            cell = [[[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str2] autorelease];
        }
        else
        {
            [cell clear];
        }
        [cell setImage:gameInfo.largeAppIcon];
        cell.nameLabel.text = gameInfo.name ;
//        cell.typeName.text = gameInfo.gameTypeName;
//        cell.typeName.hidden = YES;
        cell.typeLabel.hidden = YES;
        cell.capa.text = [NSString stringWithFormat:@"%dMb",(gameInfo.tvFileSize)/1024/1024];
        return cell;
    }
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(flag == 1)
    {
        return [self.array1 count];
    }
    else
    {
        return [self.array2 count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(flag == 1)
    {
        return 80;
    }
    else
    {
        return 80;
    }
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    if([Singleton getSingle].conn_statue != 2)
    {
        NoConnViewController* noConnVc = [[NoConnViewController alloc] initWithNibName:@"NoConnViewController" bundle:nil];
        noConnVc.quickConnVc = self.quickConn;
        [self.navigationController pushViewController:noConnVc animated:YES];
        [noConnVc release];
        return;
    }
    
    if(flag == 1)
    {
        AppIntroViewController* gameIntroduce = [[AppIntroViewController alloc] initWithNibName:nil bundle:nil];
        //页面传值
        GameInfo* gameInfo = [self.array1 objectAtIndex:row];
        
        gameIntroduce.gameInfo = gameInfo;
        
        [self.navigationController pushViewController:gameIntroduce animated:YES];
        [gameIntroduce release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if(flag == 2)
    {
        AppIntroViewController* gameIntroduce = [[AppIntroViewController alloc] initWithNibName:nil bundle:nil];
        GameInfo* gameInfo = [self.array2 objectAtIndex:row];
        gameIntroduce.gameInfo = gameInfo;
        [self.navigationController pushViewController:gameIntroduce animated:YES];
        [gameIntroduce release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)retBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc
{
    [_label1 release];
    [_label2 release];
    self.activityIndicator = nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initFailedUI
{
    _failedIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
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

@end


@interface GameIntroViewController ()

@end



@implementation AppIntroViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView* backIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 60)];
    backIv.backgroundColor = blueColor;
    [self.view addSubview: backIv];
    [backIv release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 30, 40, 40)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    [self addGameProperty];
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) gotoHandle:(NSNotification*)notification
{
    NSDictionary* dic = [notification userInfo];
    NSMutableString* url = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] gameInfoUrl]];
    [url appendString:@"?gamepkg="];
    [url appendString:[dic objectForKey:@"pkg"]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        GameInfo* gameInfo = [ParseJson createGameInfoFromJson:url];
        if(gameInfo != nil)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                switch ([[dic objectForKey:@"act"] intValue])
                {
                    case 1:                     //启动安卓游戏的手柄
                    {
                        MouseControlViewController* mouseControlVC = [[MouseControlViewController alloc] initWithNibName:@"MouseControlViewController" bundle:nil];
                        mouseControlVC.currentGameInfo = gameInfo;
                        [self.navigationController presentViewController:mouseControlVC animated:NO completion:nil];
                        [mouseControlVC release];
                        break;
                    }
                    case 2:                     //启动红白机游戏的手柄
                    {
                        HongbaijiViewController* hongbaiVc = [[HongbaijiViewController alloc] initWithNibName:@"HongbaijiViewController" bundle:nil];
                        hongbaiVc.gameParam = gameInfo.gameParam;
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
            });
        }
    });
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
    _gameImage.imageURL = [NSURL URLWithString:_gameInfo.largeAppIcon];
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
        _gameType.text = @"应用";
//    _gameType.text = _gameInfo.gameTypeName;
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
    _gameCapa.text = [NSString stringWithFormat:@"%dMb",_gameInfo.tvFileSize/1024/1024];
    _gameCapa.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]; //灰色
    [self.view addSubview:_gameCapa];
    
    UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 178, 280, 2)];
    line1.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [self.view addSubview:line1];
    [line1 release];
    
    UILabel* introLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, 80, 30)];
    introLabel.text = @"应用介绍";
    introLabel.textColor = [UIColor blackColor];
    //    introLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [introLabel setFont:[UIFont fontWithName:@"Courier New" size:19]];
    [self.view addSubview:introLabel];
    [introLabel release];
    
    //游戏介绍
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 212, 280, 120)];
    //    scrollView.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
    [label setNumberOfLines:20];
    label.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    label.text = self.gameInfo.summary;
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
    screenShot.text = @"应用截图";
    screenShot.textColor = [UIColor blackColor];
    //    introLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [screenShot setFont:[UIFont fontWithName:@"Courier New" size:19]];
    [self.view addSubview:screenShot];
    [screenShot release];
    
    
    //游戏截图
    UIScrollView* somePic = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 365, 280, 160)];
//    NSArray* gssArray = _gameInfo.gameScrShoot;
    int wid = 0;
    for(int i=0; i<3; ++i)
    {
//        GameScrShoot* gss = [gssArray objectAtIndex:i];
//        EGOImageView* imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(wid,10, 140, 160)];
        EGOImageView* imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"tb_morenren2.png"]];
        imageView.frame = CGRectMake(wid,10, 140, 160);
        wid += 150;
//        imageView.imageURL = [NSURL URLWithString:gss.imgUrl];
        imageView.imageURL = [NSURL URLWithString:self.gameInfo.faceImg];
        [somePic addSubview:imageView];
        [imageView release];
    }
    
    
    somePic.pagingEnabled = YES;
    somePic.scrollEnabled = YES;
    somePic.showsHorizontalScrollIndicator = YES;
    somePic.contentSize = CGSizeMake(450, 160);
    [self.view addSubview:somePic];
    [somePic release];
    
    UIImageView* bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 528, 320, 40)];
    bottomView.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [self.view addSubview: bottomView];
    [bottomView release];
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(50, 538, 140, 20);
    btn1.center = CGPointMake(self.view.center.x, 548);
    [btn1 setTitle:@"推送到电视安装" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(playInTv) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
//    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn2 addTarget:self action:@selector(playInPhone) forControlEvents:UIControlEventTouchUpInside];
//    btn2.frame = CGRectMake(180, 538, 100, 20);
//    [btn2 setTitle:@"在手机上玩" forState:UIControlStateNormal];
//    [self.view addSubview:btn2];
    
    //安卓游戏是1   安卓游戏
    //魂斗罗是2    红白机游戏
    //恐龙快打是3  接机游戏
}

- (NSString*) gameInfoJsonString
{
    
    //    NSDictionary* dic = [NSDictionary alloc] initWithObjectsAndKeys:self.gameInfo.game_id, nil
    return nil;
}


- (void) playInTv
{
    if([Singleton getSingle].conn_statue != 2)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"推送失败" message:@"尚未与电视进行连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    else
    {
//        NSMutableString* jsonStr = [[NSMutableString alloc] init];
//        [jsonStr appendString:[[AllUrl getInstance] gameInfoUrl]];
//        [jsonStr appendString:@"?gamepkg="];
//        [jsonStr appendString:self.gameInfo.tvApkPkg];
//        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//            NSLog(@"jsssssjjjjj %@", jsonStr);
//            GameInfo* game = [ParseJson createGameInfoFromJson:jsonStr];
//            if(game != nil)
//            {
//                self.gameInfo = game;
//            }
//        });
        
        NSMutableString* jsonString = [[NSMutableString alloc] init];
        [jsonString appendString:@"{"];
        [jsonString appendString:@"\"appid\":"];
        [jsonString appendString:[NSString stringWithFormat:@"%d,",self.gameInfo.appid]];
        [jsonString appendString:@"\"tvapkpkg\":"];
        [jsonString appendString:@"\""];
        [jsonString appendString:self.gameInfo.tvApkPkg];
        [jsonString appendString:@"\""];
        [jsonString appendString:@"}"];
        
        const char* c_jsonString = [jsonString UTF8String];
        
        string str = c_jsonString;
        NSLog(@"推动到电视:%s", str.c_str());
        sendApp([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport,0, str);
        [jsonString release];
    }
}



- (void) viewWillAppear:(BOOL)animated
{
    //    [self addGameProperty];
    [super viewWillAppear:YES];
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(disconnectedWithTv) name:@"breakDown" object:nil];
    [notification addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
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

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self];
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
@end


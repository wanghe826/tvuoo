//
//  SearchGameViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//
#import "ParseJson.h"
#import "JiejiViewController.h"
#import "HongbaijiViewController.h"
#import "MouseControlViewController.h"
#import "PSPViewController.h"
#import "SearchGameViewController.h"
#import "DEFINE.h"
#import "CommonBtn.h"
#import "GameInfo.h"
#import "EGOImageLoader/EGOImageView.h"
#import "MyCell.h"
#import "GameIntroViewController.h"
#import "AllUrl.h"
#import "MBProgressHUD.h"
@interface SearchGameViewController ()

@end

@implementation SearchGameViewController
@synthesize schTextField = _schTextField;
@synthesize hintIv = _hintIv;
@synthesize hintLabel = _hintLabel;
@synthesize tableView = _tableView;
@synthesize array = _array;
@synthesize topLabel = _topLabel;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize schLabel = _schLabel;
@synthesize noGameIv = _noGameIv;
@synthesize  sourceArray;

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
    
    _btnFlag = NO;
    
    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 120)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 80, 30)];
    label.text = @"游戏搜索";
    [label setFont:[UIFont fontWithName:@"Courier New" size:20]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(23, 82, 20, 20)];
    iv.image = [UIImage imageNamed:@"yxss_sousuo.png"];
    
    _schField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 220, 40)];
    [_schField setBackgroundColor:[UIColor whiteColor]];
    [_schField.layer setCornerRadius:4.0];
    _schField.leftView = iv;
    _schField.placeholder = @"查找游戏";
    _schField.leftViewMode = UITextFieldViewModeAlways;
    _schField.textColor = blueColor;
    [self.view addSubview:_schField];
    [iv release];
    
    UIImageView* listUv = [[UIImageView alloc] initWithFrame:CGRectMake(255, 80, 60, 40)];
    //        [listUv setImage:[UIImage imageNamed:@"ty_bai1.png"]];
    [listUv setBackgroundColor:blueColor];
    [listUv.layer setBorderWidth:1.0];
    [listUv.layer setCornerRadius:4.0];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){24,180,237,1});
    [listUv.layer setBorderColor:colorref];
    [self.view addSubview:listUv];
    [listUv release];
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    
    UIButton* schBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [schBtn addTarget:self action:@selector(searchGame) forControlEvents:UIControlEventTouchUpInside];
    [schBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [schBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [schBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    schBtn.frame = CGRectMake(255, 80, 60, 40);
    schBtn.layer.cornerRadius = 4.0;
    [self.view addSubview:schBtn];
    
    _hintIv = [[UIImageView alloc] initWithFrame:CGRectMake(50, 230, 230, 120)];
    [_hintIv setBackgroundColor:[UIColor whiteColor]];
    [_hintIv.layer setBorderWidth:1.0];
    [_hintIv.layer setCornerRadius:4.0];
    [_hintIv.layer setBorderColor:[blueColor CGColor]];
    [self.view addSubview:_hintIv];
    
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 290, 160, 50)];
    [_hintLabel setNumberOfLines:2];
    _hintLabel.text = @"请在上方输入框写上游戏名称";
    _hintLabel.textColor = blueColor;
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.center = _hintIv.center;
    [self.view addSubview:_hintLabel];
   
    _array = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, 320, 398) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 320, 30)];
    _topLabel.text = @"正在为您搜索游戏";
    [_topLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    _topLabel.textColor = blueColor;
    _topLabel.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:249.0/255.0 blue:255.0/255.0 alpha:1];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    _activityIndicatorView.hidden = YES;
    _activityIndicatorView.center = self.view.center;
    [self.view addSubview:_activityIndicatorView];
    
    _schLabel = [[UILabel alloc] initWithFrame:CGRectMake(_activityIndicatorView.center.x-75, _activityIndicatorView.center.y+30, 150, 30)];
    _schLabel.text = @"正在搜索游戏";
    _schLabel.textAlignment = NSTextAlignmentCenter;
    _schLabel.textColor = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    
    _noGameIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_meiyou.png"]];
    _noGameIv.center = self.view.center;
    
//    _tableArray = [[NSMutableArray alloc] initWithCapacity:2];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, 320, 408) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
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

- (void) searchGame
{
    if(_btnFlag == YES)
    {
        return;
    }
    [_hintIv removeFromSuperview];
    [_hintLabel removeFromSuperview];
    NSString* gameName = [_schField text];
    [self.view addSubview:_topLabel];
    [_activityIndicatorView startAnimating];
    [self.view addSubview:_schLabel];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //查找游戏
        BOOL flag = YES;
        NSMutableString* jsonUrl = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] findGameUrl]];
        [jsonUrl appendString:@"?name="];
        [jsonUrl appendString:gameName];
        
        _tableArray = [self createGameInfoArrayFromJsonUrl:jsonUrl];
        if([_tableArray count] > 0)
        {
            flag = NO;      //找到游戏
            dispatch_async(dispatch_get_main_queue(), ^{
//                _btnFlag = YES;sdjlfk
                [self.activityIndicatorView stopAnimating];
                [self.activityIndicatorView removeFromSuperview];
                [_schLabel removeFromSuperview];
//                _topLabel.text = @"共找到1个游戏";
                _topLabel.text = [NSString stringWithFormat:@"共找到%lu个游戏", (unsigned long)[_tableArray count]];
                //                    [self showGameResult:gameInfo];
//                [_tableArray addObject:gameInfo];
                [self.view addSubview:_tableView];
                [_tableView reloadData];
            });
        }
        if(flag == YES)
        {
            //没有找到游戏
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicatorView stopAnimating];
                [self.activityIndicatorView removeFromSuperview];
                [_schLabel removeFromSuperview];
                _topLabel.text = @"共找到0个游戏";
                [_tableView removeFromSuperview];
            });
        }
        [jsonUrl release];
    });
}
- (NSMutableArray*) createGameInfoArrayFromJsonUrl:(NSString*)jsonUrl
{
    
    jsonUrl = [jsonUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:jsonUrl];

    NSError* error = [[NSError alloc] init];

//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    NSData* data = [NSString stringWithContentsOfURL:url usedEncoding:N error:&error];
    NSData* data = [NSData dataWithContentsOfURL:url];
    if(data == nil)
    {
        NSLog(@"没有解析， 返回NIL");
//        NSLog(@"errorrrrr: %@", [error description]);
        [error release];
        return nil;
    }
    
    NSString* jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //开始解析json
    //json 数据最外层是数组  则返回数组
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(jsonArray == nil)
    {
        return nil;
    }
    NSMutableArray* gameInfoArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[jsonArray count]; ++i)
    {
        NSDictionary* dic = (NSDictionary*)[jsonArray objectAtIndex:i];
        GameInfo* gameInfo = [[GameInfo alloc] init];
        gameInfo.action = [[dic objectForKey:@"action"] intValue];
        gameInfo.game_id = [[dic objectForKey:@"game_id"] intValue];
        gameInfo.name = [dic objectForKey:@"name"];
        gameInfo.appType = [[dic objectForKey:@"apptype"] intValue];
        gameInfo.gameType = [dic objectForKey:@"game_type"];
        gameInfo.tvPkgName = [dic objectForKey:@"tv_pkgname"];
        gameInfo.gameParam = [[dic objectForKey:@"gameparam"] intValue];
        gameInfo.level = [[dic objectForKey:@"level"] intValue];
        gameInfo.text = [dic objectForKey:@"text"];
        gameInfo.allText = [dic objectForKey:@"allText"];
        gameInfo.faceImg = [dic objectForKey:@"faceimg"];
        gameInfo.androidPhoneUseTvApk = [[dic objectForKey:@"androidphoneusetvapk"] intValue];
        gameInfo.androidPkgPath = [dic objectForKey:@"android_pkg_path"];
        gameInfo.androidPkgSize = [[dic objectForKey:@"android_pkg_size"] longValue];
        gameInfo.androidPkgName = [dic objectForKey:@"android_pkg_name"];
        gameInfo.itunesPath = [dic objectForKey:@"itunes_path"];
        gameInfo.iosPkgPath = [dic objectForKey:@"ios_pkg_path"];
        gameInfo.iosPkgSize = [[dic objectForKey:@"ios_package_size"] longValue];
        gameInfo.iconUrl = [dic objectForKey:@"icon_url"];
        gameInfo.bigIcon = [dic objectForKey:@"big_icon"];
        gameInfo.howToPlay = [dic objectForKey:@"howtoplay"];
        gameInfo.gameCapability = [[dic objectForKey:@"game_capability"] intValue];
        gameInfo.gamePlays = [[dic objectForKey:@"game_plays"] intValue];
        gameInfo.loadingUrl = [dic objectForKey:@"loading_url"];
        gameInfo.mouseImg = [dic objectForKey:@"mouse_img"];
        gameInfo.mouseImgDown = [dic objectForKey:@"mouse_img_down"];
        gameInfo.gameTypeName = [dic objectForKey:@"gametypename"];
        gameInfo.bgTouch = [[dic objectForKey:@"bgtouch"] intValue];
        gameInfo.vCode = [[dic objectForKey:@"vcode"] intValue];
        gameInfo.tvTarget = [dic objectForKey:@"tv_target"];
        gameInfo.tvSize = [[dic objectForKey:@"tv_sizes"] longValue];
        gameInfo.tvuSupport = [[dic objectForKey:@"tvusupport"] intValue];
        gameInfo.imgZipUrl = [dic objectForKey:@"img_zip_url"];
        gameInfo.supportDpad = [[dic objectForKey:@"suppportdpad"] intValue];
        gameInfo.largeAppIcon = [dic objectForKey:@"largeiconurl"];
        gameInfo.appIcon = [dic objectForKey:@"iconurl"];
        gameInfo.summary = [dic objectForKey:@"summary"];
        [gameInfoArray addObject:gameInfo];
        [gameInfo release];
    }
//    return [gameInfoArray autorelease];
    return  gameInfoArray ;
}


- (void) showGameResult: (GameInfo*)gameInfo
{
    UIImageView* iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 160, 320, 80)];
    [self.view addSubview:iv1];
    [iv1 release];
    
    EGOImageView* imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
    imageView.frame = CGRectMake(20, 10, 60, 60);
    imageView.imageURL = [NSURL URLWithString:gameInfo.iconUrl];
    [iv1 addSubview:imageView];
    [imageView release];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 150, 30)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    //        _nameLabel.text = _nameLabelText;
    [nameLabel setFont:[UIFont fontWithName:@"Courier New" size:18]];
    nameLabel.text = gameInfo.name;
    [iv1 addSubview:nameLabel];
    [nameLabel release];
    
    UILabel* typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 33, 40, 25)];
    typeLabel.text = @"类型";
    [typeLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    typeLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
    [iv1 addSubview:typeLabel];
    [typeLabel release];
    
//    UILabel* typeName = [[UILabel alloc] initWithFrame:CGRectMake(140, 33, 100, 25)];
//    [typeName setFont:[UIFont fontWithName:@"Courier New" size:15]];
//    //        _typeName.text = _typeNameText;
//    typeName.text = gameInfo.gameType;
//    typeName.textColor = [UIColor colorWithRed:116.0/255.0 green:177.0/255.0 blue:79.0/255.0 alpha:1];
//    [iv1 addSubview:typeName];
//    [typeName release];
    
    UILabel* capaLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 40, 25)];
    capaLabel.text = @"大小";
    [capaLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    capaLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
    [iv1 addSubview:capaLabel];
    [capaLabel release];
    
    UILabel* capa = [[UILabel alloc] initWithFrame:CGRectMake(140,50,100,25)];
    capa.tag = 14;
    [capa setFont:[UIFont fontWithName:@"Courier New" size:15]];
    capa.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
    //        capa.text = [NSString stringWithFormat:@"%ldMb",(_gameInfo.androidPkgSize)/1024/1024];
    //        _capa.text = _capaText;
    capa.text = [NSString stringWithFormat:@"%luMb", (gameInfo.tvSize)/1024/1024];
    
    [iv1 addSubview:capa];
    [capa release];
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

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressSearch:(id)sender {
}

- (IBAction)closeKeyPad:(id)sender
{
    [_schField resignFirstResponder];
}
- (void)dealloc {
    [_schTextField release];
    [_activityIndicatorView release];
    [_hintIv release];
    [_hintLabel release];
    [_tableView release];
    [_tableArray release];
    [_array release];
    [_topLabel release];
    [_schLabel release];
    [_noGameIv release];
    [_schField release];
    [super dealloc];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* identifier = @"myCell";
    MyCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }

    GameInfo* gameInfo = [_tableArray objectAtIndex:[indexPath row]];
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

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section
{
    if(_tableArray == nil)
    {
        NSLog(@"_tableArray is ninl");
    }
    return [_tableArray count];
}
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameIntroViewController* gameIntroduce = [[GameIntroViewController alloc] initWithNibName:@"GameIntroViewController" bundle:nil];
    
    //        self.passValueDelegate = gameIntroduce;
    
    GameInfo* gameInfo = [_tableArray objectAtIndex:[indexPath row]];
    //        [self.passValueDelegate passValue:gameInfo];
    gameIntroduce.gameInfo = gameInfo;
    
    [self.navigationController pushViewController:gameIntroduce animated:YES];
    [gameIntroduce release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end

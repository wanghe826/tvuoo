//
//  QucikConnViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/17 Wednesday.
//  Copyright (c) 2014 wap3. All rights reserved.
//
#import "ParseJson.h"
#import "AllUrl.h"
#import "SearchGameViewController.h"
#import "QuickConnViewController.h"
#import "CommonBtn.h"
#import "DEFINE.h"
#import "Singleton.h"
#import "domain/MyJniTransport.h"
#import "GameInfo.h"
#import "MouseControlViewController.h"
#import "MBProgressHUD.h"
#import "HelpViewController.h"
#import "AllUrl.h"
#import "EGOImageView.h"

#define myBlueColor [UIColor colorWithRed:24.0/255.0 green:180.0/255.0 blue:237.0/255.0 alpha:1];

@interface QuickConnViewController ()

@end


@implementation QuickConnViewController

@synthesize timer;
@synthesize angle;
@synthesize animaUv;
//@synthesize tvArray = _tvArray;
//@synthesize sdkArray;
@synthesize avalibaleDev;
@synthesize devBtn;
@synthesize virHanBtn;
@synthesize connOrBreakBtn;
@synthesize current_ip;
@synthesize current_port;
@synthesize conn_statue;
@synthesize devView;
@synthesize devLabel;
@synthesize handLabel;
@synthesize handView;
@synthesize tableViewFlag;
@synthesize activityIndicator;
@synthesize lineIv;
@synthesize hintLabel1;
@synthesize hintLabel2;
@synthesize activityIndicator2;
@synthesize searchingLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
    }
    return self;
}
- (void)pressSearchBtn
{
    HelpViewController* help = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    [self.navigationController pushViewController:help animated:YES];
    [help release];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    [Singleton getSingle].myConnDelegate = nil;
    
//    [_avalibleTvTimer invalidate];
    [Singleton getSingle].myAddTvInfoOrSdk = nil;
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [Singleton getSingle].myDelegate = self;
    [Singleton getSingle].myBreakDownDelegate = self;
    [Singleton getSingle].myAddTvInfoOrSdk = self;
//    if([self.tvArray count] > 0)
    if([[Singleton getSingle].tvArray count] > 0)
    {
        [self.avalibaleDev reloadData];
    }
    else
    {
        [self addNoConnView];
    }
    [Singleton getSingle].myDelegate = self;
    
    //add
//    if([Singleton getSingle].conn_statue != 2)
//    {
//        for(TvInfo* tvInfo in self.tvArray)
//        {
//            tvInfo.cell_btn_statue = NO;
//        }
//        for(TvInfo* tvInfo in self.sdkArray)
//        {
//            tvInfo.cell_btn_statue = NO;
//        }
//        [self.avalibaleDev reloadData];
//    }
    /*
    _avalibleTvTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(updateTableView) userInfo:nil repeats:YES];
    [_avalibleTvTimer fire];
     */
}

#pragma add Tvinfo and sdk
- (void) addSdk
{
    [self updateTableView];
}
- (void) addTvInfo
{
    [self updateTableView];
}

- (void) updateTableView
{
    if(_btnFlag == YES)         //设备
    {
        if([[Singleton getSingle].tvArray count] == 0)
        {
            if(_hasTvFlag == NO)        //如果之前就是没有数据的状态就直接返回  不需要再调用addNoConnView
            {
                return;
            }
            [self addNoConnView];
            _hasTvFlag = NO;
        }
        else
        {
            if(_hasTvFlag == NO)        //如果之前是没有数据的状态
            {
                [self addConnView];
                [self.avalibaleDev reloadData];
            }
            else
            {
                [self.avalibaleDev reloadData];
            }
            _hasTvFlag = YES;
        }
    }
    else                        //虚拟手柄
    {
        if([[Singleton getSingle].sdkArray count] == 0)
        {
            if(_hasSdkFlag == NO)        //如果之前就是未连接状态就直接返回  不需要再调用addNoConnView
            {
                return;
            }
            [self addNoConnView];
            _hasSdkFlag = NO;
        }
        else
        {
//            self.sdkArray = [Singleton getSingle].sdkArray;
            if(_hasSdkFlag == NO)        //如果之前是未连接状态
            {
                [self addConnView];
                [self.avalibaleDev reloadData];
            }
            else
            {
                [self.avalibaleDev reloadData];
            }
            _hasSdkFlag = YES;
        }
        
    }
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc
{
//    self.searchingLabel = nil;
//    self.activityIndicator = nil;
//    self.activityIndicator2 = nil;
//    self.hintLabel2 = nil;
//    self.hintLabel1 = nil;
//    self.lineIv = nil;
//    [super dealloc];
    /*
    [devBtn release];
    [virHanBtn release];
    [_tvArray release];
    [avalibaleDev release];
    [connOrBreakBtn release];
    [animaUv release];
     */
    self.activityIndicator2 = nil;
    self.activityIndicator = nil;
    self.devBtn = nil;
    self.virHanBtn = nil;
    self.avalibaleDev = nil;
    self.handLabel = nil;
    self.handView = nil;
    self.virtualHandle = nil;
//    self.sdkArray = nil;
//    self.tvArray = nil;
    [_dimBackview release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hasSdkFlag = NO;
    _hasTvFlag = NO;
    
    _btnFlag = YES;
    // Do any additional setup after loading the view from its nib.
    
//    self.tvArray = [[NSMutableArray alloc] init];
//    self.sdkArray = [[NSMutableArray alloc] init];
//    self.sdkArray = [Singleton getSingle].sdkInfoList;
    
    Singleton* single = [Singleton getSingle];
//    single.myDelegate = self;
    single.myConnDelegate = self;
    
    float w_rate = single.width_rate;
    float h_rate = single.height_rate;
    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 131)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    self.tableViewFlag = DEV_TABLEVIEW;
    //显示列表
    UITableView* avalibDev = [[UITableView alloc] initWithFrame:CGRectMake(0, 151, 320, 400) style:UITableViewStyleGrouped];
    self.avalibaleDev = avalibDev;
    [self.avalibaleDev setDataSource:self];
    [self.avalibaleDev setDelegate:self];
    [self.view addSubview:self.avalibaleDev];
    [avalibDev release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(30*w_rate, 40*h_rate+20, 30, 30)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(240.0*w_rate, 36.33*h_rate+20, 80, 30)];
    label.text = @"连接您的设备";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
    
    
    SearchBtn* searchBtn = [[SearchBtn alloc] initWithFrame:CGRectMake(649*w_rate-10, 40*h_rate+20, 30, 30)];
    //        [searchBtn sizeToFit];
    [searchBtn addTarget:self action:@selector(pressSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [searchBtn release];
    
    //两个按钮的外边框
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
    
    self.devBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.devBtn.frame = CGRectMake(30, 148*h_rate+25, 130, 30);
    [self.devBtn addTarget:self action:@selector(pressDevBtn) forControlEvents:UIControlEventTouchUpInside];
//    devBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 148*h_rate+25, 130,30)];
//    [devBtn setBackgroundImage:[UIImage imageNamed:@"ty_bai2.png"] forState:UIControlStateNormal];
    [self.devBtn setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* deviceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lj_shebei2.png"]];
    self.devView = deviceView;
    self.devView.frame = CGRectMake(30,5,20,20);
    UILabel* dev = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 20, 20)];
    self.devLabel = dev;
    self.devLabel.text = @"设备";
    [self.devLabel sizeToFit];
    [self.devLabel setTextColor:blueColor];
    [self.devBtn addSubview:self.devView];
    [self.devBtn addSubview:self.devLabel];
    [self.view addSubview:self.devBtn];
//    [devBtn release];
    [deviceView release];
    [dev release];
    
    
    virHanBtn= [[UIButton alloc] initWithFrame:CGRectMake(162, 148*h_rate+25, 130, 30)];
    [virHanBtn addTarget:self action:@selector(pressHandBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:virHanBtn];
    
    handView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lj_shoubing1.png"]];
    handView.frame = CGRectMake(30,5,20,20);
    handLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 20, 20)];
    handLabel.text = @"虚拟手柄";
    [handLabel sizeToFit];
    [handLabel setTextColor:[UIColor whiteColor]];
    [virHanBtn addSubview:handView];
    [virHanBtn addSubview:handLabel];
    [self.view addSubview:virHanBtn];
    [virHanBtn release];
    [handLabel release];
    [handView release];
    
    _dimBackview = [[UIImageView alloc] initWithFrame:self.view.frame];
    _dimBackview.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    _dimBackview.userInteractionEnabled = YES;

    
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator = activityView;
    self.activityIndicator.color = [UIColor blackColor];
    self.activityIndicator.hidden = YES;
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
    [activityView release];
    
    
//    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(haveConnSuc) userInfo:nil repeats:YES];
//    [self addNoConnView];
}

//- (void)haveConnSuc
//{
//    if (self.activityIndicator.hidden == NO)
//    {
//        self.activityIndicator.hidden = YES;
//        [self.activityIndicator stopAnimating];
//        [self connFailed:0];
//    }
//}

- (void) addNoConnView
{
    [self.avalibaleDev removeFromSuperview];
    
    if (self.activityIndicator2 == nil)
    {
        self.activityIndicator2 = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        self.activityIndicator2.color = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
        self.activityIndicator2.hidden = YES;
        self.activityIndicator2.center = self.view.center;
    }
    [self.view addSubview:self.activityIndicator2];
    self.activityIndicator2.hidden = NO;
    [self.activityIndicator2 startAnimating];

    if(self.searchingLabel == nil)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        self.searchingLabel= label;
        self.searchingLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 35);
        self.searchingLabel.text = @"正在查找设备中";
        self.searchingLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
        [label release];
    }
    [self.view addSubview:self.searchingLabel];
    
    
    if(self.lineIv == nil)
    {
        UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 455, 320, 2)];
        self.lineIv = line;
        self.lineIv.backgroundColor = myBlueColor;
        [line release];
    }
    [self.view addSubview:self.lineIv];
    
    
    if(self.hintLabel1 == nil)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40, 465, 240, 20)];
        self.hintLabel1 = label;
        hintLabel1.text = @"请务必确认您的电视与手机";
        hintLabel1.textColor = myBlueColor;
        hintLabel1.textAlignment = NSTextAlignmentCenter;
        [label release];
    }
    [self.view addSubview:self.hintLabel1];
    
    if(self.hintLabel2 == nil)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(50, 490, 200, 20)];
        self.hintLabel2 = label;
        hintLabel2.text = @"在同个路由下";
        hintLabel2.textColor = myBlueColor;
        hintLabel2.textAlignment = NSTextAlignmentCenter;
        [label release];
    }
    [self.view addSubview:self.hintLabel2];
}


- (void)viewDidUnload
{
    [devBtn release];
    [virHanBtn release];
    [_tvArray release];
    [avalibaleDev release];
    [connOrBreakBtn release];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//dataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_btnFlag == YES)
    {
//        return [self.tvArray count];
        return [[Singleton getSingle].tvArray count];
    }
    else if(_btnFlag == NO)
    {
//        return [self.sdkArray count];
        return [[Singleton getSingle].sdkArray count];
    }
    else
    {
        return 0;
    }
}
- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_btnFlag == YES)         //可连接设备
    {
        NSInteger tvCount = [indexPath row];
        static NSString* tableViewCellIdentifier = @"QuickConnTableViewCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
        //    if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier] autorelease];
            UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lj_shebei3.png"]];
            imageView.frame = CGRectMake(20,35,40,40);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel* tvName = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 60, 20)];
//            tvName.text = [[self.tvArray objectAtIndex:tvCount] tvName];
            tvName.text = [[[Singleton getSingle].tvArray objectAtIndex:tvCount] tvName];
            [tvName sizeToFit];
            [tvName setTextColor:blueColor];
            [cell.contentView addSubview:tvName];
            [tvName release];
            
            UILabel* tvIp = [[UILabel alloc] initWithFrame:CGRectMake(70, 55, 60, 20)];
//            int int_ip = [[self.tvArray objectAtIndex:tvCount] tvIp];
            int int_ip = [[[Singleton getSingle].tvArray objectAtIndex:tvCount] tvIp];
            char* str_ip = parseIp(int_ip);
            NSString* nstring_ip = [NSString stringWithUTF8String:str_ip];
            NSString* nstring_ip1 = @"IP: ";
            NSString* labelStr = [nstring_ip1 stringByAppendingString:nstring_ip];
            tvIp.text = labelStr;
            [tvIp sizeToFit];
            [tvIp setTextColor:blueColor];
            [cell.contentView addSubview:tvIp];
            [tvIp release];
            
            connOrBreakBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [connOrBreakBtn setTag:tvCount];
            connOrBreakBtn.frame = CGRectMake(240, 35, 60, 40);
//            if([[self.tvArray objectAtIndex:tvCount] cell_btn_statue] == YES)
            if([[[Singleton getSingle].tvArray objectAtIndex:tvCount] cell_btn_statue] == YES)
            {
//                            NSLog(@"变成断开");
                [connOrBreakBtn setTitle:@"断开" forState:UIControlStateNormal];
                [connOrBreakBtn setTitleColor:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] forState:UIControlStateNormal];
                [connOrBreakBtn setBackgroundImage:[UIImage imageNamed:@"ty_huianniu1.png"] forState:UIControlStateNormal];
            }
            else
            {
//                            NSLog(@"变成连接");
                [connOrBreakBtn setTitle:@"连接" forState:UIControlStateNormal];
                [connOrBreakBtn setTitleColor:[UIColor colorWithRed:107.0/255.0 green:200.0/255.0 blue:16.0/255.0 alpha:1] forState:UIControlStateNormal];
                [connOrBreakBtn setBackgroundImage:[UIImage imageNamed:@"ty_lvanniu1.png"] forState:UIControlStateNormal];
            }
            [connOrBreakBtn addTarget:self action:@selector(pressConnOrBreak:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:connOrBreakBtn];
        }
        return cell;
    }
    else                        //虚拟手柄
    {
        NSInteger tvCount = [indexPath row];
        TvInfo* sdk = [[Singleton getSingle].sdkArray objectAtIndex:tvCount];
        
        
        
        static NSString* tableViewCellIdentifier = @"DevConnTableViewCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
        //    if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier] autorelease];
//            UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lj_shebei3.png"]];
            EGOImageView* imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"lj_shebei3.png"]];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableString* url = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] gameInfoUrl]];
                [url appendString:[NSString stringWithFormat:@"?gamepkg=%@",sdk.pkgName]];
                GameInfo* gameInfo = [ParseJson createGameInfoFromJson:url];
                if(gameInfo != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.imageURL = [NSURL URLWithString:gameInfo.iconUrl];
                        [url release];
                    });
                }
            });
            
            imageView.frame = CGRectMake(20,35,40,40);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel* tvName = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 60, 20)];
//            tvName.text = [[self.sdkArray objectAtIndex:tvCount] tvName];
            tvName.text = [[[Singleton getSingle].sdkArray objectAtIndex:tvCount] tvName];
            [tvName sizeToFit];
            [tvName setTextColor:blueColor];
            [cell.contentView addSubview:tvName];
            [tvName release];
            
            UILabel* tvIp = [[UILabel alloc] initWithFrame:CGRectMake(70, 55, 60, 20)];
//            int int_ip = [[self.sdkArray objectAtIndex:tvCount] tvIp];
            int int_ip = [[[Singleton getSingle].sdkArray objectAtIndex:tvCount] tvIp];
            char* str_ip = parseIp(int_ip);
            NSString* nstring_ip = [NSString stringWithUTF8String:str_ip];
            NSString* nstring_ip1 = @"IP: ";
            NSString* labelStr = [nstring_ip1 stringByAppendingString:nstring_ip];
            tvIp.text = labelStr;
            [tvIp sizeToFit];
            [tvIp setTextColor:blueColor];
            [cell.contentView addSubview:tvIp];
            [tvIp release];
            connOrBreakBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [connOrBreakBtn setTag:tvCount];
            connOrBreakBtn.frame = CGRectMake(240, 35, 60, 40);
//            if([[self.sdkArray objectAtIndex:tvCount] cell_btn_statue] == YES)
            
            [connOrBreakBtn setTitle:@"启动" forState:UIControlStateNormal];
            [connOrBreakBtn setTitleColor:[UIColor colorWithRed:107.0/255.0 green:200.0/255.0 blue:16.0/255.0 alpha:1] forState:UIControlStateNormal];
            [connOrBreakBtn setBackgroundImage:[UIImage imageNamed:@"ty_lvanniu1.png"] forState:UIControlStateNormal];
            /*
            if([[[Singleton getSingle].sdkArray objectAtIndex:tvCount] cell_btn_statue] == YES)
            {
//                            NSLog(@"变成断开");
                [connOrBreakBtn setTitle:@"断开" forState:UIControlStateNormal];
                [connOrBreakBtn setTitleColor:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] forState:UIControlStateNormal];
                [connOrBreakBtn setBackgroundImage:[UIImage imageNamed:@"ty_huianniu1.png"] forState:UIControlStateNormal];
            }
            else
            {
//                            NSLog(@"变成连接");
                [connOrBreakBtn setTitle:@"连接" forState:UIControlStateNormal];
                [connOrBreakBtn setTitleColor:[UIColor colorWithRed:107.0/255.0 green:200.0/255.0 blue:16.0/255.0 alpha:1] forState:UIControlStateNormal];
                [connOrBreakBtn setBackgroundImage:[UIImage imageNamed:@"ty_lvanniu1.png"] forState:UIControlStateNormal];
            }
             */
            [connOrBreakBtn addTarget:self action:@selector(pressConnOrBreak:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:connOrBreakBtn];
        }
        return cell;

    }
}

- (void) pressConnOrBreak:(id)sender
{
    NSUInteger tag = [(UIButton*)sender tag];
    TvInfo* tvInfo = nil;
    if(_btnFlag == YES)
    {
//        tvInfo = [self.tvArray objectAtIndex:tag];
        tvInfo = [[Singleton getSingle].tvArray objectAtIndex:tag];
    }
    if(_btnFlag == NO)
    {
//        tvInfo = [self.sdkArray objectAtIndex:tag];
        tvInfo = [[Singleton getSingle].sdkArray objectAtIndex:tag];
    }
    int ip = tvInfo.tvIp;
    int port = tvInfo.tvServerport;
    if(tvInfo.cell_btn_statue == YES)       //cell_btn_statue如果为yes 则表示为已连上的状态
    {
        
        
//        [[self.tvArray objectAtIndex:tag] setCell_btn_statue:NO];
        if(_btnFlag == YES)
        {
            //断开连接
            closeTcpClient(tvInfo.tvIp, tvInfo.tvServerport);
            [[[Singleton getSingle].tvArray objectAtIndex:tag] setCell_btn_statue:NO];
            
            [avalibaleDev reloadData];
            [Singleton getSingle].conn_statue = 1;
            [Singleton getSingle].current_tv = nil;
        }
        else
        {
//            [[self.sdkArray objectAtIndex:tag] setCell_btn_statue:NO];
//            [[[Singleton getSingle].sdkArray objectAtIndex:tag] setCell_btn_statue:NO];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Singleton getSingle].tvType = 3;
                connectServer(ip, port);
            });
        }
        
        
    }
    else
    {
        [self.view addSubview:_dimBackview];
        [self.activityIndicator startAnimating];
        
        if(_btnFlag == YES)
        {
            [self.view addSubview:self.activityIndicator];
//            for(TvInfo* tv in self.tvArray)
            for(TvInfo* tv in [Singleton getSingle].tvArray)
            {
                if(tv.cell_btn_statue == YES)
                {
                    //断开连接
                    closeTcpClient(tv.tvIp, tv.tvServerport);
                    tv.cell_btn_statue = NO;
                    [avalibaleDev reloadData];
                    break;
                }
            }
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Singleton getSingle].tvType = 1;
                connectServer(ip, port);
            });
        }
        else
        {
            [self.view addSubview:self.activityIndicator];
//            for(TvInfo* tv in self.sdkArray)
            for(TvInfo* tv in [Singleton getSingle].sdkArray)
            {
                if(tv.cell_btn_statue == YES)
                {
                    //断开连接
                    closeTcpClient(tv.tvIp, tv.tvServerport);
                    tv.cell_btn_statue = NO;
                    [avalibaleDev reloadData];
                    break;
                }
            }
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Singleton getSingle].tvType = 3;
                connectServer(ip, port);
            });
        }
        
        
    }

}

- (void)rotateImage
{
    static float radian =0;
    radian += 0.1f;
//    [UIView animateWithDuration:0.1 animations:^{
//        animaUv.transform = CGAffineTransformMakeRotation(radian);
//    }];
}

#pragma connect failed
- (void) connFailed:(int)ip
{
    NSLog(@"普通电视连接失败!");
//    [self.activityIndicator stopAnimating];
//    self.activityIndicator.hidden = YES;
//    //        [self.activityIndicator removeFromSuperview];
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"与电视的连接失败" message:@"是否刷新所有列表" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新列表", nil];
//    [alertView show];
//    [alertView release];
    if([[Singleton getSingle].tvArray count] == 0)
    {
        [Singleton getSingle].conn_statue = 0;
    }
    else
    {
        [Singleton getSingle].conn_statue = 1;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_dimBackview removeFromSuperview];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
//        [self.activityIndicator removeFromSuperview];
        
        if (self.activityIndicator.hidden == NO)
        {
            [_dimBackview removeFromSuperview];
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
        }
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"与电视的连接失败" message:@"是否刷新所有列表" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新列表", nil];
        [alertView show];
        [alertView release];
    });
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [alertView removeFromSuperview];
        if(_btnFlag == YES)
        {
            [[Singleton getSingle].tvArray removeAllObjects];
            [self.avalibaleDev reloadData];
//            [self pressDevBtn];
            [Singleton getSingle].conn_statue = 0;
            [self addNoConnView];
            _hasTvFlag = NO;
        }
        else
        {
            [[Singleton getSingle].sdkArray removeAllObjects];
            [self.avalibaleDev reloadData];
//            [self pressHandBtn];
            _btnFlag = NO;
            self.tableViewFlag = VIR_TABLEVIEW;
            [self.devLabel setTextColor:[UIColor whiteColor]];
            [self.devView setImage:[UIImage imageNamed:@"lj_shebei1.png"]];
            [self.virHanBtn setBackgroundColor:[UIColor whiteColor]];
            [self.handView setImage:[UIImage imageNamed:@"lj_shoubing2.png"]];
            [self.handLabel setTextColor:blueColor];
            [self.devBtn setBackgroundColor:blueColor];
            [self addNoConnView];
            _hasSdkFlag = NO;
        }
    }
}

//如果连接成功， 会回调此方法
- (void) connSuccess:(NSData*)data
{
    NSLog(@"普通电视连接成功");
    //在这里要更改按钮的状态
    int ip = 0;
    [data getBytes:&ip length:sizeof(ip)];
    
    if(_btnFlag == YES)
    {
//        for(int i=0; i<[self.tvArray count]; ++i)
        for(int i=0; i<[[Singleton getSingle].tvArray count]; ++i)
        {
//            if([[self.tvArray objectAtIndex:i] tvIp] == ip)
            if([[[Singleton getSingle].tvArray objectAtIndex:i] tvIp] == ip)
            {
//                ((TvInfo*)[self.tvArray objectAtIndex:i]).cell_btn_statue = YES;
                ((TvInfo*)[[Singleton getSingle].tvArray objectAtIndex:i]).cell_btn_statue = YES;
//                [Singleton getSingle].current_tv = (TvInfo*)[self.tvArray objectAtIndex:i];
                [Singleton getSingle].current_tv = (TvInfo*)[[Singleton getSingle].tvArray objectAtIndex:i];
                [avalibaleDev reloadData];
                break;
            }
        }
        [Singleton getSingle].conn_statue = 2;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dimBackview removeFromSuperview];
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    }
    else
    {
        TvInfo* tvInfo = nil;
//        for(int i=0; i<[self.sdkArray count]; ++i)
        for(int i=0; i<[[Singleton getSingle].tvArray count]; ++i)
        {
//            if([[self.sdkArray objectAtIndex:i] tvIp] == ip)
            if([[[Singleton getSingle].sdkArray objectAtIndex:i] tvIp] == ip)
            {
//                tvInfo = (TvInfo*)[self.sdkArray objectAtIndex:i];
                tvInfo = (TvInfo*)[[Singleton getSingle].sdkArray objectAtIndex:i];
//                ((TvInfo*)[self.sdkArray objectAtIndex:i]).cell_btn_statue = YES;
                tvInfo.cell_btn_statue = YES;
//                [Singleton getSingle].current_tv = (TvInfo*)[self.sdkArray objectAtIndex:i];
                [Singleton getSingle].current_sdk = (TvInfo*)[[Singleton getSingle].sdkArray objectAtIndex:i];
                [avalibaleDev reloadData];
                break;
            }
        }
//        [Singleton getSingle].conn_statue = 2;
        
        //连接的是sdk游戏， 直接跳转相应手柄
        
        
        NSMutableString* jsonStr = [[NSMutableString alloc] init];
        //    [jsonStr appendString:ANDROID_GAME_UI];
        [jsonStr appendString:[[AllUrl getInstance] gameInfoUrl]];
        [jsonStr appendString:@"?gamepkg="];
        if(tvInfo != nil)
        {
//            [jsonStr appendString:self.currentGameInfo.tvPkgName];
            [jsonStr appendString:tvInfo.pkgName];
        }
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            GameInfo* gameInfo = [ParseJson createGameInfoFromJson:jsonStr];
            if(gameInfo != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MouseControlViewController* mouseVc = [[MouseControlViewController alloc] initWithNibName:@"MouseControlViewController" bundle:nil];
                    mouseVc.currentGameInfo = gameInfo;
                    [_dimBackview removeFromSuperview];
                    [self.activityIndicator stopAnimating];
                    [self.activityIndicator removeFromSuperview];
                    [self.navigationController presentViewController:mouseVc animated:YES completion:nil];
                    [mouseVc release];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"载入失败" message:@"网络不给力，请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                });
            }
        });
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

//delegate
- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;    //设置为不可选中
}
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger at_row = [indexPath row];
}

- (void) pressDevBtn
{
    if(_btnFlag == YES)
    {
        return;
    }
    _btnFlag = YES;
//    [devBtn setBackgroundImage:[UIImage imageNamed:@"ty_bai2.png"] forState:UIControlStateNormal];
    [self.handLabel setTextColor:[UIColor whiteColor]];
    [self.handView setImage:[UIImage imageNamed:@"lj_shoubing1.png"]];
    [self.devView setImage:[UIImage imageNamed:@"lj_shebei2.png"]];
    [self.devLabel setTextColor:blueColor];
    [self.devBtn setBackgroundColor:[UIColor whiteColor]];
    [self.virHanBtn setBackgroundColor:blueColor];
//    if([self.tvArray count] > 0)
    if([[Singleton getSingle].tvArray count] > 0)
    {
        [self addConnView];
        [self.avalibaleDev reloadData];
    }
    else
    {
        [self addNoConnView];
    }
    self.tableViewFlag = DEV_TABLEVIEW;
}

- (void) pressHandBtn
{
//    [virHanBtn setBackgroundImage:[UIImage imageNamed:@"ty_bai2.png"] forState:UIControlStateNormal];
    if(_btnFlag == NO)
    {
        return;
    }
    _btnFlag = NO;
    self.tableViewFlag = VIR_TABLEVIEW;
    [self.devLabel setTextColor:[UIColor whiteColor]];
    [self.devView setImage:[UIImage imageNamed:@"lj_shebei1.png"]];
    [self.virHanBtn setBackgroundColor:[UIColor whiteColor]];
    [self.handView setImage:[UIImage imageNamed:@"lj_shoubing2.png"]];
    [self.handLabel setTextColor:blueColor];
    [self.devBtn setBackgroundColor:blueColor];
    
//    if([self.sdkArray count] > 0)
    if([[Singleton getSingle].sdkArray count] > 0)
    {
        [self.avalibaleDev reloadData];
    }
    else
    {
        [self addNoConnView];
    }
}

- (void) addConnView
{
    [self.view addSubview:self.avalibaleDev];
//    [Singleton getSingle].conn_statue = 1;
    [self.activityIndicator2 stopAnimating];
//    [self.activityIndicator2 release];
    self.activityIndicator2 = nil;
    
    [self.searchingLabel removeFromSuperview];
    
    [self.lineIv removeFromSuperview];
    
    [self.hintLabel2 removeFromSuperview];
    
    [self.hintLabel1 removeFromSuperview];
    
    UIImageView* bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 512, 320, 56)];
    bottomView.backgroundColor = myBlueColor;
    [self.view addSubview:bottomView];
    [bottomView release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(180, 530, 160, 20)];
    [label setFont:[UIFont fontWithName:@"Courier New" size:15]];
    label.text = @"正在刷新可连接设备";
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(label.frame.origin.x-15, label.center.y);
    [self.view addSubview:activityView];
    [activityView startAnimating];
    [activityView release];
    [label release];
}

@end

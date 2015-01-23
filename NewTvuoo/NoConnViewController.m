//
//  NoConnViewController.m
//  NewTvuoo
//
//  Created by xubo on 10/17 Friday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "NoConnViewController.h"
#import "DEFINE.h"
#import "CommonBtn.h"
#import "Singleton.h"
#import "RemoteControlViewController.h"
#import "MouseControlViewController.h"
#import "NullMouseViewController.h"
#import "KeyPadViewController.h"
#import "AboutViewController.h"
#import "LordViewController.h"
#import "ClearMemoryViewController.h"
@interface NoConnViewController ()

@end

@implementation NoConnViewController
@synthesize quickConnVc;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 130)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(155 ,30, 70, 30)];
    label.center = CGPointMake(self.view.center.x-5, 50);
    label.text = @"未连接设备";
    [label setFont:[UIFont fontWithName:@"Courier New" size:18]];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
    UIImageView* listUv = [[UIImageView alloc] initWithFrame:CGRectMake(40 , 86, 240, 50)];
    //        [listUv setImage:[UIImage imageNamed:@"ty_bai1.png"]];
    [listUv setBackgroundColor:blueColor];
    [listUv.layer setBorderWidth:1.0];
    [listUv.layer setCornerRadius:4.0];
    listUv.center = CGPointMake(self.view.center.x, 106);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){24,180,237,1});
    [listUv.layer setBorderColor:colorref];
    [self.view addSubview:listUv];
    [listUv release];
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    
    UIImageView* alertIv = [[UIImageView alloc] initWithFrame:CGRectMake(75, 80, 25, 25)];
    alertIv.center = CGPointMake(70, listUv.center.y);
    alertIv.image = [UIImage imageNamed:@"zy_faxian.png"];
    [self.view addSubview:alertIv];
    [alertIv release];
    
    UILabel* noConnLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 19, 180, 25)];
    [noConnLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    noConnLabel.text = @"您的手机未与电视建立连接";
    noConnLabel.textColor = [UIColor whiteColor];
    noConnLabel.center = CGPointMake(175, listUv.center.y);
    [self.view addSubview:noConnLabel];
    [noConnLabel release];
    
    UILabel* connLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 180, 190, 40)];
    connLabel.textColor = blueColor;
    connLabel.text = @"请先与电视进行连接";
    [connLabel setFont:[UIFont fontWithName:@"Courier New" size:20]];
    [self.view addSubview:connLabel];
    [connLabel release];
    
    UIImageView* noConnectIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weilianjie.png"]];
    noConnectIv.frame = CGRectMake(70, 230, 200, 150);
//    noConnLabel.center = self.view.center;
    [self.view addSubview:noConnectIv];
    [noConnectIv release];
    
    UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 400, 200, 60)];
    [hintLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    hintLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [hintLabel setNumberOfLines:2];
    hintLabel.text = @"请保证您的智能电视或机顶盒与手机在同个路由网络下";
    [self.view addSubview:hintLabel];
    [hintLabel release];
    
    UIImageView* btnFrame = [[UIImageView alloc] initWithFrame:CGRectMake(40 , 486, 240, 40)];
//    [btnFrame setBackgroundColor:blueColor];
    [btnFrame.layer setBorderWidth:1.0];
    [btnFrame.layer setCornerRadius:4.0];
//    btnFrame.center = CGPointMake(self.view.center.x, 106);
    [btnFrame.layer setBorderColor:[greenColor CGColor]];
    [self.view addSubview:btnFrame];
    [btnFrame release];
    UIButton* avliableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [avliableBtn addTarget:self action:@selector(pressAvliableBtn) forControlEvents:UIControlEventTouchUpInside];
    [avliableBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [avliableBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    avliableBtn.frame = CGRectMake(100 , 500, 150, 30);
    [avliableBtn setTitle:@"查看可以连接电视" forState:UIControlStateNormal] ;
    avliableBtn.center = btnFrame.center;
    [self.view addSubview:avliableBtn];
//    QuickConnViewController* quickVc = [[QuickConnViewController alloc] initWithNibName:@"QuickConnViewController" bundle:nil];
//    self.quickConnVc = quickVc;
//    [quickVc release];
}

- (void) pressAvliableBtn
{
    [self.navigationController pushViewController:self.quickConnVc animated:YES];
}

- (void) goBack
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    self.quickConnVc = nil;
    [super dealloc];
}

//- (void) viewWillAppear:(BOOL)animated
//{
//    if ([Singleton getSingle].conn_statue != 2)
//    {
//        return;
//    }
//    switch ([Singleton getSingle].tag)
//    {
//        case 1:
//        {
//            RemoteControlViewController* rVc = [[RemoteControlViewController alloc] initWithNibName:@"RemoteControlViewController" bundle:nil];
//            [self.navigationController pushViewController:rVc animated:NO];
//            [rVc release];
//            break;
//        }
//        case 2:
//        {
//            MouseControlViewController* mVc = [[MouseControlViewController alloc] initWithNibName:@"MouseControlViewController" bundle:nil];
//            [self.navigationController pushViewController:mVc animated:NO];
//            [mVc release];
//            break;
//        }
//        case 3:
//        {
//            NullMouseViewController* nVc = [[NullMouseViewController alloc] initWithNibName:@"NullMouseViewController" bundle:nil];
//            [self.navigationController pushViewController:nVc animated:NO];
//            [nVc release];
//        }
//        case 4:
//        {
//            KeyPadViewController* kVc = [[KeyPadViewController alloc] initWithNibName:@"KeyPadViewController" bundle:nil];
//            [self.navigationController pushViewController:kVc animated:NO];
//            [kVc release];
//        }
//        default:
//            break;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation GetTvStateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 60)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(155 ,30, 70, 30)];
    label.center = CGPointMake(self.view.center.x-25, 50);
    label.text = @"正在获取电视状态";
    [label setFont:[UIFont fontWithName:@"Courier New" size:18]];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
//    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityView.frame = CGRectMake(0, 0, 150, 150);
//    activityView.color = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
//    activityView.center = self.view.center;
//    [activityView startAnimating];
//    [self.view addSubview:activityView];
    _activityView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ty_jiazai.png"]];
    _activityView.frame = CGRectMake(0, 0, 150, 150);
    _activityView.center = self.view.center;
    [self.view addSubview:_activityView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotateImage) userInfo:nil repeats:YES];
    [_timer fire];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"请稍等一会， 结果马上到";
    label1.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    label1.center = CGPointMake(self.view.center.x, _activityView.center.y+150);
    [self.view addSubview:label1];
    
    [label1 release];
    [Singleton getSingle].myDelegate = self;
}

#pragma getState
- (void) getTvState:(NSNumber*)state
{
    int status = [state intValue];
    NSLog(@"stttt: %d", status);
    switch (status) {
        case 0:
        {
            [Singleton getSingle].current_tvInfo.canadb = 1;
            LordViewController* loadVC = [Singleton getSingle].viewController;
            [self.navigationController pushViewController:loadVC animated:NO];
            break;
        }
        case 1:
        {
            HintViewController* hintVc = [[HintViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:hintVc animated:YES];
            [hintVc release];
            break;
        }
        case 2:
        {
            GetModuleViewController* moduleVc = [[GetModuleViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:moduleVc animated:YES];
            [moduleVc release];
            break;
        }
        case 3:
        {
            GetRootViewController* rootVc = [[GetRootViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:rootVc animated:YES];
            [rootVc release];
            break;
        }
        default:
            break;
    }
}
- (void) rotateImage
{
//    CGAffineTransform transform = CGAffineTransformMakeRotation(90*M_PI/180);
    static int n = 10;
    _activityView.transform = CGAffineTransformMakeRotation((n+=1)*M_PI/180);
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_timer invalidate];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    checkUseState([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport);
}

- (void) goBack
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [_activityView release];
    [super dealloc];
}
@end

@implementation GetModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 130)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(155 ,30, 70, 30)];
    label.center = CGPointMake(self.view.center.x-20, 50);
    label.text = @"请先安装组件";
    [label setFont:[UIFont fontWithName:@"Courier New" size:18]];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
    UIImageView* listUv = [[UIImageView alloc] initWithFrame:CGRectMake(40 , 86, 240, 50)];
    //        [listUv setImage:[UIImage imageNamed:@"ty_bai1.png"]];
    [listUv setBackgroundColor:blueColor];
    [listUv.layer setBorderWidth:1.0];
    [listUv.layer setCornerRadius:4.0];
    listUv.center = CGPointMake(self.view.center.x, 106);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){24,180,237,1});
    [listUv.layer setBorderColor:colorref];
    [self.view addSubview:listUv];
    [listUv release];
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    
    UIImageView* alertIv = [[UIImageView alloc] initWithFrame:CGRectMake(75, 80, 25, 25)];
    alertIv.center = CGPointMake(70, listUv.center.y);
    alertIv.image = [UIImage imageNamed:@"zy_faxian.png"];
    [self.view addSubview:alertIv];
    [alertIv release];
    
    UILabel* noConnLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 19, 180, 25)];
    [noConnLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    noConnLabel.text = @"请在电视上安装增强组件";
    noConnLabel.textColor = [UIColor whiteColor];
    noConnLabel.center = CGPointMake(175, listUv.center.y);
    [self.view addSubview:noConnLabel];
    [noConnLabel release];
    
    UILabel* connLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 180, 210, 40)];
    connLabel.textColor = greenColor;
    connLabel.text = @"电视缺少游戏增强组件";
    [connLabel setFont:[UIFont fontWithName:@"Courier New" size:20]];
    [self.view addSubview:connLabel];
    [connLabel release];
    
    UIImageView* noConnectIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zujian.png"]];
    noConnectIv.frame = CGRectMake(70, 230, 200, 150);
    noConnectIv.center = CGPointMake(self.view.center.x, 305);
    //    noConnLabel.center = self.view.center;
    [self.view addSubview:noConnectIv];
    [noConnectIv release];
    
    UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 400, 200, 60)];
    [hintLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    hintLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [hintLabel setNumberOfLines:2];
    hintLabel.text = @"请先在电视进行安装";
    [self.view addSubview:hintLabel];
    [hintLabel release];
}

- (void) goBack
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [super dealloc];
}

@end

@implementation HintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 130)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(155 ,30, 70, 30)];
    label.center = CGPointMake(self.view.center.x-20, 50);
    label.text = @"请查看提示";
    [label setFont:[UIFont fontWithName:@"Courier New" size:18]];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
    UIImageView* listUv = [[UIImageView alloc] initWithFrame:CGRectMake(40 , 86, 240, 50)];
    //        [listUv setImage:[UIImage imageNamed:@"ty_bai1.png"]];
    [listUv setBackgroundColor:blueColor];
    [listUv.layer setBorderWidth:1.0];
    [listUv.layer setCornerRadius:4.0];
    listUv.center = CGPointMake(self.view.center.x, 106);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){24,180,237,1});
    [listUv.layer setBorderColor:colorref];
    [self.view addSubview:listUv];
    [listUv release];
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    
    UIImageView* alertIv = [[UIImageView alloc] initWithFrame:CGRectMake(75, 80, 25, 25)];
    alertIv.center = CGPointMake(70, listUv.center.y);
    alertIv.image = [UIImage imageNamed:@"zy_faxian.png"];
    [self.view addSubview:alertIv];
    [alertIv release];
    
    UILabel* noConnLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 19, 180, 25)];
    [noConnLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    noConnLabel.text = @"请打开电视USB调试模式";
    noConnLabel.textColor = [UIColor whiteColor];
    noConnLabel.center = CGPointMake(175, listUv.center.y);
    [self.view addSubview:noConnLabel];
    [noConnLabel release];
    
    UILabel* connLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 180, 210, 40)];
    connLabel.textColor = greenColor;
    connLabel.text = @"电视未开启USB调试模式";
    [connLabel setFont:[UIFont fontWithName:@"Courier New" size:20]];
    [self.view addSubview:connLabel];
    [connLabel release];
    
    UIImageView* noConnectIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"usb.png"]];
    noConnectIv.frame = CGRectMake(70, 230, 200, 150);
    noConnectIv.center = CGPointMake(self.view.center.x, 305);
    //    noConnLabel.center = self.view.center;
    [self.view addSubview:noConnectIv];
    [noConnectIv release];
    
    UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 400, 200, 60)];
    [hintLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    hintLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [hintLabel setNumberOfLines:2];
    hintLabel.text = @"请您在电视上查看详情";
    [self.view addSubview:hintLabel];
    [hintLabel release];
}

- (void) goBack
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [super dealloc];
}

@end


@implementation GetRootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* retPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 130)];
    [retPic setBackgroundColor:blueColor];
    [self.view addSubview:retPic];
    [retPic release];
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    [retBtn release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(155 ,30, 70, 30)];
    label.center = CGPointMake(self.view.center.x-5, 50);
    label.text = @"请先获得权限";
    [label setFont:[UIFont fontWithName:@"Courier New" size:18]];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    //        label.center = CGPointMake(160, 36.33*h_rate+20);
    [self.view addSubview:label];
    [label release];
    
    UIImageView* listUv = [[UIImageView alloc] initWithFrame:CGRectMake(40 , 86, 240, 50)];
    //        [listUv setImage:[UIImage imageNamed:@"ty_bai1.png"]];
    [listUv setBackgroundColor:blueColor];
    [listUv.layer setBorderWidth:1.0];
    [listUv.layer setCornerRadius:4.0];
    listUv.center = CGPointMake(self.view.center.x, 106);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){24,180,237,1});
    [listUv.layer setBorderColor:colorref];
    [self.view addSubview:listUv];
    [listUv release];
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    
    UIImageView* alertIv = [[UIImageView alloc] initWithFrame:CGRectMake(75, 80, 25, 25)];
    alertIv.center = CGPointMake(70, listUv.center.y);
    alertIv.image = [UIImage imageNamed:@"zy_faxian.png"];
    [self.view addSubview:alertIv];
    [alertIv release];
    
    UILabel* noConnLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 19, 180, 25)];
    [noConnLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
    noConnLabel.text = @"您的电视未获得ROOT权限";
    noConnLabel.textColor = [UIColor whiteColor];
    noConnLabel.center = CGPointMake(175, listUv.center.y);
    [self.view addSubview:noConnLabel];
    [noConnLabel release];
    
    UILabel* connLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 180, 250, 40)];
    connLabel.textColor = blueColor;
    connLabel.text = @"操作该游戏需ROOT权限支持";
    [connLabel setFont:[UIFont fontWithName:@"Courier New" size:20]];
    [self.view addSubview:connLabel];
    [connLabel release];
    
    UIImageView* noConnectIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"root_tv.png"]];
    noConnectIv.frame = CGRectMake(70, 230, 200, 150);
    //    noConnLabel.center = self.view.center;
    [self.view addSubview:noConnectIv];
    [noConnectIv release];
    
    UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 400, 200, 60)];
    [hintLabel setFont:[UIFont fontWithName:@"Courier New" size:16]];
    hintLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
    [hintLabel setNumberOfLines:2];
    hintLabel.text = @"您的电视未获得ROOT权限， 请先获取ROOT权限后继续";
    [self.view addSubview:hintLabel];
    [hintLabel release];
    
    UIImageView* btnFrame = [[UIImageView alloc] initWithFrame:CGRectMake(40 , 486, 240, 40)];
    //    [btnFrame setBackgroundColor:blueColor];
    [btnFrame.layer setBorderWidth:1.0];
    [btnFrame.layer setCornerRadius:4.0];
    //    btnFrame.center = CGPointMake(self.view.center.x, 106);
    [btnFrame.layer setBorderColor:[greenColor CGColor]];
    [self.view addSubview:btnFrame];
    [btnFrame release];
    UIButton* helpRootBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpRootBtn addTarget:self action:@selector(pressHelpRootBtn) forControlEvents:UIControlEventTouchUpInside];
    [helpRootBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [helpRootBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    helpRootBtn.frame = CGRectMake(100 , 500, 200, 30);
    [helpRootBtn setTitle:@"查看ROOT权限帮助" forState:UIControlStateNormal] ;
    helpRootBtn.center = btnFrame.center;
    [self.view addSubview:helpRootBtn];
}
- (void) pressHelpRootBtn
{
    HelpRootViewController* helpVc = [[HelpRootViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:helpVc animated:YES];
    [helpVc release];
}



- (void) goBack
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [super dealloc];
}
@end

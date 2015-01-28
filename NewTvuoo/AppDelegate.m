//
//  AppDelegate.m
//  NewTvuoo
//
//  Created by xubo on 9/4 星期四.
//  Copyright (c) 2014年 wap3. All rights reserved.
//
#import <objc/message.h>
#import "AppDelegate.h"
#import "DEFINE.h"
#import "Singleton.h"
#import "ParseJson.h"
#import "NoWIFIViewController.h"
//通讯模块
#import "domain/MyJniTransport.h"
#import "AllUrl.h"
#import "MobClick.h"            //增加友盟统计
#import "UMFeedback.h"          //增加友盟反馈

static int myClock = 0;

@implementation AppDelegate
@synthesize window;
@synthesize navController;

-(int)topMessage
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
        {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
        //0 - 无网络; 1 - 2G; 2 - 3G; 3 - 4G; 5 - WIFI
    }
    return type;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    startJni();         //  通讯开始
    [self initData];
    
    [MobClick startWithAppkey:@"53d7015d56240b939406556c"];
    [UMFeedback setAppkey:@"53d7015d56240b939406556c"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];   //禁用自动休眠定时器
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    SplashView* splashView = [[[SplashView alloc] initWithNibName:nil bundle:nil] autorelease];
    splashView.view.alpha = 0;
    sleep(5);
    LordViewController* lordViewController = [[[LordViewController alloc] initWithNibName:@"LordViewController" bundle:nil] autorelease];
    ViewControllerOrientation* viewControllerOrientation = nil;
    
    
    NSLog(@"是否显示手机游戏%d",[[AllUrl getInstance] tvu_showgame_switch]);
    if([self topMessage] == 5)
    {
        viewControllerOrientation = [[ViewControllerOrientation alloc] initWithRootViewController:lordViewController];
        viewControllerOrientation.navigationBarHidden = YES;
        
        [Singleton getSingle].viewController = lordViewController;
        //            [splashView.navigationController pushViewController:lordViewController animated:YES];
        
        [viewControllerOrientation.navigationController pushViewController:lordViewController animated:YES];
    }
    else
    {
        //非wifi网络
        NoWIFIViewController* noWifi = [[NoWIFIViewController alloc] initWithNibName:@"NoWIFIViewController" bundle:nil];
        viewControllerOrientation = [[ViewControllerOrientation alloc] initWithRootViewController:noWifi];
        viewControllerOrientation.navigationBarHidden = YES;
        [viewControllerOrientation.navigationController pushViewController:noWifi animated:YES];
        [noWifi release];
    }
    
    /*
    [UIView animateWithDuration:3.0f animations:^{
        CATransform3D transform = CATransform3DMakeRotation(0,0,0,0);
        splashView.view.layer.transform = transform;
        splashView.view.alpha = 1;
    } completion:^(BOOL finished) {
        if([self topMessage] == 5)
        {
            LordViewController* lordViewController = [[[LordViewController alloc] initWithNibName:@"LordViewController" bundle:nil] autorelease];
            [Singleton getSingle].viewController = lordViewController;
//            [splashView.navigationController pushViewController:lordViewController animated:YES];
            [viewControllerOrientation.navigationController pushViewController:lordViewController animated:YES];
        }
        else
        {
            //非wifi网络
            NoWIFIViewController* noWifi = [[NoWIFIViewController alloc] initWithNibName:@"NoWIFIViewController" bundle:nil];
            [splashView.navigationController pushViewController:noWifi animated:YES];
            [noWifi release];
        }
    }];
     */
//    [self getUrlAndUpdate];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = viewControllerOrientation;
    [self.window makeKeyAndVisible];
    [self.window release];
    [viewControllerOrientation release];
    
    [self startWatchingNetworkStatus];
    return YES;
}

- (void) getUrlAndUpdate
{
    AllUrl* allUrl = [AllUrl getInstance];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableString* updateUrl = [[NSMutableString alloc] initWithString:[allUrl updatedUrl]];
        [updateUrl appendString:@"?cid="];
        [updateUrl appendString:[NSString stringWithFormat:@"%d", 9527]];
        [updateUrl appendString:@"&pkg="];
        NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
        [updateUrl appendString:bundleId];
        [updateUrl appendString:@"&vcode="];
        NSString* vcodeStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [updateUrl appendString:vcodeStr];
        [updateUrl appendString:@"&plat="];
        [updateUrl appendString:[NSString stringWithFormat:@"%d",4]];
        NSLog(@"updateUrl-----:%@", updateUrl);
        [Singleton getSingle].updateInfo  = [ParseJson createUpdateInfoFromJson:updateUrl];
        if(single.viewController != nil)
        {
            [single.viewController performSelectorOnMainThread:@selector(updateHint) withObject:nil waitUntilDone:YES];
        }
        [updateUrl release];
    });
}

#pragma mark Network Watching
- (void)startWatchingNetworkStatus {
    //监测网络状况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    [_reach startNotifier];
    _status = ReachableViaWiFi;
}

- (void)reachabilityChanged:(NSNotification* )note {
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    //检测站点的网络连接状态
    NetworkStatus curStatus = [curReach currentReachabilityStatus];
    if (curStatus != _status) {
        NSString *str = nil;
        
        //根据不同的网络状态，UI或者程序中关于数据的下载需要做出相应的调整，自己实现
        switch (curStatus) {
            case NotReachable:
            {
                str = @"网络不可用";
                if([Singleton getSingle].viewController == nil)
                    return;
                [self noWifi];
                break;
            }
            case ReachableViaWiFi:
                str = @"wifi网络可用";
                [self noWifi];
                break;
            case ReachableViaWWAN:
                str = @"3G/GPRS网络可用";
                [self noWifi];
                break;
                
            default:
                str = @"未知网络";
                [self noWifi];
                break;
        }
        NSLog(@"%@", str);
    }
    
    _status = curStatus;
}

- (void) noWifi
{
    UIAlertView* noNet = [[UIAlertView alloc] initWithTitle:@"网络已经断开" message:@"是否关闭程序" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关闭", nil];
    [self.window addSubview:noNet];
    [noNet show];
    
    [Singleton getSingle].conn_statue = 0;
    [[Singleton getSingle].tvArray removeAllObjects];
    [[Singleton getSingle].sdkArray removeAllObjects];
    [(LordViewController*)([Singleton getSingle].viewController) updateAvalibleTv];
    [noNet release];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        return;
    }
    if(buttonIndex == 1)
    {
        exit(0);
    }
}


- (void) initData
{
    //闪屏的同时，另起线程进行部分数据的初始化
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        single = [Singleton getSingle];
        single = [Singleton getSingle];
        if(iPhone5)
        {
            single.width_rate = 320.0/720.0;
            single.height_rate = 558.0/1280.0;
        }
        if(iPhone4)
        {
            single.width_rate = 320.0/720.0;
            single.height_rate = 480.0/1280.0;
        }
        if(iPhone6)
        {
            single.width_rate = 375.0/720.0;
            single.height_rate = 667/720.0;
        }
    });
    AllUrl* allUrl = [AllUrl getInstance];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableString* updateUrl = [[NSMutableString alloc] initWithString:[allUrl updatedUrl]];
        [updateUrl appendString:@"?cid="];
        [updateUrl appendString:[NSString stringWithFormat:@"%d", 9527]];
        [updateUrl appendString:@"&pkg="];
        NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
        [updateUrl appendString:bundleId];
        [updateUrl appendString:@"&vcode="];
        NSString* vcodeStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [updateUrl appendString:vcodeStr];
        [updateUrl appendString:@"&plat="];
        [updateUrl appendString:[NSString stringWithFormat:@"%d",4]];
        NSLog(@"updateUrl-----:%@", updateUrl);
        [Singleton getSingle].updateInfo  = [ParseJson createUpdateInfoFromJson:updateUrl];
        [updateUrl release];
    });
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"appliactionWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    [[Singleton getSingle] release];
    NSLog(@"applicationDidEnterBackground");
    UIApplication* app = [UIApplication sharedApplication];
    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        exit(0);
    }];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)timerHandler
{
    NSLog(@"myclllll %d", myClock);
    if(myClock == 300)
    {
        NSLog(@"退出程序");
        [[UIApplication sharedApplication] endBackgroundTask:_bgTask];
        _bgTask = UIBackgroundTaskInvalid;
        exit(0);
    }
    myClock++;
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    NSLog(@"applicationWillEnterForeground");
    myClock = 0;
    [_timer invalidate];
    NSLog(@"取消定时器");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
//    _bgTask
//    application beginBackgroundTaskWithExpirationHandler:<#^(void)handler#>
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"应用间通信");
    return YES;
}

@end

//闪屏view
@implementation SplashView

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    UIImageView* tvuoo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 290)];
    tvuoo.image = [UIImage imageNamed:@"shanping1.png"];
    tvuoo.center = CGPointMake(self.view.center.x, 180);
    [self.view addSubview:tvuoo];
    [tvuoo release];
    
    UIImageView* newIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 35)];
    newIv.image = [UIImage imageNamed:@"shanping2.png"];
    newIv.center = CGPointMake(self.view.center.x, 450);
    [self.view addSubview:newIv];
    [newIv release];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    label.text = @"©2014 TVUOO";
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(self.view.center.x, 510);
    [self.view addSubview:label];
    [label release];

}
- (void) dealloc
{
    [super dealloc];
}

@end

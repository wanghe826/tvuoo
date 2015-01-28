//
//  AppDelegate.h
//  NewTvuoo
//
//  Created by xubo on 9/4 星期四.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LordViewController.h"
#import "ViewControllerOrientation.h"
#import "Singleton.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    Singleton* single;
    __block UIBackgroundTaskIdentifier _bgTask;
    NSTimer* _timer;
    NSTimer* _hintTimer;
    //监听网络
    Reachability *_reach;
    NetworkStatus _status;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* navController;

@end

@interface SplashView : UIViewController

@end

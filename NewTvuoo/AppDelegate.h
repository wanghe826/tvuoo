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


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Singleton* single;
    __block UIBackgroundTaskIdentifier _bgTask;
    NSTimer* _timer;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* navController;

@end

@interface SplashView : UIViewController

@end

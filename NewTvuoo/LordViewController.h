//
//  LordViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/4 星期四.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayTvGameViewController.h"
#import "RemoteControlViewController.h"
#import "MouseControlViewController.h"
#import "HotGameViewController.h"
#import "CallBack.h"
#import "QuickConnViewController.h"
#import "Singleton.h"
#import "TvAppCenterViewController.h"
#import "MBProgressHUD.h"
@class MyAlertView;
@protocol MyAlertViewDelegate <NSObject>
- (void) actSdkGame;
- (void) cancelSdkGame;
@end


@interface LordViewController : UIViewController<CallBack,UIAlertViewDelegate,MBProgressHUDDelegate,MyAlertViewDelegate>
{
    CGFloat w_rate;
    CGFloat h_rate;
    UIButton* _searchBtn;
    TvInfo* _sdkGameTvInfo;
    MBProgressHUD* _startSdk;
    NSTimer* _connectTvTimer;
    
    NSTimer* _updateDeviceTimer;
    UIAlertView* _upgradeAlertView;
}

- (void) pressBtn: (id)sender;

@property (nonatomic, retain) Singleton* single;
@property (nonatomic, retain) UIImageView* hintIv;
@property (nonatomic,retain) QuickConnViewController* connVC;
@property (nonatomic, retain) UIImageView* connIV;
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic, retain) UILabel* nLabel;
@property (nonatomic, retain) UILabel* schLabel;
@property (nonatomic, retain) NSMutableArray* tvArray;
@property (nonatomic, retain) NSMutableArray* sdkArray;
@property (nonatomic, retain) UILabel* searchLabel;
@property (nonatomic, retain) UIButton* searchBtn;
@property (nonatomic, assign) CGFloat w_rate;
@property (nonatomic, assign) CGFloat h_rate;
@end




//
//  RemoteControlViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "MouseControlViewController.h"
#import "CusMouseViewController.h"
#import "CallBack.h"
@interface RemoteControlViewController : UIViewController<CallBack>
{
    BOOL _btnFlag;
}

- (void)pressMute;
- (void)pressLowerVoice;
- (void)pressUpperVoice;
- (void)pressShutdown;

- (void)pressLord;
- (void)pressReturn;
- (void)pressMenu;
@property (nonatomic, retain) Singleton* single;
@property (nonatomic, retain) UIButton* simpleRemote;
@property (nonatomic, retain) UILabel* simpleLabel;
@property (nonatomic, retain) UIButton* gestureRemote;
@property (nonatomic, retain) UILabel* gestureLabel;
@property (nonatomic, retain) UIImageView* controlView;

@property (nonatomic, retain) UILabel* mouseLabel;
@property (nonatomic, retain) UILabel* menuLabel;
@property (nonatomic, retain) UILabel* lordLabel;

@end

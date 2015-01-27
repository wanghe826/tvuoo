//
//  MouseControlViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "domain/MyJniTransport.h"
#include "domain/package/MultiTouchPkg.h"
#include <iostream>
#import "SettingView.h"
#import <CoreMotion/CoreMotion.h>
#import "CallBack.h"
#import "EGOImageLoader/EGOImageView.h"

#define greyColor [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1]
#define greenColor [UIColor colorWithRed:107.0/255.0 green:200.0/255.0 blue:16.0/255.0 alpha:1]


@protocol LoadFailedDelegate <NSObject>
@required
- (void) tryBtnPressed;
- (void) exitBtnPressed;

- (void) leftBtnPressed;
- (void) rightBtnPressed;
@end

@interface ADView : UIView
@property (retain, nonatomic) id<LoadFailedDelegate> delegate;
@end

@class GestureView;
@class LoadFailed;
@class LoadingView;
@class TouchMess;
@class NSTvuPoint;

@interface MouseControlViewController : UIViewController<UIGestureRecognizerDelegate,ExitHandle,UIAlertViewDelegate,LoadFailedDelegate, CallBack>
{
    int _avalibaleTouchNum ;
    
    CMMotionManager* _motionManager;
    
    //正在载入资源
    LoadingView* _loadingView;
    
    LoadFailed* _loadFailed;
    
    TvuPoint* _pointArray[5];
    UITouch* _touchArray[5];
    
    EGOImageView* _backgroundImage;
    
    UIImageView* _uv1;
    UIButton* _huituiBtn;
    UILabel* _huituiLabel;
    
    UIButton* _uv2;
    UIButton* _xuanzhongBtn;
    UILabel* _xuanzhongLabel;
    
    UIImageView* _uv3;
    
    UIButton* _dbHuituiBtn;
    UILabel* _dbHuituiLabel;
    
    BOOL _btnFlag;              //控制单双击模式， 1 传统， 2 双击  3
    BOOL _btn2Flag;
    BOOL _btn3Flag;                 //_btn3Flag 控制重力的开关
    BOOL _gesFlag;                  //_gesFlag  控制手势的开关
    
    UIImageView* _uvGes;
    UIButton* _gesBtnOn;
    UIButton* _gesBtnOff;
    
    UIImageView* _moshiIV;
    
    UIImageView* _frameUV;
    
    NSMutableArray* _androidGameBtnArray;
    
    vector<TvuPoint*> _tvuPointVector;
    int _touchAction;
    
    
    UIActivityIndicatorView* _activityView;
    
    //手势开关
    UIImageView* _gesFrame;
    UIButton* _gesBtn;
    
    GestureView* _gesView;
    
    NSArray* _rockerArray;
    
    NSMutableArray* _rockerImageArray;          //存储摇杆图片数组
    CGPoint _yaoganCenter;
    CGRect _yaoganRange;
    
    NSMutableArray* _touchMessArray;
    
    
    BOOL _isMutilplePoint;
    NSMutableArray* _mutilPointArray;
    NSUInteger _numOfPoint;
}

@property (retain, nonatomic) NSArray* keyBeanArray;

@property (retain, nonatomic) Singleton* single;
@property float h_rate;
@property float w_rate;
@property (retain, nonatomic) UIImageView* mouseIV;
@property (retain, nonatomic) UILabel* moshiLabel;
@property (retain, nonatomic) UIButton* customBtn;
@property (retain, nonatomic) UIButton* doubleClickBtn;

@property (retain, nonatomic) UIButton* mouseOpBtn;
@property (retain, nonatomic) UIImageView* mouseIvOnBtn;
@property (retain, nonatomic) UIButton* gameOpBtn;
@property (retain, nonatomic) UIImageView* gameIvOnBtn;

@property (retain, nonatomic) GameInfo* currentGameInfo;
@end





@interface LoadFailed: UIView<LoadFailedDelegate>
{
    UIButton* _tryBtn;
    UIButton* _exitBtn;
}
@property (retain, nonatomic) id<LoadFailedDelegate> delegate;
@end

@interface GestureView : UIView
{
    TvuPoint* _pointArray[5];
    NSMutableArray* _mutilPoint;
}
@end

@interface LoadingView : UIView
{
    UIImageView* _activityView;
    NSTimer* _timer;
}

@end





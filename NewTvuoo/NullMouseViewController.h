//
//  NullMouseViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/9 星期二.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "MouseControlViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "CallBack.h"
@interface NullMouseViewController : UIViewController<CallBack>
{
    CMMotionManager* _motionManager;
    float _x;
    float _y;
    float _z;
}
@property (retain, nonatomic) Singleton* single;
@property (retain, nonatomic) UILabel* mouseLabel;
@property (retain, nonatomic) UILabel* menuLabel;
@property (retain, nonatomic) UILabel* lordLabel;
@end
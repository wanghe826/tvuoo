//
//  CusMouseViewController.h
//  NewTvuoo
//
//  Created by wanghe on 14-10-14.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "CallBack.h"
@interface CusMouseViewController : UIViewController<CallBack>

@property (retain, nonatomic) Singleton* single;
@property float h_rate;
@property float w_rate;
@property (retain, nonatomic) UIImageView* mouseIV;
@property (retain, nonatomic) UIImageView* mouseIV2;
@property (retain, nonatomic) UILabel* moshiLabel;
@property (retain, nonatomic) UIButton* customBtn;
@property (retain, nonatomic) UIButton* doubleClickBtn;

@property (retain, nonatomic) UIButton* mouseOpBtn;
@property (retain, nonatomic) UIImageView* mouseIvOnBtn;
@property (retain, nonatomic) UIButton* gameOpBtn;
@property (retain, nonatomic) UIImageView* gameIvOnBtn;

@property (retain, nonatomic) UIImageView* doubleClickIv;
@property (retain, nonatomic) UIImageView* doubleClickIv2;
@property (retain, nonatomic) UILabel* doubleClickLabel;
@property (retain, nonatomic) UIButton* doubleClickHuituiBtn;
@property BOOL isDoubleClick;
@end

//
//  HongbaijiViewController.h
//  NewTvuoo
//
//  Created by xubo on 10/20 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "domain/MyJniTransport.h"
#import "Singleton.h"
#import "CommonBtn.h"
#import "SettingView.h"
#import "CallBack.h"

@interface HongbaijiViewController : UIViewController<ExitHandle, CallBack>
{
    Singleton* _single;
    NSMutableArray* _viewArray;         //touchesBegan时的view
    NSMutableArray* _touchArray;        //uitouch的array
}

@property (retain, nonatomic) UIButton* player1;
@property (retain, nonatomic) UIButton* player2;
@property (nonatomic) BOOL btnFlag;

@property (retain, nonatomic) IBOutlet MyImageView *leftUp;
@property (retain, nonatomic) IBOutlet MyImageView *up;
@property (retain, nonatomic) IBOutlet MyImageView *rightUp;
@property (retain, nonatomic) IBOutlet MyImageView *left;
@property (retain, nonatomic) IBOutlet MyImageView *right;
@property (retain, nonatomic) IBOutlet MyImageView *leftDown;
@property (retain, nonatomic) IBOutlet MyImageView *down;
@property (retain, nonatomic) IBOutlet MyImageView *rightDown;

@property (retain, nonatomic) IBOutlet MyImageView *upYuan;
@property (retain, nonatomic) IBOutlet MyImageView *downYuan;
@property (retain, nonatomic) IBOutlet MyImageView *leftYuan;
@property (retain, nonatomic) IBOutlet MyImageView *rightYuan;

@property (retain, nonatomic) IBOutlet UILabel *y;
@property (retain, nonatomic) IBOutlet UILabel *a;
@property (retain, nonatomic) IBOutlet UILabel *x;
@property (retain, nonatomic) IBOutlet UILabel *b;

@property (assign, nonatomic) int gameParam; //红白机四个方向还是8方向

@end

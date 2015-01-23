//
//  JiejiViewController.h
//  NewTvuoo
//
//  Created by xubo on 10/16 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "CommonBtn.h"
#import "SettingView.h"
#import "CallBack.h"
@interface JiejiViewController : UIViewController<ExitHandle,CallBack>
{
    BOOL _leftUpFlag, _upFlag, _rightUpFlag, _leftFlag, _rightFlag, _leftDownFlag, _downFlag, _rightDownFlag;
    
    MyImageView* _upYuan, *_downYuan, *_leftYuan, *_rightYuan;
    
    CGRect _leftUp;
    CGRect _up;
    CGRect _rightUp;
    CGRect _left;
    CGRect _right;
    CGRect _leftBottom;
    CGRect _bottom;
    CGRect _rightBottom;
    Singleton* _single;
}

@property BOOL btnFlag; 
@property (retain, nonatomic) UIButton* player1;
@property (retain, nonatomic) UIButton* player2;
@property (retain, nonatomic) UIImageView* yaoganIv;
@property (retain, nonatomic) UIImageView* yuanImageView;
@end

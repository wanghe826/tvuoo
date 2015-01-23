//
//  PSPViewController.h
//  NewTvuoo
//
//  Created by xubo on 10/20 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonBtn.h"
#import "SettingView.h"
#import "CallBack.h"
@class PSPView;
@interface PSPViewController : UIViewController<ExitHandle, CallBack>
{
    MyImageView* _leftUp;
    MyImageView* _up;
    MyImageView* _rightUp;
    MyImageView* _left;
    UIImageView* _center;
    MyImageView* _right;
    MyImageView* _leftDown;
    MyImageView* _down;
    MyImageView* _rightDown;
    
    CGPoint _yaoganCenterPoint;
    CGRect _avalibleRange;
    
    CGPoint _moveToPoint;
    
    BOOL _upFlag;
    BOOL _leftFlag;
    BOOL _rightFlag;
    BOOL _downFlag;
}

@property (retain, nonatomic) IBOutlet UIImageView *yaogan;
- (IBAction)pressStartBtn:(id)sender;
- (IBAction)pressSelectBtn:(id)sender;
- (IBAction)pressBtn:(id)sender;

@property (retain, nonatomic) PSPView *yuanUp;
@property (retain, nonatomic) PSPView *yuanLeft;
@property (retain, nonatomic) PSPView *yuanRight;
@property (retain, nonatomic) PSPView *chacha;

@end


@interface PSPView : UIImageView
@property (retain, nonatomic) UIImageView* centView;
@property (retain, nonatomic) UIImage* downImage;
@property (retain, nonatomic) UIImage* upImage;
@property (assign, nonatomic) int keyCode;
@property (assign, nonatomic) BOOL flag;        //YES 按下    NO 抬起
@end

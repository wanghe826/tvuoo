//
//  KeyPadViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/9 星期二.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonBtn.h"
#import "Singleton.h"
#import "CallBack.h"
@interface KeyPadViewController : UIViewController<CallBack>
{
    Singleton* _single;
    
    UIButton* _vKeyPadBtn;
    UIView* _vKeyPadIv;
    UILabel* _vKeyPadLabel;
    
    UIButton* _hKeyPadBtn;
    UIView* _hKeyPadIv;
    UILabel* _hKeyPadLabel;
    
    BOOL _btnFlag;
    
    KeyBtn *_btnA, *_btnB, *_btnC, *_btnD, *_btnE, *_btnF, *_btnG, *_btnH, *_btnI, *_btnJ, *_btnK, *_btnL, *_btnM, *_btnN, *_btnO, *_btnP, *_btnQ, *_btnR, *_btnS, *_btnT, *_btnU, *_btnV, *_btnW, *_btnX, *_btnY, *_btnZ;
    
    UIButton* _keyBtn123;
    UILabel* _label123;
    UIButton* _keyBtnDelete;
    UILabel* _labelDelete;
    
    UIButton* _upBtn;
    UIButton* _spaceBtn;
    
    BOOL _flag;
    
    
    KeyBtn* _btn1;
    KeyBtn* _btn2;
    KeyBtn* _btn3;
    KeyBtn* _btn4;
    KeyBtn* _btn5;
    KeyBtn* _btn6;
    KeyBtn* _btn7;
    KeyBtn* _btn8;
    KeyBtn* _btn9;
    KeyBtn* _btn0;
    KeyBtn* _btn01;
    KeyBtn* _btn02;
}
- (void)goBack;

@property (retain, nonatomic) UIImageView* controlView;

@end

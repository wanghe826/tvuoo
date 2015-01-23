//
//  ClearMemoryViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/22 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "CallBack.h"

@interface ClearMemoryViewController : UIViewController<CallBack>
{
    Singleton* _single;
    UIImageView* _circleIv;
    UILabel* _numberLabel;
    UILabel* _numberLabel2;
    UILabel* _alreadyMemoLabel;
    UIButton* _quickClearBtn;
    UIImageView* _lineIv;
    
    UIImageView* _btnFrame;
    
    UIImageView* _saobaIv;
}

@property (assign, atomic) BOOL btnFlag;
@end

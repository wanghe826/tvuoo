//
//  GameIntroViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallBack.h"
#import "EGOImageLoader/EGOImageView.h"

@interface GameIntroViewController : UIViewController<CallBack,UIAlertViewDelegate>
{
    BOOL _haveInstalled;
    UIButton* _btn1;
}

@property (retain, nonatomic) UILabel* gameName;
@property (retain, nonatomic) UILabel* gameType;
@property (retain, nonatomic) UILabel* gameCapa;
@property (retain, nonatomic) UIScrollView* gameDescription;
@property (retain, nonatomic) EGOImageView* gameImage;
@property (retain, nonatomic) GameInfo* gameInfo;
@property (retain, nonatomic) UITextView *gameTextView;
@end

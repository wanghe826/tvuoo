//
//  TvAppCenterViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/22 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageLoader/EGOImageView.h"
#import "CallBack.h"
#import "QuickConnViewController.h"

@interface TvAppCenterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,CallBack>

@property (nonatomic, retain) QuickConnViewController* quickConn;
@property (nonatomic, retain) UITableView* gameList;
@property (nonatomic) BOOL btnFlag;
@property (nonatomic) int flag;
@property (nonatomic, retain) NSMutableArray* array1;  //精选新品
@property (nonatomic, retain) NSMutableArray* array2;  //电视必装

@property (nonatomic, retain) UIButton* jingxuanBtn;
@property (nonatomic, retain) UILabel* jingxuanLabel;
@property (nonatomic, retain) UIImageView* jingxuanIv;

@property (nonatomic, retain) UIButton* bizhuangBtn;
@property (nonatomic, retain) UILabel* bizhuangLabel;
@property (nonatomic, retain) UIImageView* bizhuangIv;

@property (nonatomic, retain) UILabel* failedLabel;
@property (nonatomic, retain) UIImageView* failedIv;
@property (nonatomic, retain) UIImageView* listUv;
@property (nonatomic, retain) UIButton* reloadBtn;

@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;

@property (nonatomic, retain) UIButton* btn1;
@property (nonatomic, retain) UILabel* label1;
@property (nonatomic, retain) UIButton* btn2;
@property (nonatomic, retain) UILabel* label2;
@end




@interface AppIntroViewController : UIViewController<CallBack>

@property (retain, nonatomic) UILabel* gameName;
@property (retain, nonatomic) UILabel* gameType;
@property (retain, nonatomic) UILabel* gameCapa;
@property (retain, nonatomic) UIScrollView* gameDescription;
@property (retain, nonatomic) EGOImageView* gameImage;
@property (retain, nonatomic) GameInfo* gameInfo;
@property (retain, nonatomic) UITextView *gameTextView;
@end
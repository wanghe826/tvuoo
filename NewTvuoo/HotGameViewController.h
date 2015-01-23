//
//  HotGameViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/15 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchGameViewController.h"
#import "EGOImageView.h"
#import "CallBack.h"
#import "FootView.h"
#define kNameValueTag 1
#define kColorValueTag 2
#define HOT 1
#define NEW 2
#define CATE 3
@interface HotGameViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,CallBack>
{
    SearchGameViewController* searchGameViewController;
    FootView* _footView;
//    dispatch_group_t _group;
    dispatch_queue_t _queue;
}

@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;
@property (nonatomic, retain) UITableView* gameList;
@property (nonatomic) int flag;

@property (nonatomic, retain) SearchGameViewController* searchGameViewController;
//三个列表的数据源
@property (nonatomic, retain) NSMutableArray* hotGameArray;
@property (nonatomic, retain) NSMutableArray* niceGameArray;
@property (nonatomic, retain) NSMutableArray* cateGameArray;
@property (nonatomic, retain) id<CallBack> passValueDelegate;

//获取数据失败页面的控件
@property (nonatomic, retain) UIImageView* failedIv;
@property (nonatomic, retain) UILabel* failedLabel;
@property (nonatomic, retain) UIImageView* listUv;
@property (nonatomic, retain) UIButton* reloadBtn;


//顶部五个按钮的监听
- (void)goBack;
- (void)pressSearch;
- (void)pressHot;
- (void)pressNew;
- (void)pressCatogary;

//底部三个按钮的监听
- (void)pressMyGame;
- (void)pressVirtualHandle;
- (void)pressTvHome;

@property (retain, nonatomic) UIButton* hotBtn;
@property (retain, nonatomic) UIImageView* hotIv;
@property (retain, nonatomic) UILabel* hotLabel;

@property (retain, nonatomic) UIButton* niceBtn;
@property (retain, nonatomic) UIImageView* niceIv;
@property (retain, nonatomic) UILabel* niceLabel;

@property (retain, nonatomic) UIButton* cateBtn;
@property (retain, nonatomic) UIImageView* cateIv;
@property (retain, nonatomic) UILabel* cateLabel;

@property (retain, nonatomic) UIImageView* tvHomeIv;
@property (retain, nonatomic) UILabel* tvHomeLabel;
@property (retain, nonatomic) UIImageView* myGameIv;
@property (retain, nonatomic) UILabel* myGameLabel;

@property (assign, atomic) int hotPageNum;
@property (assign, atomic) int nicePageNum;
@property (assign, atomic) int catePageNum;

@end
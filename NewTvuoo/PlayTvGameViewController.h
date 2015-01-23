//
//  PlayTvGameViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchGameViewController.h"
#import "EGOImageView.h"
#import "CallBack.h"
#import "FootView.h"
#import "EGOCache.h"
#import "MyGameVc.h"
#define kNameValueTag 1
#define kColorValueTag 2
#define HOT 1
#define NEW 2
#define CATE 3
@interface PlayTvGameViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,CallBack>
{
    SearchGameViewController* _searchGameViewController;
    FootView* footView;
    NSMutableString* _hotGameUrl;
    NSMutableString* _newGameUrl;
    NSMutableString* _categoryUrl;
    
    //获取数据失败页面的控件
    UIImageView* _failedIv;
    UILabel* _failedLabel;
    UIImageView* _listUv;
    UIButton* _reloadBtn;
    
    MyGameVc* _myGame;
}


@property (nonatomic, assign) int hotPageNum;
@property (nonatomic, assign) int nicePageNum;
@property (nonatomic, assign) int catePageNum;

@property (nonatomic) BOOL touchFlag;
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;
@property (nonatomic, retain) UITableView* gameList;
@property (atomic, assign) int flag;
//@property (atomic, retain) NSNumber* flag;

//@property (nonatomic, retain) SearchGameViewController* searchGameViewController;
//三个列表的数据源
@property (nonatomic, retain) NSMutableArray* hotGameArray;
@property (nonatomic, retain) NSMutableArray* niceGameArray;
@property (nonatomic, retain) NSMutableArray* cateGameArray;
@property (nonatomic, retain) id<CallBack> passValueDelegate;



- (void) addTitleLabel;
- (void) addSearchBtn;

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

- (void) addBottomBtn;
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

@property (retain, nonatomic) NSMutableArray* hotImgArray;
@property (retain, nonatomic) NSMutableArray* niceImgArray;
@property (retain, nonatomic) NSMutableArray* cateImgArray;


- (void) connSuccRemoveSomeView;
- (void) fetchDataIng;

@end

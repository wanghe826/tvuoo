//
//  QucikConnViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/17 Wednesday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallBack.h"
#define DEV_TABLEVIEW 1
#define VIR_TABLEVIEW 0
@interface QuickConnViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,CallBack,UIAlertViewDelegate>
{
    NSMutableArray* _tvArray;
    int current_ip;
    int current_port;
    BOOL conn_statue;
    BOOL _btnFlag;
    NSTimer* _timer;
    NSTimer* _avalibleTvTimer;
    
    BOOL _hasTvFlag;
    BOOL _hasSdkFlag;
    
    UIImageView* _dimBackview;
}
@property int tableViewFlag ;
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic) int angle;
@property (nonatomic) BOOL conn_statue;
@property (assign, nonatomic) int current_ip;
@property (assign, nonatomic) int current_port;
@property (nonatomic, retain) UIImageView* animaUv;

//两个列表的数据源
//@property (nonatomic, retain) NSMutableArray* tvArray;
//@property (nonatomic, retain) NSMutableArray* sdkArray;


@property (nonatomic, retain) UITableView* avalibaleDev;
@property (nonatomic, retain) UITableView* virtualHandle;

@property (nonatomic, retain) UIButton* devBtn;
@property (nonatomic, retain) UIButton* virHanBtn;
@property (nonatomic, retain) UIButton* connOrBreakBtn;
@property (nonatomic, retain) UILabel* devLabel;
@property (nonatomic, retain) UIImageView* devView;
@property (nonatomic, retain) UIImageView* handView;
@property (nonatomic, retain) UILabel* handLabel;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator2;

@property (nonatomic, retain) UILabel* searchingLabel;
@property (nonatomic, retain) UIImageView* lineIv;
@property (nonatomic, retain) UILabel* hintLabel1;
@property (nonatomic, retain) UILabel* hintLabel2;

@end

//
//  CateGameViewController.h
//  NewTvuoo
//
//  Created by xubo on 10/22 Wednesday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FootView.h"
#import "CallBack.h"
@interface CateGameViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,CallBack>
{
    FootView* footView;
    UIActivityIndicatorView* _activityView;
    
    UIImageView* _failedIv;
    UILabel* _failedLabel;
    UIImageView* _listUv;
    UIButton* _reloadBtn;
    
}
@property (nonatomic, retain) NSString* titleName;
@property (nonatomic, retain) NSMutableString* jsonString;
@property (nonatomic, retain) UITableView* gameList;
@property (nonatomic, retain) NSMutableArray* array;  //数据源

@property (nonatomic, assign) int pageNum;

@property (nonatomic, retain) NSMutableArray* imageArray;   //图片缓存

@property (nonatomic, assign) BOOL scrollFlag;              //拉取开关

@end

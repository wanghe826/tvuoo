//
//  SearchGameViewController.h
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallBack.h"

@interface SearchGameViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CallBack>
{
    BOOL _btnFlag;
    
    UISearchBar* _schTextField;
    UITextField* _schField;
    
    UITableView* _tableView;
    NSMutableArray* _tableArray;
}

- (IBAction)goBack:(id)sender;
- (IBAction)pressSearch:(id)sender;
- (IBAction)closeKeyPad:(id)sender;
@property (retain, nonatomic) IBOutlet UISearchBar *schTextField;

@property (retain, nonatomic) UIImageView* hintIv;
@property (retain, nonatomic) UILabel* hintLabel;
@property (retain, nonatomic) UITableView* tableView;
@property (retain, nonatomic) NSMutableArray* array;
@property (retain, nonatomic) UILabel* topLabel;
@property (retain, nonatomic) UIActivityIndicatorView* activityIndicatorView;
@property (retain, nonatomic) UILabel* schLabel;
@property (retain, nonatomic) UIImageView* noGameIv;
@property (retain, nonatomic) NSArray* sourceArray;

@end

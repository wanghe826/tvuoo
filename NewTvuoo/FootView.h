//
//  FootView.h
//  NewTvuoo
//
//  Created by xubo on 10/23 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    RefreshStateLoading = 1,
    RefreshStateRelease,
    RefreshStateNormal,
}RefreshState;


@interface FootView : UIView

@property (nonatomic, strong) UIActivityIndicatorView* activity;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, assign) RefreshState state;

- (void) refreshStateLoading;
- (void) refreshStateNormal;
- (void) refreshStateRelease;
@end

//
//  UIAlertView+Completion.h
//  NewTvuoo
//
//  Created by xubo on 12/24 星期三.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TvInfo.h"

typedef void (^Completion) (TvInfo* tvInfo);

@interface UIAlertView (Completion)
@property (nonatomic, retain) TvInfo* tvInfo;
- (void) alertViewWithBlock:(Completion)block;
@end

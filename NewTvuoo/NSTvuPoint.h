//
//  NSTvuPoint.h
//  NewTvuoo
//
//  Created by xubo on 1/16 星期五.
//  Copyright (c) 2015年 wap3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonBtn.h"
#import "GameInfo.h"
@interface NSTvuPoint : NSObject
@property (nonatomic, assign) int p_id;
@property (nonatomic, assign) float p_x;
@property (nonatomic, assign) float p_y;
@property (nonatomic, retain) UITouch* current_touch;
@property (nonatomic, retain) AndroidGameButton* button;

@property (nonatomic, retain) KeyBean* keyBean;
@end

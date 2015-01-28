//
//  NSTvuPoint.m
//  NewTvuoo
//
//  Created by xubo on 1/16 星期五.
//  Copyright (c) 2015年 wap3. All rights reserved.
//

#import "NSTvuPoint.h"

@implementation NSTvuPoint
@synthesize p_id;
@synthesize p_x;
@synthesize p_y;
@synthesize current_touch;
@synthesize button;
@synthesize keyBean;
@synthesize tag;
- (id) init
{
    if(self = [super init])
    {
        self.keyBean = nil;
    }
    return self;
}

- (void) dealloc
{
    self.current_touch = nil;
    self.button = nil;
    self.keyBean = nil;
    [super dealloc];
}
@end

//
//  FootView.m
//  NewTvuoo
//
//  Created by xubo on 10/23 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "FootView.h"

@implementation FootView
@synthesize activity;
@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor orangeColor];
        
        //活动指示器初始化
        activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.color = [UIColor blueColor];
//        activity.frame = CGRectMake(10, 0, 50, 70);
        activity.frame = CGRectMake(100,-10,100,70);
        [activity startAnimating];
//        activity.center = self.center;
        [self addSubview:activity];
        
//        //信息label初始化
//        label = [[UILabel alloc]initWithFrame:CGRectMake(100,0 ,100, 70)];
//        label.text = @"上拉刷新...";
//        label.font = [UIFont fontWithName:@"Helvetica" size:20];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor blackColor];
//        [self addSubview:label];
        
        //设置初始状态
        self.state = RefreshStateNormal;
    }
    return self;
}

- (void) refreshStateNormal
{
    self.state = RefreshStateNormal;
    [self.activity stopAnimating];
    self.label.text = @"上拉加载更多";
}

- (void) refreshStateLoading
{
    self.state = RefreshStateLoading;
    [UIView beginAnimations:nil context:nil];
    self.label.text = @"正在加载";
    [self.activity startAnimating];
    [UIView commitAnimations];
}

- (void) refreshStateRelease
{
    self.state = RefreshStateRelease;
    [UIView beginAnimations:nil context:nil];
    self.label.text = @"释放后加载";
    [UIView commitAnimations];
}

@end

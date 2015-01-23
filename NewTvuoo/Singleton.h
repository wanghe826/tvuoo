//
//  Singleton.h
//  NewTvuoo
//
//  Created by xubo on 9/19 Friday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallBack.h"
#import "TvInfo.h"

@interface Singleton : NSObject
{
    CGFloat width_rate;
    CGFloat height_rate;
}
@property (nonatomic, assign) BOOL isInProtrait;
@property (nonatomic, retain) NSNumber* isVoiceOn;
@property (nonatomic, retain) NSNumber* isValidateOn;
@property (nonatomic, retain) UpdateInfo* updateInfo;
@property (nonatomic, retain) TvInfoDetail* current_tvInfo;
@property (nonatomic, retain) TvInfoDetail* current_sdkTvInfo;
@property (nonatomic, retain) TvInfo* current_tv;
@property (nonatomic, retain) TvInfo* current_sdk;
@property (nonatomic, retain) NSMutableArray* tvInfoList;

@property (nonatomic, retain) NSMutableArray* sdkInfoList;

@property (assign, nonatomic) CGFloat width_rate;
@property (assign, nonatomic) CGFloat height_rate;
@property (assign, nonatomic) int conn_statue;
//@property (atomic, retain) Switcher* switcher;

@property (nonatomic, retain) id viewController;

@property (nonatomic, retain) id<CallBack> myDelegate;
@property (nonatomic, retain) id<CallBack> myConnDelegate;
@property (nonatomic, retain) id<CallBack> mySdkConnDelegate;
@property (nonatomic, retain) id<CallBack> myFindSdkGameDelegate;
@property (nonatomic, retain) id<CallBack> myStartGameDelegate;
@property (nonatomic, retain) id<CallBack> myBreakDownDelegate;
@property (nonatomic, retain) id<CallBack> myExitGameDelegate;
@property (nonatomic, retain) id<CallBack> mySdkBreakDownDelegate;
@property (nonatomic, retain) id<CallBack> myAddTvInfoOrSdk;

@property int tag;

@property (retain, nonatomic) NSMutableArray* tvArray;
@property (retain, nonatomic) NSMutableArray* sdkArray;

@property (nonatomic, assign) int tvType;   // 1 普通电视，  2 sdk游戏

- (void) tvInfo;            // 委托
- (void) connSuc: (NSData*)data;           // 委托
+ (Singleton*) getSingle;
- (void) addTvInfo : (TvInfo*) tv;
- (void) initWithData;

@end

//
//  CallBack.h
//  NewTvuoo
//
//  Created by xubo on 9/25 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TvInfo.h"
#import "GameInfo.h"

@protocol CallBack <NSObject>               //定义协议

//- (void) tvInfoList: (NSMutableArray*)tvList;
@optional
- (void) putTvInfo: (TvInfo*)tv;
- (void) connSuccess:(NSData*)data;
- (void) passValue: (GameInfo*)gameInfo;
- (void) passMemoValue: (int)memory withAction:(int)action;

- (void) haveInstalled: (int)ip
         withPkgName:(NSString*)pkgName
          withStatue:(int)statue
              withId:(int)gameId;

- (void) passGameInfoArray:(NSMutableArray*)gameInfoArray;

- (void) connFailed:(int)ip;

- (void) getTvState:(NSNumber*)state;

- (void) startSDKGame:(TvInfo*)tvInfo;

- (void) gotoHandle: (NSDictionary*)dic;

- (void) disconnectedWithTv;

- (void) exitHandler;

- (void) disconnectedWithSdk;

- (void) addSdk;
- (void) addTvInfo;
@end

//
//  SwitcherInfo.h
//  NewTvuoo
//
//  Created by xubo on 11/21 Friday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LAYOUT_URL  @"http://tvuent.wap3.cn/gamepad/json/gamelayout.jsp"//布局地址
#define TOPIC_URL   @"http://tvuent.wap3.cn/tvuoo/json/topic.jsp"  //专题游戏
#define GAMEINFO_URL  @"http://tvuent.wap3.cn/tvuoo/json/gameinfo.jsp"//详情地址

#define SWITCH_URL @"http://tvuent.wap3.cn/tvuoo/json/tvuswitch.jsp?"//开关地址
#define GAMEPAD_URL  @"http://tvuent.wap3.cn/tvuoo/json/gamepad.jsp"//手柄地址

#define LOG_URL @"http://report.tvuoo.com/mobstat"//日志地址
#define TVLOG_URL  @"http://report.tvuoo.com/tvstat"//日志地址
#define SDKLOG_URL @"http://report.tvuoo.com/sdkstat"//日志地址
#define JUMP_URL @"http://tvuent.wap3.cn/tvuoo/json/jump.jsp"//跳转地址
#define UPDATE_URL @"http://tvuent.wap3.cn/tvuoo/json/updateapp.jsp"//更新地址
#define GAMELIST_URL @"http://tvuent.wap3.cn/tvuoo/json/gamelist.jsp"//列表地址
#define GAMETYPE_URL @"http://tvuent.wap3.cn/tvuoo/json/gametype.jsp"//类型地址
#define SO_URL @"http://tvuent.wap3.cn/tvuoo/json/so.jsp"//so地址
#define FIND_URL @"http://tvuent.wap3.cn/tvuoo/json/findgame.jsp"//搜索地址
#define APPINFO_URL @"http://tvuent.wap3.cn/tvuoo/json/appinfo.jsp"//应用地址
#define HANDBUY_URL @"http://detail.m.tmall.com/item.htm?id=16357531492&id=16357531492&wp_m=MODULE_KEY_PLACE_HOLDER&wp_pk=shop/mall_index_825371323_&from=inshop&wp_app=weapp"

#define GETGAMES_BYIDS @"http://tvuent.wap3.cn/tvuoo/json/getgamebyids.jsp"

@class LocalData;
//新增加
@interface AllUrl : NSObject
@property (retain, nonatomic) NSString* gameListUrl;
@property (retain, nonatomic) NSString* recommendUrl;
@property (retain, nonatomic) NSString* updatedUrl;
@property (retain, nonatomic) NSString* topicUrl;
@property (retain, nonatomic) NSString* tvlogUrl;
@property (retain, nonatomic) NSString* superApkName;
@property (retain, nonatomic) NSString* logUrl;
@property (retain, nonatomic) NSString* jumpUrl;
@property (retain, nonatomic) NSString* tvuApkName;
@property (retain, nonatomic) NSString* tvuApkUrl;
@property (retain, nonatomic) NSString* handshangkBuyUrl;
@property (retain, nonatomic) NSString* getGamesUrl;
@property (retain, nonatomic) NSString* qRecode;
@property (retain, nonatomic) NSString* findGameUrl;
@property (retain, nonatomic) NSString* gameTypeUrl;
@property (retain, nonatomic) NSString* superApkUrl;
@property (retain, nonatomic) NSString* allTopicUrl;
@property (retain, nonatomic) NSString* switchUrl;
@property (retain, nonatomic) NSString* gameInfoUrl;
@property (retain, nonatomic) NSString* gameGroupUrl;
@property (retain, nonatomic) NSString* gameLayoutUrl;
@property (retain, nonatomic) NSString* gamePadUrl;
@property (retain, nonatomic) NSString* soUrl;
@property (retain, nonatomic) NSString* sdkLogUrl;

//开关
@property (assign, atomic) int tvu_ad_switch;
@property (assign, atomic) int showtvuoo_switch;
@property (assign, atomic) int tvu_showgame_switch;
@property (assign, atomic) int tvu_showremote_switch;
@property (assign, atomic) int exitgame_switch;
@property (assign, atomic) int exitsdk_switch;
+ (id)getInstance;
@end


@interface LocalData : NSObject
+(NSString*) getUrl: (NSString*)key;
+(void) setUrl: (NSString*)key withValue:(NSString*)value;
@end


@interface Switcher : NSObject<NSCoding>
@property (assign, atomic) int tvu_ad_switch;
@property (assign, atomic) int showtvuoo_switch;
@property (assign, atomic) int tvu_showgame_switch;
@property (assign, atomic) int tvu_showremote_switch;
@property (assign, atomic) int exitgame_switch;
@property (assign, atomic) int exitsdk_switch;
//
- (void) encodeWithCoder:(NSCoder *)aCoder;
- (id) initWithCoder:(NSCoder *)aDecoder;

+(Switcher*) createSwitcherFromJson:(NSString*)jsonUrl;
@end

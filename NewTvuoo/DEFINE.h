//
//  DEFINE.h
//  NewTvuoo
//
//  Created by xubo on 9/12 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#define iPhone5 [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size):NO
#define iPhone4 [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size):NO
#define iPhone6 [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size):NO
#define blueColor [UIColor colorWithRed:24/255.0 green:180/255.0 blue:237/255.0 alpha:1]

#define ALL_CATE_JSON @"http://tvuent.wap3.cn/tvuoo/json/gametype.jsp"
#define HOT_JSON @"http://tvuent.wap3.cn/tvuoo/json/topic.jsp?topicid=1"    //热门电视游戏
#define NEW_JSON @"http://tvuent.wap3.cn/tvuoo/json/topic.jsp?topicid=2"    //新品电视游戏
#define NEW_SOFT @"http://tvuent.wap3.cn/tvuoo/json/topic.jsp?topicid=3"     //新品电视软件
#define SHOULD_SOFT @"http://tvuent.wap3.cn/tvuoo/json/topic.jsp?topicid=4"     //必装软件
#define NEW_PHONE_GAME @"http://tvuent.wap3.cn/tvuoo/json/topic.jsp?topicid=6"   //新品手机游戏
#define HOT_PHONE_GAME @"http://tvuent.wap3.cn/tvuoo/json/topic.jsp?topicid=5"    //热门手机游戏

#define CATE_CATE @"http://tvuent.wap3.cn/tvuoo/json/gametype.jsp?"         //所有分类

#define CATEGORY @"http://tvuent.wap3.cn/tvuoo/json/gamelist.jsp?gametype="  //每个分类游戏

#define ANDROID_GAME_UI @"http://tvuent.wap3.cn/tvuoo/json/gameinfo.jsp?"

#define SWITCHER_JSON @"http://tvuent.wap3.cn/tvuoo/json/tvuswitch.jsp?cid=1"       //所有开关

/*
private static final int LEFT_DIR_P1 = 21;
private static final int UP_DIR_P1 = 19;
private static final int RIGHT_DIR_P1 = 22;
private static final int DOWN_DIR_P1 = 20;
private static final int LEFT_UP_DIR_P1 = 44;
private static final int RIGHT_UP_DIR_P1 = 29;
private static final int LEFT_DOWN_DIR_P1 = 47;
private static final int RIGHT_DOWN_DIR_P1 = 32;
private static final int BTN_X_P1 = 99;
private static final int BTN_Y_P1 = 100;
private static final int BTN_A_P1 = 96;
private static final int BTN_B_P1 = 97;
private static final int BTN_SELECT_P1 = 109;
private static final int BTN_START_P1 = 108;

private static final int BTN_SELECT_P2 = 15;
private static final int BTN_START_P2 = 16;
private static final int LEFT_DIR_P2 = 9;
private static final int UP_DIR_P2 = 7;
private static final int RIGHT_DIR_P2 = 10;
private static final int DOWN_DIR_P2 = 8;
private static final int LEFT_UP_DIR_P2 = 11;
private static final int RIGHT_UP_DIR_P2 = 12;
private static final int LEFT_DOWN_DIR_P2 = 13;
private static final int RIGHT_DOWN_DIR_P2 = 14;
private static final int BTN_X_P2 = 51;
private static final int BTN_Y_P2 = 46;
private static final int BTN_A_P2 = 45;
private static final int BTN_B_P2 = 33;private static final int P1_L = 21;// 左键
private static final int P1_U = 19;// 上键
private static final int P1_R = 22;// 右键
private static final int P1_D = 20;// 下键
private static final int P1_LU = -2;// 左上键
private static final int P1_RU = -8;// 右上键
private static final int P1_LD = -4;// 左下键
private static final int P1_RD = -6;// 右下键

private static final int P1_X = 99;
private static final int P1_Y = 100;
private static final int P1_A = 96;
private static final int P1_B = 97;
private static final int P1_COIN = 109;
private static final int P1_START = 108;

private static final int P2_L = 49;// 左键
private static final int P2_U = 48;// 上键
private static final int P2_R = 37;// 右键
private static final int P2_D = 53;// 下键
private static final int P2_LU = -3;// 左上键
private static final int P2_RU = -9;// 右上键
private static final int P2_LD = -5;// 左下键
private static final int P2_RD = -7;// 右下键
private static final int P2_X = 43;
private static final int P2_Y = 29;
private static final int P2_A = 44;
private static final int P2_B = 47;
private static final int P2_COIN = 35;
private static final int P2_START = 36;

*/
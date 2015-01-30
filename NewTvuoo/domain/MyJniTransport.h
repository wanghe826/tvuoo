//
//  test.h
//  TestJniHelper
//
//  Created by �ゅ� ��on 13-12-2.
//
//

#ifndef __My_Jni_Transport__
#define __My_Jni_Transport__
//#include "cocos2d.h"
//#include <jni.h>
//#include "platform/android/jni/JniHelper.h"
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include "package/MultiTouchPkg.h"
#import "CallBack.h"

//#include<android/log.h>
#include <string>
//#include <iostream>
using namespace std;

//获取设备名
string getDeviceName();
//获取设备mac地址
string getMacAddress();
//获取我的游戏信息
string getMyGameInfo();


extern "C"{
    
    void sendExitGame(int ip, int port, int type, string gamePkg);

void checkUseState(int ip, int port);
    void sendApp(int ip, int port, int act, string appInfo);
void isInstalled(int ip, int port, int id, int apptype,string gamePkg);
void  getMyGame(int ip, int port);
//计算鼠标位置
void  closeTcpClient(int ip, int port);
void validatePostion(float paramFloat1, float paramFloat2);
void  connectServer(int ip, int port);
    void  mouseMove(int ip, int port, float x, float y);
    void  mouseMoveDown(int ip, int port, float x, float y);
    void  sendGame(int ip, int port, int act, string gameInfo);
/*
//获取设备名
string getDeviceName();
//获取设备mac地址
string getMacAddress();
//获取我的游戏信息
string getMyGameInfo();
 */
void  sendSensor(int ip, int port, int act, float x, float y,
                     float z) ;
void sendSimulator(int ip,int port,int type,int act,int code);
//void sendMutiEvent(int ip, int port, int udpPort,int act, int count,T vuPoint* pointers[]);
void sendMutiEvent(int ip, int port, int udpPort,int act, int count, NSMutableArray* pointers);
char* parseIp(int ip);
void startJni();

//鼠标按下和抬起
void  mouseEvent(int ip, int port, int act, float x, float y,int flag);
    void pspMove(int ip, int port, float x, float y);
bool getRooted();
//启动游戏 --手机启动电视
void startGame(string gameJson,int ip);
//退出游戏
void exitGame(string gamePkg,int ip);
//发送tvInfo到UI
void sendPhoneInfo(string tvInfo,int ip);
//phone断开
void breakPhoneWithIp(int ip);

//发送鼠标事件
void sendMouseEvent(int act,float x,float y,int ip);
//发送psp等按键事件
void sendPSPEvent(int act,string code,int flag,int ip);
//发送感应器事件
//void sendSensor(int act,float x,float y,float z,int ip);
//发送输入法文字信息
void startInputInfo(string text,int ip);
//获取支付结果
void sendPayResopne(string payInfo);
//发送完整数据到sdk
void sendEventWithSdk(string sdkInfo);
//触摸事件
void sendMouseTouch(int act,int cnt,int aid,float ax,float ay,int bid,float bx,float by,int cid,float cx,float cy,int ip);
    
void  keyEvent(int ip, int port, int act, int code, int flag);

    void getSpeedInfo(int ip, int port, int action);
    void getSpeedInfoFromTv(string total,string cur,string last,int action);
    
//通知手机启动操作界面
//void startGameInPhone(string gameId);
//通知手机启动输入法
//void startInput();

//接到数据后在这里解析，解析后分发
//static void setData(TVUPackage *package,unsigned int ip);


 void recUdpData(unsigned char *buf,int buflen,int ip);
	void revTcpData(unsigned char *buf,int buflen,int ip,int port);
	void revDomainData(unsigned char *buf,int buflen,string domainName);
	void breakConWithIp(int ip, int port) ;
void* thread_fun(void *arg);

void* thread_udp(void *arg);

void sendBrodcast();
}

#endif /* defined(__TestJniHelper__test__) */

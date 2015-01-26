#include "Shared.h"
#include "package/Symbol.h"
#include "package/Package.h"
#include "package/JsonPackage.h"
#include "package/HeartBeatPkg.h"
#include "package/MouseDownPkg.h"
#include "package/MouseMovePkg.h"
#include "package/MouseEventPkg.h"
#include "package/OperationHintPkg.h"
#include "package/KeyEventPkg.h"
#include "SimulatorKeyEventPkg.h"
#include "package/PushInputPkg.h"
#include "package/SensorEventPkg.h"
#import "Singleton.h"
#import "TvInfo.h"
#import "PspMovePkg.h"
//#include <jni.h>
#include <iostream>
#include <sstream>
#include <dlfcn.h>
#import "ParseJson.h"
#import "CallBack.h"
#include "package/MultiTouchPkg.h"
#include <vector>
#include "AllUrl.h"
#import "NSTvuPoint.h"
//#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO, "native-activity", __VA_ARGS__))
//#define LOGW(...) ((void)__android_log_print(ANDROID_LOG_WARN, "native-activity", __VA_ARGS__))
//#define LOGE(...) ((void)__android_log_print(ANDROID_LOG_ERROR, "native-activity", __VA_ARGS__))

//锟竭筹拷锟斤拷
#define NUMTHREADS 5
//全锟街憋拷锟斤拷
//static JavaVM *g_jvm = NULL;
//static jobject g_obj = NULL;

//static jobject gClassLoader = NULL;
//static jmethodID gFindClassMethod = NULL;

//static JNIEnv *envtt = NULL;
//static jclass cls = NULL;
static Shared* device = NULL;
static float sVirtualMouseX;
static float sVirtualMouseY;
static int mDisplayHeight;
static int mDisplayWidth;
static pthread_mutex_t m_mutex;
static bool RUN = true;
static int TVU_BUF_SEND = 8192;

string int2str(unsigned short &i) {
	string s;
	stringstream ss(s);
	ss << i;
	return ss.str();
}
string floatToString(float value) {
	char Strf[256];
	memset(Strf, 0, 256);
	sprintf(Strf, "%f", value);
	return Strf;
}

string intToString(int value) {
	char Strf[16];
	memset(Strf, 0, 16);
	sprintf(Strf, "%d", value);
	return Strf;
}

extern "C" {

void validatePostion(float paramFloat1, float paramFloat2) {
	sVirtualMouseX = paramFloat1 + sVirtualMouseX;
	sVirtualMouseY = paramFloat2 + sVirtualMouseY;
	float f1 = mDisplayWidth / 2.0F - 1;
	float f2 = mDisplayHeight / 2.0F - 1;
	if (sVirtualMouseX < -f1)
		sVirtualMouseX = -f1;
	if (sVirtualMouseY < -f2)
		sVirtualMouseY = -f2;
	if (sVirtualMouseX > f1)
		sVirtualMouseX = f1;
	if (sVirtualMouseY > f2)
		sVirtualMouseY = f2;
}
    /*
     * 加速信息
     * @param total 总大小
     * @param cur 当前使用大小
     * @param last 之前大小
     * @param action 0加速状态 1加速完成后
     */
    //action =0
void getSpeedInfo(int ip, int port, int action)
{
    if (device != NULL){
            char buf[TVU_BUF_SEND];
            bzero(buf, TVU_BUF_SEND);
            int pIp = ip;
            int pport = port;
            int paction = action;
            JsonPackage *package = new JsonPackage(TVU_GET_TV_SPEED_);
            package->addData(TVU_PKG_GAME_SPEED_GET, intToString(paction));
            int len = package->encode(buf, TVU_BUF_SEND, false);
            if (len >= 4) {
                device->sendTcpData(pport, pIp, buf, len);
            }
            if (package != NULL) {
                delete package;
            }
        }
    }
    
void getSpeedInfoFromTv(string total, string cur, string last,int action)
{
    if(action == 0)
    {
        //当前内存所占百分比
        int current = atoi(cur.c_str());
        int all = atoi(total.c_str());
        int rate = current*100/all;
        if([[Singleton getSingle].myDelegate respondsToSelector:@selector(passMemoValue:withAction:)])
        {
            [[Singleton getSingle].myDelegate passMemoValue:rate withAction:0];
        }
    }
    else if(action ==1)
    {
        //已经清理的内存所占百分比
        int i_current = atoi(cur.c_str());
        int i_total = atoi(total.c_str());
        int i_last = atoi(last.c_str());
        int rate = (i_last - i_current)*100/i_total;
        rate = abs(rate);
        if([[Singleton getSingle].myDelegate respondsToSelector:@selector(passMemoValue:withAction:)])
        {
            [[Singleton getSingle].myDelegate passMemoValue:rate withAction:1];
        }
    }
}
    
    
//有连接断开 ip电视的ip
void breakDev(int ip, int port) {
    NSLog(@"电视断开了");
    int flag = 0;
    
    if([Singleton getSingle].current_tv)
    {
        if((ip == [Singleton getSingle].current_tv.tvIp) && (port == [Singleton getSingle].current_tv.tvServerport))        //普通tv  异常断开
        {
            [Singleton getSingle].current_tv = nil;
            
            
            if([[Singleton getSingle].tvArray count] <= 1)
            {
                [Singleton getSingle].conn_statue = 0;
            }
            for(TvInfo* tvInfo in [Singleton getSingle].tvArray)
            {
                tvInfo.cell_btn_statue = NO;
            }
            [Singleton getSingle].conn_statue = 1;
        }
        else
        {
            //sdk连接异常断开
            flag = 1;
        }
    }
    else
    {
        flag = 1;
    }
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(flag == 1)               //代表断开的是adk 游戏
        {
            NSLog(@"sdk 游戏断开了");
            if([[Singleton getSingle].mySdkBreakDownDelegate respondsToSelector:@selector(disconnectedWithSdk)])
            {
                [[Singleton getSingle].mySdkBreakDownDelegate disconnectedWithSdk];
            }
        }
        else
        {
            if([[Singleton getSingle].myBreakDownDelegate respondsToSelector:@selector(disconnectedWithTv)])
            {
                [[Singleton getSingle].myBreakDownDelegate disconnectedWithTv];
            }
        }
        
    });
    
    
}
static  char *st;
char* parseIp(int ip)
{
    struct in_addr ip_addr;
    memcpy(&ip_addr, &ip, 4);
    st = inet_ntoa(ip_addr);                              //将int型ip 转换成 字符串
    return st;
}
    
    
//连接状态 conflag 0 失败 1成功
void conStatue(int ip, int conflag)
{
    if(conflag <= 1)
    {
        char* ipAddr = parseIp(ip);
        NSLog(@"连接失败 %s\n，，， %d", ipAddr, conflag);
        if([Singleton getSingle].tvType == 1 || [Singleton getSingle].tvType == 3)
        {
            if([[Singleton getSingle].myConnDelegate respondsToSelector:@selector(connFailed:)])
            {
                [[Singleton getSingle].myConnDelegate connFailed:ip];
            }
        }
        if([Singleton getSingle].tvType == 2)
        {
            if([[Singleton getSingle].mySdkConnDelegate respondsToSelector:@selector(connFailed:)])
            {
                [[Singleton getSingle].mySdkConnDelegate connFailed:ip];
            }
        }
        
    }
}
void* thread_heart(void *arg) {
	while (RUN) {
		if (device != NULL) {
			break;
		}
		sleep(1);
	}
	char buf[TVU_BUF_SEND];
	while (RUN) {
		if (device->getRunStatue() != RUNNING) {
			continue;
		}
		HeartBeatPkg *package = new HeartBeatPkg();
		bzero(buf, TVU_BUF_SEND);
		int len = package->encode(buf, TVU_BUF_SEND, false);
		device->checkAct(buf, len);
		if (package != NULL) {
			delete package;
		}
		sleep(TVU_HEART);
	}
    return NULL;
}

void* thread_fun(void *arg) {
	pthread_mutex_init(&m_mutex, NULL);
	device = Shared::getInstance();
	RUN = true;
//	device = new Singleton();
	device->init(NULL);
	for (int portIdx = 0; portIdx < PORT_COUNT; portIdx++) {
		int flag = device->addUdpServer(PORTS[portIdx], 1);
		if (flag == 1) {
			break;
		}
	}
//	pthread_t pt2;
//	pthread_mutex_lock(&m_mutex);
//	pthread_create(&pt2, NULL, thread_heart, NULL);
//	pthread_mutex_unlock(&m_mutex);
	device->run();
    return NULL;
}
//手动连接
void  connectServer(int ip, int port) {
	if (device != NULL) {
		int peerIp = ip;
		int peerPort = port;
		int conFlag = device->connectServer(peerIp, peerPort);
		if (conFlag > 0) {
//			conStatue(peerIp, 1);
			JsonPackage* package = new JsonPackage(TVU_PHONE_DEVICE_DETAIL_);
			package->addData(TVU_PKG_HAND1_VS, intToString(1));
			package->addData(TVU_PKG_HAND1_DEVNAME, "手机");
			package->addData(TVU_PKG_HAND1_MINVS, "1");
			package->addData(TVU_PKG_HAND1_MAC, "12.sd.12");
			package->addData(TVU_PKG_HAND1_TAG, "tag");
			package->setAddr(peerIp);
			char buf[TVU_BUF_SEND];
			bzero(buf, TVU_BUF_SEND);
			int len = package->encode(buf, TVU_BUF_SEND, false);
			if (len > 4) {
				device->sendTcpData(peerPort, peerIp, buf, len);
			}
			if (package != NULL) {
				delete package;
			}

		} else {
			conStatue(peerIp, 0);
		}
	}
}
//启动
void  startJni()
{
	pthread_t pt;
	pthread_create(&pt, NULL, thread_fun, NULL);
}
//停止
void  stopJni() {
	RUN = false;
	if (device != NULL) {
		device->closeAll();
	}
}

    //主动断开
void  closeTcpClient(int ip, int port) {
	if (device != NULL) {
		int pIp = ip;
		int pport = port;
		device->closeTcpClient(pIp, pport);
		breakDev(pIp, pport);
	}

}
    
    //主动发送鼠标move事件
void  mouseMove(int ip, int port, float x, float y) {

	if (device != NULL) {
		char buf[TVU_BUF_SEND];
		bzero(buf, TVU_BUF_SEND);
		float px = x;
		float py = y;

//		LOGE("mouseMOve|x = %f,y = %f", px, py);
		int pIp = ip;
		int pport = port;
		MouseMovePkg *package = new MouseMovePkg();
		package->setX(px);
		package->setY(py);
		package->setAddr(pIp);
		int len = package->encode(buf, TVU_BUF_SEND, false);
		if (len > 4) {
			device->sendUdpData(pport, pIp, buf, len);
		}
		if (package != NULL) {
			delete package;
		}
	}

}
void  mouseMoveDown(int ip, int port, float x, float y) {
	if (device != NULL) {
		char buf[TVU_BUF_SEND];
		bzero(buf, TVU_BUF_SEND);
		float px = x;
		float py = y;
		int pIp = ip;
		int pport = port;
		MouseDownPkg *package = new MouseDownPkg();
		package->setX(px);
		package->setY(py);
		package->setAddr(pIp);
		int len = package->encode(buf, TVU_BUF_SEND, false);
		if (len > 4) {
			device->sendUdpData(pport, pIp, buf, len);
		}
		if (package != NULL) {
			delete package;
		}
	}

}
//    鼠标左键按下和抬起
void  mouseEvent(int ip, int port, int act, float x, float y,
		int flag) {
	if (device != NULL) {
		char buf[TVU_BUF_SEND];
		bzero(buf, TVU_BUF_SEND);
		float px = x;
		float py = y;
		int pIp = ip;
		int pport = port;
		int pact = act;
		int pflag = flag;
		MouseEventPkg *package = new MouseEventPkg();
		package->setX(px);
		package->setY(py);
		package->setAct(pact);
		package->setFlag(pflag);
		int len = package->encode(buf, TVU_BUF_SEND, false);
		if (len > 4) {
			device->sendTcpData(pport, pIp, buf, len);
		}
		if (package != NULL) {
			delete package;
		}
	}

}

void sendSimulator(int ip,int port,int type,int act,int code)
{
    if (device != NULL) {
        char buf[TVU_BUF_SEND];
        bzero(buf, TVU_BUF_SEND);
        int pIp = ip;
        int pport = port;
        int pact = act;
        int pcode = code;
        int ptype = type;
        SimulatorKeyEventPkg *package = new SimulatorKeyEventPkg();
        package->setAct(pact);
        package->setType(ptype);
        package->setCode(pcode);
        int len = package->encode(buf, TVU_BUF_SEND, false);
        if (len > 4) {
            device->sendTcpData(pport, pIp, buf, len);
        }
        if (package != NULL) {
            delete package;
        }
    }
}

void  keyEvent(int ip, int port, int act, int code, int flag) {
//	LOGE("keyEvent");
	if (device != NULL) {
		char buf[TVU_BUF_SEND];
		bzero(buf, TVU_BUF_SEND);
		int pIp = ip;
		int pport = port;
		int pact = act;
		int pflag = flag;
		int pcode = code;
		KeyEventPkg *package = new KeyEventPkg();
		package->setAct(pact);
		package->setFlag(pflag);
		package->setCode(pcode);
		int len = package->encode(buf, TVU_BUF_SEND, false);
		if (len > 4) {
			device->sendTcpData(pport, pIp, buf, len);
		}
		if (package != NULL) {
			delete package;
		}
	}
}
void  inputText(int ip, int port, int act, string text) {

}
void  sendSensor(int ip, int port, int act, float x, float y,
		float z) {
//	LOGE("sensro");
	if (device != NULL) {
		char buf[TVU_BUF_SEND];
		bzero(buf, TVU_BUF_SEND);
		int pIp = ip;
		int pport = port;
		int pact = act;
		float px = x;
		float py = y;
		float pz = z;
		SensorEventPkg *package = new SensorEventPkg();
		package->setAct(pact);
		package->setX(px);
		package->setY(py);
		package->setZ(pz);
		int len = package->encode(buf, TVU_BUF_SEND, false);
		if (len > 4) {
//            NSLog(@"发送sensor!");
//            NSLog(@"bufffffff ====   %s", buf + 4);
			device->sendUdpData(pport, pIp, buf, len);
		}
		if (package != NULL) {
			delete package;
		}
	}

}
    //
void  payInfo(int ip, int port, string paytext) {

}
//手动调用     获取我的游戏信息
void  getMyGame(int ip, int port) {
	if (device != NULL) {
		char buf[TVU_BUF_SEND];
		bzero(buf, TVU_BUF_SEND);
		int pIp = ip;
		int pport = port;
		JsonPackage *package = new JsonPackage(TVU_MYGAME_INFO_);
		package->addData(TVU_PKG_HAND_TAG,"TVUOO");
		int len = package->encode(buf, TVU_BUF_SEND, false);
		if (len >= 4) {
			device->sendTcpData(pport, pIp, buf, len);
		}
		if (package != NULL) {
			delete package;
		}
	}
}

    //手动调用     启动电视上的某个游戏
void  sendGame(int ip, int port, int act, string gameInfo) {
    
	if (device != NULL) {
		char buf[TVU_BUF_SEND];
		bzero(buf, TVU_BUF_SEND);
		int pIp = ip;
		int pport = port;
		int pact = act;
//		string pgameinfo = jstringTostring(env, gameInfo);
        string pgameinfo = gameInfo;
		JsonPackage *package = new JsonPackage(TVU_GAME_STATUE_);
		package->addData(TVU_PKG_GAME_ACT, intToString(pact));
		package->addData(TVU_PKG_GAME_GAMEINFO, pgameinfo);
		int len = package->encode(buf, TVU_BUF_SEND, false);
		if (len > 4) {
			device->sendTcpData(pport, pIp, buf, len);
		}
		if (package != NULL) {
			delete package;
		}
	}
    
}

    //发送多点事件
//    void sendMutiEvent(int ip, int port, int udpPort,int act, int count, TvuPoint* pointers[])
    void sendMutiEvent(int ip, int port, int udpPort,int act, int count, NSMutableArray* pointers)
    {
        
        if (device != NULL)
        {
            MultiTouchPkg *package = new MultiTouchPkg();
            int iact = act;
            int icount = count;
            package->setAct(iact);
            package->setCnt(icount);
            


            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"p_id" ascending:YES];
            
            NSArray* sortedArray =[pointers sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            
            for(NSTvuPoint* point in sortedArray)
            {
                TvuPoint* tvuPoint = new TvuPoint();
                tvuPoint->setId(point.p_id);
                tvuPoint->setX(point.p_x);
                tvuPoint->setY(point.p_y);
                
                package->addPoint(tvuPoint);
            }
            
            
            char buf[TVU_BUF_SEND];
            bzero(buf, TVU_BUF_SEND);
            int datalen = package->encode(buf, TVU_BUF_SEND, false);
//            int flag = 0;

            
            if (datalen > 4) {
                int pIp = ip;
                int pport = port;
//                int pudpPort = udpPort;
                if(iact==2){
//                    NSLog(@"发送multiPoint 2");
                    device->sendTcpData(udpPort, pIp, buf, datalen);
                }else
                {
//                    NSLog(@"发送multiPoint > 2, action:: %d", iact);
                    device->sendTcpData(pport, pIp, buf, datalen);
                }
            }
            //		LOGE("datalen = %d",datalen);
            if (package != NULL) {
                delete package;
            }
        }
        
    }



//发送tvInfo到UI (回调函数，得到udp广播的电视信息)
void sendTvInfo(string tvInfo, int ip)
{
    Singleton* single = [Singleton getSingle];
    NSString* tvStr = [NSString stringWithUTF8String:tvInfo.c_str()];
    TvInfo* tv = [ParseJson createTvInfoFromJson:tvStr];
    
    if(tv == nil)
    {
        return ;
    }
    tv.tvIp = ip;
    tv.date = [NSDate date];
    
    if(tv.tvType == 2)
    {
        if([single.sdkArray count] > 0)
        {
            for(TvInfo* tvinfo in single.sdkArray)
            {
                if([tvinfo.pkgName isEqualToString:tv.pkgName])
                {
                    tvinfo.date = [NSDate date];
                    return;             //如果发现此tvinfo对象已存在列表当中， 则返回
                }
            }
        }
        [single.sdkArray addObject:tv];
        
        if([[Singleton getSingle].myAddTvInfoOrSdk respondsToSelector:@selector(addSdk)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[Singleton getSingle].myAddTvInfoOrSdk addSdk];
            });
        }
        
        if([Singleton getSingle].isInProtrait == NO)
        {
            if([[Singleton getSingle].myFindSdkGameDelegate respondsToSelector:@selector(startSDKGame:)])
            {
                [[Singleton getSingle].myFindSdkGameDelegate startSDKGame:tv];
            }
        }
        return;
    }
    if(tv.tvType == 1)
    {
        
        for(TvInfo* tvInfo in single.tvArray)
        {
            if(tvInfo.tvIp == tv.tvIp)
            {
                tvInfo.date = [NSDate date];
                return;
            }
        }
        [single.tvArray addObject:tv];
        
        if([[Singleton getSingle].myAddTvInfoOrSdk respondsToSelector:@selector(addTvInfo)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[Singleton getSingle].myAddTvInfoOrSdk addTvInfo];
            });
        }
        
        if([single.tvArray count] > 0)
        {
            if(single.conn_statue == 0)
            {
                single.conn_statue = 1;
            }
        }
    }
}

//回调函数    (连接成功， 获取电视的信息)
void sendTvAllInfo(string tvInfo, int ip)
{
    NSLog(@"连接成功的回调-----%s", tvInfo.c_str());
    NSString* jsonStr = [NSString stringWithFormat:@"%s", tvInfo.c_str()];
    
    
    NSData* data = [NSData dataWithBytes:&ip length:sizeof(ip)];
    
//    [[Singleton getSingle] connSuc:data];
    
    NSObject* object = nil;
    if([Singleton getSingle].tvType == 1 || [Singleton getSingle].tvType == 3)
    {
        
        object = (NSObject*)[Singleton getSingle].myConnDelegate;
    }
    else if([Singleton getSingle].tvType == 2)
    {
        TvInfoDetail* tv = [ParseJson createTvInfoDetailFromJson:jsonStr];
        [Singleton getSingle].current_sdkTvInfo = tv;
        object = (NSObject*)[Singleton getSingle].mySdkConnDelegate;
    }
    
    if([Singleton getSingle].tvType == 1)
    {
        TvInfoDetail* tv = [ParseJson createTvInfoDetailFromJson:jsonStr];
        [Singleton getSingle].current_tvInfo = tv;
    }
    else
    {
        TvInfoDetail* tv = [ParseJson createTvInfoDetailFromJson:jsonStr];
        [Singleton getSingle].current_sdkTvInfo = tv;
    }
    
    
    if([object respondsToSelector:@selector(connSuccess:)])
    {
//        [[Singleton getSingle].myConnDelegate connSuccess:data];
        [object performSelectorOnMainThread:@selector(connSuccess:) withObject:data waitUntilDone:YES];
    }
}

    //回调函数    手机端可以从电视获取我的游戏信息
void startAllGame(string allGame, int ip)
{
    NSLog(@"获取我的电视已经有的游戏:%s",allGame.c_str());
    NSString* games = [NSString stringWithFormat:@"%s", allGame.c_str()];
    NSLog(@"gameeees: %@", games);
    NSData* data = [games dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_DATA_DESTRUCTOR_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    if(data != nil)
    {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if(error == nil)
        {
            //解析json 成功
            __block NSMutableArray* gameInfoArray = [[NSMutableArray alloc] initWithCapacity:1];
//            NSArray* jsonArray = [dic objectForKey:@"allgameinfo"];
            id jsonArray = [dic objectForKey:@"allgameinfo"];
            
            if(![jsonArray isKindOfClass:[NSArray class]])
            {
                [gameInfoArray release];
                return;
            }
            
            for(int i=0; i<[jsonArray count]; ++i)
            {
                NSDictionary* dictionary = [jsonArray objectAtIndex:i];
                NSMutableString* jsonUrl = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] gameInfoUrl]];
                [jsonUrl appendString:@"?gameid="];
                [jsonUrl appendString:[dictionary objectForKey:@"game_id"]];
                dispatch_group_async(group, queue, ^{
                    GameInfo* gameInfo = [ParseJson createGameInfoFromJson:jsonUrl];
                    if(gameInfo != nil)
                    {
                        [gameInfoArray addObject:gameInfo];
                    }
                    [jsonUrl release];
                });
            }
            dispatch_group_notify(group, queue, ^{
                if([[Singleton getSingle].myDelegate respondsToSelector:@selector(passGameInfoArray:)])
                {
                    [[Singleton getSingle].myDelegate passGameInfoArray:gameInfoArray];
                }  
            });
        }
        else
        {
            NSLog(@"解析失败");
        }
    }
    dispatch_release(group);
}

    //回调函数     (电视启动了某个游戏)
void startGame(int act, string gameName, string pkg, int ip, int limit)
{
    if([Singleton getSingle].isInProtrait == YES)
    {
        return;
    }
    NSDictionary* dic = [[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:act],@"act",[NSString stringWithFormat:@"%s",gameName.c_str()],@"gameName", [NSString stringWithFormat:@"%s", pkg.c_str()], @"pkg",[NSNumber numberWithInt:limit],@"limit", nil] autorelease];
    if([[Singleton getSingle].myStartGameDelegate respondsToSelector:@selector(gotoHandle:)])
    {
        [[Singleton getSingle].myStartGameDelegate gotoHandle:dic];
    }
}

    //回调函数   (电视启动了支付)
void startPay(string payInfo, int ip) {
}
//回调函数   （电视推荐的某个应用)
void startApp(string appInfo, int ip) {
    /*
	g_jvm->AttachCurrentThread(&envtt, NULL);
	cls = envtt->GetObjectClass(g_obj);
	if (cls == NULL) {
		LOGE("GetClass Error.....");
	}
	//	LOGE("setData()");
	jmethodID mid = envtt->GetStaticMethodID(cls, "startApp",
			"(Ljava/lang/String;I)V");
	if (mid == NULL) {
		LOGE("GetMethodID() Error.....");
	}
	jstring jinfo = envtt->NewStringUTF(appInfo.c_str());
	jint jip = ip;
	envtt->CallStaticVoidMethod(cls, mid, jinfo, jip);
	envtt->DeleteLocalRef(jinfo);
	if (g_jvm->DetachCurrentThread() != JNI_OK) {
		LOGE(" DetachCurrentThread() failed");
	}
     */
}
//回调函数  电视退出了某个游戏
void exitGame(int ip)
{
    if([[Singleton getSingle].myExitGameDelegate respondsToSelector:@selector(exitHandler)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Singleton getSingle].myExitGameDelegate exitHandler];
        });
    }
}

void startInput(int ip) {
    /*
	g_jvm->AttachCurrentThread(&envtt, NULL);
	cls = envtt->GetObjectClass(g_obj);
	if (cls == NULL) {
		LOGE("GetClass Error.....");
	}
	//	LOGE("setData()");
	jmethodID mid = envtt->GetStaticMethodID(cls, "startInput",
			"(Ljava/lang/String;I)V");
	if (mid == NULL) {
		LOGE("GetMethodID() Error.....");
	}
	jint jip = ip;
	envtt->CallStaticVoidMethod(cls, mid, jip);
	if (g_jvm->DetachCurrentThread() != JNI_OK) {
		LOGE(" DetachCurrentThread() failed");
	}
*/
}

void gameStatue(int statue, string pkg, int ip) {
    /*
	g_jvm->AttachCurrentThread(&envtt, NULL);
	cls = envtt->GetObjectClass(g_obj);
	if (cls == NULL) {
		LOGE("GetClass Error.....");
	}
	//	LOGE("setData()");
	jmethodID mid = envtt->GetStaticMethodID(cls, "gameStatue",
			"(ILjava/lang/String;I)V");
	if (mid == NULL) {
		LOGE("GetMethodID() Error.....");
	}
	jstring jinfo = envtt->NewStringUTF(pkg.c_str());
	jint jip = ip;
	jint jstatue = statue;
	envtt->CallStaticVoidMethod(cls, mid, jstatue, jinfo, jip);
	envtt->DeleteLocalRef(jinfo);
	if (g_jvm->DetachCurrentThread() != JNI_OK) {
		LOGE(" DetachCurrentThread() failed");
	}*/
}

void contralTag(int tag, int ip) {
    /*

	g_jvm->AttachCurrentThread(&envtt, NULL);
	cls = envtt->GetObjectClass(g_obj);
	if (cls == NULL) {
		LOGE("GetClass Error.....");
	}
	//	LOGE("setData()");
	jmethodID mid = envtt->GetStaticMethodID(cls, "gameStatue", "(II)V");
	if (mid == NULL) {
		LOGE("GetMethodID() Error.....");
	}
	jint jip = ip;
	jint jstatue = tag;
	envtt->CallStaticVoidMethod(cls, mid, jstatue, jip);
	if (g_jvm->DetachCurrentThread() != JNI_OK) {
		LOGE(" DetachCurrentThread() failed");
	}
     */

}
    
    /**
     * psp 移动事件
     */
    void pspMove(int ip, int port, float x, float y)
    {
        if (device != NULL) {
            char buf[TVU_BUF_SEND];
            bzero(buf, TVU_BUF_SEND);
            float px = x;
            float py = y;
            int pIp = ip;
            int pport = port;
            PspMovePkg *package = new PspMovePkg();
            package->setX(px);
            package->setY(py);
            package->setAddr(pIp);
            int len = package->encode(buf, TVU_BUF_SEND, false);
            if (len > 4) {
                device->sendUdpData(pport, pIp, buf, len);
            }
            if (package != NULL) {
                delete package;
            }
        }
        
    }
    
    

void loactionPlayer(float x, float y, int ip) {

}
    
    
void isInstalled(int ip, int port, int id, int apptype,string gamePkg)
{
        if (device != NULL) {
            char buf[TVU_BUF_SEND];
            bzero(buf, TVU_BUF_SEND);
//            int pIp = ip;
//            int pport = port;
            int ptype = apptype;
            int pid = id;
            string pgameinfo = gamePkg;
            JsonPackage *package = new JsonPackage(TVU_GET_GAME_INSATLLED_);
            package->addData(TVU_PKG_GAME_STATUE_TYPE, intToString(ptype));
            package->addData(TVU_PKG_GAME_STATUE_PKG, pgameinfo);
            package->addData(TVU_PKG_GAME_STATUE_ID, intToString(pid));
            int len = package->encode(buf, TVU_BUF_SEND, false);
            if (len > 4) {
                device->sendTcpData(port, ip, buf, len);
            }
            if (package != NULL) {
                delete package;
            }
        }
    }

int parseType(unsigned char *buf, int buflen) {
	u_short type = *((u_short*) buf);
	return type;
}

void recUdpData(unsigned char *buf, int buflen, int ip) {
	int type = parseType(buf, buflen);
	if (type == TVU_BROADCAST_MESSAGE_) {
		//解析回一个单播
		int flag = 0;
		JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
				false);
		sendTvInfo(package->toJsonString(), ip);
		if (package != NULL) {
			delete package;
		}
	} else {
		printf("udp未知事件");
	}
}
    
void sendExitGame(int ip, int port, int type, string gamePkg)
{
        if (device != NULL) {
            char buf[TVU_BUF_SEND];
            bzero(buf, TVU_BUF_SEND);
            int pIp = ip;
            int pport = port;
            int pact = type;
//            string pgameinfo = jstringTostring(env, gamePkg);
            JsonPackage *package = new JsonPackage(TVU_EXIT_GAME_);
            package->addData(TVU_PKG_GAME_ACT, intToString(pact));
            package->addData(TVU_PKG_GAME_GAMEPKG, gamePkg);
            int len = package->encode(buf, TVU_BUF_SEND, false);
            if (len > 4) {
                device->sendTcpData(pport, pIp, buf, len);
            }
            if (package != NULL) {
                delete package;
            }
        }
}

void getGameInstalled(int ip, string pkg, int statue, int gameId)
{
            NSLog(@"是否安装");
    if([[Singleton getSingle].myDelegate respondsToSelector:@selector(haveInstalled:withPkgName:withStatue:withId:)])
    {
        [[Singleton getSingle].myDelegate haveInstalled:ip withPkgName:[NSString stringWithUTF8String:pkg.c_str()] withStatue:statue withId:gameId];
    }
    
}
    
    /*
     *推送某个 应用
     */
    void sendApp(int ip, int port, int act, string appInfo) {
        if (device != NULL) {
            char buf[TVU_BUF_SEND];
            bzero(buf, TVU_BUF_SEND);
            int pact = act;
            JsonPackage *package = new JsonPackage(TVU_APPINFO_);
            package->addData(TVU_PKG_APP_ACT, intToString(pact));
            package->addData(TVU_PKG_APP_APPINFO, appInfo);
            int len = package->encode(buf, TVU_BUF_SEND, false);
//            LOGE("sendapp data = %s", buf+4);
            if (len > 4) {
                device->sendTcpData(port, ip, buf, len);
            }
            if (package != NULL) {
                delete package;
            }
        }
    }
    
    
void checkUseState(int ip, int port)
{
        if (device != NULL) {
            char buf[TVU_BUF_SEND];
            bzero(buf, TVU_BUF_SEND);
            int pIp = ip;
            int pport = port;
            JsonPackage *package = new JsonPackage(TVU_USE_STATE_);
            package->addData(TVU_PKG_USE_STATE, "0");
            int len = package->encode(buf, TVU_BUF_SEND, false);
            if (len >= 4) {
                device->sendTcpData(pport, pIp, buf, len);
            }
            if (package != NULL) {
                delete package;
            }
        }
}
    
void getUseState(int state)
{
    if([Singleton getSingle].myDelegate)
    {
        if([[Singleton getSingle].myDelegate respondsToSelector:@selector(getTvState:)])
        {
//            [[Singleton getSingle].myDelegate getTvState:state];
            NSObject* object = [Singleton getSingle].myDelegate;
            [object performSelectorOnMainThread:@selector(getTvState:) withObject:[NSNumber numberWithInt:state] waitUntilDone:YES];
        }
    }
}
    
void revTcpData(unsigned char *buf, int buflen, int ip, int port) {
	int type = parseType(buf, buflen);
	int flag = 0;
	if (type == TVU_TV_DEVICE_DETAIL) {
//		LOGE("phone tcp 设备信息 %s", buf+4);
		JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
				false);
		if (package != NULL) {
			sendTvAllInfo(package->toJsonString(), ip);
			delete package;
		}

	} else if (type == TVU_INPUT_METHOD_SHOW) {
//		LOGE("phone tcp 弹出输入法");
		PushInputPkg *package = (PushInputPkg*) Package::decode(buf, buflen,
				flag, true);
		if (package != NULL) {
			startInput(ip);
			delete package;
		}
	} else if (type == TVU_START_GAME) {
//		LOGE("phone tcp 启动游戏");
        
		JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
				true);
		if (package != NULL) {
            string slimit = package->getData(TVU_PKG_START_GAMELIMIT);
            int limit = atoi(slimit.c_str());
			string sact = package->getData(TVU_PKG_START_ACT);
			int act = atoi(sact.c_str());
			startGame(act, package->getData(TVU_PKG_START_GAMENAME),
					package->getData(TVU_PKG_START_PKGNAME), ip, limit);
			delete package;
		}
	} else if (type == TVU_START_PAY) {
//		LOGE("phone tcp 发起支付");
		JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
				true);
		if (package != NULL) {
			startPay(package->toJsonString(), ip);
			delete package;
		}
	} else if (type == TVU_APP_SPREAD) {
//		LOGE("phone tcp 手机下载推广");
		JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
				true);
		if (package != NULL) {
			startApp(package->toJsonString(), ip);
			delete package;
		}
	} else if (type == TVU_GAME_STATUE) {
//		LOGE("phone tcp 游戏状态");
		JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
				true);
		if (package != NULL) {
			string sact = package->getData(TVU_PKG_GAMESTATUE_ACT);
			int act = atoi(sact.c_str());
			gameStatue(act, package->getData(TVU_PKG_GAMESTATUE_PKG), ip);
			delete package;
		}
	} else if (type == TVU_OPERATION_HINT) {
//		LOGE("phone tcp 操控指示");
		JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
				true);
		if (package != NULL) {
			string sact = package->getData(TVU_PKG_GAMESTATUE_ACT);
			int act = atoi(sact.c_str());
			contralTag(act, ip);
			delete package;
		}
	} else if (type == TVU_EXIT_GAME) {
//		LOGE("phone tcp 退出游戏");
		JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
				true);
		if (package != NULL) {
			exitGame(ip);
			delete package;
		}
	} else if (type == TVU_CHECK_LOCATION) {
//		LOGE("phone tcp 坐标校正");

	} else if (type == TVU_HEARTBEAT_) {
//		LOGE("phone tcp 心跳");
	} else if (type == TVU_MYGAME_INFO) {
		JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
				true);
		if (package != NULL) {
			startAllGame(package->toJsonString(), ip);
			delete package;
		}
    } else if (type == TVU_GET_TV_SPEED) {
        JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
                                                              true);
        if (package != NULL) {
            string total = package->getData(TVU_PKG_GAME_SPEED_TOTAL);
            string cur = package->getData(TVU_PKG_GAME_SPEED_CUR);
            string last = package->getData(TVU_PKG_GAME_SPEED_LAST);
            string action = package->getData(TVU_PKG_GAME_SPEED_ACTION);
            int iaction = atoi(action.c_str());
            getSpeedInfoFromTv(total, cur, last, iaction);
            delete package;
        }
    }
    else if (type == TVU_GET_GAME_INSATLLED)
    {
        JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
                                                              true);
        if (package != NULL)
        {
            string pkg = package->getData(TVU_GAME_INSTALLED_PKG_NAME);
            string sstatue = package->getData(TVU_GAME_INSTALLED);
            string sid = package->getData(TVU_PKG_GAME_STATUE_ID);
            int statue = atoi(sstatue.c_str());
            int id = atoi(sid.c_str());
            getGameInstalled(ip, pkg, statue, id);
            delete package;
        }
    }
    else if (type == TVU_USE_STATE) {
//        LOGE("phone tcp 部署信息 = %s",buf+4);
        JsonPackage *package = (JsonPackage*) Package::decode(buf, buflen, flag,
                                                              true);
        if (package != NULL) {
            string sstate = package->getData(TVU_PKG_USE_STATE);
            int state = atoi(sstate.c_str());
            getUseState(state);
            delete package;
        }
    }
    else
    {
		printf("phone tcp 未知事件");
	}
}
    




    
    
void revDomainData(unsigned char *buf, int buflen, string domainName) {
//	int type = parseType(buf, buflen);
	//解析ip信息转发至相应的手机
//	LOGE("domain 未知事件");
}
void breakConWithIp(int ip, int port) {
	breakDev(ip, port);
}
}

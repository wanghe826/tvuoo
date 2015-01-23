#include "Package.h"
#include "MouseEventPkg.h"
#include "OperationHintPkg.h"
#include "MouseMovePkg.h" 
#include "MouseDownPkg.h"
#include "KeyEventPkg.h"
#include "MultiTouchPkg.h"
#include "PushInputPkg.h"
#include "SensorEventPkg.h"
#include "HeartBeatPkg.h"
#include "JsonPackage.h" 
#include <iostream>
using namespace std;
//父类的构造函数和虚析构函数
Package::Package()
{
	m_type = 0;
	m_length = 0;
	m_addr = 0;
//	cout << "父类的空构造函数" << endl;
}  
Package::Package(u_short type, u_short length):m_type(type), m_length(length)
{
	m_addr = 0;
//	cout <<"没有ip的构造函数" << endl;
}
Package::Package(u_short type, u_short length, u_int addr):m_type(type), m_length(length), m_addr(addr)
{
//	cout << "父类的构造函数， 初始化包头部分" << endl;
}
Package::~Package()
{
}
/*****************************************
const unsigned int TVU_BROADCAST_MESSAGE_ = 0x0000;
const unsigned int TVU_PHONE_DEVICE_DETAIL_ = 0x0001;
const unsigned int TVU_MOUSE_MOVE_ = 0x0002;
const unsigned int TVU_MOUSE_DOWN_ = 0x0003;
const unsigned int TVU_MOUSE_UP_DOWN_ = 0x0004;
const unsigned int TVU_KEY_EVENT_ = 0x0005;
const unsigned int TVU_INPUT_METHOD_EVENT_ = 0x0006;
const unsigned int TVU_SENSOR_EVENT_ = 0x0007;
const unsigned int TVU_MULTI_POINT_ = 0x0008;
const unsigned int TVU_PAY_RESUTL_ = 0x0009;
const unsigned int TVU_GAME_STATUE_ = 0x000A;
const unsigned int TVU_HEARTBEAT_ = 0x000B;
******************************************/
 // 处理二进制类型 
Package* Package::decode(void* buff, int length,int &flag, bool exist)  	//flag 值代表返回状态    
{
	int hasIp = 0;
	if(exist)
	{
		hasIp = 1;
	}
	else
	{
		hasIp = 0;
	}
	
	if(length < (sizeof(u_short) + sizeof(u_short)))
	{
		flag = -1;												//没有解析 
		return NULL;
	}

	Package* package = NULL;
	u_short type = *((u_short*)buff);
	u_short pkgLen = *((u_short*)((char*)buff+sizeof(u_short)));    //wh_
	if(length < pkgLen)											
	{
		flag = -1; 											//缓冲区不够整包的长度， 直接返回0； 
		return NULL;
	}
	
	switch(type)
	{
		case TVU_MOUSE_EVENT_:					//固定没有ip 
			package = new MouseEventPkg();
			break;
		case TVU_HEARTBEAT_:
			package = new HeartBeatPkg();
			break;
		case TVU_MOUSE_MOVE_:
			package = new MouseMovePkg();
			break;
		case TVU_MOUSE_DOWN_:
			package = new MouseDownPkg();
			break;
		case TVU_KEY_EVENT_:
		case TVU_SIMULATOR_CODE_:
			package = new KeyEventPkg();
			break;
		case TVU_SENSOR_EVENT_:
			package = new SensorEventPkg();
			break;
		case TVU_MULTI_POINT_:
			package = new MultiTouchPkg();
			break;
		case TVU_OPERATION_HINT:
			package = new OperationHintPkg();
			break;
		case TVU_BROADCAST_MESSAGE_:    //握手信息       固定没有ip
		case TVU_INPUT_METHOD_EVENT_:	//               固定没有ip 
		case TVU_START_GAME:			//游戏启动       固定没有ip
		case TVU_START_PAY:				//支付信息发起   固定没有ip 
		case TVU_GAME_STATUE_:			//游戏信息       固定没有ip 
		case TVU_APP_SPREAD:			//手机下载推广   固定没有ip 
		case TVU_EXIT_GAME:				//退出游戏       固定没有ip 
		case TVU_MYGAME_INFO_:
		case TVU_PAY_RESUTL_:			//支付结果
		case TVU_PHONE_DEVICE_DETAIL_:  //手机设备信息			固定需要ip
		case TVU_TV_DEVICE_DETAIL:		//电视设备信息			固定需要ip 
		case TVU_GRAVITY_CHECK_RESULT:  //重力校正结果			固定需要ip 
		case TVU_ARRANGE_MESSAGE:		//部署信息				固定需要ip 
		case TVU_GAME_STATUE:			//游戏状态信息
		case TVU_CHECK_LOCATION:		//坐标校正       固定不需要ip 
		case TVU_PHONE_BREAK:
		case TVU_MYGAME_INFO:
		case TVU_INIT_INFO:
        case TVU_GET_TV_SPEED:
        case TVU_GET_GAME_INSATLLED:
        case TVU_USE_STATE_:
        case TVU_USE_STATE:
			package = new JsonPackage();
			break;
		default:
			//处理脏数据 
			return NULL;
	}
	
	int sizeOfHeader = package -> decodeHeader(buff, length, hasIp);       			  //解析的Header字节数 
	int sizeOfBody = package -> decodeBody((char*)buff+sizeOfHeader, length-sizeOfHeader);   //解析的Body字节数    wh_
	
	if(length < (sizeOfHeader + sizeOfBody))
	{
		return NULL;
	}
	flag = 1;
	return package;
}
int Package::decodeHeader(void* buff, int length,  int flag)
{
	
	int size = sizeof(u_short);
	int sz = size*2 + sizeof(u_int);
	if(buff==NULL || length<size*2)
	{
		return 0;
	}
	 
	if(flag==1)				//有ip信息 
	{
		if(length < sz)
		{
			return 0;
		}
		u_short type = *((u_short*)buff);
		u_short leng = *((u_short*)((char*)buff + size));
		
		this->m_type = type;
		this->m_length = leng;
		
		unsigned int addr = *((unsigned int*)((char*)buff + size*2));   //wh_
		this->m_addr = addr;
		return sz;
	}
	else
	{
//		u_short type = *((u_short*)buff);
//		u_short length = *((u_short*)((char*)buff + size));             //wh_
		
		return size*2;
	}
}


int Package::encode(void* buff, int length, bool exist)
{
//	int size_of_uShort = sizeof(u_short);
//	int size_of_uInt = sizeof(u_int);
	if(length < (this -> getPkgLength()))
	{
		return 0;								//buff的长度不够， 直接返回0，  没有打包 
	}
	
	int lenHeader = this -> encodeHeader(buff,length,exist);
	int lenBody = this -> encodeBody((char*)buff + lenHeader, length-lenHeader);        //wh_
	*((u_short*)((char*)buff+sizeof(u_short))) = lenHeader + lenBody;                   //wh_
	return lenHeader + lenBody;
}

int Package::encodeHeader(void* buff, int length, bool exist)
{
	int size_u_short = sizeof(u_short);
	int size_u_int = sizeof(u_int);
	if(length < (size_u_short*2))
	{
		return 0;
	}
	
	*((u_short*)buff) = m_type;
		
//	*((u_short*)(buff + size_u_short)) = m_length;
		
	if(!exist)														//如果没有IP 
	{
		return size_u_short * 2;
	}
	*((unsigned int*)((char*)buff + size_u_short*2)) = m_addr;      //wh_
	
	return size_u_short*2+size_u_int;		
}



 
int Package::decodeBody(void* buff, int length)
{
//	cout << "调用Package的decodeBody方法" << endl;
    return 0;
}

int Package::encodeBody(void* buff, int length)
{
//	cout << "调用父类的虚函数" << endl;
    return 0;
}


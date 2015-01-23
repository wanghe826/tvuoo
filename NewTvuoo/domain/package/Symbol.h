#ifndef SYMBOL_H
#define SYMBOL_H
#include <string>
#include <cstddef>
using namespace std;
typedef unsigned short u_short;
typedef unsigned int u_int;

//this platform   float 4 byte     unsigned short 2 byte;

//phone ---> TV   ( 后缀 —)
const unsigned int TVU_BROADCAST_MESSAGE_ = 0x0000;
const unsigned int TVU_PHONE_DEVICE_DETAIL_ = 0x0001;
const unsigned int TVU_MOUSE_MOVE_ = 0x0002;
const unsigned int TVU_MOUSE_DOWN_ = 0x0003;
const unsigned int TVU_MOUSE_EVENT_ = 0x0004;
const unsigned int TVU_KEY_EVENT_ = 0x0005;
const unsigned int TVU_INPUT_METHOD_EVENT_ = 0x0006;
const unsigned int TVU_SENSOR_EVENT_ = 0x0007;
const unsigned int TVU_MULTI_POINT_ = 0x0008;
const unsigned int TVU_PAY_RESUTL_ = 0x0009;
const unsigned int TVU_GAME_STATUE_ = 0x000A;
const unsigned int TVU_HEARTBEAT_ = 0x000B;
const unsigned int TVU_SIMULATOR_CODE_ = 0x000C;
const unsigned int TVU_MYGAME_INFO_ = 0x000D;
const unsigned int TVU_PHONE_BREAK = 0x000E;
const unsigned int TVU_EXIT_GAME_ = 0x000F;
const unsigned int TVU_GET_GAME_INSATLLED_ = 0x0010;
const unsigned int TVU_GET_TV_SPEED_ = 0X0011;
const unsigned int TVU_PSP_MOVE_ = 0x0012;
const unsigned int TVU_APPINFO_ = 0x0013;
const unsigned int TVU_USE_STATE_ = 0x0014;

//TV ---> phone 
const unsigned int TVU_TV_DEVICE_DETAIL = 0x8001;
const unsigned int TVU_INPUT_METHOD_SHOW = 0x8002;
const unsigned int TVU_START_GAME = 0x8003; //start game ,   if null ip,  sent to all  phone
const unsigned int TVU_GRAVITY_CHECK_RESULT = 0x8004;
const unsigned int TVU_ARRANGE_MESSAGE = 0x8005;
const unsigned int TVU_START_PAY = 0x8006;
const unsigned int TVU_APP_SPREAD = 0x8007;
const unsigned int TVU_GAME_STATUE = 0x8008;
const unsigned int TVU_OPERATION_HINT = 0x8009;
const unsigned int TVU_EXIT_GAME = 0x800A;
const unsigned int TVU_CHECK_LOCATION = 0x800B;
const unsigned int TVU_MYGAME_INFO = 0x800C;
const unsigned int TVU_INIT_INFO = 0x800D;
const unsigned int TVU_GET_GAME_INSATLLED = 0x800E;
const unsigned int TVU_GET_TV_SPEED = 0X800F;
const unsigned int TVU_USE_STATE = 0x8010;



//const string TVU_PACKAGE_MAPNAME_TAG = "tag"; //固定值TVUOO
//const string TVU_PACKAGE_MAPNAME_NAME = "name"; //device 名
//const string TVU_PACKAGE_MAPNAME_MAC = "mac"; //device mac
//const string TVU_PACKAGE_MAPNAME_TEXT = "text"; //握手包响应的文字信息，输入框文字信息
//const string TVU_PACKAGE_MAPNAME_CODE = "code"; //按键组合码
//const string TVU_PACKAGE_MAPNAME_PNAME = "pName"; //商品名称
//const string TVU_PACKAGE_MAPNAME_DESC = "desc"; //商品描述
//const string TVU_PACKAGE_MAPNAME_CPNAME = "CPNAME"; //开发商名称
//const string TVU_PACKAGE_MAPNAME_RESERVE = "reserve"; //预留
//const string TVU_PACKAGE_MAPNAME_SIGN = "sign"; //签名数据
//const string TVU_PACKAGE_MAPNAME_RESULTSTRING = "resultstring"; //支付结果显示文字
//const string TVU_PACKAGE_MAPNAME_PKGNAME = "pkgName"; //游戏包名
//const string TVU_PACKAGE_MAPNAME_GAMEID = "gameID"; //游戏id
//const string TVU_PACKAGE_MAPNAME_GAMEINFO = "gameInfo"; //本地已安装游戏信息

//握手信息 0x0000 
const static string TVU_PKG_HAND_TYPE = "type"; //设备标识
const static string TVU_PKG_HAND_TAG = "tag"; //固定值TVUOO 
const static string TVU_PKG_HAND_NAME = "name"; //设备名，eg. 乐视 
const static string TVU_PKG_HAND_SERVERPORT = "serverport"; //tcp 端口 
const static string TVU_PKG_HAND_UDPPORT = "udpport"; //udp 端口

//握手信息0x0001
const static string TVU_PKG_HAND1_VS = "vs"; //版本号
const static string TVU_PKG_HAND1_DEVNAME = "devName"; //设备名字
const static string TVU_PKG_HAND1_MINVS = "minVs"; //最低支持版本
const static string TVU_PKG_HAND1_MAC = "mac"; //mac 地址
const static string TVU_PKG_HAND1_TAG = "tag"; //固定值TVUOO

//输入法数据 0x0006
const static string TVU_PKG_INPUT_TEXT = "text"; //输入法数据信息
const static string TVU_PKG_INPUT_ACT = "act"; //输入法操作码， 0清空， 1修改

// 支付结果 0x0009
//const static string TVU_PKG_PAYRET_PAYINFO = "payinfo"; 
const static string TVU_PKG_PAYRET_PAYRESULT = "pay_result"; //0 成功， 1 失败
const static string TVU_PKG_PAYRET_TOTAL_FEE = "total_fee"; //交易成功的金额
const static string TVU_PKG_PAYRET_SUBJECT = "subject"; //商品名称

//游戏信息0x000A
const static string TVU_PKG_GAME_ACT = "game_act"; //0启动， 1下载....2安装
const static string TVU_PKG_GAME_GAMEINFO = "gameinfo"; //游戏信息
const static string TVU_PKG_GAME_GAMEPKG = "gamepkg"; //游戏包名

//获取游戏状态TVU_GET_GAMESTATUE_
const static string TVU_PKG_GAME_STATUE_TYPE = "statue_apptype"; //0启动， 1下载....2安装
const static string TVU_PKG_GAME_STATUE_ID = "statue_gameid"; //0启动， 1下载....2安装
const static string TVU_PKG_GAME_STATUE_PKG = "statue_gamepkg"; //游戏信息

//获取加速情况
const static string TVU_PKG_GAME_SPEED_GET = "spped_get";
const static string TVU_PKG_USE_STATE = "use_state";

// 电视设备信息  0x8001
const static string TVU_PKG_TV_TAG = "tag"; //固定值TVUOO
const static string TVU_PKG_TV_NAME = "name"; //电视设备名
const static string TVU_PKG_TV_MAC = "mac"; //设备mac地址
const static string TVU_PKG_TV_WIDTH = "width"; //设备宽度
const static string TVU_PKG_TV_HEIGHT = "height"; //设备高度
const static string TVU_PKG_TV_CANADB = "canadb"; //是否可以adb 0否， 1是
const static string TVU_PKG_TV_ISROOT = "isroot"; //是否root 0否， 1是
const static string TVU_PKG_TV_CAPA = "capa"; //性能  1中 2低 3高
const static string TVU_PKG_TV_PLAYER = "player"; //第几个用户
const static string TVU_PKG_TV_DEVICEID = "deviceid"; //设备自定义id 0 defalut 1ali 2xiaomi

//游戏启动 0x8003
const static string TVU_PKG_START_PKGNAME = "pkgname";
const static string TVU_PKG_START_ACT = "act"; //所启动的游戏类型
const static string TVU_PKG_START_GAMENAME = "gamename";

//重力校正结果 0x8004
const static string TVU_PKG_CHECKSENSOR_SENSORON = "sensoron"; //activity方向，java端获取
const static string TVU_PKG_CHECKSENEOR_ROTATION = "rotation";
const static string TVU_PKG_CHECKSENSOR_DATA = "data";

//部署信息 0x8005
const static string TVU_PKG_DEPLOY_ISPASS = "ispass"; //0未启动touch.jar，1启动

//支付信息发起 0x8006
const static string TVU_PKG_STARTPAY_SUBJECT = "subject"; //商品名称
const static string TVU_PKG_STARTPAY_BODY = "body"; //商品描述
const static string TVU_PKG_STRATPAY_TOTAL_FEE = "total_fee"; //交易金额
const static string TVU_PKG_STARTPAY_PAY_TYPE = "pay_type"; //交易方式 0阿里， 1移动MM， 2.。。。
const static string TVU_PKG_STARTPAY_PAYINFO = "payinfo";

//所有游戏信息
const static string TVU_PKG_ALLGAMEINFO = "allgameinfo";

//手机下载推广
const static string TVU_PKG_DOWN_ACT = "act"; //下载方式
const static string TVU_PKG_DOWN_APPINFO = "appinfo"; //app信息

//游戏状态信息0x8008
const static string TVU_PKG_GAMESTATUE_ACT = "act"; //关闭，启动，死亡，下一关等等
const static string TVU_PKG_GAMESTATUE_PKG = "pkg"; //游戏包名

//退出游戏 0x800A
const static string TVU_PKG_EXITGAME_FLAG = "falg";

//坐标校正 0x800B
const static string TVU_PKG_CHECKLOC = "list";

//游戏状态是否已安装TVU_GET_GAME_INSATLLED
const static string TVU_GAME_INSTALLED = "isinstalled";
const static string TVU_GAME_INSTALLED_PKG_NAME = "install_pkgname";

//获取加速情况信息
const static string TVU_PKG_GAME_SPEED_TOTAL = "speed_total";
const static string TVU_PKG_GAME_SPEED_CUR = "speed_cur";
const static string TVU_PKG_GAME_SPEED_LAST = "speed_last";
const static string TVU_PKG_GAME_SPEED_ACTION = "speed_action";

const static string STRINGNames[] = { TVU_PKG_HAND1_DEVNAME,
		TVU_PKG_STARTPAY_PAYINFO, TVU_PKG_DOWN_APPINFO, TVU_PKG_START_PKGNAME,
		TVU_PKG_START_GAMENAME, TVU_PKG_GAMESTATUE_PKG, TVU_PKG_GAME_STATUE_PKG,
		TVU_GAME_INSTALLED_PKG_NAME, TVU_PKG_GAME_GAMEPKG,
		TVU_PKG_GAME_SPEED_TOTAL, TVU_PKG_GAME_SPEED_CUR,
		TVU_PKG_GAME_SPEED_LAST,TVU_PKG_HAND_NAME,TVU_PKG_HAND1_MAC,TVU_PKG_HAND_TAG};
const static string TVU_PKG_START_GAMELIMIT = "gamelimit";

const static string TVU_PKG_APP_ACT = "app_act"; //0启动， 1下载....2安装
const static string TVU_PKG_APP_APPINFO = "app_info"; //游戏信息
const static string TVU_PKG_APP_APPPKG = "app_pkg"; //游戏包名

#endif


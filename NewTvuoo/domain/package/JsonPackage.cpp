#include "JsonPackage.h"
#include "../jsoncpp/include/json/json.h"


int JsonPackage::encodeBody(void* buff, int length)
{
    string json = toJsonString();
    int lengOfString = json.length();
    if(lengOfString > length)
    {
        return 0;
    }
    strcpy((char*)buff, json.c_str());
    return lengOfString;
}
int JsonPackage::decodeBody(void* buff, int length)
{
    string json = (char*)buff;
    fromJsonString(json);
    return json.length();
}

void JsonPackage::fromJsonString(string json)
{
    Json::Reader reader;
    Json::Value value;
    if(!reader.parse(json, value))
    {
        //		cout << "不是合法的json" << endl;
        return;
    }
    Json::Value::Members members(value.getMemberNames());
    
    
    for (Json::Value::Members::iterator it = members.begin(); it != members.end(); ++it)
    {
        const std::string &key = *it;
        
        if(!key.compare(TVU_PKG_HAND_TYPE))
        {
            addData(TVU_PKG_HAND_TYPE, value[TVU_PKG_HAND_TYPE].toStyledString());
        }
        else if(!key.compare(TVU_PKG_HAND_TAG))
        {
            addData(TVU_PKG_HAND_TAG, value[TVU_PKG_HAND_TAG].asString());
        }
        else if(!key.compare(TVU_PKG_HAND_NAME))
        {
            addData(TVU_PKG_HAND_NAME, value[TVU_PKG_HAND_NAME].asString());
        }
        else if(!key.compare(TVU_PKG_HAND_SERVERPORT))
        {
            addData(TVU_PKG_HAND_SERVERPORT, value[TVU_PKG_HAND_SERVERPORT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_HAND_UDPPORT))
        {
            addData(TVU_PKG_HAND_UDPPORT, value[TVU_PKG_HAND_UDPPORT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_HAND1_VS))
        {
            addData(TVU_PKG_HAND1_VS, value[TVU_PKG_HAND1_VS].toStyledString());
        }
        else if(!key.compare(TVU_PKG_HAND1_DEVNAME))
        {
            addData(TVU_PKG_HAND1_DEVNAME, value[TVU_PKG_HAND1_DEVNAME].asString());
        }
        else if(!key.compare(TVU_PKG_HAND1_MINVS))
        {
            addData(TVU_PKG_HAND1_MINVS, value[TVU_PKG_HAND1_MINVS].toStyledString());
        }
        else if(!key.compare(TVU_PKG_HAND1_MAC))
        {
            addData(TVU_PKG_HAND1_MAC, value[TVU_PKG_HAND1_MAC].asString());
        }
        else if(!key.compare(TVU_PKG_HAND1_TAG))
        {
            addData(TVU_PKG_HAND1_TAG, value[TVU_PKG_HAND1_TAG].asString());
        }
        else if(!key.compare(TVU_PKG_INPUT_TEXT))
        {
            addData(TVU_PKG_INPUT_TEXT, value[TVU_PKG_INPUT_TEXT].asString());
        }
        else if(!key.compare(TVU_PKG_INPUT_ACT))
        {
            addData(TVU_PKG_INPUT_ACT, value[TVU_PKG_INPUT_ACT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_GAME_ACT))
        {
            addData(TVU_PKG_GAME_ACT, value[TVU_PKG_GAME_ACT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_GAME_GAMEINFO))		//json 嵌套
        {
            addData(TVU_PKG_GAME_GAMEINFO, value[TVU_PKG_GAME_GAMEINFO].toStyledString());
        }
        else if(!key.compare(TVU_PKG_TV_TAG))
        {
            addData(TVU_PKG_TV_TAG, value[TVU_PKG_TV_TAG].asString());
        }
        else if(!key.compare(TVU_PKG_TV_NAME))
        {
            addData(TVU_PKG_TV_NAME, value[TVU_PKG_TV_NAME].asString());
        }
        else if(!key.compare(TVU_PKG_TV_MAC))
        {
            addData(TVU_PKG_TV_MAC, value[TVU_PKG_TV_MAC].asString());
        }
        else if(!key.compare(TVU_PKG_TV_WIDTH))
        {
            addData(TVU_PKG_TV_WIDTH, value[TVU_PKG_TV_WIDTH].toStyledString());
        }
        else if(!key.compare(TVU_PKG_TV_HEIGHT))
        {
            addData(TVU_PKG_TV_HEIGHT, value[TVU_PKG_TV_HEIGHT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_TV_CANADB))
        {
            addData(TVU_PKG_TV_CANADB, value[TVU_PKG_TV_CANADB].toStyledString());
        }
        else if(!key.compare(TVU_PKG_TV_ISROOT))
        {
            addData(TVU_PKG_TV_ISROOT, value[TVU_PKG_TV_ISROOT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_TV_CAPA))
        {
            addData(TVU_PKG_TV_CAPA, value[TVU_PKG_TV_CAPA].toStyledString());
        }
        else if(!key.compare(TVU_PKG_TV_PLAYER))
        {
            addData(TVU_PKG_TV_PLAYER, value[TVU_PKG_TV_PLAYER].toStyledString());
        }
        else if(!key.compare(TVU_PKG_START_PKGNAME))
        {
            addData(TVU_PKG_START_PKGNAME, value[TVU_PKG_START_PKGNAME].asString());
        }
        else if(!key.compare(TVU_PKG_START_ACT))
        {
            addData(TVU_PKG_START_ACT, value[TVU_PKG_START_ACT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_START_GAMENAME))
        {
            addData(TVU_PKG_START_GAMENAME, value[TVU_PKG_START_GAMENAME].asString());
        }
        else if(!key.compare(TVU_PKG_CHECKSENSOR_SENSORON))
        {
            addData(TVU_PKG_CHECKSENSOR_SENSORON, value[TVU_PKG_CHECKSENSOR_SENSORON].toStyledString());
        }
        else if(!key.compare(TVU_PKG_CHECKSENEOR_ROTATION))
        {
            addData(TVU_PKG_CHECKSENEOR_ROTATION, value[TVU_PKG_CHECKSENEOR_ROTATION].toStyledString());
        }
        else if(!key.compare(TVU_PKG_CHECKSENSOR_DATA))
        {
            addData(TVU_PKG_CHECKSENSOR_DATA, value[TVU_PKG_CHECKSENSOR_DATA].asString());
        }
        else if(!key.compare(TVU_PKG_DEPLOY_ISPASS))
        {
            addData(TVU_PKG_DEPLOY_ISPASS, value[TVU_PKG_DEPLOY_ISPASS].toStyledString());
        }
        else if(!key.compare(TVU_PKG_DOWN_ACT))
        {
            addData(TVU_PKG_DOWN_ACT, value[TVU_PKG_DOWN_ACT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_DOWN_APPINFO))				//app信息
        {
            addData(TVU_PKG_DOWN_APPINFO, value[TVU_PKG_DOWN_APPINFO].asString());
        }
        else if(!key.compare(TVU_PKG_GAMESTATUE_ACT))
        {
            addData(TVU_PKG_GAMESTATUE_ACT, value[TVU_PKG_GAMESTATUE_ACT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_GAMESTATUE_PKG))
        {
            addData(TVU_PKG_GAMESTATUE_PKG, value[TVU_PKG_GAMESTATUE_PKG].asString());
        }
        else if(!key.compare(TVU_PKG_EXITGAME_FLAG))
        {
            addData(TVU_PKG_EXITGAME_FLAG, value[TVU_PKG_EXITGAME_FLAG].toStyledString());
        }
        else if(!key.compare(TVU_PKG_CHECKLOC))
        {
            addData(TVU_PKG_CHECKLOC,value[TVU_PKG_CHECKLOC].toStyledString());
        }
        else if(!key.compare(TVU_PKG_STARTPAY_SUBJECT))
        {
            addData(TVU_PKG_STARTPAY_SUBJECT, value[TVU_PKG_STARTPAY_SUBJECT].asString());
        }
        else if(!key.compare(TVU_PKG_STARTPAY_BODY))
        {
            addData(TVU_PKG_STARTPAY_BODY, value[TVU_PKG_STARTPAY_BODY].asString());
        }
        else if(!key.compare(TVU_PKG_STRATPAY_TOTAL_FEE))
        {
            addData(TVU_PKG_STRATPAY_TOTAL_FEE, value[TVU_PKG_STRATPAY_TOTAL_FEE].toStyledString());
        }
        else if(!key.compare(TVU_PKG_STARTPAY_PAY_TYPE))
        {
            addData(TVU_PKG_STARTPAY_PAY_TYPE, value[TVU_PKG_STARTPAY_PAY_TYPE].toStyledString());
        }
        else if(!key.compare(TVU_PKG_PAYRET_PAYRESULT))
        {
            addData(TVU_PKG_PAYRET_PAYRESULT, value[TVU_PKG_PAYRET_PAYRESULT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_PAYRET_TOTAL_FEE))
        {
            addData(TVU_PKG_PAYRET_TOTAL_FEE, value[TVU_PKG_PAYRET_TOTAL_FEE].toStyledString());
        }
        else if(!key.compare(TVU_PKG_PAYRET_SUBJECT))
        {
            addData(TVU_PKG_PAYRET_SUBJECT, value[TVU_PKG_PAYRET_SUBJECT].asString());
        }else if(!key.compare(TVU_PKG_ALLGAMEINFO))
        {
            addData(TVU_PKG_ALLGAMEINFO, value[TVU_PKG_ALLGAMEINFO].toStyledString());
        }else if(!key.compare(TVU_GAME_INSTALLED))
        {
            addData(TVU_GAME_INSTALLED, value[TVU_GAME_INSTALLED].toStyledString());
        }else if(!key.compare(TVU_PKG_GAME_STATUE_TYPE))
        {
            addData(TVU_PKG_GAME_STATUE_TYPE, value[TVU_PKG_GAME_STATUE_TYPE].toStyledString());
        }else if(!key.compare(TVU_PKG_GAME_STATUE_ID))
        {
            addData(TVU_PKG_GAME_STATUE_ID, value[TVU_PKG_GAME_STATUE_ID].toStyledString());
        }else if(!key.compare(TVU_PKG_GAME_STATUE_PKG))
        {
            addData(TVU_PKG_GAME_STATUE_PKG, value[TVU_PKG_GAME_STATUE_PKG].asString());
        }else if(!key.compare(TVU_GAME_INSTALLED_PKG_NAME))
        {
            addData(TVU_GAME_INSTALLED_PKG_NAME, value[TVU_GAME_INSTALLED_PKG_NAME].asString());
        }else if(!key.compare(TVU_PKG_GAME_SPEED_TOTAL))
        {
            addData(TVU_PKG_GAME_SPEED_TOTAL, value[TVU_PKG_GAME_SPEED_TOTAL].asString());
        }else if(!key.compare(TVU_PKG_GAME_SPEED_CUR))
        {
            addData(TVU_PKG_GAME_SPEED_CUR, value[TVU_PKG_GAME_SPEED_CUR].asString());
        }else if(!key.compare(TVU_PKG_GAME_SPEED_LAST))
        {
            addData(TVU_PKG_GAME_SPEED_LAST, value[TVU_PKG_GAME_SPEED_LAST].asString());
        }else if(!key.compare(TVU_PKG_GAME_SPEED_ACTION))
        {
            addData(TVU_PKG_GAME_SPEED_ACTION, value[TVU_PKG_GAME_SPEED_ACTION].toStyledString());
        }
        else if(!key.compare(TVU_PKG_START_GAMELIMIT))
        {
            addData(TVU_PKG_START_GAMELIMIT, value[TVU_PKG_START_GAMELIMIT].toStyledString());
        }
        else if(!key.compare(TVU_PKG_TV_DEVICEID))
        {
            addData(TVU_PKG_TV_DEVICEID, value[TVU_PKG_TV_DEVICEID].toStyledString());
        }else if(!key.compare(TVU_PKG_USE_STATE))
        {
            addData(TVU_PKG_USE_STATE, value[TVU_PKG_USE_STATE].toStyledString());
        }
    }
}
string JsonPackage::toJsonString()
{
    if(m_shakeHandMsg.empty())
    {
        cout << "empty" << endl;
        return "";
    }
    string json = "{";
    for (map<string, string>::iterator it = m_shakeHandMsg.begin(); it!=m_shakeHandMsg.end(); it++)
    {
        string name = it->first;
        string value = it->second;
        json = json+"\""+name+"\":";
        bool isInNames = false;
        for (int i = 0; i<sizeof(STRINGNames)/sizeof(STRINGNames[0]); i++)
        {
            if (!name.compare(STRINGNames[i]))
            {
                isInNames = true;
                break;
            }
        }
        if (isInNames/*&&name.compare(TVU_PACKAGE_MAPNAME_GAMEINFO)*/)
        {
            json = json+"\""+value+"\"";
        }
        else
        {
            json = json+value;
        }
        json = json+",";
    }
    json = string(json,0,strlen(json.c_str())-1);
    json = json + "}";
    return json;
}

void JsonPackage::addData(string key, string value)
{
    int size = key.length() + value.length();
    m_shakeHandMsg.insert(map<string, string>::value_type(key, value));
    //	m_length += size;
}

string JsonPackage::getData(string key)
{
    map<string, string>::iterator iter = m_shakeHandMsg.begin();
    for(; iter != m_shakeHandMsg.end(); ++iter)
    {
        
        if((iter->first) == key)
        {
            
            return iter->second;
        }
    }
    return "";
}
//构造函数
JsonPackage::JsonPackage(u_short type)
{
    m_type = type;
} 
JsonPackage::JsonPackage()
{
}

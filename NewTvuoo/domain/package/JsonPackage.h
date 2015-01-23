#ifndef JSON_PACKAGE_H_
#define JSON_PACKAGE_H_
#include "Symbol.h"
#include "Package.h"
#include <string>
#include <map>
using namespace std;
class JsonPackage: public Package
{
	public:
		//virtual 
		virtual int decodeBody(void* buff, int length);
		virtual int encodeBody(void* buff, int length);
		
		string toJsonString();
		void fromJsonString(string json);
		
		void addData(string key, string value);
		string getData(string key);
//		void removeData(string key);
		
//		static JsonPackage* decode(char* buff, int length);
//		int encode(char* buff, int length);
		
		//构造函数
		JsonPackage(u_short type); 
		JsonPackage();
		
		void setAddr(u_int ip)
		{
			m_addr = ip;
			m_length += sizeof(u_int);
		}
		u_int getAddr()
		{
			return m_addr;
		}
		u_short getType()
		{
			return m_type;
		}
		u_short getLength()
		{
			return m_length;
		}
	private:
		//包体 
		map<string, string> m_shakeHandMsg;
} ;
#endif

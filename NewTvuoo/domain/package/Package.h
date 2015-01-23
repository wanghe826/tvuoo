// base class 
#ifndef PACKAGE_H_
#define PACKAGE_H_

#include "Symbol.h"
#include <iostream>
#include <string>
using namespace std;
//class MouseMovePkg;
class Package
{
	protected:
		
		// 包头 
		u_short m_type;
		u_short m_length;
		u_int m_addr; 				 				//可能没有ip 
		
		
		int decodeHeader(void* buff, int length, int flag);				//返回已经解包的包头所占字节数 
		virtual int decodeBody(void* buff, int length);
		
		int encodeHeader(void* buff,int length, bool exist);			//返回已打包的包头所占字节数 
		virtual int encodeBody(void* buff, int length);		


	public:
		//解包
		static Package* decode(void* buff, int length,int &flag, bool exist);		//二进制的方式 
		
		//打包
		int encode(void* buff, int length, bool exist);					//二进制的方式     
		
//		void setPkgType(u_short type);
		u_short getPkgType() const
		{
			return m_type;
		}

//		void setPkgLength(u_short length);
		u_short getPkgLength() const
		{
			return m_length;
		}

		void setAddr(u_int addr)
		{
			m_addr = addr;
		}
		unsigned int getAddr() const
		{
			return m_addr;
		}
	
	
		Package();
		Package(u_short type, u_short length);
		Package(u_short type, u_short length, u_int addr);
		
		virtual ~Package(); 
		
		 
};
#endif

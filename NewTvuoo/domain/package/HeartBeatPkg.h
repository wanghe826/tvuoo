#ifndef HEART_BEAT_PKG_H_
#define HEART_BEAT_PKG_H_
#include "Package.h"
class HeartBeatPkg : public Package
{
	public:
		HeartBeatPkg();
		int decodeBody(void* buff, int length);
		int encodeBody(void* buff, int length);
		
//		void setAddr(u_int addr)
//		{
//			m_addr = addr;
//			m_length += ((sizeof(u_int)));
//		}
};

#endif

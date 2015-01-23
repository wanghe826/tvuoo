#ifndef PUSH_INPUT_PKG_H_
#define PUSH_INPUT_PKG_H_
#include "Package.h"
class PushInputPkg : public Package
{
	public:
		PushInputPkg();
		void setAddr(u_int addr)
		{
			m_addr = addr;
			m_length += ((sizeof(u_int)));
		}
		
		int decodeBody(void* buff, int length);
		int encodeBody(void* buff, int length);
};
#endif

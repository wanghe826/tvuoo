#ifndef OPERATION_HINT_PKG_H_
#define OPERATION_HINT_PKG_H_
#include "Package.h"
class OperationHintPkg : public Package
{
	public:
		OperationHintPkg();
//		void setAddr(u_int addr)
//		{
//			m_addr = addr;
//			m_length += ((sizeof(u_int)));
//		}
		
	private:
		int m_act ;			//操控指示
	public:
		void setAct(int act)
		{
			m_act = act;
		} 
		int getAct() const
		{
			return m_act;
		}
		
		int encodeBody(void*buff, int length);
		int decodeBody(void*buff, int length);
};
#endif

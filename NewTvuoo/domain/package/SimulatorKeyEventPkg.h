#ifndef SIMULATOR_KEY_EVENT_PKG_H_
#define SIMULATOR_KEY_EVENT_PKG_H_

#include "Package.h"
#include "Symbol.h"

class SimulatorKeyEventPkg : public Package
{
	private:
		int m_act;
		int m_code;
		int m_flag;
	public:
		SimulatorKeyEventPkg();
		
		int decodeBody(void* buff, int length);
		int encodeBody(void* buff, int length);
		
		void setAct(int act)
		{
			m_act = act;
		}
		int getAct()
		{
			return m_act;
		}
		
		void setCode(int code)
		{
			m_code = code;
		}
		int getCode()
		{
			return m_code;
		}
		
		void setType(int type)
		{
			m_flag = type;
		}
		int getType()
		{
			return m_flag;
		}
		
		
//		void setAddr(u_int addr)
//		{
//			m_addr = addr;
//			m_length += ((sizeof(u_int)));
//		}
};
#endif

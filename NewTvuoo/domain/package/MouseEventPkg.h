#ifndef MOUSE_EVENT_PKG_H_
#define MOUSE_EVENT_PKG_H_

#include "Package.h"
#include "Symbol.h"

class MouseEventPkg : public Package		//鼠标事件 0x0004
{
	private:
		float m_x;
		float m_y;
		int m_act; 	   	// 0表示按下  1表示抬起
		int m_flag;
	public:
		MouseEventPkg();
		void setAddr(u_int addr)
		{
			m_addr = addr;
			m_length += ((sizeof(u_int)));
		}
		void setX(float x)
		{
			m_x = x;
		}
		float getX()
		{
			return m_x;
		}
		
		void setY(float y)
		{
			m_y = y;
		}
		float getY()
		{
			return m_y;
		}
		
		void setAct(int act)
		{
			m_act = act;
		}
		int getAct()
		{
			return m_act;
		}
		
		void setFlag(int flag)
		{
			m_flag = flag;
		}
		int getFlag()
		{
			return m_flag;
		}
		
		int decodeBody(void* buff, int length);
		int encodeBody(void* buff, int length);
};
#endif

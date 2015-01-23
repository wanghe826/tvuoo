#ifndef MOUSE_DOWN_PKG_H_
#define MOUSE_DOWN_PKG_H_
#include "Symbol.h"
#include "Package.h"
class MouseDownPkg : public Package     //鼠标移动   左键按下 
{
	private:
		float m_x, m_y;
		
	public:
		void setX(float x);
		void setY(float y);
		
		float getX();
		float getY();
		
		int decodeBody(void* buff, int length);
		int encodeBody(void* buff, int length);
		
		MouseDownPkg(); 
		
		void setAddr(u_int addr)
		{
			m_addr = addr;
			m_length += ((sizeof(u_int)));
		}		
};

#endif

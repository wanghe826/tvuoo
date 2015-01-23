#ifndef PSP_MOVE_PKG_H_
#define PSP_MOVE_PKG_H_

#include "Package.h"
#include "Symbol.h"
#include <iostream>
using namespace std;
class PspMovePkg : public Package			//鼠标移动  左键未按下
{
	private:
		float m_x, m_y;
	public:
		void setX(float x);
		float getX();
		
		void setY(float y);
		float getY();

	public:
		int decodeBody(void* buff, int length);
		int encodeBody(void* buff, int length);
		
		//构造函数
		void setAddr(u_int addr)
		{
			m_addr = addr;
			m_length += ((sizeof(u_int)));
		}
		PspMovePkg();

};

#endif

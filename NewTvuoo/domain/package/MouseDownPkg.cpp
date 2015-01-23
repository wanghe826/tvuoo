#include "MouseDownPkg.h"

MouseDownPkg::MouseDownPkg()
{
	m_type = TVU_MOUSE_DOWN_;
	m_length = (((sizeof(u_short))*2 + ((sizeof(float))*2))); 
} 



//成员变量的get 和 set方法 
void MouseDownPkg::setX(float x)
{
	m_x = x;
}
float MouseDownPkg::getX()
{
	return m_x;
}

void MouseDownPkg::setY(float y)
{
	m_y = y;
}
float MouseDownPkg::getY()
{
	return m_y;
}

//virtual   覆盖父类的虚函数
int MouseDownPkg::decodeBody(void* buff, int length)
{
	int size = sizeof(float);
	if(length < size*2)
	{
		return 0;
	}
	float x = *((float*)buff);
	setX(x);

	float y = *((float*)((char*)buff + sizeof(float)));
	setY(y);
	return size*2;
} 

int MouseDownPkg::encodeBody(void* buff, int length)
{
	int size = sizeof(float);
    
	if(length < size*2)
	{
		return 0;
	}
	*((float*)buff) = m_x;
	*((float*)((char*)buff + size)) = m_y;
	return size*2;
}


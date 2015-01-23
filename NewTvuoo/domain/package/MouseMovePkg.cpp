#include "MouseMovePkg.h"

MouseMovePkg::MouseMovePkg()
{
	m_type = TVU_MOUSE_MOVE_;
	m_length = (((sizeof(u_short))*2 + ((sizeof(float))*2))); 
}


int MouseMovePkg::decodeBody(void* buff, int length)
{
	int size = sizeof(float);
	if(length < (size*2))
	{
		return 0;
	}

	float x = *((float*)(buff));
	setX(x);

	float y = *((float*)((char*)buff + sizeof(float)));  //wh_
	setY(y);
	
	return size*2;
}

int MouseMovePkg::encodeBody(void* buff, int length)
{
	int size = (sizeof(float))*2;
	if(length < size)
	{
		return 0;
	}
	*((float*)buff) = m_x;
	*((float*)((char*)buff + sizeof(float))) = m_y;   //wh_
//    
//	cout << "调用MouseMovePkg的encodeBody方法" << endl;
	return size;
}

float MouseMovePkg::getX()
{
	return m_x;
}
void MouseMovePkg::setX(float x)
{
	m_x = x;
}

float MouseMovePkg::getY()
{
	return m_y;
}
void MouseMovePkg::setY(float y)
{
	m_y = y;
}

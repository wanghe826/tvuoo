#include "PspMovePkg.h"

PspMovePkg::PspMovePkg()
{
	m_type = TVU_PSP_MOVE_;
	m_length = (((sizeof(u_short))*2 + ((sizeof(float))*2))); 
}


int PspMovePkg::decodeBody(void* buff, int length)
{
	int size = sizeof(float);
	if(length < (size*2))
	{
		return 0;
	}

	float x = *((float*)(buff));
	setX(x);

	float y = *((float*)((char*)buff + sizeof(float)));
	setY(y);
	
	return size*2;
}

int PspMovePkg::encodeBody(void* buff, int length)
{
	int size = (sizeof(float))*2;
	if(length < size)
	{
		return 0;
	}
	*((float*)buff) = m_x;
	*((float*)((char*)buff + sizeof(float))) = m_y;
	cout << "调用MouseMovePkg的encodeBody方法" << endl;
	return size;
}

float PspMovePkg::getX()
{
	return m_x;
}
void PspMovePkg::setX(float x)
{
	m_x = x;
}

float PspMovePkg::getY()
{
	return m_y;
}
void PspMovePkg::setY(float y)
{
	m_y = y;
}

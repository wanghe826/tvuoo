#include "MouseEventPkg.h"

MouseEventPkg::MouseEventPkg()
{
	m_type = TVU_MOUSE_EVENT_;
	m_length = (((sizeof(u_short))*2 + ((sizeof(float))*2) + ((sizeof(int))*2))); 
}

//覆盖父类的virtual
int MouseEventPkg::decodeBody(void* buff, int length)
{
	int size_of_float = sizeof(float);
	int size_of_int = sizeof(int);
	int size = size_of_float*2 + size_of_int*2;
	char* p = (char*)buff;
	
	if(length < size)
	{
		return 0;
	}
	m_x = *((float*)p);
	
	p += size_of_float;
	m_y = *((float*)p);
	
	p += size_of_float;
	m_act = *((int*)p);
	
	p += size_of_int;
	m_flag = *((int*)p);
	
	return size;
}

int MouseEventPkg::encodeBody(void* buff, int length)
{
	int size_of_float = sizeof(float);
	int size_of_int = sizeof(int);
	int size = size_of_float*2 + size_of_int*2;
	if(length < size)
	{
		return 0;
	}
	char *p = (char*)buff;
	*((float*)p) = m_x;
	
	p += size_of_float;
	*((float*)p) = m_y;
	
	p += size_of_float;
	*((int*)p) = m_act;
	
	p += size_of_int;
	*((int*)p) = m_flag;
	return size;
	
}  

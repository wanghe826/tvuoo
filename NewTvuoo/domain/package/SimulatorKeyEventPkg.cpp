#include "SimulatorKeyEventPkg.h"

SimulatorKeyEventPkg::SimulatorKeyEventPkg()
{
	m_type = TVU_SIMULATOR_CODE_;
	m_length = (((sizeof(u_short))*2 + ((sizeof(int))*3))); 
}

int SimulatorKeyEventPkg::decodeBody(void* buff, int length)
{
	int size_of_int = sizeof(int);
	if(length < size_of_int*3)			//body 长度不足一个body
	{
		return 0;
	}
	m_act = *((int*)buff);
	m_code = *((int*)((char*)buff + size_of_int));
	m_flag = *((int*)((char*)buff + (size_of_int*2)));
	return size_of_int*3;
}

int SimulatorKeyEventPkg::encodeBody(void* buff, int length)
{
	int size_of_int = sizeof(int);
	if(length < size_of_int * 3)
	{
		return 0;
	}
	char *p = (char*)buff;
	*((int*)buff) = m_act;

	p += size_of_int;
	*((int*)p) = m_code;

	p += size_of_int;
	*((int*)p) = m_flag;
	return size_of_int*3;
}

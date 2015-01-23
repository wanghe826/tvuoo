#include "SensorEventPkg.h"

SensorEventPkg::SensorEventPkg()
{
	m_type = TVU_SENSOR_EVENT_;
	m_length = ((sizeof(u_short))*2 + (sizeof(float))*3 + sizeof(int));
}

int SensorEventPkg::decodeBody(void* buff, int length)
{
	int size_of_float = sizeof(float);
	int size_of_int = sizeof(int);
	
	if(length < (size_of_float*3 + size_of_int))
	{
		return 0;
	}
	
	m_x = *((float*)buff);
	m_y = *((float*)((char*)buff + size_of_float));
	m_z = *((float*)((char*)buff + size_of_float + size_of_float));
	m_act = *((int*)((char*)buff + size_of_float*3));
	
	return size_of_float*3 + size_of_int;
}

int SensorEventPkg::encodeBody(void* buff, int length)
{
	int size_of_float = sizeof(float);
	int size_of_int = sizeof(int);
	int size = size_of_float*3 + size_of_int;
	if(length < size)
	{
		return 0;
	}
	
	*((float*)buff) = m_x;
	*((float*)((char*)buff + size_of_float)) = m_y;
	*((float*)((char*)buff + size_of_float*2)) = m_z;
	*((int*)((char*)buff + size_of_float*3)) = m_act; 
	return size;
}

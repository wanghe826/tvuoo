#include "OperationHintPkg.h"

int OperationHintPkg::decodeBody(void* buff, int length)
{
	if(length < sizeof(int))
	{
		return 0;
	}
	m_act = *((int*)buff);
	return sizeof(int);
}

int OperationHintPkg::encodeBody(void* buff, int length)
{
	if(length < sizeof(int))
	{
		return 0;
	}
	
	*((int*)buff) = m_act;
	return sizeof(int);
}

OperationHintPkg::OperationHintPkg()
{
	m_type = TVU_OPERATION_HINT;
	m_length = ((sizeof(u_short))*2 + sizeof(int));
}



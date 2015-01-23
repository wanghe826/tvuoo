#include "PushInputPkg.h"

PushInputPkg::PushInputPkg()
{
	m_type = TVU_INPUT_METHOD_SHOW;
	m_length = ((sizeof(u_short))*2);
}


int PushInputPkg::decodeBody(void* buff, int length)
{
	return 0;
}
int PushInputPkg::encodeBody(void* buff, int length)
{
	return 0;
}

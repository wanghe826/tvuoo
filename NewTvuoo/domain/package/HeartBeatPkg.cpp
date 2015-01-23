#include "HeartBeatPkg.h"

HeartBeatPkg::HeartBeatPkg()
{
	m_type = TVU_HEARTBEAT_;
	m_length = (sizeof(u_short) + sizeof(u_short));
}


int HeartBeatPkg::decodeBody(void* buff, int length)
{
	return 0;
}
int HeartBeatPkg::encodeBody(void* buff, int length)
{
	return 0;
}

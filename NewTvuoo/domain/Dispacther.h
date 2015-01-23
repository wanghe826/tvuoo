#ifndef TVU_DISPATCHER
#define TVU_DISPATCHER
#include <string.h>
#include <string>
using namespace std;
class Dispacther{
public:
	virtual void recUdpData(unsigned char *buf,int buflen,int ip)=0;//���udp���(����domain)
	virtual	void revTcpData(unsigned char *buf,int buflen,int ip,int port)=0;//���tcp���
	virtual	void revDomainData(unsigned char *buf,int buflen,string domainName)=0;//���tcp���
};

#endif

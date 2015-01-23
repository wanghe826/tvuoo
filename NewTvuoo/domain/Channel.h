#ifndef TVU_CHANNEL_NEW
#define TVU_CHANNEL_NEW
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<pthread.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/event.h>
#include <sys/wait.h>
#include <errno.h>
#include <time.h>
#include <fcntl.h>
#include <iostream>
#include <sstream>
#include <sys/event.h>
#include <arpa/inet.h>
#include <string>
#include <sys/un.h>
#include <netinet/tcp.h>

using namespace std;
#include "Dispacther.h"

#ifndef TVU_BUF_SIZE
#define TVU_BUF_SIZE	8192
#endif
enum{
	DOMAIN_TYPE,
	TCP_TYPE
};

class Channel{
private:
	int m_fd;
	int m_type;
	int m_ip;
	string m_name;
	unsigned char* m_buf;
	int remain;
	int m_port;
	long actTime;
	long sendActTime;

public:
	Channel(int fd, int ip, string name, int type,int port);
	~Channel();
	int getPort();
	int getFd();
	int getType();
	int getIp();
	string getName();
	void setPort(int port);
	void setFd(int fd);
	void setType(int type);
	void setIp(int ip);
	void setName(string name);
	int readData(Dispacther* dispacther);
	int parseTcpData(unsigned char* buf,int len);
	long checkRecActTime();
	long checkSendActTime();
	void updateActTime();
	void updateSendActTime();
};
#endif

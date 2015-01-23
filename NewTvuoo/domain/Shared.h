#ifndef TVU_SINGLETON
#define TVU_SINGLETON
#include "Channel.h"
#include "Dispacther.h"
#include <list>
#define MCAST_ADDR "224.0.0.100" /*一个局部连接多播地址，路由器不进行转发*/
 const unsigned short PORTS[] = {29527,40984,23481,46321,37633};
#ifndef PORT_COUNT
#define PORT_COUNT (sizeof(PORTS)/sizeof(PORTS[0]))
#endif
#define TVU_HEART_TIMEOUT 10
#define TVU_HEART 2
 enum run_statue{
     RUN_BEGAIN,
     RUN_INIT,
     RUNNING,
     RUN_CLOSE
 };

#define TVU_BROADCAST 2
class Shared{
private:
	static Shared* m_singleton;
	Shared();
public:
	static Shared* getInstance() {
		//获取唯一实例
		if (!m_singleton) {
			m_singleton = new Shared;
//			singleton = new Shared();
		}
		return m_singleton;
	}
//	Shared();
		~Shared();
	int init(Dispacther *dispatcher); //初始化epoll 信息 返回值<0 初始化epoll失败
//	int getPortWithFd(int fd); //根据fd查询 channels返回对应的端口号
//	int getIpWithFd(int fd);//根据fd查询 channels返回对应的ip，仅对tcpchannel有效
//	Channel getChannelWithFd(int fd);//根据fd直接查询出channel
	void closeAll(); //关闭所有连接
	void closeUdp(); //关闭单个连接
	void closeTcpClient(int ip,int port); //关闭tcp客户端
	void closeTcpServer(); //关闭tcp服务端
	void closeDomian(string name); //关闭domain socket
	void run(); //运行整个epoll机制
	int sendUdpData(int port, int ip, const char* buf, int buflen); //发送udp数据,返回-1发送失败,必须先调用addUdpServer成功后才会成功
	int sendTcpData(int port,int ip,const char* buf, int buflen); //发送tcp数据，返回-1发送失败
	int sendTcpWithIp(int ip,const char* buf,int buflen);//根据ip发送tcp数据，仅用于sdk和main
	int sendTcpForAll(const char* buf,int buflen);
	int sendDomainData(string domainName, const char* buf, int buflen); //发送domain数据，返回-1发送失败
	int addTcpServer(int port); //添加tcpsever，填入port，返回fd，返回-1添加失败
	int addUdpServer(int port, int type); //添加udpsever，填入port，返回fd，返回-1添加失败(是否加入type标识创建方式？组播接收or广播接收)
	int addDomainServer(string name); //添加domainsever，填入port，返回fd，返回-1添加失败
	int connectServer(int ip, unsigned short port); //连接服务端，填入服务端ip及端口号返回fd,返回-1连接失败
	int connectDomain(string name); //连接domain服务端,填入名称,返回-1连接失败
	unsigned short getUdpPort();
	unsigned short getTcpPort();
	string getDomainName();
	void sendPackageWithAll(const char* buf, int buflen);
	void checkAct(const char* buf, int buflen);
	int getRunStatue();
    void socketkeepalive(int sockfd);
private:
	int runStatue;
	pthread_mutex_t m_mutex;
	int m_epoll_fd;
	string m_domainServerName;
	int tcp_port, udp_port;
	int tcp_fd, udp_fd, domian_fd; //tcpserver最多存在一个，udpserver最多存在一个，domianserver最多存在一个
	unsigned char * m_readBuf, *m_readTcpBuf;

	Shared(const Shared&);
	Shared& operator=(const Shared&);
	list<Channel*> channels;
	Dispacther* m_dispatcher;
	int openPort(unsigned short port, int protocal);
	int setnonblocking(int sockfd);
	int socket_local_server_bind(int s, const char *name, int namespaceId);
	int socket_make_sockaddr_un(const char *name, int namespaceId,
			struct sockaddr_un *p_addr, socklen_t *alen);
	int socket_local_client_connect(int fd, const char *name, int namespaceId,
			int type);
	int addInEpoll(int fd);
	int closeListConWithFd(int fd);
	int deleteFdFromEpoll(int fd);

};
//Shared *Shared::m_singleton = NULL;
#endif

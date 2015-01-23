#include "Shared.h"
#include "MyJniTransport.h"

Shared *Shared::m_singleton = NULL;
Shared::Shared() {
	m_readBuf = (unsigned char*) (malloc(TVU_BUF_SIZE));
	bzero(m_readBuf, TVU_BUF_SIZE);

//	m_readTcpBuf = (unsigned char*) (malloc(TVU_BUF_SIZE));
//	bzero(m_readTcpBuf, TVU_BUF_SIZE);

	pthread_mutex_init(&m_mutex, NULL);
	m_epoll_fd = 0;
	m_domainServerName = "";
	tcp_fd = 0;
	udp_fd = 0;
	domian_fd = 0; //tcpserver最多存在一个，udpserver最多存在一个，domianserver最多存在一个
	channels.clear();
	runStatue = RUN_BEGAIN;
}

int Shared::socket_make_sockaddr_un(const char *name, int namespaceId,
		struct sockaddr_un *p_addr, socklen_t *alen) {
	memset(p_addr, 0, sizeof(*p_addr));
	size_t namelen;
	namelen = strlen(name);
	if ((namelen + 1) > sizeof(p_addr->sun_path)) {
		goto error;
	}
	p_addr->sun_path[0] = 0;
	memcpy(p_addr->sun_path + 1, name, namelen);
	p_addr->sun_family = AF_LOCAL;
	*alen = namelen + offsetof(struct sockaddr_un, sun_path) + 1;
	return 0;
	error: return -1;
}
int Shared::socket_local_server_bind(int s, const char *name,
		int namespaceId) {
	struct sockaddr_un addr;
	socklen_t alen;
	int n;
	int err;
	err = socket_make_sockaddr_un(name, namespaceId, &addr, &alen);
	if (err < 0) {
		return -1;
	}
	/* basically: if this is a filesystem path, unlink first */
	if (1) {
		/*ignore ENOENT*/
		unlink(addr.sun_path);
	}
	n = 1;
	setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &n, sizeof(n));
	if (bind(s, (struct sockaddr *) &addr, alen) < 0) {
		return -1;
	}
	return s;
}
int Shared::socket_local_client_connect(int fd, const char *name,
		int namespaceId, int type) {
	struct sockaddr_un addr;
	socklen_t alen;
	size_t namelen;
	int err;
	err = socket_make_sockaddr_un(name, namespaceId, &addr, &alen);
	if (err < 0) {
		goto error;
	}
	if (connect(fd, (struct sockaddr *) &addr, alen) < 0) {
		goto error;
	}
	return fd;
	error: return -1;
}

int Shared::init(Dispacther* dispatcher) {
//	printf("init");
	if (runStatue != RUN_BEGAIN) {
//		printf("please close then init");
		return -1;
	}
	m_dispatcher = NULL;
	if (dispatcher != NULL) {
		m_dispatcher = dispatcher;
	}
//	m_epoll_fd = epoll_create(20);
    m_epoll_fd = kqueue();
	if (m_epoll_fd < 0) {
//		printf("epoll create fail");
		return -1;
	}
	runStatue = RUN_INIT;
	return 1;
}

int Shared::deleteFdFromEpoll(int fd) {
	pthread_mutex_lock(&m_mutex);
	struct kevent ev;
	if (m_epoll_fd > 0) {
        EV_SET(&ev, fd, EVFILT_READ, EV_DELETE, 0, 0, NULL);
	}
	pthread_mutex_unlock(&m_mutex);
    return 1;
}

int Shared::closeListConWithFd(int fd) {
	pthread_mutex_lock(&m_mutex);
//	printf("closeListConWithFd");
	struct kevent ev;
	list<Channel*>::iterator v;
	for (v = channels.begin(); v != channels.end();) {
		list<Channel*>::iterator temp = v++;
		if (fd > 0 && fd == (*temp)->getFd()) {
			if (m_epoll_fd > 0) {
                EV_SET(&ev, fd, EVFILT_READ, EV_DELETE, 0, 0, NULL);
                kevent(m_epoll_fd, &ev, 1, NULL, 0, NULL);
			}
//			printf("close fd = %d", fd);
			if ((*temp) != NULL) {
				delete (Channel*) (*temp);
			}
			channels.erase(temp);
		}

	}
	pthread_mutex_unlock(&m_mutex);
    return 0;
}

void Shared::closeAll() {
//	printf("closeAll list size = %d", channels.size());
	struct kevent ev;
	list<Channel*>::iterator v;
	for (v = channels.begin(); v != channels.end();) {
		list<Channel*>::iterator temp = v++;
		closeListConWithFd((*temp)->getFd());
	}
	closeTcpServer();
	closeUdp();
	if (domian_fd > 0) {
		if (m_epoll_fd > 0) {
            EV_SET(&ev, domian_fd, EVFILT_READ, EV_DELETE, 0, 0, NULL);
            kevent(m_epoll_fd, &ev, 1, NULL, 0, NULL);
		}
		close(domian_fd);
		domian_fd = 0;
	}
	if (m_epoll_fd > 0) {
		close(m_epoll_fd);
		m_epoll_fd = 0;
	}
	runStatue = RUN_BEGAIN;

}
void Shared::closeUdp() {
	struct kevent ev;
	if (udp_fd > 0) {
		struct ip_mreq mreq; /*加入多播组*/
		mreq.imr_multiaddr.s_addr = inet_addr(MCAST_ADDR); /*多播地址*/
		mreq.imr_interface.s_addr = htonl(INADDR_ANY); /*网络接口为默认*/
		if (m_epoll_fd > 0) {
            EV_SET(&ev, udp_fd, EVFILT_READ, EV_DELETE, 0, 0, NULL);
            kevent(m_epoll_fd, &ev, 1, NULL, 0, NULL);
		}
		close(udp_fd);
		udp_fd = 0;
		udp_port = 0;

	}

}
void Shared::closeTcpClient(int ip, int port) {
	list<Channel*>::iterator v;
	for (v = channels.begin(); v != channels.end();) {
		list<Channel*>::iterator temp = v++;
		if ((*temp)->getIp() == ip && port == (*temp)->getPort()) {
			closeListConWithFd((*temp)->getFd());
		}
	}

}
void Shared::closeTcpServer() {
	struct kevent ev;
	if (tcp_fd > 0) {
		if (m_epoll_fd > 0) {
            EV_SET(&ev, tcp_fd, EVFILT_READ, EV_DELETE, 0, 0, NULL);
            kevent(m_epoll_fd, &ev, 1, NULL, 0, NULL);

		}
		close(tcp_fd);
		tcp_fd = 0;
		tcp_port = 0;
	}

}
void Shared::closeDomian(string name) {
	struct kevent ev;
	if (!name.compare(m_domainServerName) && domian_fd > 0) {
		if (m_epoll_fd > 0) {
            EV_SET(&ev, domian_fd, EVFILT_READ, EV_DELETE, 0, 0, NULL);
            kevent(m_epoll_fd, &ev, 1, NULL, 0, NULL);
		}
		close(domian_fd);
		domian_fd = 0;
	} else {
		list<Channel*>::iterator v;
		for (v = channels.begin(); v != channels.end();) {
			list<Channel*>::iterator temp = v++;
			if (!(*temp)->getName().compare(name)) {
				closeListConWithFd((*temp)->getFd());
			}
		}

	}

}

void Shared::checkAct(const char* buf, int buflen) {
	//检测tcp心跳数据
//	while(runStatue == RUNNING){
	list<Channel*>::iterator v;
	for (v = channels.begin(); v != channels.end();) {
		list<Channel*>::iterator temp = v++;
		if ((*temp)->getType() == TCP_TYPE) { //只检测tcp心跳
			if ((*temp)->checkSendActTime() > TVU_HEART) {
				//发送心跳
				sendTcpData((*temp)->getPort(), (*temp)->getIp(), buf, buflen);
			}
			if ((*temp)->checkRecActTime() > TVU_HEART_TIMEOUT) {
				//检测是否长时间没收到数据(包括心跳)，是的话关闭连接
				breakConWithIp((*temp)->getIp(), (*temp)->getPort());
				closeListConWithFd((*temp)->getFd());
				//
			}
		}
	}
//		sleep(TVU_HEART);
//	}

}

//void* checkHeartAct(void* arg) {
//	Shared *singleton = (Shared *) arg;
//	while (singleton != NULL && singleton->getRunStatue() == RUNNING) {
//		singleton->checkAct();
//		sleep(TVU_HEART);
//	}
//}

int Shared::getRunStatue() {

	return runStatue;
}

void Shared::run() {
	if (runStatue != RUN_INIT) {
//		printf("please init");
		return;
	}
	runStatue = RUNNING;
//	printf("run");
//	pthread_t tid;
//	pthread_create(&tid, NULL, checkHeartAct, this);
	int new_fd, nfds, n, ret;
	int clientFd;
	socklen_t len = sizeof(struct sockaddr_in);
	struct sockaddr_in their_addr;
	struct kevent ev, events[20];
    EV_SET(&ev, STDIN_FILENO, EVFILT_READ, EV_ADD, 0, 0, NULL);
    kevent(m_epoll_fd, &ev, 1, NULL, 0, NULL);
	if (m_epoll_fd > 0) {
		while (1) {
			nfds = kevent(m_epoll_fd, NULL, 0, events, 20, 0);
			if (nfds < 0) {
				printf("epoll wait err = %d,errno = %d",nfds,errno);
				if(nfds==-1&&errno==EINTR){
					continue;
				}else{
					break;
				}
			}
			for (n = 0; n < nfds; ++n) {
				if (events[n].ident == tcp_fd) {
					bzero(&their_addr, sizeof(their_addr));
					new_fd = accept(tcp_fd, (struct sockaddr *) &their_addr,
							&len);
					if (new_fd < 0) {
//						printf("accept");
						if (new_fd == -1 && errno == EAGAIN) {
							continue;
						} else {
							closeAll();
						}
					} else {
						printf(
								"有连接来自于： %s:%d， 分配的 socket 为:%d/n", inet_ntoa(their_addr.sin_addr), ntohs(their_addr.sin_port), new_fd);
						bool isIn = false;
						list<Channel*>::iterator v;
						for (v = channels.begin(); v != channels.end();) {
							list<Channel*>::iterator temp = v++;
							if ((*temp)->getIp()
									== their_addr.sin_addr.s_addr) {
//								printf("has in channels");
								closeListConWithFd((*temp)->getFd());
								break;
							}
						}
						int flag = addInEpoll(new_fd);
						if (flag < 0) {
//							printf("新的连接加入epoll失败");
							continue;
						} else {
//							printf(
//									"新的连接加入epoll成功%d", their_addr.sin_addr.s_addr);
						}
						Channel* channel = new Channel(new_fd,
								their_addr.sin_addr.s_addr, "", TCP_TYPE,
								ntohs(their_addr.sin_port));
						channels.push_back(channel);
					}
				} else {
						if (events[n].ident == udp_fd) {
							int dataLen = recvfrom(udp_fd, (void *) m_readBuf,
									TVU_BUF_SIZE, 0,
									(struct sockaddr *) &their_addr, &len);
							if (dataLen == -1 && errno == EAGAIN) {
								continue;
							}
							m_readBuf[dataLen] = 0;
							recUdpData(m_readBuf, dataLen,
									their_addr.sin_addr.s_addr);
							if (m_dispatcher != NULL) {
								m_dispatcher->recUdpData(m_readBuf, dataLen,
										their_addr.sin_addr.s_addr);
							}
							while (1) {
								int dataLen = recvfrom(udp_fd,
										(void *) m_readBuf, TVU_BUF_SIZE, 0,
										(struct sockaddr *) &their_addr, &len);
								m_readBuf[dataLen] = 0;
								if (dataLen == 0
										|| (dataLen == -1 && errno == EAGAIN)) {
									break;
								} else {
									if (dataLen > 0) {
										recUdpData(m_readBuf, dataLen,
												their_addr.sin_addr.s_addr);
										if (m_dispatcher != NULL) {
											m_dispatcher->recUdpData(m_readBuf,
													dataLen,
													their_addr.sin_addr.s_addr);
										}
									} else {
									}
								}
							}

						} else if (events[n].ident == domian_fd) {
							int dataLen = read(domian_fd, m_readBuf,
									TVU_BUF_SIZE);
							if (dataLen == -1 && errno == EAGAIN) {
								continue;
							}
							m_readBuf[dataLen] = 0;
							revDomainData(m_readBuf, dataLen,
									m_domainServerName);
							if (m_dispatcher != NULL) {
								m_dispatcher->revDomainData(m_readBuf, dataLen,
										m_domainServerName);
							}
							while (1) {
								int dataLen = read(domian_fd, m_readBuf,
										TVU_BUF_SIZE);
								m_readBuf[dataLen] = 0;
								if (dataLen == 0
										|| (dataLen == -1 && errno == EAGAIN)) {
									break;
								} else {
									if (dataLen > 0) {
										revDomainData(m_readBuf, dataLen,
												m_domainServerName);
										if (m_dispatcher != NULL) {
											m_dispatcher->revDomainData(
													m_readBuf, dataLen,
													m_domainServerName);
										}
									} else {
										printf("domain server err");
									}
								}
							}
						} else if ((clientFd = events[n].ident) > 0) {
							list<Channel*>::iterator v;
							for (v = channels.begin(); v != channels.end();) {
								list<Channel*>::iterator temp = v++;
								if ((*temp)->getFd() == clientFd) {
									int flag = (*temp)->readData(m_dispatcher);
									if (flag < 0) {
										breakConWithIp((*temp)->getIp(), (*temp)->getPort());
										closeListConWithFd((*temp)->getFd());
										//通知关闭连接
									}
								}
							}
						}
					} 
				}
			}
	}
}
int Shared::sendUdpData(int port, int ip, const char* buf, int buflen) {
	int len = 0;
	sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	addr.sin_addr.s_addr = ip;
	len = sendto(udp_fd, (void*) buf, buflen, 0, (struct sockaddr *) &addr,
			sizeof(addr));
	if (len > 0) {

//		printf("发送成功port = %d", port);
	} else if (len < 0 && errno != EINTR && errno != EWOULDBLOCK
			&& errno != EAGAIN) {
		//发送失败
		printf("发送失败port= %d,errno = %d", port, errno);
	}
	return len;
}
int Shared::sendTcpData(int port, int ip, const char* buf, int buflen)
{
	//发送tcp数据，返回-1发送失败
	list<Channel*>::iterator v;
	int len = 0;
	for (v = channels.begin(); v != channels.end();)
    {
		list<Channel*>::iterator temp = v++;
		if ((*temp)->getIp() == ip && port == (*temp)->getPort())
        {
            
			len = send((*temp)->getFd(), (void*) buf, buflen, 0);
			if (len > 0)
            {
				printf("发送成功= %d", len);
				(*temp)->updateSendActTime(); //更新发送时间
			}
            else if(len < 0 && errno != EINTR && errno != EWOULDBLOCK
					&& errno != EAGAIN)
            {
				//发送失败 关闭连接
				printf("tcp 发送失败= %d", errno);
				breakConWithIp((*temp)->getIp(), (*temp)->getPort());
				closeListConWithFd((*temp)->getFd());
			}
			break;
		}
	}
	return len;
}

int Shared::sendTcpWithIp(int ip,const char* buf,int buflen){
	//发送tcp数据，返回-1发送失败
	list<Channel*>::iterator v;
	int len = 0;
	for (v = channels.begin(); v != channels.end();) {
		list<Channel*>::iterator temp = v++;
		if ((*temp)->getIp() == ip&&(*temp)->getType()==TCP_TYPE) {
			len = send((*temp)->getFd(), (void*) buf, buflen, 0);
			if (len > 0) {
//				printf("发送成功= %d", len);
				(*temp)->updateSendActTime(); //更新发送时间
			} else if (len < 0 && errno != EINTR && errno != EWOULDBLOCK
					&& errno != EAGAIN) {
				//发送失败 关闭连接
				printf("tcp 发送失败= %d", errno);
				breakConWithIp((*temp)->getIp(), (*temp)->getPort());
				closeListConWithFd((*temp)->getFd());
			}
			break;
		}
	}
	return len;
}

int Shared::sendTcpForAll(const char* buf,int buflen){
	//发送tcp数据，返回-1发送失败
	list<Channel*>::iterator v;
	int len = 0;
	for (v = channels.begin(); v != channels.end();) {
		list<Channel*>::iterator temp = v++;
		if ((*temp)->getType()==TCP_TYPE) {
			len = send((*temp)->getFd(), (void*) buf, buflen, 0);
			if (len > 0) {
//				printf("发送成功= %d", len);
				(*temp)->updateSendActTime(); //更新发送时间
			} else if (len < 0 && errno != EINTR && errno != EWOULDBLOCK
					&& errno != EAGAIN) {
				//发送失败 关闭连接
				printf("tcp 发送失败= %d", errno);
				breakConWithIp((*temp)->getIp(), (*temp)->getPort());
				closeListConWithFd((*temp)->getFd());
			}
			break;
		}
	}
	return len;
}

int Shared::sendDomainData(string domainName, const char* buf, int buflen) {
	//发送domain数据，返回-1发送失败
	list<Channel*>::iterator v;
	int len = 0;
	for (v = channels.begin(); v != channels.end();) {
		list<Channel*>::iterator temp = v++;
//		printf("name = %s||temp name = %s",domainName.c_str(),(*temp)->getName().c_str());
		if (!(*temp)->getName().compare(domainName)) {
			len = send((*temp)->getFd(), (void*) buf, buflen, 0);
			if (len > 0) {
//				printf("do main 发送成功=%s",buf+4);
			} else if (len < 0 && errno != EINTR && errno != EWOULDBLOCK
					&& errno != EAGAIN) {
				//发送失败
				printf("发送失败= %d", errno);
			}
			break;
		}
	}
	return len;

}
int Shared::addTcpServer(int port) {
	//添加tcpsever，填入port，返回fd，返回-1添加失败
	if (runStatue < RUN_INIT) {
		printf("please init");
		return -1;
	}
	if (tcp_fd > 0) {
		printf("has add tcp server");
		return -1;
	}

	printf("addTcpServer");
	tcp_fd = openPort(port, SOCK_STREAM);
	if (tcp_fd < 0) {
		printf("add tcpserver fail");
		return -1;
	} else {
		tcp_port = port;
	}
	if (listen(tcp_fd, 1) == -1) {
		printf("listen tcp fail");
		close(tcp_fd);
		tcp_fd = 0;
		tcp_port = 0;
		return -1;
	}
	int flag = addInEpoll(tcp_fd);
	if (flag < 0) {
		printf("TCP epoll 添加失败");
		tcp_fd = 0;
		tcp_port = 0;
		return -1;
	} else {
		printf("监听 tcp 加入 epoll 成功！/n");
	}
	return 1;
}
int Shared::addUdpServer(int port, int type) {
	//添加udpsever，填入port，返回fd，返回-1添加失败(是否加入type标识创建方式？组播接收or广播接收)
	if (runStatue < RUN_INIT) {
		printf("please init");
		return -1;
	}
	if (udp_fd > 0) {
		printf("udp server has create");
		return -1;
	}
	printf("addUdpServer");

	udp_fd = openPort(port, SOCK_DGRAM);
	if (udp_fd > 0) {
		int loop = 0;
		int err = setsockopt(udp_fd, IPPROTO_IP, IP_MULTICAST_LOOP, &loop,
				sizeof(loop));
		if (err < 0) {
			printf("setsockopt loop fail");
			return -1;
		}
		struct ip_mreq mreq; /*加入多播组*/
		mreq.imr_multiaddr.s_addr = inet_addr(MCAST_ADDR); /*多播地址*/
		mreq.imr_interface.s_addr = htonl(INADDR_ANY); /*网络接口为默认*/
		err = setsockopt(udp_fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq,
				sizeof(mreq));
		if (err < 0) {
			perror("setsockopt():add mac_addr fail ");
			return -1;
		}
		udp_port = port;
		printf("udp port = %d", udp_port);
	}else{
		return -1;
	}
	int flag = addInEpoll(udp_fd);
	if (flag < 0) {
		printf("UDP epoll 添加失败");
		udp_fd = 0;
		udp_port = 0;
	} else {
		printf("监听 udp 加入 epoll 成功！/n");
	}

	return 1;
}

int Shared::addDomainServer(string name) {
	//添加domainsever，填入port，返回fd，返回-1添加失败
	if (runStatue < RUN_INIT) {
		printf("please init");
		return -1;
	}
	if (domian_fd > 0) {
		printf("domain server han create");
		return -1;
	}

	printf("addDomainServer");
	domian_fd = socket(AF_LOCAL, SOCK_DGRAM, 0);
	if (domian_fd < 0) {
		printf("DOmain socket fd create fail");
		return -1;
	} else {
		int err = socket_local_server_bind(domian_fd, name.c_str(), 0);
		if (err < 0) {
			close(domian_fd);
			domian_fd = 0;
			printf("domain bind fail");
			return -1;
		} else {
			int flag = addInEpoll(domian_fd);
			if (flag < 0) {
				printf("domain epoll 添加失败");
				domian_fd = 0;
				return -1;
			} else {
				printf("domain epoll 添加成功");
				m_domainServerName = name;
			}
		}

	}
	return 1;

}
void Shared::socketkeepalive(int sockfd)
{
    int keepAlive=1;//开启keepalive属性
    int keepIdle=5;//如该连接在5秒内没有任何数据往来，则进行探测
    int keepInterval=2;//探测时发包的时间间隔为2秒
    int keepCount=3;//探测尝试的次数。如果第1次探测包就收到响应了，则后2次的不再发送
    if(setsockopt(sockfd,SOL_SOCKET,SO_KEEPALIVE,(void *)&keepAlive,sizeof(keepAlive))!=0)//若无错误发生，setsockopt()返回值为0
    {
        //        close
        closeListConWithFd(sockfd);
    }
    //SOL_TCP
    /*
    if(setsockopt(sockfd,IPPROTO_TCP,TCP_KEEPIDLE,(void *)&keepIdle,sizeof(keepIdle))!=0)
    {
        closeListConWithFd(sockfd);
    }
     */
    if(setsockopt(sockfd,IPPROTO_TCP,TCP_KEEPINTVL,(void *)&keepInterval,sizeof(keepInterval))!=0)
    {        //        exit(1);
        closeListConWithFd(sockfd);
    }
    if(setsockopt(sockfd,IPPROTO_TCP,TCP_KEEPCNT,(void *)&keepCount,sizeof(keepCount))!=0)
    {
        //        exit(1);
        closeListConWithFd(sockfd);
    }
}
int Shared::connectServer(int ip, unsigned short port) {
	//连接服务端，填入服务端ip及端口号返回fd,返回-1连接失败
	list<Channel*>::iterator v;
	for (v = channels.begin(); v != channels.end();) {
		list<Channel*>::iterator temp = v++;
		if ((*temp)->getIp() == ip && port == (*temp)->getPort()) {
			printf("has in channels");
			return -1;
		}
	}
	printf("connectServer");
	sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	addr.sin_addr.s_addr = ip;
//	printf("ip =%s",inet_ntoa(ip));
	if (addr.sin_addr.s_addr == INADDR_NONE) {
		//无效IP
		printf("无效ip ");
		return -1;
	}
	bzero(&(addr.sin_zero), 8);
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock < 1) {
		printf("tcp connect create fail");
		return -1;
	}
	if (connect(sock, (struct sockaddr*) &addr, sizeof(addr)) < 0) {
		close(sock);
		printf("tcp connect fail errno = %d", errno);
		return -1;
	} else {
		printf("connect server sucess");
		int flag = addInEpoll(sock);
		if (flag < 0) {
			printf("client addInEpoll fail");
			close(sock);
			return -1;
		} else {
			printf("client addInEpoll sucess");
			Channel* channel = new Channel(sock, ip, "", TCP_TYPE, port);
			channels.push_back(channel);
            socketkeepalive(sock);
		}
	}
	return 1;
}
int Shared::connectDomain(string name) {
	//连接domain服务端,填入名称,返回-1连接失败
	int s = socket(AF_LOCAL, SOCK_DGRAM, 0);
	if (s < 0) {
		printf("domain client s fail");
		return -1;
	}
	if (0 > socket_local_client_connect(s, name.c_str(), 0, SOCK_DGRAM)) {
		close(s);
		printf("domain client connect fail errno = %d", errno);
		return -1;
	} else {
		int flag = addInEpoll(s);
		if (flag < 0) {
			close(s);
			printf("domain client 添加到epoll失败");
			return -1;
		} else {
			printf("domain client 添加到epoll成功");
			list<Channel*>::iterator v;
			for (v = channels.begin(); v != channels.end();) {
					list<Channel*>::iterator temp = v++;
					if (!(*temp)->getName().compare(name)) {
						closeListConWithFd((*temp)->getFd());
						break;
					}
				}
			Channel* channel = new Channel(s, 0, name, DOMAIN_TYPE, 0);
			channels.push_back(channel);
		}
		return 1;
	}

}

int Shared::openPort(unsigned short port, int protocal) {
	struct sockaddr_in local_addr; /*本地地址*/
	int err = -1;
	int fd = socket(AF_INET, protocal, 0); /*建立套接字*/
	if (fd == -1) {
		printf("socket() port err");
		return -1;
	}
	/*初始化地址*/
	memset(&local_addr, 0, sizeof(local_addr));
	local_addr.sin_family = AF_INET;
	local_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	local_addr.sin_port = htons(port);
	/*绑定socket*/
	err = bind(fd, (struct sockaddr*) &local_addr, sizeof(local_addr));
	if (err < 0) {
		close(fd);
		printf("UNBIND");
		return -2;
	}
	return fd;
}

int Shared::addInEpoll(int fd) {
	int opt = SO_REUSEADDR;
	setnonblocking(fd);
	setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
	struct kevent ev;
     EV_SET(&ev, fd, EVFILT_READ, EV_ADD, 0, 0, NULL);
	if (kevent(m_epoll_fd, &ev, 1, NULL, 0, NULL) < 0) {
		return -1;
	}
	return 1;
}
int Shared::setnonblocking(int sockfd) {
	if (fcntl(sockfd, F_SETFL, fcntl(sockfd, F_GETFD, 0) | O_NONBLOCK) == -1) {
		return -1;
	}
	return 0;
}
void Shared::sendPackageWithAll(const char* buf, int buflen) {
	in_addr addr;
	inet_aton(MCAST_ADDR, &addr);
	for (int i = 0; i < PORT_COUNT; i++) {
		if (udp_fd > 0) {
			sendUdpData(PORTS[i], addr.s_addr, buf, buflen);
		}
	}
}
unsigned short Shared::getUdpPort() {
	return udp_port;
}
unsigned short Shared::getTcpPort() {
	return tcp_port;
}
string Shared::getDomainName() {
	return m_domainServerName;
}


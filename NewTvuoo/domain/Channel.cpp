#include "Channel.h"
#include "MyJniTransport.h"

Channel::Channel(int fd, int ip, string name, int type, int port) {
	m_fd = fd;
	m_ip = ip;
	m_name = name;
	m_type = type;
	m_port = port;
	m_buf = (unsigned char*) (malloc(TVU_BUF_SIZE));
	bzero(m_buf, TVU_BUF_SIZE);
	remain = 0;
	time_t t;
	time(&t);
	actTime = t;
	sendActTime = t;

}
Channel::~Channel() {
//	LOGE("~Channel");
	if (m_fd > 0) {
//		LOGE("~Channel1");
		close(m_fd);
	}
	m_fd = 0;
//	LOGE("Channel1 free");
	free(m_buf);
	m_name = "";
	m_type = 0;
	m_ip = 0;
	m_port = 0;
//	LOGE("~Channel2");
}
int Channel::getPort() {
	return m_port;
}
void Channel::setPort(int port) {
	m_port = port;
}
int Channel::getFd() {
	return m_fd;
}
int Channel::getIp() {
	return m_ip;
}
string Channel::getName() {
	return m_name;
}
int Channel::getType(){
	return m_type;
}
void Channel::setFd(int fd) {
	m_fd = fd;
}
void Channel::setIp(int ip) {
	m_ip = ip;
}
void Channel::setType(int type) {
	m_type = type;
}
void Channel::setName(string name) {
	m_name = name;
}
int Channel::readData(Dispacther* dispatcher) {
	//处理包 得到完整包后调用dispatcher rev 方法
	int len = 0;
	if (m_ip == 0 && m_name.empty()) {
//		LOGE("ip=%d|name=%s", m_ip, m_name.c_str());
	} else if (m_ip == 0 && !m_name.empty() && m_type == DOMAIN_TYPE) {
		len = read(m_fd, m_buf, TVU_BUF_SIZE);
		m_buf[len] = 0;
//		LOGE("有 client udp数据来自于domain");
		if (dispatcher != NULL) {
			dispatcher->revDomainData(m_buf, len, m_name);
		}
	} else if (m_ip != 0 && m_name.empty() && m_type == TCP_TYPE) {
		while (1) {
			len = read(m_fd, m_buf + remain, TVU_BUF_SIZE - remain);
			if (len == -1 && errno == EAGAIN) {
				return 1;
			}
			if (len >= 0) {
				m_buf[len] = 0;
				if (len == 0) {
					return -1;
				}
				updateActTime();//更新接收时间
				int total = len + remain;
				while (1) {
					int flag = parseTcpData(m_buf, total); //返回一个整包的长度，不够则返回-1，返回，-2代表收到脏包
					if (flag < 0) {
						remain = total;
						break;
					} else {
						total = total - flag;
						memmove(m_buf, m_buf + flag, total);
					}
				}
			} else {
				//return -1,close fd
				return -1;
			}
		}

		if (dispatcher != NULL) {
			dispatcher->revTcpData(m_buf, len, m_ip,m_port);
		}
	}
	return len;
}

int Channel::parseTcpData(unsigned char* buf, int len) {
	int size = sizeof(u_short);
//	int ipSize = sizeof(u_int);
	if (len >= 2 * size) {
//		u_short type = *((u_short*) buf);
		u_short dataLen = *((u_short*) (buf + size));
		if (len >= dataLen) {
			//解析一个包
			revTcpData(buf,dataLen,m_ip,m_port);
			return dataLen;
		} else {
			return -1;
		}
	} else {
		return -1;
	}
}
long Channel::checkRecActTime() {
	time_t t;
	time(&t);
	return t - actTime;
}
long Channel::checkSendActTime() {
	time_t t;
	time(&t);
	return t - sendActTime;

}
void Channel::updateActTime() {
	time_t t;
	time(&t);
	actTime = t;
}
void Channel::updateSendActTime() {
	time_t t;
	time(&t);
	sendActTime = t;
}

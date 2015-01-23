#include "Package.h"
#include "Symbol.h"
class SensorEventPkg : public Package
{
	private:
		float m_x;
		float m_y;
		float m_z;
		int m_act;		//传感器类型
	public:
		void setX(float x)
		{
			m_x = x;
		}
		void setY(float y)
		{
			m_y = y;
		} 
		void setZ(float z)
		{
			m_z = z;
		}
		
		float getX()
		{
			return m_x;
		}
		float getY()
		{
			return m_y;
		}
		float getZ()
		{
			return m_z;
		}
		int getAct()
		{
			return m_act;
		}
//		int setAct(int act){
        void setAct(int act)
        {
			m_act = act;
		}
		
		SensorEventPkg();
//		void setAddr(u_int addr)
//		{
//			m_addr = addr;
//			m_length += ((sizeof(u_int)));
//		}
		
		int decodeBody(void* buff, int length);
		int encodeBody(void* buff, int length);
};

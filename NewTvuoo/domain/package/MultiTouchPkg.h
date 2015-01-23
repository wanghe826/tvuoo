#ifndef MULTI_TOUCH_PKG_H_
#define MULTI_TOUCH_PKG_H_
#include "Symbol.h"
#include "Package.h"
#include <vector>
#include <list>

class TvuPoint
{
private:
    unsigned int m_id;
    float m_x;
    float m_y;
public:
    TvuPoint(unsigned int id, float x, float y)
    {
        m_id = id;
        m_x = x;
        m_y = y;
    }
    TvuPoint()
    {
    }
    
    unsigned int getId() const
    {
        return m_id;
    }
    void setId(unsigned int id)
    {
        m_id = id;
    }
    
    float getX() const
    {
        return m_x;
    }
    void setX(float x)
    {
        m_x = x;
    }
    
    float getY() const
    {
        return m_y;
    }
    void setY(float y)
    {
        m_y = y;
    }
    
};
class MultiTouchPkg : public Package
{
private:
    int m_act;
    int m_cnt;
    //		int m_move;
    //		vector<Point> m_pointList;
    list<TvuPoint*> m_pointList;
public:
    void setAct(int act)
    {
        m_act = act;
    }
    void setCnt(int cnt)
    {
        m_cnt = cnt;
    }
    //		void setMove(int move)
    //		{
    //			m_move = move;
    //		}
    ~MultiTouchPkg();
    int getAct() const
    {
        return m_act;
    }
    int getCnt() const
    {
        return m_cnt;
    }
    //		int getMove() const
    //		{
    //			return m_move;
    //		}
    
    void addPoint(TvuPoint* point);
    list<TvuPoint*> getPoints();
    
    //构造函数
    MultiTouchPkg();
    //		void setAddr(u_int addr)
    //		{
    //			m_addr = addr;
    //			m_length += ((sizeof(u_int)));
    //		}
    
    //解包和打包
    int decodeBody(void* buff, int length);
    int encodeBody(void* buff, int length); 
    
    int getSize()
    {
        return m_pointList.size();
    }
    
};
#endif
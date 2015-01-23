#include "MultiTouchPkg.h"
void MultiTouchPkg::addPoint(TvuPoint* point) {
    if (point == NULL) {
        return;
    }
    //	int count = point -> getId();
    //	m_pointList.insert(map<int, Point*>::value_type(count, point));
    m_pointList.push_back(point);
    m_length += sizeof(TvuPoint);
}
MultiTouchPkg::~MultiTouchPkg() {
    list<TvuPoint*>::iterator v;
    for (v = m_pointList.begin(); v != m_pointList.end();) {
        list<TvuPoint*>::iterator temp = v++;
        delete (TvuPoint*)(*temp);
    }
}
list<TvuPoint*> MultiTouchPkg::getPoints() {
    //	map<int, Point*>::iterator iter = m_pointList.begin();
    //	for(; iter != m_pointList.end(); ++iter)
    //	{
    //		cout << "iterrrrr " << m_pointList.size() << endl;
    //		if((iter -> first) == count)
    //		{
    //			cout <<"执行"<< endl;
    //			return (iter -> second);
    //		}
    //	}
    //	return NULL;
    return m_pointList;
}

MultiTouchPkg::MultiTouchPkg() {
    m_type = TVU_MULTI_POINT_;
    m_length = (((sizeof(u_short)) * 2 + ((sizeof(int)) * 2)));
}

int MultiTouchPkg::decodeBody(void* buff, int length) {
    int size_of_point = sizeof(TvuPoint);
    int size_of_float = sizeof(float);
    int size_of_int = sizeof(int);
    
    char* p = (char*)buff;
    m_act = *((int*) buff);
    p += size_of_int;
    m_cnt = *((int*) p);
    cout << "mmmm------------" << m_cnt << endl;
    //	p += size_of_int;
    //	m_move = *((int*)p);
    int size = m_cnt * size_of_point + size_of_int * 2;
    p += size_of_int;
    if (length < size) {
        return 0;
    }
    for (int i = 0; i < m_cnt; ++i) {
        TvuPoint* point = new TvuPoint();
        u_int id = *((u_int*) p);
        point->setId(id);
        p += (sizeof(u_int));
        float x = *((float*) p);
        point->setX(x);
        p += size_of_float;
        float y = *((float*) p);
        point->setY(y);
        p += size_of_float;
        
        this->addPoint(point);
    }
    cout << "m_pointList的长度" << m_pointList.size() << endl;
    return size;
}

int MultiTouchPkg::encodeBody(void* buff, int length) {
    /*
     int m_act;
     int m_cnt;
     int m_move;
     map<int, Point*> m_pointList;
     class Point
     {
     unsigned int ;
     float
     float;
     }
     */
    int size_of_int = sizeof(int);
    
    int len1 = m_pointList.size();
    int len2 = sizeof(u_int) + sizeof(float) * 2;
    int size_of_map = len1 * len2;
    
    int size = size_of_int * 2 + size_of_map;
    if (length < size) {
        return 0;
    }
    *((int*) buff) = m_act;
    *((int*) ((char*)buff + size_of_int)) = m_cnt;
    
    char* p = ((char*)buff + size_of_int * 2);
    int capacity = m_pointList.size();
    if (capacity > 0) {
        list<TvuPoint*>::iterator v;
        for (v = m_pointList.begin(); v != m_pointList.end();) {
            list<TvuPoint*>::iterator temp = v++;
            *((u_int*) p) = (*temp)->getId();
            p += (sizeof(u_int));
            *((float*) p) = (*temp)->getX();
            p += (sizeof(float));
            *((float*) p) = (*temp)->getY();
            p += (sizeof(float));
        }
//        cout << "size ====" << size << endl;
        return size;
    } else {
        return 0;
    }
}
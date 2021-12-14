#include "LinkedList.h"

template<class T>
class Heap {
    private:
        LinkedList<T> list;
        int size;
    public:
        Heap();
        void insert(T data);
};

template<class T>
Heap<T> :: Heap() {
    list = LinkedList<T> list;
    size = 0;
}

template<class T>
void Heap<T> :: insert(T data) {
    if(list.isEmpty) {
        
    }
}
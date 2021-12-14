#include "Entrada.h"
#include "Dir.h"

template<class T>
struct Node {

    // DATOS

    T data;
    Node<T>* next;

    // CONSTRUCTORES

    Node(T data) {
        this->data = data;
        next = NULL;
    }

    Node(T data, Node<T>* next) {
        this->data = data;
        this->next = next;
    }

};
// Sergio Lopez Urzaiz
// A00827462
// 28/9/2020
// Instituto Tecnologico de Monterrey
// Ingenieria en Tecnologias Computacionales

#include "Node.h"

template<class T>
class LinkedList {
    private:
        Node<T>* head;
        Node<T>* tail;
        int size;
    public:
        LinkedList();
        int getSize();
        bool isEmpty();
        T front();
        void addFirst(T data);
        Node<T>* getPos(int n);
        void addLast(T data);
        T popBack();
        void insert(T data);
        void print();
        T remove();
        void operator=(LinkedList<T> lista);
        T pop();
        vector<T> sort();
        vector<T> sortReverse();
};

// Constructor de lista vacia
template<class T>
LinkedList<T> :: LinkedList() {
    head = NULL;
    size = 0;
}

// Getter del size
template<class T>
int LinkedList<T> :: getSize() {
    return size;
}

// Funcion que verifica que la lista este vacia
template<class T>
bool LinkedList<T> :: isEmpty() {
    return size == 0;
}

// O(n)
// Funcion que retorna el dato de la cabeza
template<class T>
T LinkedList<T> :: front() {
    return head->data;
}

// O(n)
// Agregar un dato al principio que apunte al dato que estaba primero
template<class T>
void LinkedList<T> :: addFirst(T data) {
    if(isEmpty()) {
        head = new Node<T>(data, head);
        tail = head;
    }
    else {
        head = new Node<T>(data, head);
    }
    size++;
}

// O(n)
// Funcion que retorna la posicion introducida
template<class T>
Node<T>* LinkedList<T> :: getPos(int n) {
    Node<T>* temp = head;
    for(int i = 1; i < n; i++) {
        temp = temp->next;
    }
    return temp;
}

// O(n)
// Funcion que inserta un dato al final de la lista
template<class T>
void LinkedList<T> :: addLast(T data) {
    if(!isEmpty()) {
        Node<T>* temp = head;
        while(temp->next != NULL) {
            temp = temp->next;
        }
        temp->next = new Node<T>(data);
        tail = temp->next;
    }
    else {
        head = new Node<T>(data, head);
        tail = head;
    }
    size++;
}

// O(n)
// Funcion que elimina el ultimo dato y devuelve su valor
template<class T>
T LinkedList<T> :: popBack() {
    if(!isEmpty()) {
        if(size == 1) {
            T value = head->data;
            head = NULL;
            tail = NULL;
            size--;
            return value;
        }
        Node<T>* temp = head;
        while(temp->next->next != NULL) {
            temp = temp->next;
        }
        tail = temp;
        T value = temp->next->data;
        temp = temp->next;
        tail->next = NULL;
        delete temp;
        size--;
        return value;
    }
    T temp;
    return temp;
}

// O(n)
// Funcion que inserta un dato en la lista de manera 'Heap'
template<class T>
void LinkedList<T> :: insert(T data) {
    if(isEmpty()) {
        head = new Node<T>(data, head);
        tail = head;
        size++;
    }
    else {
        addLast(data);
        int i = size;
        Node<T>* temp = tail;
        Node<T>* parent = getPos(i/2);
        while(parent->data < temp->data && i > 1) {
            swap(parent->data, temp->data);
            i = i/2;
            temp = parent;
            parent = getPos(i/2);
        }
    }
}

// O(n)
// Funcion que imprime los datos de la lista
template<class T>
void LinkedList<T> :: print() {
    Node<T>* temp = head;
    cout << endl;
    while(temp != NULL) {
        temp->data.show();
        temp = temp->next;
    }
    cout << endl;
}

// O(n)
// Funcion que elimina el valor maximo y reacomoda por prioridad
template<class T>
T LinkedList<T> :: remove() {
    if(size == 1) {
        T value = head->data;
        head = NULL;
        tail = NULL;
        return value;
    }
    else if(!isEmpty()) {
        T value = head->data;  
        head->data = popBack();
        bool doing = true;
        int pos = 1;
        Node<T>* left;
        Node<T>* right;
        Node<T>* temp = head;
        while(doing) {
            if(pos * 2 <= size) { // Existe hijo izquierdo
                left = getPos(pos*2);
                if(pos * 2 + 1 <= size) { // Existe hijo derecho
                    right = getPos(pos*2+1);
                    if(left->data >= right->data && left->data > temp->data) { // Hijo izquierdo mayor que derecho y mayor que dato
                        swap(left->data, temp->data);
                        temp = left;
                        pos = pos * 2;
                    }
                    else if(right->data >= left->data && right->data > temp->data) { // Hijo derecho mayor que izquierdo y mayor que dato
                        swap(right->data, temp->data);
                        temp = right;
                        pos = pos * 2 + 1;
                    }
                    else { // Ningun hijo es mayor que el dato
                        doing = false;
                    }
                }
                else {
                    // Solo existe hijo izquierdo
                    if(left->data > temp->data) { // Hijo izquierdo mayor que dato
                        swap(left->data, temp->data);
                        temp = left;
                        pos = pos * 2;
                    }
                    else { // Solo existe un hijo y no es mayor
                        doing = false;
                    }
                }
            }
            else {
                // No tiene hijos
                doing = false;
            }
        }
        return value;
    }
    T temp;
    return temp;
}

// O(n)
// Funcion que devuelve el primer dato y lo elimina de la lista
template<class T>
T LinkedList<T> :: pop() {
    if(!isEmpty()) {
        Node<T>* temp = head;
        head = head->next;
        T value = temp->data;
        delete temp;
        size--;
        return value;
    }
    T temp;
    return temp;
}

// O(n)
// Funcion que convierte de LinkedList a heap
template<class T>
void LinkedList<T> :: operator=(LinkedList<T> lista) {
    while(!lista.isEmpty()) {
        insert(lista.pop());
    }
}

// O(n)
// Funcion que convierte la LinkedList a un vector al retornar el valor mas alto y eliminarlo
template<class T>
vector<T> LinkedList<T> :: sort() {
    vector<T> v;
    int n = size;
    for(int i = 0; i < n; i++) {
        v.insert(v.begin(), remove());
    }
    return v;
}

// O(n)
// Funcion que convierte la LinkedList a un vector al retornar el valor mas alto y eliminarlo pero de manera inversa
template<class T>
vector<T> LinkedList<T> :: sortReverse() {
    vector<T> v;
    int n = size;
    for(int i = 0; i < n; i++) {
        v.push_back(remove());
    }
    return v;
}
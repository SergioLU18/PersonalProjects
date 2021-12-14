#include "Node.h"

class LinkedList {
    private:
        Node* head;
        Node* tail;
        int size;
    public:
        LinkedList();
        bool isEmpty();
        void push(Entrada data);
        void print();
        int getSize();
        Entrada operator[](int index);
        void stack(Entrada data);
        void pop(Node* nodo);
        Entrada getData(Node* nodo);
        Node* getHead();
        Node* getTail();
        Entrada front();
        Entrada pop();
        void enQueue(Entrada data);
        void sort();
        void merge(int left, int right, Node* nLeft, Node* nRight);
        void mergeSort(int left, int mid, int right, Node* nLeft, Node* nMid, Node* nRight);
        Node* recorre(Node* nodo, int n);
};

// O(n)
// Constructor vacio de LinkedList
LinkedList :: LinkedList() {
    head = NULL;
    tail = NULL;
    size = 0;
}

// O(n)
// Funcion que retorna 'true' si la LinkedList esta vacia
bool LinkedList :: isEmpty() {
    return size == 0;
}

// O(n)
// Funcion que agrega un valor al principio de la LinkedList
void LinkedList :: push(Entrada data) {
    if(isEmpty()) {
        head = new Node(data, head);
        tail = head;
        size++;
    }
    else {
        Node* temp = new Node(data, head);
        head->previous = temp;
        head = temp;
        size++;
    }
}

// O(n)
// Funcion que muestra todos los datos en la LinkedList
void LinkedList :: print() {
    Node* temp = head;
    for(int i = 0; i < size; i++) {
        temp->data.show();
        temp = temp->next;
        cout << endl;
    }
}

// O(n)
// Funcion que retorna el size
int LinkedList :: getSize() {
    return size;
}

// Funcion que anula la funcion previa de '[]' y le asigna una nueva funcion para obtener el valor del indice introducido
Entrada LinkedList :: operator[](int index) {
    Node* temp = head;
    if(!isEmpty()) {
        for(int i = 0; i < size; i++) {
            if(i == index) {
                return temp->data;
            }
            temp = temp->next;
        }
    }
}

// O(n)
// Funcion que agrega elementos al principio de la fila por metodo 'Stack'
void LinkedList :: stack(Entrada data) {
    if(isEmpty()) {
        head = new Node(data);
        tail = head;
        size++;
    }
    else {
        Node* temp = new Node(data, head);
        head->previous = temp;
        head = temp;
        size++;
    }
}

// O(n)
// Funcion que hace 'pop' a un elemento especificado en los parametros
void LinkedList :: pop(Node* nodo) {
    if(!isEmpty()) {
        if(nodo->previous != NULL) {
            Node* temp = nodo->previous;
            temp->next = nodo->next;
            delete nodo;
            size--;
            return;
        }
        else if (nodo->next != NULL) {
            Node *temp = nodo->next;
            delete nodo;
            size--;
            return;
        }
        else {
            delete nodo;
        }
    }
}

// O(n)
// Funcion que retorna head 
Node* LinkedList :: getHead() {
    return head;
}

// O(n)
// Funcion que retorna tail
Node* LinkedList :: getTail() {
    return tail;
}


// O(n)
// Funcion que retorna el dato de la cabeza
Entrada LinkedList :: front() {
    return head->data;
}

Entrada LinkedList :: pop() {
    if(!isEmpty()) {
        Node* temp = head;
        head = head->next;
        Entrada aux = temp->data;
        delete temp;
        size--;
        return aux;
    }
    Entrada temp;
    return temp;
}

// O(n) 
// Funcion que agrega elementos al final de la cola por medio de 'Queue'
void LinkedList :: enQueue(Entrada data) {
    if(isEmpty()) {
        head = new Node(data);
        tail = head;
        size++;
    }
    else {
        Node* temp = head;
        while(temp->next != NULL) {
            temp = temp->next;
        }
        temp->next = new Node(data);
        tail = temp->next;
        size++;
    }
}

// O(n)
// Funcion que recorre posiciones de Nodo
Node* LinkedList :: recorre(Node* nodo, int n) {
    Node* temp = nodo;
    for(int i = 0; i < n; i++) {
        temp = temp->next;
    }   
    return temp;
}

// O(n)
// Funcion que llama al mergeSort con parametros
void LinkedList :: sort() {
    merge(0, size - 1, head, tail);
}

// O(log n)
// Funcion recursiva que realiza el proceso de 'merge'
void LinkedList :: merge(int left, int right, Node* nLeft, Node* nRight) {
    if (left < right) {
        int mid = (left + right) / 2;
        Node* nMid = recorre(nLeft, mid - left);
        merge(left, mid, nLeft, nMid);
        merge(mid + 1, right, nMid->next, nRight);
        mergeSort(left, mid, right, nLeft, nMid, nRight);
    }
}

// O(log n)
// Funcion que agrega los datos a la lista original
void LinkedList :: mergeSort(int left, int mid, int right, Node* nLeft, Node* nMid, Node* nRight) {

    LinkedList L;
    LinkedList R;

    int n = mid - left + 1;
    int m = right - mid;

    Node* tempPos = nLeft;

    for(int i = 0; i < n; i++) {
        L.enQueue(nLeft->data);
        nLeft = nLeft->next;
    }
    for(int i = 0; i < m; i++) {
        R.enQueue(nMid->next->data);
        nMid = nMid->next;
    }

    int i = 0;
    int j = 0;

    while (i < n && j < m) {
        if (L.front() <= R.front()) {
            tempPos->data = L.pop();
            i++;
        }
        else {
            tempPos->data = R.pop();
            j++;
        }
        tempPos = tempPos->next;
    }

    while (i < n) {
        tempPos->data = L.pop();
        tempPos = tempPos->next;
        i++;
    }

    while (j < m) {
        tempPos->data = R.pop();
        tempPos = tempPos->next;
        j++;
    }
}
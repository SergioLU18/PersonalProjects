#include "Entrada.h"

struct Node {

    // DATOS

    Entrada data;
    Node* next;
    Node* previous;

    // CONSTRUCTORES

    Node(Entrada data) {
        this->data = data;
        next = NULL;
        previous = NULL;
        
    }

    Node(Entrada data, Node* next) {
        this->data = data;
        this->next = next;
        previous = NULL;
    }

    Node(Entrada data, Node* next, Node* previous) {
        this->data = data;
        this->next = next;
        this->previous = previous;
    }

};
using namespace std;

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>

#include "LinkedList.h"

// Funcion que convierte el mes introducido de formato string a int
int numMes(string mes) {
    string meses[12] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
    for(int i = 0; i < 12; i++) {
        if(mes == meses[i]) {
            return i;
        }
    }
    return -1;
}

int main() {

    // Creamos variables
    
    ifstream bitacora("bitacora2.txt");
    string ip, line, razon, temp;
    char delim = ' ';
    int cont = 1;

    Entrada dato;
    LinkedList<Entrada> lista;

    // Leemos archivo y agregamos datos a LinkedList de tipo Entrada

    while(getline(bitacora, line)) {
        stringstream ss(line);
        while(getline(ss, temp, delim)) {

            // Leer mes
            if (cont == 1) {
                dato.mes = numMes(temp);
            }

            // Leer dia
            if (cont == 2) {
                dato.dia = atoi(temp.c_str());
            }

            // Leer hora
            if (cont == 3) {
                dato.hora = atoi(temp.substr(0,2).c_str());
                dato.minutos = atoi(temp.substr(3,4).c_str());
                dato.segundos = atoi(temp.substr(6,7).c_str());
            }

            // Leer IP
            if (cont == 4) {
                dato.ip = temp.substr(0, temp.length() - 5);
                dato.puerto = temp.substr(temp.length() - 4);
            }

            // Leer razon
            if (cont == 5) {
                razon = temp;
            }

            // Leer razon
            if (cont > 5) {
                razon = razon + " " + temp;
            }
            cont++;
        }
        dato.razon = razon;
        lista.addFirst(dato);
        cont = 1;
        razon = "";
    }

    // Creamos nuestro heap con base a la LinkedList creada previamente

    LinkedList<Entrada> heap;
    heap = lista;  

    // Creamos un vector en donde ordenamos los datos por IP
    
    vector<Entrada> datos;
    datos = heap.sort();

    // Creamos variables en donde guardaremos objetos tipo 'Dir' que seran direrccion y sus accesos

    LinkedList<Dir> heapDir;
    vector<Dir> datosDir;

    Dir dir;
    int n;
    
    // Haremos un for que servira como 'count'
    // En este iremos creando objetos tipo 'Dir' que tendran IP y sus accesos
    // Los objetos creados seran insertados en nuestro Heap de tipo 'Dir'

    for(int i = 0; i < datos.size(); i++) {
        if(i == 0) {
            dir.ip = datos[i].ip;
            dir.puerto = datos[i].puerto;
            n = 1;
        }
        else {
            if(dir.ip != datos[i].ip) {
                dir.cantidad = n;
                heapDir.insert(dir);
                dir.ip = datos[i].ip;
                dir.puerto = datos[i].puerto;
                n = 1;
            }
            else {
                n++;
            }
            if(i == datos.size()-1) {
                dir.cantidad = n;
                heapDir.insert(dir);
            }
        }
    }

    // Creamos nuestro vector ordenando nuestro heap de tipo 'Dir' de manera inversa para obtener mayores

    datosDir = heapDir.sortReverse();

    // Imprimimos los 5 IP's con mas accesos

    for(int i = 0; i < 5; i++) {
        datosDir[i].show();
        cout << endl;
    }
    
}
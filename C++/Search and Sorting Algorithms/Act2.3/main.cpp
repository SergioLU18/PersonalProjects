// Sergio Lopez Urzaiz
// A00827462
// 2/10/2020
// Intituto Tecnologico de Estudios Superiores de Monterrey

using namespace std;

#include <iostream>
#include <string>
#include <vector>
#include <ctime>
#include <fstream>
#include <sstream>
#include <sys/time.h>

#include "LinkedList.h"

// Funcion que calcula el tiempo que le tomo a la funcion ejecutarse
void calculaTiempo(struct timeval begin, struct timeval end) {
    long seconds, microseconds;
    double elapsed;
    seconds = end.tv_sec - begin.tv_sec;
    microseconds = end.tv_usec - begin.tv_usec;
    elapsed = seconds + microseconds*1e-6;
    printf("Tiempo de ejecucion: %.8f segundos\n", elapsed);
}

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

// Funcion que busca el rango inferior por medio de busqueda inferior
int busquedaBinaria(LinkedList lista, Entrada dato) {
    int low = 0;
    int high = lista.getSize() - 1;
    int mid;
    if (dato > lista.getTail()->data) {
        return -1;
    }
    while (low <= high) {
        mid = (low + high) / 2;
        if (lista[mid] >= dato && dato > lista[mid-1]) {
            return mid;
        }
        else {
            if (lista[mid] >= dato) {
                high = mid - 1;
            }
            else {
                low = mid + 1;
            }
        }
    }
    return 0;
}

// Funcion que busca el rango superior por medio de busqueda binaria
int busquedaBinariaSup(LinkedList lista, Entrada dato) {
    int low = 0;
    int high = lista.getSize() - 1;
    int mid;
    if (dato < lista.getHead()->data) {
        return -1;
    }
    while (low < high) {
        mid = (low + high) / 2;
        if (dato >= lista[mid] && lista[mid+1] > dato) {
            return mid;
        }
        else {
            if(lista[mid] > dato) {
                high = mid - 1;
            }
            else {
                low = mid + 1;
            }
        }
    }
    return lista.getSize() - 1;
}

// O(n)
// Funcion que imprime todos los datos en un rango
void printRange(LinkedList lista, int start, int finish) {
    Node* temp = lista.getHead();
    for(int i = 0; i < finish; i++) {
        if(i >= start && i <= finish) {
            temp->data.show();
        }
        temp = temp->next;
    }
}

int main() {

    struct timeval begin, end;
    long seconds, microseconds;
    double elapsed;

    ifstream bitacora("bitacora.txt");
    string ip, line, razon, puerto, temp;
    char delim = ' ';
    int cont = 1;

    Entrada dato;
    LinkedList lista;

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
        lista.push(dato);
        cont = 1;
        razon = "";
    }

    gettimeofday(&begin, 0);
    lista.sort();
    gettimeofday(&end, 0);
    calculaTiempo(begin, end);

    ofstream ordenados;
    ordenados.open("ordenados.txt");
    string meses[12] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

    Node* nodoTemp = lista.getHead();
    Entrada eTemp = nodoTemp->data;

    for(int i = 0; i < lista.getSize() - 1; i++) { 
        ordenados << meses[eTemp.mes] << " " << eTemp.dia << " ";
        if(eTemp.hora < 10) {
            ordenados << "0";
        }
        ordenados << eTemp.hora << ":";
        if(eTemp.minutos < 10) {
            ordenados << "0";
        }
        ordenados << eTemp.minutos << ":";
        if(eTemp.segundos < 10) {
            ordenados << "0";
        }
        ordenados << eTemp.segundos << " ";
        ordenados << eTemp.ip << ":" << eTemp.puerto << " " << eTemp.razon << endl;
        nodoTemp = nodoTemp->next;
        eTemp = nodoTemp->data;
    }

    cout << "Los datos han sido ordenados\n" << endl;

    int mes, dia, hora, minutos, segundos;

    cout << "Introduzca la fecha del rango inferior en formato de numeros" << endl;
    cout << "Mes: " << endl;
    cin >> mes;
    cout << "Dia: " << endl;
    cin >> dia;
    cout << "Hora: " << endl;
    cin >> hora; 
    cout << "Minutos: " << endl;
    cin >> minutos;
    cout << "Segundos: " << endl;
    cin >> segundos;

    Entrada rangoInferior(mes, dia, hora, minutos, segundos);

    cout << "Introduzca la fecha del rango superior en formato de numeros" << endl;
    cout << "Mes: " << endl;
    cin >> mes;
    cout << "Dia: " << endl;
    cin >> dia;
    cout << "Hora: " << endl;
    cin >> hora; 
    cout << "Minutos: " << endl;
    cin >> minutos;
    cout << "Segundos: " << endl;
    cin >> segundos;

    Entrada rangoSuperior(mes, dia, hora, minutos, segundos);

    int rangoInf = busquedaBinaria(lista, rangoInferior);
    int rangoSup = busquedaBinariaSup(lista, rangoSuperior);

    if (rangoInf == 2 || rangoSup == 2 || rangoSup < rangoInf) {
        cout << "Las fechas introducidas estan fuera de rango" << endl;
    }
    else {
        printRange(lista, rangoInf, rangoSup);
    }

    //lista.print();

}
using namespace std;

#include <iostream>
#include <string>
#include <vector>
#include <ctime>
#include <fstream>
#include <sstream>

#include "Entrada.h"

// Funcion que ordena los datos por metodo quicksort
void quickSort(vector<Entrada> &data, int left, int right) {
    if (left < right){
        Entrada n = data[left];
        int cont = left;
        Entrada temp;
        for(int i = left + 1; i <= right; i++) {
            if(n > data[i]) {
                temp = data[i];
                data.erase(data.begin() + i);
                data.insert(data.begin() + cont, temp);
                cont++;
            }
        }
        quickSort(data, left, cont-1);
        quickSort(data, cont + 1, right);  
    }
}

// Funcion que convierte de formato string a numero el mes introducido
int numMes(string mes) {
    string meses[12] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
    for(int i = 0; i < 12; i++) {
        if(mes == meses[i]) {
            return i;
        }
    }
    return -1;
}

// Busqueda binaria para la fecha de rango inferior
int busquedaBinaria(vector<Entrada> data, Entrada dato) {
    int low = 0;
    int high = data.size() - 1;
    int mid;
    while (low < high) {
        mid = (low + high) / 2;
        if (data[mid] >= dato && dato > data[mid-1]) {
            return mid;
        }
        else {
            if (data[mid] >= dato) {
                high= mid - 1;
            }
            else {
                low = mid + 1;
            }
        }
    }
    return low;
}

// Busqueda binaria para la fecha de rango superior
int busquedaBinariaF(vector<Entrada> data, Entrada dato) {
    int low = 0;
    int high = data.size() - 1;
    int mid;
    while ((low != high) and (low < high)) {
        mid = (low + high) / 2;
        if (dato >= data[mid] and data[mid+1] > dato) {
            return mid;
        }
        else {
            if (data[mid] > dato) {
                high = mid - 1;
            }
            else {
                low = mid + 1;
            }
        }
    }
    return low + 1;
}


int main() {

    ifstream prueba("bitacora.txt");

    string mes, ip, line, razon, puerto, temp;
    char delim = ' ';
    int cont = 1;
    int dia, hora;
    int minutos, segundos;

    Entrada dato;
    vector<Entrada> entradas;

    while(getline(prueba, line)){

        stringstream ss(line);

        while(getline(ss, temp, delim)){

            // LECTURA MES
            if (cont == 1) {
                mes = temp;
                dato.setMes(numMes(temp));
            }

            // LECTURA DIA
            if (cont == 2) {
                dia = atoi(temp.c_str());
                dato.setDia(dia);
            }

            // LECTURA HORA
            if (cont == 3) {
                hora = atoi(temp.substr(0,2).c_str());
                dato.setHora(hora);
                minutos = atoi(temp.substr(3,4).c_str());
                dato.setMinutos(minutos);
                segundos = atoi(temp.substr(6,7).c_str());
                dato.setSegundos(segundos);

            }

            // LECTURA IP
            if (cont == 4) {
                ip = temp.substr(0,temp.length() - 5);
                dato.setIp(ip);
            }

            // Lectura PUERTO
            if (cont == 4) {
                puerto = temp.substr(temp.length() - 4);
                dato.setPuerto(puerto);
            }
            // LECTURA RAZON
            if (cont == 5) {
                razon = temp;
            }
            if (cont > 5) {
                razon = razon + " " + temp;
            }
            cont++;
        }
        dato.setRazon(razon);
        entradas.push_back(dato);
        cont = 1;
        razon = "";
    }
    
    // Ordenamos los datos
    quickSort(entradas, 0, entradas.size()-1);

    // Abrimos el archvo en donde escribiremos
    ofstream ordenados;
    ordenados.open("ordenados.txt");
    string meses[12] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

    
    // Escribimos los datos guardados en el vector
    for(int i = 0; i < entradas.size(); i++) {

        ordenados << meses[entradas[i].getMes()] << " " << entradas[i].getDia() << " ";
        ordenados << entradas[i].getHora() << ":" << entradas[i].getMinutos() << ":" << entradas[i].getSegundos() << " ";
        ordenados << entradas[i].getIp() << ":" << entradas[i].getPuerto() << " ";
        ordenados << entradas[i].getRazon() << endl;

    }
    
    cout << "Los datos fueron ordenados y escritos en un nuevo archivo" << endl;

    int mesI, diaI, horaI, minI, segI;
    int mesF, diaF, horaF, minF, segF;

    int opcion = 1;

    cout << "Bienvenido. Favor de introducir el rango de fechas de entradas a imprimir";

    // Creamos un pseudo menu para la impresion de datos dentro de un rango
    while (opcion != 0) {
        
        cout << "Fecha minima" << endl;
        cout << "Mes (Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12): ";
        cin >> mesI;
        cout << "Dia: ";
        cin >> diaI;
        cout << "Hora (24h): ";
        cin >> horaI;
        cout << "Minutos: ";
        cin >> minI;
        cout << "Segundos: ";
        cin >> segI;

        Entrada fechaI(mesI - 1, diaI, horaI, minI, segI);

        cout << "Mes (Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12): ";
        cin >> mesF;
        cout << "Dia: ";
        cin >> diaF;
        cout << "Hora (24h): ";
        cin >> horaF;
        cout << "Minutos: ";
        cin >> minF;
        cout << "Segundos: ";
        cin >> segF;

        Entrada fechaF(mesF - 1, diaF, horaF, minF, segF);

        int inicio, final;
        int posicionI, posicionF;

        // Se obtienen la posicion final y la inicial
        inicio = busquedaBinaria(entradas, fechaI);
        final = busquedaBinariaF(entradas, fechaF);


        if (inicio != -1 and final == -1) {
            for(int i = inicio; i < entradas.size(); i++) {
                entradas[i].print(i);
            }
        }

        if (inicio == -1 and final != -1) {
            for(int i = 0; i < final; i++) {
                entradas[i].print(i);
            }
        }

        if (inicio != -1 and final != -1) {
            for(int i = inicio; i <= final; i++) {
                entradas[i].print(i);
            }
        }
        cout << "Desea buscar otro rango de entradas? 1 = Si, 0 = No" << endl;
        cin >> opcion;
    }
}
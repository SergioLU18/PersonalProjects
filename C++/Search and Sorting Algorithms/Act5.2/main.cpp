using namespace std;

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <queue>
#include <algorithm>

#include "GrafosL.h"

int main() {
    
    // Creamos variables
    ifstream bitacora("bitacoraACT4_3.txt");
    string ip, line, temp;
    char delim = ' ';
    int cont = 1;

    // Obtenemos primera linea
    getline(bitacora, line);
    stringstream ss(line);

    // Obtenemos el valor de # de Ip's
    getline(ss, temp, delim);
    int cantIp = stoi(temp);

    // Obtenemos el valor de # de accesos
    getline(ss, temp, delim);
    int cantAccesos = stoi(temp);

    // Creamos vector de vectores de tipo "string" de donde crearemos nuestro grafo
    vector<vector<string>> list;

    // Creamos vector tipo "string" en donde guardaremos valores
    vector<string> tempList;

    // Recorremos todos los lugares hasta llegar a las direcciones
    for(int i = 0; i < cantIp; i++) {
        getline(bitacora, line);
    }

    // Ahora obtenemos los vertices y conexiones y los ponemos en una lista
    while(getline(bitacora, line)) {
        stringstream ss(line);
        // Checamos todos los elementos de la linea
        while(getline(ss, temp, delim)) {
            // Solo queremos checar los ip, por lo que solo guardaremos valores cuando nuestro contador valga 4 y 5
            if(cont == 4) {
                ip = temp.substr(0, temp.length() - 5);
                tempList.push_back(ip);
            }
            if(cont == 5) {
                ip = temp.substr(0, temp.length() - 5);
                tempList.push_back(ip);
            }
            cont++;
        }
        // Introducimos vector a vector de vectores
        list.push_back(tempList);
        // Reseteamos vector y contador
        tempList.clear();
        cont = 1;
    }

    // Creamos grafo a partir de nuestro vector lista
    GrafosL<string> grafo(list);

    // Creamos variables
    char option = 's';
    string looking;

    // Empezamos ciclo
    while(option == 's') {
        cout << "Introduzca la IP de la cual desea ver adyacencias: " << endl;
        cin >> looking;
        grafo.printAdjacents(looking);
        cout << "Introduzca 's' si quiere ver otras adyacencias o 'n' si prefiere salir" << endl;
        cin >> option;
    }

}
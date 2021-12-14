using namespace std;

#include<iostream>
#include<string>
#include<vector>
#include<sstream>
#include<fstream>
#include<typeinfo>

#include "Video.h"
#include "Pelicula.h"
#include "Serie.h"
#include "Episodio.h"

// Funcion que valida que existan los archivos que buscamos

void valida(string nombre) {
    ifstream archivo(nombre);
    if(!archivo.is_open()) {
        throw runtime_error("El archivo");
    }
}

// Funcion que mostrara los videos de cierto genero que caen dentro del rango de calificacion deseado

void mostrarRangoGenero(vector<Video*> videos, double min, double max, string gen) {
    for(int i = 0; i < videos.size(); i++) {
        if((videos[i]->getGenero() == gen) and (*videos[i] >= min) and (*videos[i] <= max)){
            videos[i]->imprimir();
        }
    }
}

// Funcion que mostrara los videos de cierto genero

void mostrarGenero(vector<Video*> videos, string gen) {
    for(int i = 0; i < videos.size(); i ++) {
        if(videos[i]->getGenero() == gen){
            videos[i]->imprimir();
        }
    }
}

// Funcion que mostrara los episodios de una serie que caen en un rango especifico

void mostrarSerieRango(vector<Video*> videos, vector<Serie*> series, double min, double max, string serie) {
    int id;
    for(int i = 0; i < series.size(); i++){
        if(series[i]->getNombre() == serie){
            id = series[i]->getId();
        }
    }
    for(int i = 0; i < videos.size(); i++){
        if((videos[i]->getId() == id) and (*videos[i] >= min) and (*videos[i] <= max)){
            videos[i]->imprimir();
        }
    }
}

// Funcion que mostrara las peliculas que caen en un rango especifico

void mostrarPeliculaRango(vector<Video*> videos, vector<Serie*> series, double min, double max) {
    bool print;
    for(int i = 0; i < videos.size(); i++){
        print = true;
        for(int j = 0; j < series.size(); j++){
            if(videos[i]->getId() == series[j]->getId()){
                print = false;
            }
        }
        if ((print == true) and (*videos[i] >= min) and (*videos[i] <= max)){
            videos[i]->imprimir();
        }
    }
}

// Funcion que califica un video

void califica(vector<Video*> videos, string video, double calificacion) {
    for(int i = 0; i < videos.size(); i++){
        if(videos[i]->getNombre() == video){
            videos[i]->setCalificacion(calificacion);
            cout << "Le asigno la calificacion: " << calificacion << " a " << videos[i]->getNombre() << endl;
        }
    }
}

// Funcion que calcula cuanto tardarias en ver una serie

void tiempo(vector<Video*> videos, vector<Serie*> series, string serie) {
    int id, horas = 0, mins = 0;
    string temp;
    for(int i = 0; i < series.size(); i++) {
        if(series[i]->getNombre() == serie) {
            id = series[i]->getId();
        }
    }
    for(int i = 0; i < videos.size(); i++) {
        if (videos[i]->getId() == id){
            temp = videos[i]->getDuracion();
            horas += int(temp[0]) - 48;
            mins += ((int(temp[2]) - 48) * 10 + (int(temp[3]) - 48));
        }

    }
    horas += mins / 60;
    mins = mins % 60;
    cout << "Tardaria " << horas << " horas con " << mins << " minutos" << endl;
}

int main () {

    vector<Video*> videos;
    vector<Serie*> series;

    // Creamos el menu donde llamaremos a todas las opciones que puede llamar el usuario

    bool archivos = false;
    int opcion = 0;
    double min, max, calificacion;
    string gen, serie, video;
    cout << "Introduzca una opcion" << endl;
    cout << "0. Salir" << endl;
    cout << "1. Cargar archivos" << endl;
    cout << "2. Mostrar los videos en general con un cierto rango de calificacion de un cierto genero" << endl;
    cout << "3. Mostrar los videos en general de un cierto genero" << endl;
    cout << "4. Mostrar los episodios de una determinada serie con un rango de calificacion determinada" << endl;
    cout << "5. Mostrar las peliculas con cierto rango de calificacion" << endl;
    cout << "6. Calificar un video" << endl;
    cout << "7. Tiempo para ver una serie" << endl;
    cin >> opcion;

    while (opcion != 0) {

        if (opcion == 1){
            if(archivos == false){
                // Declaramos las variables que usaremos para luego leer las peliculas

                archivos = true;

                ifstream datosPelicula("Files/Peliculas.csv");
                ifstream datosSerie("Files/Series.csv");
                ifstream datosEpisodios("Files/Episodios.csv");

                // Validamos que los archivos existan
                try {
                    valida("Files/Peliculas.csv");
                } catch(runtime_error& e) {
                    cout << e.what() << " de peliculas no existe" << endl;
                    archivos = false;
                }
                try {
                    valida("Files/Series.csv");
                } catch(runtime_error& e) {
                    cout << e.what() << " de series no existe" << endl;
                    archivos = false;
                }
                try {
                    valida("Files/Episodios.csv");
                } catch(runtime_error& e) {
                    cout << e.what() << " de episodios no existe" << endl;
                    archivos = false;
                }

                if(archivos == true){
                    stringstream ss;
                    string valor, line, nombre, duracion, genero;
                    char delim = ',';
                    int col, id;
                    double calificacion;

                    getline(datosPelicula, line);
                    while(getline(datosPelicula, line)){
                        stringstream ss(line);
                        col = 0;
                        while(getline(ss, valor, delim)){
                            switch(col){
                                // ID
                                case 0:
                                    id =atoi(valor.c_str());
                                    break;
                                // Nombre
                                case 1:
                                    nombre = valor;
                                    for(int i = 0; i < nombre.size(); i++){
                                        if(nombre[i] == ' '){
                                            nombre[i] = '_';
                                        }
                                    }
                                    break;
                                // Duracion
                                case 2:
                                    duracion = valor;
                                    break;
                                // Genero
                                case 3:
                                    genero = valor;
                                    break;
                                // Calificacion
                                case 4:
                                    calificacion = stod(valor);
                                    break;
                            }
                            col++;
                        }
                        videos.push_back(new Pelicula(id, genero, nombre, duracion, calificacion));
                    }

                    // Ahora leeremos las series
                    
                    int temporadas;

                    getline(datosSerie, line);
                    while(getline(datosSerie, line)){
                        stringstream ss(line);
                        col = 0;
                        while(getline(ss, valor, delim)){
                            switch(col){
                                // ID
                                case 0:
                                    id =atoi(valor.c_str());
                                    break;
                                // Nombre
                                case 1:
                                    nombre = valor;
                                    for(int i = 0; i < nombre.size(); i++){
                                        if(nombre[i] == ' '){
                                            nombre[i] = '_';
                                        }
                                    }
                                    break;
                                // Genero
                                case 2:
                                    genero = valor;
                                    break;
                                // Temporadas
                                case 3:
                                    temporadas = atoi(valor.c_str());
                                    break;
                            }
                            col++;
                        }
                        series.push_back(new Serie(id, genero, nombre, temporadas));
                    }

                    

                    // Ahora cargamos los datos de los episodios

                    int temporada, idEpisodio;

                    getline(datosEpisodios, line);
                    while(getline(datosEpisodios, line)){
                        stringstream ss(line);
                        col = 0;
                        while(getline(ss, valor, delim)){
                            switch(col){
                                // ID
                                case 0:
                                    id =atoi(valor.c_str());
                                    break;
                                // ID episodio
                                case 1:
                                    idEpisodio = atoi(valor.c_str());
                                    break;
                                // Nombre
                                case 2:
                                    nombre = valor;
                                    for(int i = 0; i < nombre.size(); i++){
                                        if(nombre[i] == ' '){
                                            nombre[i] = '_';
                                        }
                                    }
                                    break;
                                // Duracion
                                case 3:
                                    duracion = valor;
                                    break;
                                // Calificacion
                                case 4:
                                    calificacion = stod(valor);
                                    break;
                                // Temporada 
                                case 5:
                                    temporada = atoi(valor.c_str());
                                    break;
                            }
                            col++;
                        }
                        for(int i = 0; i < series.size(); i++){
                            if(series[i]->getId() == id){
                                genero = series[i]->getGenero();
                            }
                        }
                        videos.push_back(new Episodio(id, genero, idEpisodio, nombre, duracion, calificacion, temporada));
                    }
                    cout << "Los archivos se cargaron exitosamente" << endl;
                }
                        }
                        else {
                            cout << "Los archivos ya estan cargados" << endl;
                        }
                    }

        // Mostrar los videos en general con un cierto rango de calificación de un cierto género
        if (opcion == 2){
            if(archivos == false) {
                cout << "No hay archivos cargados" << endl;
            }
            else {
                cout << "Favor de introducir la calificacion minima: ";
                cin >> min;
                cout << "Favor de introducir la calificacion maxima: ";
                cin >> max;
                cout << "Favor de introducir el genero que desea ver (Drama, Misterio, Accion): ";
                cin >> gen;
                mostrarRangoGenero(videos, min, max, gen);
            }
        }
        // Mostrar los videos en general de un cierto género
        if (opcion == 3){
            if(archivos == false) {
                cout << "No hay archivos cargados" << endl;
            }
            else {
                cout << "Favor de introducir el genero que desea ver (Drama, Misterio, Accion): ";
                cin >> gen;
                mostrarGenero(videos, gen);
            }
        }
        if (opcion == 4){
            if(archivos == false) {
                cout << "No hay archivos cargados" << endl;
            }
            else {
                cout << "Favor de introducir la serie de la cual desea ver episodios" << endl;
                for(int i = 0; i < series.size(); i++){
                    cout << series[i]->getNombre() << endl;
                }
                cin >> serie;
                cout << "Favor de introducir la calificacion minima: ";
                cin >> min;
                cout << "Favor de introducir la calificacion maxima: ";
                cin >> max;
                mostrarSerieRango(videos, series, min, max, serie);
            }
            
        }
        if (opcion == 5){
            if(archivos == false) {
                cout << "No hay archivos cargados" << endl;
            }
            else {
                cout << "Favor de introducir la calificacion minima: ";
                cin >> min;
                cout << "Favor de introducir la calificacion maxima: ";
                cin >> max;
                mostrarPeliculaRango(videos, series, min, max);
            }
        }
        if (opcion == 6){
            if(archivos == false) {
                cout << "No hay archivos cargados" << endl;
            }
            else {
                cout << "Introduzca el video a calificar. Use '_' para los espacios: ";
                for(int i = 0; i < videos.size(); i++){
                    videos[i]->imprimir();
                }
                cin >> video;
                cout << "Inroduzca la calificacion que desea asignar: ";
                cin >> calificacion;
                califica(videos, video, calificacion);
            }
        }
        if (opcion == 7){
            if(archivos == false) {
                cout << "No hay archivos cargados" << endl;
            }
            else {
                cout << "Introduzca la serie que desea saber cuanto tardaria en verla: " << endl;
                for(int i = 0; i < series.size(); i++) {
                    cout << series[i]->getNombre() << endl;
                }
                cin >> serie;
                tiempo(videos, series, serie);
            }   
        }
        cout << "Introduzca una opcion" << endl;
        cout << "0. Salir" << endl;
        cout << "1. Cargar archivos" << endl;
        cout << "2. Mostrar los videos en general con un cierto rango de calificacion de un cierto genero" << endl;
        cout << "3. Mostrar los videos en general de un cierto genero" << endl;
        cout << "4. Mostrar los episodios de una determinada serie con un rango de calificacion determinada" << endl;
        cout << "5. Mostrar las peliculas con cierto rango de calificacion" << endl;
        cout << "6. Calificar un video" << endl;
        cout << "7. Tiempo para ver una serie" << endl;
        cin >> opcion;
    }

    return 0;
}
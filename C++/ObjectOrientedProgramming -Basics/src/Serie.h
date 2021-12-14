using namespace std;

class Serie : public Video {
    protected:
        string nombre;
        int temporadas;
    public:
        Serie();
        Serie(int id, string genero, string nombre, int temporadas);
        void imprimir();
        string getNombre();
        int getTemporadas();
};

Serie :: Serie() : Video() {
    nombre = "-";
    temporadas = 0;
}

Serie :: Serie(int id, string genero, string nombre, int temporadas) : Video(id, genero) {
    this->nombre = nombre;
    this->temporadas = temporadas;
}

void Serie :: imprimir() {
    cout << "ID: " << id << " - ";
    cout << "Nombre: " << nombre << " - ";
    cout << "Genero: " << genero << " - ";
    cout << "Temporadas: " << temporadas << endl;
}

string Serie :: getNombre() {
    return nombre;
}

int Serie :: getTemporadas() {
    return temporadas;
}
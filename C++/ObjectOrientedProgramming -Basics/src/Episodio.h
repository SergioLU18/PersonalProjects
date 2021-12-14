using namespace std;

class Episodio : public Video {
    protected:
        int idEpisodio, temporada;
        string nombre, duracion;
        double calificacion;
    public:
        Episodio();
        Episodio(int id, string genero, int idEpisodio, string nombre, string duracion, double calificacion, int temporada);
        int getidEpisodio();
        string getNombre();
        void setCalificacion(double calificacion);
        void imprimir();
        bool operator>=(double calificacion);
        bool operator<=(double calificacion);
        double getCalificacion();
        string getDuracion();
};

Episodio :: Episodio() : Video () {
    idEpisodio = 0;
    temporada = 0;
    nombre = "-";
    duracion = "-";
    calificacion = 0.0;
}

Episodio :: Episodio(int id, string genero, int idEpisodio, string nombre, string duracion, double calificacion, int temporada) : Video (id, genero) {
    this->idEpisodio = idEpisodio;
    this->nombre = nombre;
    this->duracion = duracion;
    this->calificacion = calificacion;
    this->temporada = temporada;
}

int Episodio :: getidEpisodio() {
    return idEpisodio;
}

string Episodio :: getNombre() {
    return nombre;
}

void Episodio :: setCalificacion(double calificacion) {
    this->calificacion = calificacion;
}

void Episodio :: imprimir() {
    cout << "ID: " << id << " - ";
    cout << "ID Episodio: " << idEpisodio << " - ";
    cout << "Nombre: " << nombre << " - ";
    cout << "Duracion: " << duracion << " - ";
    cout << "Calificacion: " << calificacion << " - ";
    cout << "Temporada: " << temporada << endl;
}

bool Episodio :: operator>=(double calificacion) {
    if(this->calificacion >= calificacion) {
        return true;
    }
    else {
        return false;
    }
}

bool Episodio :: operator<=(double calificacion) {
    if(this->calificacion <= calificacion) {
        return true;
    }
    else {
        return false;
    }
}

double Episodio :: getCalificacion() {
    return calificacion;
}

string Episodio :: getDuracion() {
    return duracion;
}
using namespace std;

class Pelicula : public Video {
    protected:
        string nombre, duracion;
        double calificacion;
    public:
        Pelicula();
        Pelicula(int id, string genero, string nombre, string duracion, double califiacion);
        void imprimir();
        string getNombre();
        bool operator>=(double calificacion);
        bool operator<=(double calificacion);
        void setCalificacion(double calificacion);
        double getCalificacion();
        string getDuracion();
};

Pelicula :: Pelicula() : Video() {
    nombre = "-";
    duracion = "-";
    calificacion = 0;
}

Pelicula :: Pelicula(int id, string genero, string nombre, string duracion, double calificacion) : Video(id, genero) {
    this->nombre = nombre;
    this->duracion = duracion;
    this->calificacion = calificacion;
}

void Pelicula :: imprimir() {
    cout << "ID: " << id << " - ";
    cout << "Nombre: " << nombre << " - ";
    cout << "Duracion: " << duracion << " - ";
    cout << "Genero: " << genero << " - ";
    cout << "Calificacion: " << calificacion << endl;
}

string Pelicula :: getNombre() {
    return nombre;
}

bool Pelicula :: operator>=(double calificacion) {
    if (this->calificacion >= calificacion) {
        return true;
    }
    else {
        return false;
    }
}

bool Pelicula :: operator<=(double calificacion) {
    if (this->calificacion <= calificacion) {
        return true;
    }
    else {
        return false;
    }
}

void Pelicula :: setCalificacion(double calificacion) {
    this->calificacion = calificacion;
}

double Pelicula :: getCalificacion() {
    return calificacion;
}

string Pelicula :: getDuracion() {
    return duracion;
}

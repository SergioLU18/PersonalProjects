using namespace std;

class Video {
    protected:
        int id;
        string genero;
    public:
        Video();
        Video(int id, string genero);
        int getId();
        string getGenero();
        virtual void imprimir();
        virtual bool operator>=(double calificacion);
        virtual bool operator<=(double calificacion);
        virtual string getNombre();
        virtual void setCalificacion(double calificacion);
        virtual string getDuracion();
};

Video :: Video() {
    id = 0;
    genero = "-";
}

Video :: Video(int id, string genero) {
    this->id = id;
    this->genero = genero;
}

int Video :: getId() {
    return id;
}

string Video :: getGenero() {
    return genero;
}

void Video :: imprimir() {
    int pass;
}

bool Video :: operator>=(double calificacion){
    bool pass;
    return pass;
}

bool Video :: operator<=(double calificacionn){
    bool pass;
    return pass;
}

string Video :: getNombre(){
    string pass;
    return pass;
}

void Video :: setCalificacion(double calificacion){
    int pass;
}

string Video :: getDuracion(){
    string pass;
    return pass;
}
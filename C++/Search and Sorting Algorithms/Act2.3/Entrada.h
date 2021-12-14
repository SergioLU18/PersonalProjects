struct Entrada {
    
    int mes, dia, hora, minutos, segundos;
    string ip, razon, puerto;

    Entrada() {
        mes = 0;
        dia = 0;
        hora = 0;
        minutos = 0;
        segundos = 0;
        ip = "N/a";
        razon = "N/a";
        puerto = "N/a";
    }

    Entrada(int mes, int dia, int hora, int minutos, int segundos) {
        this->mes = mes;
        this->dia = dia;
        this->hora = hora;
        this->minutos = minutos;
        this->segundos = segundos;
    }

    int calculateFecha() {
        return segundos + minutos * 100 + hora * 10000 + dia * 1000000 + mes * 100000000; 
    }

    void show() {
        string meses[12] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        cout << "Mes: " << meses[mes] << endl;
        cout << "Dia: " << dia << endl;
        cout << "Hora: " << hora << endl;
        cout << "Minutos: " << minutos << endl;
        cout << "Segundos: " << segundos << endl;
        cout << "IP: " << ip << endl;
        cout << "Puerto: " << puerto << endl;
        cout << "Razon: " << razon << endl;
    }

    bool operator<(Entrada dato) {
        if (calculateFecha() < dato.calculateFecha()) {
            return true;
        }
        else {
            return false;
        }
    }

    bool operator>(Entrada dato) {
        if (calculateFecha() > dato.calculateFecha()) {
            return true;
        }
        else {
            return false;
        }
    }

    bool operator<=(Entrada dato) {
        if (calculateFecha() <= dato.calculateFecha()) {
            return true;
        }
        else {
            return false;
        }
    }

    bool operator>=(Entrada dato) {
        if (calculateFecha() >= dato.calculateFecha()) {
            return true;
        }
        else {
            return false;
        }
    }
};
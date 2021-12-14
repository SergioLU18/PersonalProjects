struct Entrada {
    
    int mes, dia, hora, minutos, segundos, cantidad;
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

    int calculate() {
        int n = 0;
        string temp;
        temp = ip.substr(6,3);
        n += stoi(temp) * 100;
        temp = ip.substr(10,4);
        n += stoi(temp);
        return n;
    }

    void show() {
        cout << "IP: " << ip << endl;
        //cout << "Puerto: " << puerto << endl;
    }

    bool operator<(Entrada dato) {
        if (ip < dato.ip) {
            return true;
        }
        return false;
    }

    bool operator>(Entrada dato) {
        if (ip > dato.ip) {
            return true;
        }
        return false;
        
    }

    bool operator<=(Entrada dato) {
        if (ip <= dato.ip) {
            return true;
        }
        return false;
    }

    bool operator>=(Entrada dato) {
        if (ip >= dato.ip) {
            return true;
        }
        return false;
    }
};
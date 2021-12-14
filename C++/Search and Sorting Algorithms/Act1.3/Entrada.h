struct Entrada {

    int mes, dia, hora, minutos, segundos;
    string ip, razon, puerto;

    Entrada() {
        this->mes = 0;
        this->dia = 0;
        this->hora = 0;
        this->minutos = 0;
        this->segundos = 0;
        this->ip = " ";
        this->puerto = " ";
        this->razon = " ";
    }

    Entrada(int mes, int dia, int hora, int minutos, int segundos) {
        this->mes = mes;
        this->dia = dia;
        this->hora = hora;
        this->minutos = minutos;
        this->segundos = segundos;
        this->ip = " ";
        this->puerto = " ";
        this->razon = " ";
    }

    void setMes(int mes) {
        this->mes = mes;
    }
    int getMes() {
        return this->mes;
    }
    void setDia(int dia) {
        this->dia = dia;
    }
    int getDia() {
        return this->dia;
    }
    void setHora(int hora) {
        this->hora = hora;
    }
    int getHora() {
        return this->hora;
    }
    void setMinutos(int minutos) {
        this->minutos = minutos;
    }
    int getMinutos() {
        return this->minutos;
    }
    void setSegundos(int segundos) {
        this->segundos = segundos;
    }
    int getSegundos() {
        return this->segundos;
    }
    void setIp(string ip) {
        this->ip = ip;
    }
    string getIp() {
        return this->ip;
    }
    void setPuerto(string puerto) {
        this->puerto = puerto;
    }
    string getPuerto() {
        return this->puerto;
    }
    void setRazon(string razon) {
        this->razon = razon;
    }
    string getRazon() {
        return this->razon;
    }

    void print(int i) {
        string meses[12] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        cout << "Entrada: " << i + 1 << endl;
        cout << "Fecha: " << meses[mes] << " " << dia << endl;
        cout << "Hora: " << hora << ":" << minutos << ":" << segundos << endl;
        cout << "Ip: " << ip << endl;
        cout << "Puerto: " << puerto << endl;
        cout << "Razon: " << razon << endl;
    }

    bool operator > (Entrada dato){
        if (mes > dato.getMes()) {
            return true;
        }
        if (mes == dato.getMes()) {
            if (dia > dato.getDia()) {
                return true;
            }
            if (dia == dato.getDia()) {
                if (hora > dato.getHora()) {
                    return true;
                }
                if (hora == dato.getHora()) {
                    if (minutos > dato.getMinutos()) {
                        return true;
                    }
                    if (minutos == dato.getMinutos()) {
                        if (segundos > dato.getSegundos()) {
                            return true;
                        }
                        if (segundos == dato.getSegundos()) {
                            return false;
                        }
                        else {
                            return false;
                        }
                    }
                    else {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
            else {
                return false;
            }
        }
        else {
            return false;
        }
    }
    
    bool operator >= (Entrada dato){
        if (mes > dato.getMes()) {
            return true;
        }
        if (mes == dato.getMes()) {
            if (dia > dato.getDia()) {
                return true;
            }
            if (dia == dato.getDia()) {
                if (hora > dato.getHora()) {
                    return true;
                }
                if (hora == dato.getHora()) {
                    if (minutos > dato.getMinutos()) {
                        return true;
                    }
                    if (minutos == dato.getMinutos()) {
                        if (segundos > dato.getSegundos()) {
                            return true;
                        }
                        if (segundos == dato.getSegundos()) {
                            return true;
                        }
                        else {
                            return false;
                        }
                    }
                    else {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
            else {
                return false;
            }
        }
        else {
            return false;
        }
    }
    bool operator == (Entrada dato) {
        if(mes == dato.getMes() & dia == dato.getDia() & hora == dato.getHora() & minutos == dato.getMinutos() & segundos == dato.getSegundos()) {
            return true;
        }
        else {
            false;
        }
    }
};
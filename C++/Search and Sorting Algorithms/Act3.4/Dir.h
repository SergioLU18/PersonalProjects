struct Dir {
    string ip, puerto;
    int cantidad;

    Dir() {
        ip = "N/a";
        puerto = "N/a";
        cantidad = 0;
    }

    bool operator<(Dir dir) {
        if(this->cantidad < dir.cantidad) {
            return true;
        }
        else {
            return false;
        }
    }

    bool operator>(Dir dir) {
        if(this->cantidad > dir.cantidad) {
            return true;
        }
        else {
            return false;
        }
    }

    bool operator<=(Dir dir) {
        if(this->cantidad <= dir.cantidad) {
            return true;
        }
        else {
            return false;
        }
    }

    bool operator>=(Dir dir) {
        if(this->cantidad >= dir.cantidad) {
            return true;
        }
        else {
            return false;
        }
    }

    void show() {
        cout << "IP: " << ip << endl;
        //cout << "Puerto: " << puerto << endl;
        cout << "Cantidad de accesos: " << cantidad << endl;
    }

};
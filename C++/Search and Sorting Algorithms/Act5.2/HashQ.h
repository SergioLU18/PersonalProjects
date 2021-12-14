class HashQ {
    private:
        vector<string> table;
        vector<int> status; //0-Vacia 1-Ocupada 2-Borrada
        int size;
        int hashing(string data);
        int quadTest(int index);
    public:
        HashQ();
        HashQ(int size);
        void createHash(vector<string> list);
        int getSize();
        bool isPrime(int n);
        int nextPrime(int n);
        bool isEmpty();
        bool isFull();
        void print();
        int findData(string data);
        void addData(string data);
        void deleteData(string data);
        HashQ(const HashQ&);
};

// Constructor vacio
HashQ :: HashQ() {
    size = 0;
}

// Funcion que devuelve el size
int HashQ :: getSize() {
    return size;
}

// Funcion que devuelve si el numero es primo
bool HashQ :: isPrime(int n) {
    if (n == 2 || n == 3)
        return true;
    if (n == 1 || n % 2 == 0)
        return false;
    for (int i = 3; i * i <= n; i += 2)
        if (n % i == 0)
            return false;
    return true;
}

// Funcion que devuelve el siguiente numero primo
int HashQ :: nextPrime(int n) {
    if (n <= 0)
        n == 3;
    if (n % 2 == 0)
        n++;
    for (; !isPrime( n ); n += 2);
    return n;
}

int HashQ :: hashing(string data) {
    int key = 0;
    for(auto c : data) {
        key += abs(int(c));
    } 
    return key%size; // Residuo
}

int HashQ :: quadTest(int index) {
    if(status[index] != 1) {
        return index;
    }
    int cont = 1;
    int newIndex = index;
    while(status[newIndex] == 1) {
        newIndex = (index + cont*cont) % size;
        cont++;
    }
    return newIndex;
}

// Constructor que toma un vector de datos como parametro
void HashQ :: createHash(vector<string> list) {

    // Asignamos size
    size = nextPrime(list.size());
    // Creamos tabla de datos y de status
    table = vector<string>(size);
    status = vector<int>(size, 0);
    // Declaramos variables
    int index, newIndex;
    // Ciclo en el que agregaremos datos
    for(auto data : list) {
        index = hashing(data);
        newIndex = quadTest(index);
        table[newIndex] = data;
        status[newIndex] = 1;
    }

}

// Constructor que toma size como parametro
HashQ :: HashQ(int size) {

    // Asignamos size
    this->size = size;
    // Creamos tabla de datos y de status
    table = vector<string>(size);
    status = vector<int>(size, 0);

}

// Funcion que checa si nuestra tabla esta llena
bool HashQ :: isFull() {
    
    if (std::find(status.begin(), status.end(), 1) != status.end()) {
        return false;
    }
    return true;

}

// Funcion que imprime todos los valores de la tabla
void HashQ :: print() {
    for(int i = 0; i < table.size(); i++) {
        cout << i << " - " << table[i] << endl;
    }
}

// Funcion que agrega dato a tabla
void HashQ :: addData(string data) {
    if(!isFull()) {
        int index = hashing(data);
        int newIndex = quadTest(index);
        table[newIndex] = data;
        status[newIndex] = 1;
    }
}

// Funcion que devuevle la posiicon de un dato tomado como parametro
int HashQ :: findData(string data) {
    int index = hashing(data);
    int newIndex = index;
    int cont = 1;
    bool doing = true;
    while(status[newIndex] == 1 && table[newIndex] != data){
        // Si no encuentra en la posicion, checa la siguiente
        newIndex = (index + cont*cont) % size;
        cont++;
    } 
    // En caso de no existir, devuelve -1
    return newIndex;
}


template<class T>
struct Edge {
    T vertex;
    int peso;
};

template<class T>
class GrafosL {
    private:
        vector<T> vertices;
        vector<vector<Edge<T>>> adjacents;
        vector<vector<Edge<T>>> heap;
        vector<T> verticesHeap;
        int findVertex(T vertex);
        void searchingBFS(int n, vector<bool> &visited, queue<T> &fila);
        void searchingDFS(int n, vector<bool> &visited);
        void searchingTop(int n, vector<bool> &visited, vector<T> &fila);
        bool searchingBip(int n, vector<string> &colors, queue<T> &fila, bool &status);
    public:
        GrafosL(vector<vector<T>> list);
        void print();
        void BFS(int inicio);
        void DFS(int inicio);
        void findPath(int inicio);
        void topSort();
        int minWeight(vector<int> weight, vector<bool> status);
        void bipartite();
        void maxHeap();
        void front();
        void max();
};

// Constuctor de la clase Grafos en formato "Lista de Adyacencia"
template<class T>
GrafosL<T> :: GrafosL(vector<vector<T>> list) {

    // Creamos variables
    int source = 0;
    int target = 1;
    int weight = 2;
    vector<Edge<T>> vec;

    // Creamos lista de vertices
    for(vector<T> edge : list) {
        T temp = edge[source];
        int pos = findVertex(temp);
        if(pos < 0) {
            vertices.push_back(temp);
        }
        temp = edge[target];
        pos = findVertex(temp);
        if(pos < 0) {
            vertices.push_back(temp);
        }
    }

    sort(vertices.begin(), vertices.end());

    // Crear lista de adyacencias del size de la cantidad de vertices
    vector<Edge<T>> temp;
    vector<vector<Edge<T>>> tempList(vertices.size(), temp);
    adjacents = tempList;

    // Agregar los destinos a la lista de adyacencias
    for(auto path : list) {
        int pos = findVertex(path[source]);
        Edge<T> edge;
        edge.vertex = path[target];
        edge.peso = 0;
        adjacents[pos].push_back(edge);
    }

}

// Funcion que imprime toda la lista de adyacencia
template<class T>
void GrafosL<T> :: print() {

    cout << endl;
    for(vector<Edge<T>> i : adjacents) {
            for(auto j : i) {
                cout << j.vertex << " -> ";
            }
        cout << endl;
    }
    cout << endl;

}

// Funcion que busca un vertice dentro de nuestro vector 'vertices' y devuelve la posicion en caso de encontrarlo
template<class T>
int GrafosL<T> :: findVertex(T vertex) {

    typename vector<T> :: iterator it;
    
    it = find(vertices.begin(), vertices.end(), vertex);

    if (it != vertices.end()) {
        return it - vertices.begin();
    }

    return -1;
}

// Funcion utilizada por BFS para poder funcionar de manera recursiva y poder determinar todos los caminos
template<class T>
void GrafosL<T> :: searchingBFS(int n, vector<bool> &visited, queue<T> &fila) {

    // Checamos si ya se visito este vertice
    // if(visited[n]) {
    //     paths.push_back(path);
    //     return;
    // }

    // En caso de no haber visitado checamos vecinos
    // else {

        // Cambiamos a que ya se visito e imprimimos vertice
        visited[n] = true;
        // path.push_back(vertices[n]);
        fila.pop();

        // Declaramos variables para uso mas simple
        int source = 0;
        int pos;

        // Imprimimos a los vecinos
        for(vector<T> arco : adjacents) {
            if(arco[source] == vertices[n]) {
                for(int i = 0; i < arco.size(); i++) {
                    pos = findVertex(arco[i]);
                    if(!visited[pos]) {
                        cout << vertices[pos] << " ";
                        fila.push(vertices[pos]);
                        visited[pos] = true;
                    }
                }
            }
        }

        // Funcion recursiva a los vecinos
        if(fila.size() >= 1) {
            pos = findVertex(fila.front());
            searchingBFS(pos, visited, fila);
        }

    // }


}

// Funcion que recorre la anchura de nuestro Grafo
template<class T>
void GrafosL<T> :: BFS(int inicio) {

    // Creamos vector de visitados
    vector<bool> visited(vertices.size(), false);

    // Creamos variable de fila tipo 'queue'
    queue<T> fila;

    // Llamamos funcion recursiva
    cout << endl;
    cout << "BFS --> " << vertices[inicio] << " ";
    fila.push(vertices[inicio]);
    searchingBFS(inicio, visited, fila);

}

// Funcion utilizada por DFS para poder funcionar de manera recursiva y determinar todos los caminos
template<class T>
void GrafosL<T> :: searchingDFS(int n, vector<bool> &visited) {

    // Checamos si ya se visito este vertice
    if(visited[n]) {
        return;
    }

    // En caso de no haber visitado checamos
    else {

        // Cambiamos a que ya se visito el vertice
        visited[n] = true;
        cout << vertices[n] << " ";

        // Declaramos variables 
        int pos;
        int source = 0;

        // Llamamos funcion con todos los vecinos
        for(vector<T> arco : adjacents) {
            if(arco[source] == vertices[n]) {
                for(int i = 0; i < arco.size(); i++) {
                    pos = findVertex(arco[i]);
                    searchingDFS(pos, visited);
                }
            }
        }
    }

}

// Funcion que recorre la profundidad de nuestro Grafo
template<class T>
void GrafosL<T> :: DFS(int inicio) {

    // Creamos vector de visitados
    vector<bool> visited(vertices.size(), false);

    // Llamamos funcion recursiva
    cout << endl;
    cout << "DFS --> ";
    searchingDFS(inicio, visited);
    cout << endl;
}

// Funcion que busca el valor mas corto de nuestro vector
template<class T>
int GrafosL<T> :: minWeight(vector<int> weight, vector<bool> status) {
    int pos = -1;
    int shortest = INT_MAX;
    for(int i = 0; i < weight.size(); i++) {
        if(!status[i]) {
            if(weight[i] < shortest) {
                shortest = weight[i];
                pos = i;
            }
        }
    }
    return pos;
}

// Funcion que usara algoritmo de Dijkstra para encontrar caminos mas cortos
template<class T>
void GrafosL<T> :: findPath(int inicio) {

    // Creamos vectores
    vector<T> paths(vertices.size(), -1);
    vector<int> costs(vertices.size(), INT_MAX);
    costs[inicio] = 0;
    vector<bool> visited(vertices.size(), false);

    // Variables
    int current = inicio;
    int pos;
    while(current >= 0) {

        visited[current] = true;
        // Checamos vecinos
        for(int vecino = 1; vecino < adjacents[current].size(); vecino++) {
            // Obtenemos posicion de vecino
            pos = findVertex(adjacents[current][vecino].vertex);
            if(!visited[pos]) {
                if(costs[current] + adjacents[current][vecino].peso < costs[pos]) {
                    // Asignamos valores
                    costs[pos] = costs[current] + adjacents[current][vecino].peso;
                    paths[pos] = current;
               }
           }
       }

       current = minWeight(costs, visited);

   }

    cout << endl;
    vector<T> fila;
    for(int i = 0; i < vertices.size(); i++) {
        fila.clear();
        cout << vertices[i] << " ";
        int next = paths[i];
        while(next >= 0) {
            fila.insert(fila.begin(), next);
            next = paths[next];
        }
        for(int j = 0; j < fila.size(); j++) {
            cout << " --> " << fila[j];
        }
        cout << " with cost: " << costs[i] << endl;
    }
    cout << endl;

}

// Algoritmo utilizado por 'TopSort' para encontrar el orden
template<class T>
void GrafosL<T> :: searchingTop(int n, vector<bool> &visited, vector<T> &fila) {
    if (visited[n]) {
        return;
    }
    else {
        // Mencionamos que visitamos nodo
        visited[n] = true;
        // Variable
        int pos;
        // Checamos vecinos
        for(int i = 1; i < adjacents[n].size(); i++) {
            // Obtenemos posicion de vecino
            pos = findVertex(adjacents[n][i].vertex);
            // Llamamos funcion con valores vecinos para recorrer
            if(pos > 0) {
                searchingTop(pos, visited, fila);
            }
        }
        // Al terminar insertamos el valor a nuestra fila al principio
        fila.insert(fila.begin(), vertices[n]);
    }
}

// Algoritmo que busca el orden topologico
template<class T>
void GrafosL<T> :: topSort() {

    // Creamos vector de visitados
    vector<bool> visited(vertices.size(), false);

    // Creamos vector de fila
    vector<T> fila;

    // Variables
    bool doing = true;
    int n = 0;
    
    while(doing) {
        searchingTop(n, visited, fila);
        // Checamos si existen nodos por visitar
        for(int i = 0; i < visited.size(); i++) {
            if(!visited[i]) {
                n = i;
            }
        }
        // Si el nodo elegido esta visitado, es que ya visitamos todos los nodos
        if(visited[n]) {
            doing = false;
        }
    }

    // Ya que se creo el ordenamiento imprimimos los valores
    cout << endl;
    for(int i = 0; i < fila.size(); i++) {
        if(i == 0) {
            cout << "Topological Sort: " << fila[i];
        }
        else {
            cout << " --> " << fila[i];
        }
    }
    cout << endl << endl;

}

// Algoritmo usado por bipartite para verificar que sea bipartita
template<class T>
bool GrafosL<T> :: searchingBip(int n, vector<string> &colors, queue<T> &fila, bool &status) {

    // Eliminamos vertice de fila
    fila.pop();

    // Variable
    int pos;

    // Checamos vecinos
    for(int i = 0; i < adjacents[n].size(); i++) {
        if(i != 0) {
            pos = findVertex(adjacents[n][i].vertex);
            if(colors[n] == colors[pos]) {
                status = false;
                return status;
            }
            else {
                if(colors[n] == "blue") {
                    colors[i] = "red";
                }
                else if(colors[n] == "red") {
                    colors[i] = "blue";
                }
                fila.push(vertices[pos]);
            }
        }
    }

    // Recursion
    if(fila.size() >= 1) {
        pos = findVertex(fila.front());
        searchingBip(pos, colors, fila, status);
    }

}

// Algoritmo que checa si el Grafo es bipartito
template<class T>
void GrafosL<T> :: bipartite() {

    // Creamos vector de colores
    vector<string> colors(vertices.size(), "white");
    colors[0] = "blue";

    // Creamos variable de tipo queue
    queue<T> fila;
    fila.push(vertices[0]);

    // Variable temporal
    bool status = true;

    status = searchingBip(0, colors, fila, status);
    cout << endl << "Bipartite: " << status << endl << endl;
    
}

// O(n^2)
// Algoritmo con el que haremos nuestro max Heap
template<class T>
void GrafosL<T> :: maxHeap() {

    // Despejamos vector de heap y vertices heap
    heap.clear();
    verticesHeap.clear();

    // Declaramos variable 
    int pos, n;

    // Introducimos cada elemento a la lista
    for(int i = 0; i < adjacents.size(); i++) {
        // Metemos el valor de 'i' en nuestro heap
        heap.push_back(adjacents[i]);
        // Metemos el valor de vertices en 'i'
        verticesHeap.push_back(vertices[i]);
        // Posicion inicial sera el ultimo elmento del heap
        pos = heap.size() - 1;
        // Empazamos ciclo checando si el padre tiene menos accesos
        while(pos > 0 && heap[pos/2].size() < heap[pos].size()) {
            // En caso de tener menos accesos, hacemos un swap
            swap(heap[pos/2], heap[pos]);
            // Movemos valores del vertice
            swap(verticesHeap[pos/2], verticesHeap[pos]);
            // Recorremos
            pos = pos / 2;
        }
    }

}

// Funcion que dara el primer valor del heap (# mayor de accesos)
template<class T>
void GrafosL<T> :: front() {
    cout << "\nIP con mas accesos: " << verticesHeap[0] << " con " << heap[0].size() << " accesos\n" << endl;
}

// Funcion temporal que use para ver ip con mas accesos
template<class T>
void GrafosL<T> :: max() {
    int n = 0;
    for(vector<Edge<T>> i : adjacents) {
        if(i.size() > n) {
            n = i.size();
        }
    }
    cout << "Num accesos max: " << n << endl;
}

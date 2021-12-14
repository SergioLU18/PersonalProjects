#include "HashQ.h"
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
        HashQ hash;
        int findVertex(T vertex);
    public:
        GrafosL(vector<vector<T>> list);
        void printAdjacents(string looking);
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

    // Creamos tabla hash con base a vector de vertices
    hash.createHash(vertices);

    // Crear lista de adyacencias del size de la cantidad de vertices
    vector<Edge<T>> temp;
    vector<vector<Edge<T>>> tempList(hash.getSize(), temp);
    adjacents = tempList;
    

    // Agregar los destinos a la lista de adyacencias
    for(auto path : list) {
        int pos = hash.findData(path[source]);
        Edge<T> edge;
        edge.vertex = path[target];
        edge.peso = 0;
        adjacents[pos].push_back(edge);
    }

}

// Funcion que imprime todos las adyacencias del ip introducido
template<class T>
void GrafosL<T> :: printAdjacents(string looking) {

    int pos = hash.findData(looking);
    cout << looking;
    for(auto element : adjacents[pos]) {
        cout << " --> " << element.vertex;
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

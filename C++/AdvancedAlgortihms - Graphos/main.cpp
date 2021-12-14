#include <iostream>
#include <climits>
#include <queue>
#include <vector>
#include <algorithm>
#include <unordered_set>
#include <map>
#include <cmath>
#include <cfloat>
#include <fstream>

using namespace std;

#define MAX 400

typedef  pair<int, int> iPair; 

struct Colonia {
    string name;
    int x, y;
    bool central;
    Colonia() {
        name = "";
        x = 0;
        y = 0;
        central = 0;
    }
    Colonia(string name, int x, int y,  bool central) {
        this->x = x;
        this->y = y;
        this->name = name;
        this->central = central;
    }
};
  
struct Graph { 
    int V, E, costMSTKruskal, costMSTPrim; 
    int matrix[MAX][MAX]; // Adyacencia
    int mat[MAX][MAX];    // Floyd   
    int p[MAX][MAX];      // Floyd
    int centrales;        // Cantidad de centrales
    vector< pair<int, pair<int, int>> > edges;     // Kruskal
    vector<vector<pair<int, int>>> adjList;        // Prim
    vector<pair<int, int>> selectedEdgesK;         // Arcos Kruskal
    vector<pair<int, int>> selectedEdgesP;         // Arcos Prim
  
    Graph(int V, int E){ 
        this->V = V; 
        this->E = E;
        adjList.resize(V); 
        costMSTKruskal = 0;
        costMSTPrim = 0;
        centrales = 0;
    } 
  
    void addEdge(int u, int v, int w) { 
        matrix[u][v] = matrix[v][u] = mat[u][v] = mat[v][u] = w;
        edges.push_back({w, {u, v}}); // First es el costo, second es el vertice de conexion
        adjList[u].push_back({v,w});
    } 
    void load(map<string, int> pos);
    void print();
    void kruskalMST(); 
    void primMST();
    void tsp(ofstream& myfile, vector<Colonia> colonias);
    void floyd();
    void printFloyd();
    void consultaFloyd(ofstream& myfile, map<int, string> indexColonias, int a, int b);
    void checarTrayectoria(ofstream& myfile, int a, int b, map<int, string> indexColonias);
}; 

struct Nodo{
    int niv;
    int costoAcum;
    int costoPos;
    int verticeAnterior;
    int verticeActual;
    bool visitados[MAX];
    vector<string> coloniasVisitadas;
    bool operator<(const Nodo &otro) const{
        return costoPos >= otro.costoPos;
    }
    
    // marcar todos los vistiados como false
    Nodo(){
        for(int i=0; i<MAX; i++){
            visitados[i] = false;
        }
    }
};

struct DisjointSets 
{ 
    int *parent, *rnk; 
    int n; 
  
    DisjointSets(int n){ 
        this->n = n; 
        parent = new int[n+1]; 
        rnk = new int[n+1]; 
        for (int i = 0; i <= n; i++){ 
            rnk[i] = 0; 
            parent[i] = i; 
        } 
    } 
  
    int find(int u) 
    { 
        if (u != parent[u]) 
            parent[u] = find(parent[u]); 
        return parent[u]; 
    } 
  
    void merge(int x, int y) 
    { 
        x = find(x), y = find(y); 
        if (rnk[x] > rnk[y]) 
            parent[y] = x; 
        else 
            parent[x] = y; 
        if (rnk[x] == rnk[y]) 
            rnk[y]++; 
    } 
}; 



string coloniaClose;
Colonia coloniaTemp;

void Graph::load(map<string, int> posColonias){
    string a, b;
    int c;
    for(int i = 0; i < V; i++) {
        for(int j = 0; j < V; j++) {
            matrix[i][j] = matrix[j][i] = mat[i][j] = mat[j][i] = INT_MAX;
        }
    }
    for (int i=0; i<E; i++){
        cin >> a >> b >> c;
        addEdge(posColonias[a],posColonias[b],c);
    }
    for(int i = 0; i < V; i++) {
        for(int j = 0; j < V; j++) {
            p[i][j] = p[j][i] = -1;
        }
    }
}

void Graph::floyd() {
    for(int k = 0; k < V; k++) {
        for(int i = 0; i < V; i++) {
            for(int j = 0; j < V; j++) {
                if(mat[i][k] != INT_MAX && mat[k][j] != INT_MAX && mat[i][k] + mat[k][j] < mat[i][j]) {
                    mat[i][j] = mat[i][k] + mat[k][j];
                    p[i][j] = k;
                }
            }
        }
    }
}

void Graph::printFloyd() {
    cout << "Matriz de costos: " << endl;
    for(int i = 0; i < V; i++) {
        for(int j = 0; j < V; j++) {
            if(mat[i][j] == INT_MAX) {
                cout << "INF\t";
            }
            else {
                cout << mat[i][j] << "\t";
            }
        }
        cout << endl;
    }
    cout << "Matriz de trayectorias: " << endl;
    for(int i = 0; i < V; i++) {
        for(int j = 0; j < V; j++) {
            cout << p[i][j] << "\t";
        }
        cout  << endl;
    }
}

void Graph::checarTrayectoria(ofstream& myfile, int a, int b, map<int, string> indexColonias) {
    if(p[a][b] != -1) {
        checarTrayectoria(myfile, a, p[a][b], indexColonias);
        myfile << indexColonias[p[a][b]] << " - ";
        checarTrayectoria(myfile, p[a][b], b, indexColonias);
    }
}

void Graph::consultaFloyd(ofstream& myfile, map<int, string> indexColonias, int a, int b) {
    if ( mat[a][b] == INT_MAX) {
        cout << "No hay camino" << endl;
    }
    else {
        myfile << indexColonias[a] << " - ";
        checarTrayectoria(myfile, a, b, indexColonias);
        myfile << indexColonias[b] << " (" << mat[a][b] << ")" << endl;
    }
}

void Graph::print(){
    cout << "Adjacent List:" << endl;
    for (int i=0; i<V; i++){
        cout << " " << i << ": ";
        for (int j=0; j<adjList[i].size(); j++){
            cout << "(" << adjList[i][j].first << "," << adjList[i][j].second << ") ";
        }
        cout << endl;
    }
    cout << "Matrix: " << endl;
    for(int i = 0; i < V; i++) {
        for(int j = 0; j < V; j++) {
            cout << matrix[i][j] << " ";
        }
        cout << endl;
    }
}
// aqui empieza el tsp
void calculaCostoPosible(Nodo &nodoActual, int matAdj[MAX][MAX], int n){
    nodoActual.costoPos = nodoActual.costoAcum;
    int costoObtenido;
    for(int i=0; i<=n; i++) {
        costoObtenido = INT_MAX;

        if(!nodoActual.visitados[i] || i == nodoActual.verticeActual){
            if(!nodoActual.visitados[i]){
                for(int j=1; j<=n; j++){
                    if(i != j && (!nodoActual.visitados[j] || j == 1)){
                        costoObtenido = min(costoObtenido, matAdj[i][j]);
                    }
                }
            }
            else{
                for(int j=1; j<=n; j++){
                    if(!nodoActual.visitados[j]) {
                        costoObtenido = min(costoObtenido, matAdj[i][j]);
                    }
                }
            }
            nodoActual.costoPos += costoObtenido;
        }
    }
}

void Graph::tsp(ofstream& myfile, vector<Colonia> colonias) {
    int costoOpt = INT_MAX;
    int coloniaInicial = 0;
    while(colonias[coloniaInicial].central) {
        coloniaInicial++;
    }
    Nodo raiz;
    raiz.niv = 0;
    raiz.costoAcum = 0;
    raiz.verticeActual = coloniaInicial;
    raiz.visitados[coloniaInicial] = true;
    raiz.coloniasVisitadas.push_back(colonias[coloniaInicial].name);
    calculaCostoPosible(raiz, matrix, V);
    vector<string> ans;
    priority_queue<Nodo> pq;
    pq.push(raiz);
    while(!pq.empty()) {
        // Agarramos nodo
        Nodo temp = pq.top();
        pq.pop();
        // Checamos si ya recorrio todos los nodos y puede conectar con el final
        if(temp.niv == V - 1 - centrales and matrix[temp.verticeActual][coloniaInicial] != INT_MAX) {
            //cout << temp.niv << " with " << temp.costoAcum << endl;
            if(temp.costoAcum + matrix[temp.verticeActual][coloniaInicial] < costoOpt) {
                costoOpt = temp.costoAcum + matrix[temp.verticeActual][coloniaInicial];
                ans = temp.coloniasVisitadas;
                ans.push_back(colonias[coloniaInicial].name);
            }
        }
        else if(temp.costoPos < costoOpt) {
            // Checamos cada posible nodo a visitar y lo metemos al priority queue
            for(int i = 0; i < V; i++) {
                if(matrix[temp.verticeActual][i] != INT_MAX and temp.verticeActual != i and !temp.visitados[i]) {
                    // Creamos nodo que agregaremos al priority queue
                    Nodo child = temp;
                    child.costoAcum += matrix[temp.verticeActual][i];
                    if(colonias[i].central == 0) {
                        child.visitados[i] = true;
                        child.niv++;
                    }
                    child.verticeActual = i;
                    child.verticeAnterior = temp.verticeActual;
                    child.coloniasVisitadas = temp.coloniasVisitadas;
                    child.coloniasVisitadas.push_back(colonias[i].name);
                    calculaCostoPosible(child, matrix, V);
                    if(child.costoPos < costoOpt) {
                        pq.push(child);
                    }
                }
            }
        }
    }
    for(int i = 0; i < ans.size(); i++) {
        myfile << ans[i];
        if(i + 1< ans.size()) {
            myfile << " - ";
        }
    }
    myfile << endl << "La Ruta Optima tiene un costo de: " << costoOpt << endl;
}

// Complejidad: O(E logE)
void Graph::kruskalMST(){ 
    costMSTKruskal = 0;
    sort(edges.begin(), edges.end());
    DisjointSets ds(V);
    for(auto it : edges) {
        int u = it.second.first;
        int v = it.second.second;
        int set_u = ds.find(u);
        int set_v = ds.find(v);
        if(set_u != set_v) {
            ds.merge(u, v);
            costMSTKruskal += it.first;
            selectedEdgesK.push_back({u, v});
        }
    }
} 



bool compareX(const Colonia &p1, const Colonia &p2) {
    return (p1.x < p2.x);
}

bool compareY(const Colonia &p1, const Colonia &p2) {
    return (p1.y < p2.y);
}

float dist(Colonia &p1, Colonia &p2) {
    return sqrt((p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y));
}

float bruteForce(vector<Colonia> P, int ini, int fin) {
    float minBF = FLT_MAX;
    for(int j = 0; j <= fin; j++) {
        if(dist(coloniaTemp, P[j]) < minBF) {
            minBF = dist(coloniaTemp, P[j]);
            coloniaClose = P[j].name;
        }
    }
    return minBF;
}

float strip_Closest(vector<Colonia> &strip, float dMenor) {
    float dMinStrip = dMenor;
    // Ordenar el vector strip con respecto al eje de las Y's
    sort(strip.begin(), strip.end(), compareY);
    for(int j = 0; j < strip.size() && (strip[j].y - coloniaTemp.y) < dMinStrip; j++) {
        if(dist(coloniaTemp, strip[j]) < dMinStrip) {
            dMinStrip = dist(coloniaTemp, strip[j]);
            coloniaClose = strip[j].name;
        }
    }
    
    return dMinStrip;
}

float closest_Helper(vector<Colonia> &P, int ini, int fin) {
    // Si el rango tiene maximo 3 elementos ==> Fuerza Bruta.
    if(fin - ini < 3) {
        return bruteForce(P, ini, fin);
    }
    int mid = (ini + fin) / 2;
    Colonia midPoint = P[mid];
    float dl = closest_Helper(P, ini, mid);
    float dr = closest_Helper(P, mid+1, fin);
    float dMenor = min(dl, dr);

    // Construir un vector que contenga los puntos cercanos (menor a dMenor) con respecto al punto del medio.
    vector<Colonia> strip;
    for(int i = ini; i <= fin; i++) {
        if(abs(P[i].x - midPoint.x) < dMenor) {
            strip.push_back(P[i]);
        }
    }
    // Encontrar el menor entre las distancias de los puntos de strip y dMenor
    dMenor = strip_Closest(strip, dMenor);
    return dMenor;
}

float closest(vector<Colonia> P) {
    // Ordenar los puntos con respecto al eje X.
    sort(P.begin(), P.end(), compareX);
    return closest_Helper(P, 0, P.size()-1);
}

int main() {

    // n = cantidad de colonias
    // m = número de conexiones entre colonias
    // q = futuras nuevas colonias que se desean conectar.
    int n, m, q;
    cin >> n >> m >> q; 
    vector<Colonia> colonias(n);
    map<string, int> posColonias;
    map<int, string> indexColonias;
    string name;
    int x, y, central;
    // Creamos graph y cargamos datos
    Graph g(n, m);
    for(int i = 0; i < n; i++) {
        cin >> name >> x >> y >> central;
        Colonia colonia(name, x, y, central);
        colonias[i] = colonia;
        posColonias[name] = i;
        indexColonias[i] = name;
        if(central) {
            g.centrales++;
        }
    }
    g.load(posColonias);
    // Abrimos archivo donde escribiremos
    ofstream myfile("output.txt");

    // KRUSKAL = CABLEADO OPTIMO
    g.kruskalMST();
    myfile << "-------------------" << endl;
    myfile << "1 - Cableado optimo de nueva conexion." << endl;
    vector<pair<int,int>> selectedEdges = g.selectedEdgesK;
    for(auto it: selectedEdges) {
        myfile << indexColonias[it.first] << " - " << indexColonias[it.second] << " " << g.matrix[it.first][it.second] << endl;
    }
    myfile << "Costo total: " << g.costMSTKruskal << endl;

    g.floyd();

    // TSP = CICLO HAMILTONIANO PARA NO CENTRALES
    myfile << "-------------------" << endl;
    myfile << "2 - La ruta optima." << endl;
    g.tsp(myfile, colonias);

    // FLOYD = CAMINOS MAS CORTOS ENTRE CENTRALES
    myfile << "-------------------" << endl;
    myfile << "3 - Caminos mas cortos entre centrales." << endl;

    for(int i = 0; i < n; i++) {
        for(int j = i+1; j < n; j++) {
            // Checar si i con j son centrales
            if(colonias[i].central && colonias[j].central) {
                g.consultaFloyd(myfile, indexColonias, i, j);
            }
        }
    }

    // CLOSEST PAIR = CONEXION MAS CERCANA PARA NUEVOS PUNTOS
    myfile << "-------------------" << endl;
    myfile << "4 - Conexion de nuevas colonias." << endl;
    // Creamos vector para nuevas colonias y las cargamos
    vector<Colonia> coloniasNuevas(q);
    for(int i = 0; i < q; i++) {
        cin >> name >> x >> y;
        coloniaTemp = Colonia(name, x, y, 0);
        vector<Colonia> copiaColonias = colonias;
        closest(copiaColonias);
        myfile << name << " debe conectarse con " << coloniaClose << endl;
    }

    myfile << "-------------------" << endl;

}

/* 

EJEMPLO DE INPUT:

5 8 2
LindaVista 200 120 1
Purisima 150 75 0
Tecnologico -50 20 1
Roma -75 50 0
AltaVista -50 40 0
LindaVista Purisima 48
LindaVista Roma 17
Purisima Tecnologico 40
Purisima Roma 50
Purisima AltaVista 80
Tecnologico Roma 55
Tecnologico AltaVista 15
Roma AltaVista 18
Independencia 180 -15
Roble 45 68

EJEMPLO DE OUTPUT:

-------------------
1 – Cableado óptimo de nueva conexión.
Tecnologico - AltaVista 15
LindaVista - Roma 17
Roma - AltaVista 18
Purisima - Tecnologico 40
Costo Total: 90
-------------------
2 – La ruta óptima.
Purisima - Roma - AltaVista - Tecnologico - Purisima
La Ruta Óptima tiene un costo total de: 123
-------------------
3 – Caminos más cortos entre centrales.
LindaVista - Roma - AltaVista - Tecnologico (50)
-------------------
4 – Conexión de nuevas colonias.
Independencia debe conectarse con Purisima
Roble debe conectarse con AltaVista
-------------------

*/
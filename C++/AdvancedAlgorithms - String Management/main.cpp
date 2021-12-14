#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>

using namespace std;

int main() {

    // Declaramos variables
    ifstream data;
    vector<string> malicious;
    map<string, int> mapMal;
    string line, t;
    int q = 1;

    // Obtenemos codigos maliciosos
    data.open("mcode.txt");
    while(getline(data, line)) {
        mapMal[line] = 0;
    }
    for(auto const &pair: mapMal) {
        malicious.push_back(pair.first);
    }
    data.close();

    while(q < 4) {

        switch(q) {
            case 1:
                // Obtenemos transmisiones
                // transmission1
                data.open("transmission1.txt");
                while(getline(data, line)) {
                    t = line;
                }
                data.close();
                break;
            case 2:
                // transmission2
                data.open("transmission2.txt");
                while(getline(data, line)) {
                    t = line;
                }
                data.close();
                break;
            case 3:
                // transmission3
                data.open("transmission3.txt");
                while(getline(data, line)) {
                    t = line;
                }
                data.close();
                break;
        }

        // Creamos vector donde guardaremos posiciones
        int n = malicious.size();
        vector<int> tempVec;
        vector<vector<int>> posMal(n, tempVec);

        // Checamos transmission1
        int count1 = 0;
        char let;
        string temp;
        for(int i = 0; i < t.size(); i++) {
            // Checamos si hay una posible coincidencia
            let = t[i];
            for(int j = 0; j < malicious.size(); j++) {
                temp = malicious[j];
                // Checamos si tienen la misma inicial
                if(temp[0] == let) {
                    // Checamos si queda espacio
                    if(i + temp.size() < t.size()) {
                        // Comparamos y sumamos
                        if(temp == t.substr(i,temp.size())) {
                            mapMal[temp]++;
                            posMal[j].push_back(i);
                        }
                    }
                }
            }
        }
        int cont = 0;
        for(auto const &pair: mapMal) {
            cout << "Codigo: " << pair.first << endl;
            cout << "Transmission" << q << ".txt ==> " << pair.second << endl;
            mapMal[pair.first] = 0;
            for(int i = 0; i < posMal[cont].size(); i++) {
                cout << posMal[cont][i] << " ";
            }
            cont++;
            cout << endl;
        }
        q++;
        posMal.clear();
    }    


}

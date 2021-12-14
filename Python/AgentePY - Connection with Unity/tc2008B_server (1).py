# TC2008B. Sistemas Multiagentes y Gráficas Computacionales
# Python server to interact with Unity
# Sergio. Julio 2021
# Actualización Lorena Martínez Agosto 2021

from http.server import BaseHTTPRequestHandler, HTTPServer
import logging
import json
import numpy as np
import agentpy as ap
import random
import matplotlib.pyplot as plt
import seaborn as sns
import IPython

# Size of the board:
width = 30
height = 30

# Importa tu lógica de agentes aqui:

# Agente
class Coche(ap.Agent):

    def setup(self):

        # Genera la condicion pasajeros
        # 1 == pasajero discapacitado
        # 2 == carpool
        # 3 == pasajero individual
        self.pasajeros = random.randint(1,3)

# Modelo
class Estacionamiento(ap.Model):

    def setup(self):

        self.time = 0
        self.numCoches = 0

        # Creamos agentes (coches)
        n_cajones = int((self.p.size**2))
        cajones = self.agents = ap.AgentList(self, n_cajones)

        # Creamos grid (cajones)
        self.cajones = ap.Grid(self, [self.p.size]*2, track_empty=True)
        self.cajones.add_agents(cajones, random=False, empty=True)

        # Creamos lista de agentes (coches)
        self.coches = ap.AgentList(self, self.p.coches, Coche)

        # Condicion con la cual sabremos si es 'pared' o cajon
        # 0 == Calle
        # 1 == Linea blanca
        # 2 == Libre
        # 3 == Ocupado
        self.cajones.agents.condition = 0

        # Marcamos los contornos
        self.cajones.agents[0:38, 0:1].condition = 1
        self.cajones.agents[0:1, 0:38].condition = 1
        self.cajones.agents[37:38, 0:38].condition = 1
        self.cajones.agents[0:38, 37:38].condition = 1

        # Marcamos los primeros cajones
        self.cajones.agents[3:35, 17:19].condition = 1

        # Creamos cajones para mostrar disponibilidad
        cajon1 = self.cajones.agents[4:6, 12:17]
        cajon2 = self.cajones.agents[7:9, 12:17]
        cajon3 = self.cajones.agents[10:12, 12:17]
        cajon4 = self.cajones.agents[13:15, 12:17]
        cajon5 = self.cajones.agents[16:18, 12:17]
        cajon6 = self.cajones.agents[19:21, 12:17]
        cajon7 = self.cajones.agents[22:24, 12:17]
        cajon8 = self.cajones.agents[25:27, 12:17]
        cajon9 = self.cajones.agents[28:30, 12:17]
        cajon10 = self.cajones.agents[31:33, 12:17]

        cajon11 = self.cajones.agents[4:6, 19:24]
        cajon12 = self.cajones.agents[7:9, 19:24]
        cajon13 = self.cajones.agents[10:12, 19:24]
        cajon14 = self.cajones.agents[13:15, 19:24]
        cajon15 = self.cajones.agents[16:18, 19:24]
        cajon16 = self.cajones.agents[19:21, 19:24]
        cajon17 = self.cajones.agents[22:24, 19:24]
        cajon18 = self.cajones.agents[25:27, 19:24]
        cajon19 = self.cajones.agents[28:30, 19:24]
        cajon20 = self.cajones.agents[31:33, 19:24]
        
        self.listCajones = [cajon1, cajon2, cajon3, cajon4, cajon5, cajon6, cajon7, cajon8, cajon9, cajon10, cajon11, cajon12, cajon13,cajon14, cajon15, cajon16, cajon17, cajon18, cajon19, cajon20]
        
        self.listDiscapacitados = {cajon7:'cajon7',cajon8:'cajon8',cajon9:'cajon9',cajon10:'cajon10'}
        self.listCarpool = {cajon6:'cajon6',cajon20:'cajon20',cajon19:'cajon19',cajon18:'cajon18',cajon17:'cajon17',cajon16:'cajon16'}
        self.listIndividual = {cajon1:'cajon1',cajon2:'cajon2',cajon3:'cajon3',cajon4:'cajon4',cajon5:'cajon5',cajon11:'cajon11',cajon12:'cajon12',cajon13:'cajon13',cajon14:
        'cajon14',cajon15:'cajon15'}
        self.cajonesOcupados = []
        
        for cajon in self.listCajones:
            cajon.condition = 2

    def subasta(self):
        
        # Obtenemos pasajeros del coche que sigue
        n = self.coches[0].pasajeros
        # if n == 1:
        #     print("Entro coche con pasajero discapacitado")
        # if n == 2:
        #     print("Entro coche con carpool")
        # if n == 3:
        #     print("Entro coche con pasajero individual")
        
        # Variable con la que sabremos si se asigno lugar
        assigned = False

        # 1 == discapacitado
        if n == 1:
            for cajon in self.listDiscapacitados:
                if cajon not in self.cajonesOcupados:
                    cajon.condition = 3
                    self.cajonesOcupados.append(cajon)
                    assigned = True 
                    del self.coches[0]
                    return self.listDiscapacitados[cajon]

            if assigned == False:
                n += 1

        # 2 == carpool
        if n == 2:
            for cajon in self.listCarpool:
                if cajon not in self.cajonesOcupados:
                    cajon.condition = 3
                    self.cajonesOcupados.append(cajon)
                    assigned = True
                    del self.coches[0]
                    return self.listCarpool[cajon]
 
            if assigned == False:
                n += 1

        # 3 == individual
        if n == 3:
            for cajon in self.listIndividual:
                if cajon not in self.cajonesOcupados:
                    cajon.condition = 3
                    self.cajonesOcupados.append(cajon)
                    assigned = True
                    del self.coches[0]
                    return self.listIndividual[cajon]

            if assigned == False:
                return 'none'
                # print("Estacionamiento lleno")

    def quitar(self):
        
        self.cajonesOcupados[0].condition = 2
        del self.cajonesOcupados[0]
        return "quitar"

    # El step sera un manejo global en donde se asignara y quitara lugares
    def step(self):

        print('entro')

        ans = "none"
        self.time += 1
        if self.time % 2 == 0:
            ans = self.subasta()
        if self.time % 5 == 0:
            ans = self.quitar()
        
        return ans


#El rey del server:
class Server(BaseHTTPRequestHandler):
    
    # 

    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        
    def do_GET(self):
        logging.info("GET request,\nPath: %s\nHeaders:\n%s\n", str(self.path), str(self.headers))
        self._set_response()
        self.wfile.write("GET request for {}".format(self.path).encode('utf-8'))

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        #post_data = self.rfile.read(content_length)
        post_data = json.loads(self.rfile.read(content_length))
        #logging.info("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                     #str(self.path), str(self.headers), post_data.decode('utf-8'))
        logging.info("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                     str(self.path), str(self.headers), json.dumps(post_data))
        
        # AQUI ACTUALIZA LO QUE SE TENGA QUE ACTUALIZAR
        self._set_response()
        #AQUI SE MANDA EL SHOW 
        resp = "{\"data\":" + estacionamiento.step() + "}"
        print(resp)
        self.wfile.write(resp.encode('utf-8'))


def run(server_class=HTTPServer, handler_class=Server, port=8585):
    logging.basicConfig(level=logging.INFO)
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    logging.info("Starting httpd...\n") # HTTPD is HTTP Daemon!
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:   # CTRL+C stops the server
        pass
    httpd.server_close()
    logging.info("Stopping httpd...\n")

if __name__ == '__main__':
    from sys import argv
    
    # Modelo
    parameters = {'size': 38, 'coches': 50}
    estacionamiento = Estacionamiento(parameters)
    estacionamiento.setup()

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()

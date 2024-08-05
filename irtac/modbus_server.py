from pyModbusTCP.server import ModbusServer, DataBank
import random
import time
import logging

logging.basicConfig()
logging.getLogger('pyModbusTCP.server').setLevel(logging.DEBUG)

host = '0.0.0.0'
port = 8888

def run():
    Server = ModbusServer(host=host, port=port)
    Server.start()

if __name__ == '__main__':
    run()
    

from python import Python
from python import PythonObject

from collections.vector import InlineArray
import time

fn int_to_byte_list(n: Int) raises -> PythonObject:
    var py = Python.import_module("builtins")
    var byte_list: PythonObject = py.list()
    var temp = n
    while temp > 0:
        byte_list.append(PythonObject(UInt8(temp & 0xFF)))
        temp >>= 8
    return byte_list

fn python_byte_list_to_int(python_byte_list: PythonObject) raises -> Int:
    var n: Int = 0 
    var shift: Int = 0
    for byte_obj in python_byte_list:
        n |= (Int(byte_obj.__int__()) << shift)
        shift += 8
    return n 

fn main() raises:
    var py = Python.import_module("builtins")

    var client_py = Python.import_module("pyModbusTCP.client")
    var utils_py = Python.import_module("pyModbusTCP.utils")


    var client = client_py.ModbusClient(host='localhost', port=8888, auto_open=True)

    var watchdog: Int = 0
    var watchdog_address: Int = 0
    while True:
        var byte_list = client.read_holding_registers(watchdog_address, 4)
        watchdog = python_byte_list_to_int(byte_list)

        print("Watchdog: ", watchdog)
        time.sleep(1.0)

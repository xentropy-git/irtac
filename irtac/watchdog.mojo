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

fn main() raises:
    var py = Python.import_module("builtins")

    var client_py = Python.import_module("pyModbusTCP.client")
    var utils_py = Python.import_module("pyModbusTCP.utils")


    var client = client_py.ModbusClient(host='localhost', port=8888, auto_open=True)

    var watchdog: Int = 0
    var watchdog_address: Int = 0
    while True:
        print("Watchdog: ", watchdog)
        watchdog += 100
        var bytes = int_to_byte_list(watchdog)
        print(bytes.__str__())
        client.write_multiple_registers(watchdog_address,  bytes)
        time.sleep(1.0)

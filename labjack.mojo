from python import Python

struct LabjackDevice:
    var device_type: Int
    var connection_type: Int
    var serial_number: String
    var handle: Int


    fn __init__(inout self, info: PythonObject) raises:
        self.device_type = info[0]
        self.connection_type = info[1]
        self.serial_number = info[2]
        self.handle = -1

    fn __str__(self) -> String:
        return "LabjackDevice(Device type: " + String(self.device_type) + ", Connection type: " + String(self.connection_type) + ", Serial number: " + self.serial_number + ")"

    fn __repr__(self) -> String:
        return self.__str__()



fn main() raises:
    var ljm = Python.import_module("labjack.ljm")

    var handle = ljm.openS("ANY", "ANY", "ANY")
    var info = ljm.getHandleInfo(handle)
    var device = LabjackDevice(info)


    print(device)

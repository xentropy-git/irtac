from python import Python
from time import now

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
    var a_names =["AIN0_RANGE", "AIN0_RESOLUTION_INDEX", "AIN0_NEGATIVE_CH", "AIN0_SETTLING_US"]
    var a_values = [10.0, 0, 199, 0]

    print("Configuring analog input.")

    ljm.eWriteNames(handle, 4, a_names, a_values)

    print("Reading analog input.")

    var seconds_to_read = 2.0
    var start_time = now()
    var ns_to_read = int(seconds_to_read * 1e9)
    
    var data_points = 0

    var scanList = ljm.namesToAddresses(1, ["AIN0"])[0]
    ljm.eStreamStart(handle, 256, 1, scanList, 2048)
    while now() - start_time < ns_to_read:
        print("Tick")
        var a_values = ljm.eStreamRead(handle)
        data_points += len(a_values[0])

    print("Read " + String(data_points) + " data points in " + String(seconds_to_read) + " seconds.")

    # cleanup
    ljm.eStreamStop(handle)
    ljm.close(handle)

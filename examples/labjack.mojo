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
    var np = Python.import_module("numpy")
    var plt = Python.import_module("matplotlib.pyplot")
    var signal = Python.import_module("scipy.signal")
    var librosa = Python.import_module("librosa")
    var handle = ljm.openS("ANY", "ANY", "ANY")
    var info = ljm.getHandleInfo(handle)
    var device = LabjackDevice(info)
    print(device)
    var a_names =["AIN3_RANGE", "AIN3_RESOLUTION_INDEX", "AIN3_NEGATIVE_CH", "AIN3_SETTLING_US"]
    var a_values = [5.0, 0, 199, 0]

    print("Configuring analog input.")

    ljm.eWriteNames(handle, 4, a_names, a_values)

    print("Reading analog input.")

    var seconds_to_read = 12.0
    var start_time = now()
    var ns_to_read = int(seconds_to_read * 1e9)

    var sample_rate = 2048
    var samples_per_read = 256
    var data_points = 0

    var scanList = ljm.namesToAddresses(1, ["AIN3"])[0]
    ljm.eStreamStart(handle, samples_per_read, 1, scanList, sample_rate)
    
    var total_data = np.zeros(int(seconds_to_read * sample_rate))

    var i = 0
    while now() - start_time < ns_to_read:
        print("Tick")
        var a_values = ljm.eStreamRead(handle)[0]

        for j in range(0, len(a_values)):
            total_data[i] = a_values[j]
            i += 1


    print("Read " + String(len(total_data)) + " data points in " + String(seconds_to_read) + " seconds.")
    print(total_data)

    # write to csv
    with open("data.csv", "w") as f:
        for i in range(0, len(total_data)):
            f.write(String(total_data[i]) + "\n")

    var spectrogram = signal.spectrogram(total_data, fs=sample_rate, scaling='spectrum')
    plt.pcolormesh(spectrogram[1], spectrogram[0], np.log10(spectrogram[2]), cmap='viridis')
    plt.ylabel('Frequency [Hz]')
    plt.xlabel('Time [sec]')

    # save plt to file
    plt.savefig("spectrogram.png")

    # cleanup
    ljm.eStreamStop(handle)
    ljm.close(handle)


alias SAMPLE_RATE: Int = 2048
alias TICK_RATE: Int = 32
alias RAW_SIGNAL_CHUNK_SIZE: Int = SAMPLE_RATE // TICK_RATE
alias SCROLLING_BUFFER_SIZE: Int = SAMPLE_RATE * 12
alias FFT_SIZE: Int = 1024

@value
struct EngineState:
    var watchdog: Int               # incrementing number that changes to indicate system health
    var raw_signal: InlineArray[Float32, RAW_SIGNAL_CHUNK_SIZE]
    var magnitude_pk2pk: Float32    # peak to peak magnitude of the current signal
    var last_update: Int             # current time in ns
    var tick_rate: Int               # ticks per second
    var sample_rate: Int            # samples per second

    var fft: InlineArray[Float32, FFT_SIZE]
    var scrolling_buffer: InlineArray[Float32, SCROLLING_BUFFER_SIZE]

    fn __init__(inout self):
        self.watchdog = 0

        # initialize to zeros
        self.raw_signal = InlineArray[Float32, RAW_SIGNAL_CHUNK_SIZE](0)
        self.magnitude_pk2pk = 0.0
        self.last_update = 0
        self.tick_rate = TICK_RATE
        self.sample_rate = SAMPLE_RATE
        self.fft = InlineArray[Float32, FFT_SIZE](0)
        self.scrolling_buffer = InlineArray[Float32, SCROLLING_BUFFER_SIZE](0)





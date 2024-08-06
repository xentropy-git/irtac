import asyncio
import logging
from logging.handlers import TimedRotatingFileHandler
import colorlog
import pymodbus
from pymodbus import pymodbus_apply_logging_config
from pymodbus.datastore import ModbusSimulatorContext
from pymodbus.server.simulator.http_server import ModbusSimulatorServer


# File handler with rotation at midnight
file_handler = TimedRotatingFileHandler("logs/log.txt", when="midnight", interval=1, backupCount=7)
file_formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
file_handler.setFormatter(file_formatter)

# Console handler with color
console_handler = colorlog.StreamHandler()
console_formatter = colorlog.ColoredFormatter(
    "%(log_color)s%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    datefmt=None,
    reset=True,
    log_colors={
        'DEBUG': 'cyan',
        'INFO': 'green',
        'WARNING': 'yellow',
        'ERROR': 'red',
        'CRITICAL': 'red,bg_white',
    },
    secondary_log_colors={},
    style='%'
)
console_handler.setFormatter(console_formatter)
handlers = [console_handler, file_handler]

logging.basicConfig(level=logging.DEBUG, handlers=handlers)

logger = logging.getLogger(__file__)



async def run_simulator():
    logger.info("Starting modbus server.")
    task = ModbusSimulatorServer()
    #pymodbus.logging.Log._logger = logger
    await task.run_forever()

if __name__ == "__main__":
    asyncio.run(run_simulator(), debug=True)

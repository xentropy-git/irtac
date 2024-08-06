#!/usr/bin/env python3
"""Pymodbus simulator server/client Example.

An example of how to use the simulator (server) with a client.

for usage see documentation of simulator

.. tip:: pymodbus.simulator starts the server directly from the commandline
"""
import asyncio
import logging

from pymodbus import FramerType
from pymodbus.client import AsyncModbusTcpClient
from pymodbus.datastore import ModbusSimulatorContext, ModbusSlaveContext, ModbusSequentialDataBlock, ModbusServerContext
from pymodbus.server import ModbusSimulatorServer, get_simulator_commandline


async def run_simulator():
    """Run server."""
    #_logger.info("### start server simulator")

    datastore = ModbusSlaveContext(
                di=ModbusSequentialDataBlock(0, [0] * 100),
                co=ModbusSequentialDataBlock(0, [0] * 100),
                hr=ModbusSequentialDataBlock(0, [0] * 500),
                ir=ModbusSequentialDataBlock(0, [0] * 500),
            )

    context = ModbusSimulatorContext(slaves=datastore, single=True)

    server = ModbusSimulator(context)

    server.serve_forever()

    #_logger.info("### shutdown server")
    await task.stop()
    #_logger.info("### Thanks for now.")


if __name__ == "__main__":
    asyncio.run(run_simulator(), debug=True)

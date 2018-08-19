`include "src/snow64_memory_access_fifo_defines.header.sv"

package PkgSnow64MemoryAccessFifo;


typedef logic [`MSB_POS__SNOW64_CPU_ADDR:0] CpuAddr;
typedef logic [`MSB_POS__SNOW64_MEMORY_ACCESS_FIFO__DATA:0] LarData;


// Snow64MemoryAccessReadFifo

typedef enum logic
{
	RdFifoStIdle,
	RdFifoStWaitForMem
} ReadFifoState;

typedef struct packed
{
	logic req;

	// This address is generally aligned to the size of LarData.
	CpuAddr addr;
} PartialPortIn_ReadFifo_ReqRead;

typedef struct packed
{
	logic valid, cmd_accepted;
	LarData data;
} PartialPortIn_ReadFifo_FromMemoryBusGuard;

typedef struct packed
{
	logic valid, busy;
	LarData data;
} PartialPortOut_ReadFifo_ReqRead;

typedef PartialPortIn_ReadFifo_ReqRead
	PartialPortOut_ReadFifo_ToMemoryBusGuard;


typedef struct packed
{
	logic `STRUCTDIM(PartialPortIn_ReadFifo_ReqRead) req_read;
	logic `STRUCTDIM(PartialPortIn_ReadFifo_FromMemoryBusGuard)
		from_memory_bus_guard;
} PortIn_MemoryAccessReadFifo;

typedef struct packed
{
	logic `STRUCTDIM(PartialPortOut_ReadFifo_ReqRead) req_read;
	logic `STRUCTDIM(PartialPortOut_ReadFifo_ToMemoryBusGuard)
		to_memory_bus_guard;
} PortOut_MemoryAccessReadFifo;


// Snow64MemoryAccessWriteFifo

typedef struct packed
{
	logic valid, cmd_accepted;
} PartialPortIn_WriteFifo_FromMemoryBusGuard;




endpackage : PkgSnow64MemoryAccessFifo

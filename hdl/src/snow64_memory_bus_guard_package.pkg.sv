`include "src/snow64_memory_bus_guard_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


package PkgSnow64MemoryBusGuard;

typedef logic [`MSB_POS__SNOW64_CPU_ADDR:0] CpuAddr;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] LarData;

//typedef enum logic [`MSB_POS__SNOW64_MEMORY_BUS_GUARD__STATE:0]
//{
//	StIdle,
//	StOneReqWaitForMem,
//	StTwoReqsWaitForMem0,
//	StTwoReqsWaitForMem1
//} State;

typedef enum logic [`MSB_POS__SNOW64_MEMORY_BUS_GUARD__REQUEST_TYPE:0]
{
	ReqTypNone,
	ReqTypReadInstr,
	ReqTypReadData,
	ReqTypWriteData
} RequestType;

typedef struct packed
{
	logic req;
	CpuAddr addr;
} PartialPortIn_MemoryBusGuard_ReqRead;

typedef struct packed
{
	logic req;
	CpuAddr addr;
	LarData data;
} PartialPortIn_MemoryBusGuard_ReqWrite;

typedef struct packed
{
	// valid:  indicate command complete
	// cmd_accepted:  indicate command accepted (used for clearing the
	// FIFO)
	logic valid, cmd_accepted;
	LarData data;
} PartialPortOut_MemoryBusGuard_ReqRead;

typedef struct packed
{
	// valid:  indicate command complete
	// cmd_accepted:  indicate command accepted (used for clearing the
	// FIFO)
	logic valid, cmd_accepted;
} PartialPortOut_MemoryBusGuard_ReqWrite;


// The memory input interface
typedef struct packed
{
	logic valid;
	LarData data;
} PartialPortIn_MemoryBusGuard_MemAccess;

// Whether we want to read from or write to memory.
typedef enum logic
{
	MemAccTypRead,
	MemAccTypWrite
} MemAccessType;

// The memory output interface
typedef struct packed
{
	logic req;
	CpuAddr addr;
	LarData data;
	logic mem_acc_type;
} PartialPortOut_MemoryBusGuard_MemAccess;

typedef struct packed
{
	logic `STRUCTDIM(PartialPortIn_MemoryBusGuard_ReqRead)
		req_read_instr, req_read_data;

	logic `STRUCTDIM(PartialPortIn_MemoryBusGuard_ReqWrite)
		req_write_data;

	logic `STRUCTDIM(PartialPortIn_MemoryBusGuard_MemAccess) mem_access;
} PortIn_MemoryBusGuard;

typedef struct packed
{
	logic `STRUCTDIM(PartialPortOut_MemoryBusGuard_ReqRead)
		req_read_instr, req_read_data;

	logic `STRUCTDIM(PartialPortOut_MemoryBusGuard_ReqWrite)
		req_write_data;

	logic `STRUCTDIM(PartialPortOut_MemoryBusGuard_MemAccess)
		mem_access;
} PortOut_MemoryBusGuard;


endpackage : PkgSnow64MemoryBusGuard

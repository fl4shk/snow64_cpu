`include "src/snow64_instr_cache_defines.header.sv"


package PkgSnow64InstrCache;

typedef logic [`MSB_POS__SNOW64_CPU_ADDR:0] CpuAddr;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] LarData;

typedef struct packed
{
	logic valid;
	LarData data;
} PartialPortIn_InstrCache_MemAccess;

typedef struct packed
{
	logic req;
	CpuAddr addr;
	LarData data;
} PartialPortIn_InstrCache_ReqRead;

typedef struct packed
{
	logic valid;
	LarData data;
} PartialPortOut_InstrCache_ReqRead;

typedef struct packed
{
	logic req;
	CpuAddr addr;
} PartialPortOut_InstrCache_MemAccess;

typedef struct packed
{
	logic `STRUCTDIM(PartialPortIn_InstrCache_ReqRead) req_read;
	logic `STRUCTDIM(PartialPortIn_InstrCache_MemAccess) mem_access;
} PortIn_InstrCache;

typedef struct packed
{
	logic `STRUCTDIM(PartialPortOut_InstrCache_ReqRead) req_read;
	logic `STRUCTDIM(PartialPortOut_InstrCache_MemAccess) mem_access;
} PortOut_InstrCache;


endpackage : PkgSnow64InstrCache

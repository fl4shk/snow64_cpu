`include "src/snow64_instr_cache_defines.header.sv"


package PkgSnow64InstrCache;

localparam WIDTH__LINE = `WIDTH__SNOW64_ICACHE_LINE;
localparam MSB_POS__LINE = `WIDTH2MP(WIDTH__LINE);

localparam WIDTH__LINE_PACKED_OUTER_DIM
	= `WIDTH__SNOW64_ICACHE_LINE_PACKED_OUTER_DIM;
localparam MSB_POS__LINE_PACKED_OUTER_DIM
	= `WIDTH2MP(WIDTH__LINE_PACKED_OUTER_DIM);

localparam WIDTH__LINE_PACKED_INNER_DIM
	= `WIDTH__SNOW64_ICACHE_LINE_PACKED_INNER_DIM;
localparam MSB_POS__LINE_PACKED_INNER_DIM
	= `WIDTH2MP(WIDTH__LINE_PACKED_INNER_DIM);

localparam WIDTH__INCOMING_ADDR__BASE_ADDR
	= `WIDTH__SNOW64_ICACHE_INCOMING_ADDR__BASE_ADDR;
localparam MSB_POS__INCOMING_ADDR__BASE_ADDR
	= `WIDTH2MP(WIDTH__INCOMING_ADDR__BASE_ADDR);


localparam ARR_SIZE__NUM_LINES = `ARR_SIZE__SNOW64_ICACHE_NUM_LINES;
localparam LAST_INDEX__NUM_LINES
	= `ARR_SIZE_TO_LAST_INDEX(ARR_SIZE__NUM_LINES);



typedef struct packed
{
	logic [`MSB_POS__SNOW64_ICACHE_INCOMING_ADDR__BASE_ADDR:0] base_addr;
	logic [`MSB_POS__SNOW64_ICACHE_INCOMING_ADDR__TAG:0] tag;
	logic [`MSB_POS__SNOW64_ICACHE_INCOMING_ADDR__LINE_INDEX:0] line_index;

	logic [`MSB_POS__SNOW64_ICACHE_INCOMING_ADDR__DONT_CARE:0] dont_care;
} IncomingAddr;


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

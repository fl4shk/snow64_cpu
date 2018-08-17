`include "src/snow64_instr_cache_defines.header.sv"


package PkgSnow64InstrCache;

localparam WIDTH__LINE_DATA = `WIDTH__SNOW64_ICACHE_LINE_DATA;
localparam MSB_POS__LINE_DATA = `WIDTH2MP(WIDTH__LINE_DATA);

localparam WIDTH__LINE_PACKED_OUTER_DIM
	= `WIDTH__SNOW64_ICACHE_LINE_PACKED_OUTER_DIM;
localparam MSB_POS__LINE_PACKED_OUTER_DIM
	= `WIDTH2MP(WIDTH__LINE_PACKED_OUTER_DIM);

localparam WIDTH__LINE_PACKED_INNER_DIM
	= `WIDTH__SNOW64_ICACHE_LINE_PACKED_INNER_DIM;
localparam MSB_POS__LINE_PACKED_INNER_DIM
	= `WIDTH2MP(WIDTH__LINE_PACKED_INNER_DIM);

//localparam WIDTH__EFFECTIVE_ADDR__LOW_BASE_ADDR
//	= `WIDTH__SNOW64_ICACHE_EFFECTIVE_ADDR__LOW_BASE_ADDR;
//localparam MSB_POS__EFFECTIVE_ADDR__LOW_BASE_ADDR
//	= `WIDTH2MP(WIDTH__EFFECTIVE_ADDR__LOW_BASE_ADDR);


localparam ARR_SIZE__NUM_LINES = `ARR_SIZE__SNOW64_ICACHE_NUM_LINES;
localparam LAST_INDEX__NUM_LINES
	= `ARR_SIZE_TO_LAST_INDEX(ARR_SIZE__NUM_LINES);


typedef logic [`MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__TAG:0] Tag;
typedef logic [`MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__ARR_INDEX:0]
	ArrIndex;
typedef logic [`MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__LINE_INDEX:0]
	LineIndex;

typedef logic [`MSB_POS__SNOW64_CPU_ADDR:0] CpuAddr;
typedef logic [`MSB_POS__SNOW64_ICACHE_LINE_DATA:0] LineData;
typedef logic [`MSB_POS__SNOW64_INSTR:0] Instr;


typedef struct packed
{
	Tag tag;
	ArrIndex arr_index;
	LineIndex line_index;

	logic [`MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__DONT_CARE:0] dont_care;
} EffectiveAddr;


typedef struct packed
{
	logic valid;
	LineData data;
} PartialPortIn_InstrCache_MemAccess;

typedef struct packed
{
	logic req;
	CpuAddr addr;
} PartialPortIn_InstrCache_ReqRead;

typedef struct packed
{
	logic valid;
	Instr instr;
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

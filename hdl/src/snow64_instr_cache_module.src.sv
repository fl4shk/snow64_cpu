`include "src/snow64_instr_cache_defines.header.sv"


module Snow64InstrCache(input logic clk,
	input PkgSnow64InstrCache::PortIn_InstrCache in,
	output PkgSnow64InstrCache::PortOut_InstrCache out);

	localparam __MSB_POS__LINE_DATA
		= PkgSnow64InstrCache::MSB_POS__LINE_DATA;
	localparam __MSB_POS__LINE_PACKED_OUTER_DIM
		= PkgSnow64InstrCache::MSB_POS__LINE_PACKED_OUTER_DIM;
	localparam __MSB_POS__LINE_PACKED_INNER_DIM
		= PkgSnow64InstrCache::MSB_POS__LINE_PACKED_INNER_DIM;
	localparam __ARR_SIZE__NUM_LINES
		= PkgSnow64InstrCache::ARR_SIZE__NUM_LINES;
	localparam __LAST_INDEX__NUM_LINES
		= PkgSnow64InstrCache::LAST_INDEX__NUM_LINES;

	localparam __MSB_POS__EFFECTIVE_ADDR__ARR_INDEX
		= `MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__ARR_INDEX;
	localparam __MSB_POS__EFFECTIVE_ADDR__TAG
		= `MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__TAG;
	localparam __MSB_POS__EFFECTIVE_ADDR__LINE_INDEX
		= `MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__LINE_INDEX;

	PkgSnow64InstrCache::PartialPortIn_InstrCache_ReqRead
		real_in_req_read;
	assign real_in_req_read = in.req_read;


	PkgSnow64InstrCache::PartialPortIn_InstrCache_MemAccess
		real_in_mem_access;
	assign real_in_mem_access = in.mem_access;


	PkgSnow64InstrCache::PartialPortOut_InstrCache_ReqRead
		real_out_req_read;
	assign out.req_read = real_out_req_read;

	PkgSnow64InstrCache::PartialPortOut_InstrCache_MemAccess
		real_out_mem_access;
	assign out.mem_access = real_out_mem_access;


	PkgSnow64InstrCache::EffectiveAddr __in_req_read__effective_addr;
	assign __in_req_read__effective_addr = real_in_req_read.addr;


	// Locals (not ports)
	logic [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0]
		__lines_arr[0 : __LAST_INDEX__NUM_LINES];

	PkgSnow64InstrCache::Tag __tags_arr[0 : __LAST_INDEX__NUM_LINES];
	logic __valid_flags_arr[0 : __LAST_INDEX__NUM_LINES];



	`ifdef FORMAL
	//wire __formal__in_req_read__req = real_in_req_read.req;
	//wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__in_req_read__addr 
	//	= real_in_req_read.addr;

	//wire __formal__in_mem_access__valid = real_in_mem_access.valid;
	//wire [__MSB_POS__LINE_DATA:0] __formal__in_mem_access__data
	//	= real_in_mem_access.data;

	//wire [__MSB_POS__EFFECTIVE_ADDR__BASE_ADDR:0]
	//	__formal__in_req_read__effective_addr__base_addr
	//	= __in_req_read__effective_addr.base_addr;
	wire [__MSB_POS__EFFECTIVE_ADDR__TAG:0]
		__formal__in_req_read__effective_addr__tag
		= __in_req_read__effective_addr.tag;
	wire [__MSB_POS__EFFECTIVE_ADDR__ARR_INDEX:0]
		__formal__in_req_read__effective_addr__arr_index
		= __in_req_read__effective_addr.arr_index;
	wire [__MSB_POS__EFFECTIVE_ADDR__LINE_INDEX:0]
		__formal__in_req_read__effective_addr__line_index
		= __in_req_read__effective_addr.line_index;

	//wire __formal__out_req_read__valid = real_out_req_read.valid;
	//wire [`MSB_POS__SNOW64_INSTR:0] __formal__out_req_read__instr
	//	= real_out_req_read.instr;

	//wire __formal__out_mem_access__req = real_out_mem_access.req;
	//wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__out_mem_access__addr
	//	= real_out_mem_access.addr;
	`endif		// FORMAL




	initial
	begin
		integer __i;

		for (__i=0; __i<__ARR_SIZE__NUM_LINES; __i=__i+1)
		begin
			__lines_arr[__i] = 0;
			__tags_arr[__i] = 0;
			__valid_flags_arr[__i] = 0;
		end
	end

endmodule

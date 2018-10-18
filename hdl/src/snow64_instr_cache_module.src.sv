`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_instr_cache_defines.header.sv"

module Snow64InstrCache(input logic clk,
	input PkgSnow64InstrCache::PartialPortIn_InstrCache_ReqRead
		in_req_read,
	input PkgSnow64InstrCache::PartialPortIn_InstrCache_MemAccess
		in_mem_access,

	output PkgSnow64InstrCache::PartialPortOut_InstrCache_ReqRead
		out_req_read,
	output PkgSnow64InstrCache::PartialPortOut_InstrCache_MemAccess
		out_mem_access);


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

	localparam __WIDTH__EFFECTIVE_ADDR__LINE_INDEX
		= `WIDTH__SNOW64_ICACHE_EFFECTIVE_ADDR__LINE_INDEX;
	localparam __MSB_POS__EFFECTIVE_ADDR__LINE_INDEX
		= `MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__LINE_INDEX;

	//localparam __MSB_POS__LINE_BYTE_INDEX
	//	= `MSB_POS__SNOW64_ICACHE_LINE_BYTE_INDEX;
	localparam __MSB_POS__EFFECTIVE_ADDR__DONT_CARE
		= `MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__DONT_CARE;


	logic __state = PkgSnow64InstrCache::StIdle,
		__next_state = PkgSnow64InstrCache::StIdle;


	PkgSnow64InstrCache::EffectiveAddr
		__curr_req_effective_addr, __captured_req_effective_addr = 0,
		__effective_addr_for_miss;
	logic __captured_in_req_read__req = 0;

	assign __curr_req_effective_addr = in_req_read.addr;

	assign __effective_addr_for_miss.tag
		= __captured_req_effective_addr.tag;
	assign __effective_addr_for_miss.arr_index
		= __captured_req_effective_addr.arr_index;
	assign __effective_addr_for_miss.line_index = 0;
	assign __effective_addr_for_miss.dont_care = 0;


	logic [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0]
		__lines_arr[__ARR_SIZE__NUM_LINES];
	wire [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0] __in_mem_access__data
		= in_mem_access.data;

	PkgSnow64InstrCache::Tag __tags_arr[__ARR_SIZE__NUM_LINES];
	logic __valid_flags_arr[__ARR_SIZE__NUM_LINES];

	logic [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0] __captured_req_line = 0;
	PkgSnow64InstrCache::Tag __captured_req_tag = 0;
	logic __captured_req_valid_flag = 0;

	wire __captured_req_line_is_valid = (__captured_req_valid_flag
		&& (__captured_req_tag == __captured_req_effective_addr.tag));

	initial
	begin
		integer __i;
		out_req_read = 0;
		out_mem_access = 0;

		for (__i=0; __i<__ARR_SIZE__NUM_LINES; __i=__i+1)
		begin
			__lines_arr[__i] = 0;
			__tags_arr[__i] = 0;
			__valid_flags_arr[__i] = 0;
		end
	end

	always @(*) out_req_read.valid = (__captured_in_req_read__req
		&& (__state == PkgSnow64InstrCache::StIdle)
		&& (__next_state == PkgSnow64InstrCache::StIdle));

	always @(*)
	begin
		case (__captured_req_effective_addr.line_index)
		0: out_req_read.instr = __captured_req_line[0];
		1: out_req_read.instr = __captured_req_line[1];
		2: out_req_read.instr = __captured_req_line[2];
		3: out_req_read.instr = __captured_req_line[3];
		4: out_req_read.instr = __captured_req_line[4];
		5: out_req_read.instr = __captured_req_line[5];
		6: out_req_read.instr = __captured_req_line[6];
		7: out_req_read.instr = __captured_req_line[7];
		endcase
	end

	// Compute __next_state
	always @(*)
	begin
		case (__state)
		PkgSnow64InstrCache::StIdle:
		begin
			__next_state = (__captured_in_req_read__req
				&& (!__captured_req_line_is_valid))
				? PkgSnow64InstrCache::StWaitForMem
				: PkgSnow64InstrCache::StIdle;
		end

		PkgSnow64InstrCache::StWaitForMem:
		begin
			__next_state = in_mem_access.valid
				? PkgSnow64InstrCache::StIdle
				: PkgSnow64InstrCache::StWaitForMem;
		end
		endcase
	end

	//initial
	//begin
	//	#200
	//	$display("INSTR CACHE:  debug $finish;");
	//	$finish;
	//end


	always @(posedge clk)
	begin
		//$display("INSTR CACHE stuff:  %h %h; %h %h %h; %h; %h %h",
		//	__state, __next_state,

		//	__captured_req_line,
		//	__captured_req_tag,
		//	__captured_req_valid_flag,

		//	__lines_arr[0],

		//	__curr_req_effective_addr,
		//	__captured_req_effective_addr);

		__state <= __next_state;

		case (__state)
		PkgSnow64InstrCache::StIdle:
		begin
			case (__next_state)
			PkgSnow64InstrCache::StIdle:
			begin
				out_mem_access.req <= 0;
				__captured_in_req_read__req <= in_req_read.req;
				__captured_req_effective_addr <= __curr_req_effective_addr;

				__captured_req_line <= __lines_arr
					[__curr_req_effective_addr.arr_index];
				__captured_req_tag <= __tags_arr
					[__curr_req_effective_addr.arr_index];
				__captured_req_valid_flag <= __valid_flags_arr
					[__curr_req_effective_addr.arr_index];
			end

			PkgSnow64InstrCache::StWaitForMem:
			begin
				$display("INSTR CACHE:  miss:  %h",
					__effective_addr_for_miss);

				out_mem_access.req <= 1;
				out_mem_access.addr <= __effective_addr_for_miss;
			end
			endcase
		end

		PkgSnow64InstrCache::StWaitForMem:
		begin
			out_mem_access.req <= 0;
			__captured_in_req_read__req <= 0;

			if (__next_state == PkgSnow64InstrCache::StIdle)
			begin
				$display("INSTR CACHE:  Done waiting for mem:  %h %h %h",
					__captured_req_effective_addr,
					in_mem_access.data,
					__captured_req_effective_addr.tag);
				__lines_arr[__captured_req_effective_addr.arr_index]
					<= in_mem_access.data;
				__tags_arr[__captured_req_effective_addr.arr_index]
					<= __captured_req_effective_addr.tag;
				__valid_flags_arr[__captured_req_effective_addr.arr_index]
					<= 1;
			end
		end
		endcase
	end


endmodule

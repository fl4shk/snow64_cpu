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

	localparam __WIDTH__EFFECTIVE_ADDR__LINE_INDEX
		= `WIDTH__SNOW64_ICACHE_EFFECTIVE_ADDR__LINE_INDEX;
	localparam __MSB_POS__EFFECTIVE_ADDR__LINE_INDEX
		= `MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__LINE_INDEX;

	//localparam __MSB_POS__LINE_BYTE_INDEX
	//	= `MSB_POS__SNOW64_ICACHE_LINE_BYTE_INDEX;
	localparam __MSB_POS__EFFECTIVE_ADDR__DONT_CARE
		= `MSB_POS__SNOW64_ICACHE_EFFECTIVE_ADDR__DONT_CARE;

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


	PkgSnow64InstrCache::EffectiveAddr
		__in_req_read__effective_addr, __addr_for_miss;
	assign __in_req_read__effective_addr = real_in_req_read.addr;

	assign __addr_for_miss.tag = __in_req_read__effective_addr.tag;
	assign __addr_for_miss.arr_index
		= __in_req_read__effective_addr.arr_index;
	assign __addr_for_miss.line_index = 0;
	assign __addr_for_miss.dont_care = 0;


	// Locals (not ports)
	logic [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0]
		__lines_arr[__ARR_SIZE__NUM_LINES];
	wire [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0] __in_mem_access__data
		= real_in_mem_access.data;

	PkgSnow64InstrCache::Tag __tags_arr[__ARR_SIZE__NUM_LINES];
	logic __valid_flags_arr[__ARR_SIZE__NUM_LINES];

	logic __state;


	logic [__MSB_POS__EFFECTIVE_ADDR__TAG:0]
		__captured_in_req_read__effective_addr__tag;
	logic [__MSB_POS__EFFECTIVE_ADDR__ARR_INDEX:0]
		__captured_in_req_read__effective_addr__arr_index;
	logic [__MSB_POS__EFFECTIVE_ADDR__LINE_INDEX:0]
		__captured_in_req_read__effective_addr__line_index;


	`ifdef FORMAL
	localparam __ENUM__STATE__IDLE = PkgSnow64InstrCache::StIdle;
	localparam __ENUM__STATE__WAIT_FOR_MEM
		= PkgSnow64InstrCache::StWaitForMem;

	logic [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0]
		__debug_lines_arr[__ARR_SIZE__NUM_LINES];

	PkgSnow64InstrCache::Tag __debug_tags_arr[__ARR_SIZE__NUM_LINES];
	logic __debug_valid_flags_arr[__ARR_SIZE__NUM_LINES];

	always @(posedge clk)
	begin
		integer i;
		for (i=0; i<__ARR_SIZE__NUM_LINES; i=i+1)
		begin
			__debug_lines_arr[i] <= __lines_arr[i];
			__debug_tags_arr[i] <= __tags_arr[i];
			__debug_valid_flags_arr[i] <= __valid_flags_arr[i];
		end
	end


	wire __formal__in_req_read__req = real_in_req_read.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__in_req_read__addr 
		= real_in_req_read.addr;

	wire __formal__in_mem_access__valid = real_in_mem_access.valid;
	wire [__MSB_POS__LINE_DATA:0] __formal__in_mem_access__data
		= real_in_mem_access.data;

	wire [__MSB_POS__EFFECTIVE_ADDR__TAG:0]
		__formal__in_req_read__effective_addr__tag
		= __in_req_read__effective_addr.tag;
	wire [__MSB_POS__EFFECTIVE_ADDR__ARR_INDEX:0]
		__formal__in_req_read__effective_addr__arr_index
		= __in_req_read__effective_addr.arr_index;
	wire [__MSB_POS__EFFECTIVE_ADDR__LINE_INDEX:0]
		__formal__in_req_read__effective_addr__line_index
		= __in_req_read__effective_addr.line_index;

	wire __formal__out_req_read__valid = real_out_req_read.valid;
	wire [`MSB_POS__SNOW64_INSTR:0] __formal__out_req_read__instr
		= real_out_req_read.instr;

	wire __formal__out_mem_access__req = real_out_mem_access.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__out_mem_access__addr
		= real_out_mem_access.addr;
	`endif		// FORMAL

	initial
	begin
		integer __i;

		// We start with NO valid information.
		for (__i=0; __i<__ARR_SIZE__NUM_LINES; __i=__i+1)
		begin
			__lines_arr[__i] = 0;
			__tags_arr[__i] = 0;
			__valid_flags_arr[__i] = 0;
		end

		__state = PkgSnow64InstrCache::StIdle;
		real_out_req_read = 0;
		real_out_mem_access = 0;
		__captured_in_req_read__effective_addr__tag = 0;
		__captured_in_req_read__effective_addr__arr_index = 0;
		__captured_in_req_read__effective_addr__line_index = 0;
	end

	`define CURR_CONTAINED_LINE \
		__lines_arr[__in_req_read__effective_addr.arr_index]
	`define CURR_CONTAINED_TAG \
		__tags_arr[__in_req_read__effective_addr.arr_index]
	`define CURR_CONTAINED_VALID_FLAG \
		__valid_flags_arr[__in_req_read__effective_addr.arr_index]

	`define CAPTURED_CONTAINED_TAG \
		__tags_arr[__captured_in_req_read__effective_addr__arr_index]
	`define CAPTURED_CONTAINED_LINE \
		__lines_arr[__captured_in_req_read__effective_addr__arr_index]
	`define CAPTURED_CONTAINED_VALID_FLAG \
		__valid_flags_arr[__captured_in_req_read__effective_addr__arr_index]

	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64InstrCache::StIdle:
		begin
			if (real_in_req_read.req)
			begin
				// InstrCache hit
				if ((`CURR_CONTAINED_TAG
					== __in_req_read__effective_addr.tag)
					&& `CURR_CONTAINED_VALID_FLAG)
				begin
					real_out_req_read.valid <= 1;

					//real_out_req_read.instr
					//	<= `CURR_CONTAINED_LINE
					//	[__in_req_read__effective_addr.line_index];
					case (__in_req_read__effective_addr.line_index)
					0:
					begin
						real_out_req_read.instr
							<= `CURR_CONTAINED_LINE[0];
					end
					1:
					begin
						real_out_req_read.instr
							<= `CURR_CONTAINED_LINE[1];
					end
					2:
					begin
						real_out_req_read.instr
							<= `CURR_CONTAINED_LINE[2];
					end
					3:
					begin
						real_out_req_read.instr
							<= `CURR_CONTAINED_LINE[3];
					end
					4:
					begin
						real_out_req_read.instr
							<= `CURR_CONTAINED_LINE[4];
					end
					5:
					begin
						real_out_req_read.instr
							<= `CURR_CONTAINED_LINE[5];
					end
					6:
					begin
						real_out_req_read.instr
							<= `CURR_CONTAINED_LINE[6];
					end
					7:
					begin
						real_out_req_read.instr
							<= `CURR_CONTAINED_LINE[7];
					end
					endcase

					real_out_mem_access.req <= 0;
				end

				// InstrCache miss
				else
				begin
					__state <= PkgSnow64InstrCache::StWaitForMem;
					real_out_req_read.valid <= 0;

					real_out_mem_access.req <= 1;
					real_out_mem_access.addr <= __addr_for_miss;

					__captured_in_req_read__effective_addr__tag
						<= __in_req_read__effective_addr.tag;
					__captured_in_req_read__effective_addr__arr_index
						<= __in_req_read__effective_addr.arr_index;
					__captured_in_req_read__effective_addr__line_index
						<= __in_req_read__effective_addr.line_index;
				end
			end

			else
			begin
				real_out_req_read.valid <= 0;
			end
		end

		PkgSnow64InstrCache::StWaitForMem:
		begin
			real_out_mem_access.req <= 0;

			if (real_in_mem_access.valid)
			begin
				__state <= PkgSnow64InstrCache::StIdle;

				`CAPTURED_CONTAINED_TAG
					<= __captured_in_req_read__effective_addr__tag;
				`CAPTURED_CONTAINED_VALID_FLAG <= 1;

				real_out_req_read.valid <= 1;

				//real_out_req_read.instr <= __in_mem_access__data
				//	[__captured_in_req_read__effective_addr__line_index];
				case (__captured_in_req_read__effective_addr__line_index)
				0:
				begin
					real_out_req_read.instr <= __in_mem_access__data[0];
				end
				1:
				begin
					real_out_req_read.instr <= __in_mem_access__data[1];
				end
				2:
				begin
					real_out_req_read.instr <= __in_mem_access__data[2];
				end
				3:
				begin
					real_out_req_read.instr <= __in_mem_access__data[3];
				end
				4:
				begin
					real_out_req_read.instr <= __in_mem_access__data[4];
				end
				5:
				begin
					real_out_req_read.instr <= __in_mem_access__data[5];
				end
				6:
				begin
					real_out_req_read.instr <= __in_mem_access__data[6];
				end
				7:
				begin
					real_out_req_read.instr <= __in_mem_access__data[7];
				end
				endcase
				`CAPTURED_CONTAINED_LINE <= real_in_mem_access.data;
			end
		end
		endcase
	end

	`undef CURR_CONTAINED_LINE
	`undef CURR_CONTAINED_TAG
	`undef CURR_CONTAINED_VALID_FLAG

	`undef CAPTURED_CONTAINED_TAG
	`undef CAPTURED_CONTAINED_LINE
	`undef CAPTURED_CONTAINED_VALID_FLAG

endmodule

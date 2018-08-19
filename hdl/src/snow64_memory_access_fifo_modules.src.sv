`include "src/snow64_memory_access_fifo_defines.header.sv"

module Snow64MemoryAccessReadFifo(input logic clk,
	input PkgSnow64MemoryAccessFifo::PortIn_MemoryAccessReadFifo in,
	output PkgSnow64MemoryAccessFifo::PortOut_MemoryAccessReadFifo out);

	PkgSnow64MemoryAccessFifo::PartialPortIn_ReadFifo_ReqRead
		real_in_req_read;
	assign real_in_req_read = in.req_read;

	PkgSnow64MemoryAccessFifo::PartialPortIn_ReadFifo_FromMemoryBusGuard
		real_in_from_memory_bus_guard;
	assign real_in_from_memory_bus_guard = in.from_memory_bus_guard;

	PkgSnow64MemoryAccessFifo::PartialPortOut_ReadFifo_ReqRead
		real_out_req_read;
	assign out.req_read = real_out_req_read;


	PkgSnow64MemoryAccessFifo::PartialPortOut_ReadFifo_ToMemoryBusGuard
		real_out_to_memory_bus_guard;
	assign out.to_memory_bus_guard = real_out_to_memory_bus_guard;


	logic __state;
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] __captured_in_req_read__addr;


	`ifdef FORMAL
	localparam __ENUM__STATE__IDLE
		= PkgSnow64MemoryAccessFifo::RdFifoStIdle;
	localparam __ENUM__STATE__WAIT_FOR_MEM
		= PkgSnow64MemoryAccessFifo::RdFifoStWaitForMem;

	wire __formal__in_req_read__req = real_in_req_read.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__in_req_read__addr
		= real_in_req_read.addr;

	wire __formal__in_from_memory_bus_guard__valid
		= real_in_from_memory_bus_guard.valid;
	wire __formal__in_from_memory_bus_guard__cmd_accepted
		= real_in_from_memory_bus_guard.cmd_accepted;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__in_from_memory_bus_guard__data
		= real_in_from_memory_bus_guard.data;

	wire __formal__out_req_read__valid = real_out_req_read.valid;
	wire __formal__out_req_read__busy = real_out_req_read.busy;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __formal__out_req_read__data
		= real_out_req_read.data;

	wire __formal__out_to_memory_bus_guard__req
		= real_out_to_memory_bus_guard.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__out_to_memory_bus_guard__addr
		= real_out_to_memory_bus_guard.addr;
	`endif		// FORMAL

	initial
	begin
		__state = PkgSnow64MemoryAccessFifo::RdFifoStIdle;
		__captured_in_req_read__addr = 0;

		real_out_req_read = 0;
		real_out_to_memory_bus_guard = 0;
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64MemoryAccessFifo::RdFifoStIdle:
		begin
			
		end

		PkgSnow64MemoryAccessFifo::RdFifoStWaitForMem:
		begin
			
		end
		endcase
	end


endmodule

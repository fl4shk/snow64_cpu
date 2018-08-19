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
	logic __cmd_was_accepted;


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
		__cmd_was_accepted = 0;

		real_out_req_read = 0;
		real_out_to_memory_bus_guard = 0;
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64MemoryAccessFifo::RdFifoStIdle:
		begin
			real_out_req_read.valid <= 0;

			if (real_in_req_read.req)
			begin
				__state <= PkgSnow64MemoryAccessFifo::RdFifoStWaitForMem;

				real_out_to_memory_bus_guard.req <= 1;
				real_out_to_memory_bus_guard.addr <= real_in_req_read.addr;

				real_out_req_read.busy <= 1;

				__cmd_was_accepted <= 0;
			end

			else // if (!real_in_req_read.req)
			begin
				real_out_to_memory_bus_guard.req <= 0;
				real_out_req_read.busy <= 0;
			end
		end

		PkgSnow64MemoryAccessFifo::RdFifoStWaitForMem:
		begin
			if (real_in_from_memory_bus_guard.cmd_accepted)
			begin
				__cmd_was_accepted <= 1;
				real_out_to_memory_bus_guard.req <= 0;
			end

			// ...On the off chance that SOMEHOW the memory bus guard
			// already has our data, we can make this work.
			if ((real_in_from_memory_bus_guard.cmd_accepted
				|| __cmd_was_accepted)
				&& (real_in_from_memory_bus_guard.valid))
			begin
				// Grant the requested data.
				__state <= PkgSnow64MemoryAccessFifo::RdFifoStIdle;

				real_out_req_read.valid <= 1;
				real_out_req_read.busy <= 0;
				real_out_req_read.data
					<= real_in_from_memory_bus_guard.data;
			end
		end
		endcase
	end


endmodule

module Snow64MemoryAccessWriteFifo(input logic clk,
	input PkgSnow64MemoryAccessFifo::PortIn_MemoryAccessWriteFifo in,
	output PkgSnow64MemoryAccessFifo::PortOut_MemoryAccessWriteFifo out);

	PkgSnow64MemoryAccessFifo::PartialPortIn_WriteFifo_ReqWrite
		real_in_req_write;
	assign real_in_req_write = in.req_write;

	PkgSnow64MemoryAccessFifo::PartialPortIn_WriteFifo_FromMemoryBusGuard
		real_in_from_memory_bus_guard;
	assign real_in_from_memory_bus_guard = in.from_memory_bus_guard;

	PkgSnow64MemoryAccessFifo::PartialPortOut_WriteFifo_ReqWrite
		real_out_req_write;
	assign out.req_write = real_out_req_write;


	PkgSnow64MemoryAccessFifo::PartialPortOut_WriteFifo_ToMemoryBusGuard
		real_out_to_memory_bus_guard;
	assign out.to_memory_bus_guard = real_out_to_memory_bus_guard;


	logic __state;
	logic __cmd_was_accepted;


	`ifdef FORMAL
	localparam __ENUM__STATE__IDLE
		= PkgSnow64MemoryAccessFifo::WrFifoStIdle;
	localparam __ENUM__STATE__WAIT_FOR_MEM
		= PkgSnow64MemoryAccessFifo::WrFifoStWaitForMem;

	wire __formal__in_req_write__req = real_in_req_write.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__in_req_write__addr
		= real_in_req_write.addr;

	wire __formal__in_from_memory_bus_guard__valid
		= real_in_from_memory_bus_guard.valid;
	wire __formal__in_from_memory_bus_guard__cmd_accepted
		= real_in_from_memory_bus_guard.cmd_accepted;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __formal__in_req_write__data
		= real_in_req_write.data;

	wire __formal__out_req_write__valid = real_out_req_write.valid;
	wire __formal__out_req_write__busy = real_out_req_write.busy;

	wire __formal__out_to_memory_bus_guard__req
		= real_out_to_memory_bus_guard.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__out_to_memory_bus_guard__addr
		= real_out_to_memory_bus_guard.addr;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_to_memory_bus_guard__data
		= real_out_to_memory_bus_guard.data;
	`endif		// FORMAL

	initial
	begin
		__state = PkgSnow64MemoryAccessFifo::WrFifoStIdle;
		__cmd_was_accepted = 0;

		real_out_req_write = 0;
		real_out_to_memory_bus_guard = 0;
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64MemoryAccessFifo::WrFifoStIdle:
		begin
			real_out_req_write.valid <= 0;

			if (real_in_req_write.req)
			begin
				__state <= PkgSnow64MemoryAccessFifo::WrFifoStWaitForMem;

				real_out_to_memory_bus_guard.req <= 1;
				real_out_to_memory_bus_guard.addr <= real_in_req_write.addr;
				real_out_to_memory_bus_guard.data
					<= real_in_req_write.data;


				real_out_req_write.busy <= 1;

				__cmd_was_accepted <= 0;
			end

			else // if (!real_in_req_write.req)
			begin
				real_out_to_memory_bus_guard.req <= 0;
				real_out_req_write.busy <= 0;
			end
		end

		PkgSnow64MemoryAccessFifo::WrFifoStWaitForMem:
		begin
			if (real_in_from_memory_bus_guard.cmd_accepted)
			begin
				__cmd_was_accepted <= 1;
				real_out_to_memory_bus_guard.req <= 0;
			end

			// ...On the off chance that SOMEHOW the memory bus guard
			// already has our data, we can make this work.
			if ((real_in_from_memory_bus_guard.cmd_accepted
				|| __cmd_was_accepted)
				&& (real_in_from_memory_bus_guard.valid))
			begin
				// Grant the requested data.
				__state <= PkgSnow64MemoryAccessFifo::WrFifoStIdle;

				real_out_req_write.valid <= 1;
				real_out_req_write.busy <= 0;
				//real_out_req_write.data
				//	<= real_in_from_memory_bus_guard.data;
			end
		end
		endcase
	end


endmodule

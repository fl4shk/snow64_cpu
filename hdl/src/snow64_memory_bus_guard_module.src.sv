`include "src/snow64_memory_bus_guard_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


module Snow64MemoryBusGuard(input logic clk,
	input PkgSnow64MemoryBusGuard::PortIn_MemoryBusGuard in,
	output PkgSnow64MemoryBusGuard::PortOut_MemoryBusGuard out);

	PkgSnow64MemoryBusGuard::State __state;
	PkgSnow64MemoryBusGuard::RequestType __req_type;

	initial
	begin
		__state = PkgSnow64MemoryBusGuard::StIdle;
		__req_type = PkgSnow64MemoryBusGuard::ReqTypReadInstr;
	end


	`ifdef FORMAL
	localparam __ENUM__STATE__IDLE = PkgSnow64MemoryBusGuard::StIdle;
	localparam __ENUM__STATE__WAIT_FOR_MEM
		= PkgSnow64MemoryBusGuard::StWaitForMem;

	localparam __ENUM__REQUEST_TYPE__READ_INSTR
		= PkgSnow64MemoryBusGuard::ReqTypReadInstr;
	localparam __ENUM__REQUEST_TYPE__READ_DATA
		= PkgSnow64MemoryBusGuard::ReqTypReadData;
	localparam __ENUM__REQUEST_TYPE__WRITE_DATA
		= PkgSnow64MemoryBusGuard::ReqTypWriteData;
	localparam __ENUM__REQUEST_TYPE__BAD
		= PkgSnow64MemoryBusGuard::ReqTypBad;
	`endif

	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_ReqRead
		real_in_req_read_instr, real_in_req_read_data;
	assign real_in_req_read_instr = in.req_read_instr;
	assign real_in_req_read_data = in.req_read_data;

	wire __in_req_read_instr__req
		= real_in_req_read_instr.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __in_req_read_instr__addr
		= real_in_req_read_instr.addr;

	wire __in_req_read_data__req
		= real_in_req_read_data.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __in_req_read_data__addr
		= real_in_req_read_data.addr;

	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_ReqWrite
		real_in_req_write_data;
	assign real_in_req_write_data = in.req_write_data;

	wire __in_req_write_data__req = real_in_req_write_data.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __in_req_write_data__addr
		= real_in_req_write_data.addr;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_req_write_data__data
		= real_in_req_write_data.data;

	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_MemAccess
		real_in_mem_access;
	assign real_in_mem_access = in.mem_access;

	wire __in_mem_access__busy = real_in_mem_access.busy;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_mem_access__data
		= real_in_mem_access.data;


	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqRead
		real_out_req_read_instr, real_out_req_read_data;
	assign out.req_read_instr = real_out_req_read_instr;
	assign out.req_read_data = real_out_req_read_data;

	logic __out_req_read_instr__busy, __out_req_read_data__busy;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__out_req_read_instr__data, __out_req_read_data__data;

	assign real_out_req_read_instr.busy = __out_req_read_instr__busy;
	assign real_out_req_read_instr.data = __out_req_read_instr__data;

	assign real_out_req_read_data.busy = __out_req_read_data__busy;
	assign real_out_req_read_data.data = __out_req_read_data__data;

	initial
	begin
		{__out_req_read_instr__busy, __out_req_read_data__busy} = 0;
		{__out_req_read_instr__data, __out_req_read_data__data} = 0;
	end

	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqWrite
		real_out_req_write_data;
	assign out.req_write_data = real_out_req_write_data;

	logic __out_req_write_data__busy;
	assign real_out_req_write_data.busy = __out_req_write_data__busy;

	initial
	begin
		__out_req_write_data__busy = 0;
	end

	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_Status
		real_out_status;
	assign out.status = real_out_status;

	wire __out_status__busy
		= (__state == PkgSnow64MemoryBusGuard::StWaitForMem);
	assign real_out_status.busy = __out_status__busy;


	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_MemAccess
		real_out_mem_access;
	assign out.mem_access = real_out_mem_access;


	logic __out_mem_access__req;
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] __out_mem_access__addr;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __out_mem_access__data;
	PkgSnow64MemoryBusGuard::MemAccessType __out_mem_access__mem_acc_type;

	assign real_out_mem_access.req = __out_mem_access__req;
	assign real_out_mem_access.addr = __out_mem_access__addr;
	assign real_out_mem_access.data = __out_mem_access__data;
	assign real_out_mem_access.mem_acc_type
		= __out_mem_access__mem_acc_type;

	initial
	begin
		{__out_mem_access__req, __out_mem_access__addr,
			__out_mem_access__data} = 0;

		__out_mem_access__mem_acc_type
			= PkgSnow64MemoryBusGuard::MemAccTypRead;
	end




	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64MemoryBusGuard::StIdle:
		begin
			// Priority of response:
			// read data, write data, read instructions
			// It's assumed that instruction reads WON'T happen multiple
			// cycles in a row, and that they are infrequent.
			// 
			// It is assumed that data reads and wirtes CAN happen multiple
			// cycles in a row, but only if they're not blocked by a read
			// of a block of instructions.
			if (__in_req_read_instr__req)
			begin
				__state <= PkgSnow64MemoryBusGuard::StWaitForMem;
				__req_type <= PkgSnow64MemoryBusGuard::ReqTypReadInstr;

				__out_mem_access__req <= 1;
			end

			else if (__in_req_read_data__req)
			begin
				__state <= PkgSnow64MemoryBusGuard::StWaitForMem;
				__req_type <= PkgSnow64MemoryBusGuard::ReqTypReadData;
			end

			else if (__in_req_write_data__req)
			begin
				__state <= PkgSnow64MemoryBusGuard::StWaitForMem;
				__req_type <= PkgSnow64MemoryBusGuard::ReqTypWriteData;
			end
		end

		PkgSnow64MemoryBusGuard::StWaitForMem:
		begin
			__out_mem_access__req <= 0;
			//__out_mem_access__addr <= 0;
			//__out_mem_access__data <= 0;
			//__out_mem_access__mem_acc_type <= 0;
			case (__req_type)
			PkgSnow64MemoryBusGuard::ReqTypReadInstr:
			begin
				if (!__in_mem_access__busy)
				begin
					
				end
			end

			PkgSnow64MemoryBusGuard::ReqTypReadData:
			begin
				
			end

			PkgSnow64MemoryBusGuard::ReqTypWriteData:
			begin
				
			end
			endcase
		end
		endcase
	end

endmodule

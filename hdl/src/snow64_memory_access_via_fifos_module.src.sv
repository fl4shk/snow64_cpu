`include "src/snow64_memory_access_via_fifos_defines.header.sv"

`define ADDRDIM [`MSB_POS__SNOW64_CPU_ADDR:0]
`define DATADIM [`MSB_POS__SNOW64_LAR_FILE_DATA:0]

// Since with Icarus Verilog at least (not sure if that's required by the
// standard?) we can't do a forward reference from one package to another
// package, we're stuck using multiple packed structs here for the ports of
// Snow64MemoryAccessViaFifos.
module Snow64MemoryAccessViaFifos(input logic clk,
	input PkgSnow64MemoryAccessFifo::PartialPortIn_ReadFifo_ReqRead
		in_mem_acc_read_fifo__instr__req_read,
		in_mem_acc_read_fifo__data__req_read,
	input PkgSnow64MemoryAccessFifo::PartialPortIn_WriteFifo_ReqWrite
		in_mem_acc_write_fifo__data__req_write,

	input PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_MemAccess
		in_mem_bus_guard__mem_access,

	output PkgSnow64MemoryAccessFifo::PartialPortOut_ReadFifo_ReqRead
		out_mem_acc_read_fifo__instr__req_read,
		out_mem_acc_read_fifo__data__req_read,
	output PkgSnow64MemoryAccessFifo::PartialPortOut_WriteFifo_ReqWrite
		out_mem_acc_write_fifo__data__req_write,

	output PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_MemAccess
		out_mem_bus_guard__mem_access);


	import PkgSnow64MemoryAccessFifo::*;
	import PkgSnow64MemoryBusGuard::*;




	PortIn_MemoryAccessReadFifo
		__in_mem_acc_read_fifo__instr, __in_mem_acc_read_fifo__data;
	PortOut_MemoryAccessReadFifo
		__out_mem_acc_read_fifo__instr, __out_mem_acc_read_fifo__data;
	Snow64MemoryAccessReadFifo __inst_mem_acc_read_fifo__instr
		(.clk(clk), .in(__in_mem_acc_read_fifo__instr),
		.out(__out_mem_acc_read_fifo__instr));
	Snow64MemoryAccessReadFifo __inst_mem_acc_read_fifo__data
		(.clk(clk), .in(__in_mem_acc_read_fifo__data),
		.out(__out_mem_acc_read_fifo__data));


	PartialPortIn_ReadFifo_FromMemoryBusGuard
		__real_in_mem_acc_read_fifo__instr__from_mbg,
		__real_in_mem_acc_read_fifo__data__from_mbg;
	PartialPortOut_ReadFifo_ToMemoryBusGuard
		__real_out_mem_acc_read_fifo__instr__to_mbg,
		__real_out_mem_acc_read_fifo__data__to_mbg;

	assign __in_mem_acc_read_fifo__instr
		= {in_mem_acc_read_fifo__instr__req_read,
		__real_in_mem_acc_read_fifo__instr__from_mbg};
	assign __in_mem_acc_read_fifo__data
		= {in_mem_acc_read_fifo__data__req_read,
		__real_in_mem_acc_read_fifo__data__from_mbg};

	assign {out_mem_acc_read_fifo__instr__req_read,
		__real_out_mem_acc_read_fifo__instr__to_mbg}
		= __out_mem_acc_read_fifo__instr;
	assign {out_mem_acc_read_fifo__data__req_read,
		__real_out_mem_acc_read_fifo__data__to_mbg}
		= __out_mem_acc_read_fifo__data;


	PortIn_MemoryAccessWriteFifo __in_mem_acc_write_fifo__data;
	PortOut_MemoryAccessWriteFifo __out_mem_acc_write_fifo__data;
	Snow64MemoryAccessWriteFifo __inst_mem_acc_write_fifo(.clk(clk),
		.in(__in_mem_acc_write_fifo__data),
		.out(__out_mem_acc_write_fifo__data));

	PartialPortIn_WriteFifo_FromMemoryBusGuard
		__real_in_mem_acc_write_fifo__data__from_mbg;
	PartialPortOut_WriteFifo_ToMemoryBusGuard
		__real_out_mem_acc_write_fifo__data__to_mbg;

	assign __in_mem_acc_write_fifo__data
		= {in_mem_acc_write_fifo__data__req_write,
		__real_in_mem_acc_write_fifo__data__from_mbg};

	assign {out_mem_acc_write_fifo__data__req_write,
		__real_out_mem_acc_write_fifo__data__to_mbg}
		= __out_mem_acc_write_fifo__data;


	PortIn_MemoryBusGuard __in_mem_bus_guard;
	PortOut_MemoryBusGuard __out_mem_bus_guard;
	Snow64MemoryBusGuard __inst_mem_bus_guard(.clk(clk),
		.in(__in_mem_bus_guard), .out(__out_mem_bus_guard));

	PartialPortIn_MemoryBusGuard_ReqRead
		__real_in_mem_bus_guard__req_read__instr,
		__real_in_mem_bus_guard__req_read__data;
	PartialPortIn_MemoryBusGuard_ReqWrite
		__real_in_mem_bus_guard__req_write__data;

	PartialPortOut_MemoryBusGuard_ReqRead
		__real_out_mem_bus_guard__req_read__instr,
		__real_out_mem_bus_guard__req_read__data;
	PartialPortOut_MemoryBusGuard_ReqWrite
		__real_out_mem_bus_guard__req_write__data;

	assign __in_mem_bus_guard
		= {__real_in_mem_bus_guard__req_read__instr,
		__real_in_mem_bus_guard__req_read__data,
		__real_in_mem_bus_guard__req_write__data,
		in_mem_bus_guard__mem_access};

	assign {__real_out_mem_bus_guard__req_read__instr,
		__real_out_mem_bus_guard__req_read__data,
		__real_out_mem_bus_guard__req_write__data,
		out_mem_bus_guard__mem_access}
		= __out_mem_bus_guard;

	// Connections between the FIFOs and the Snow64MemoryBusGuard.
	assign __real_in_mem_bus_guard__req_read__instr
		= __real_out_mem_acc_read_fifo__instr__to_mbg;
	assign __real_in_mem_bus_guard__req_read__data
		= __real_out_mem_acc_read_fifo__data__to_mbg;
	assign __real_in_mem_bus_guard__req_write__data
		= __real_out_mem_acc_write_fifo__data__to_mbg;

	assign __real_in_mem_acc_read_fifo__instr__from_mbg
		= __real_out_mem_bus_guard__req_read__instr;
	assign __real_in_mem_acc_read_fifo__data__from_mbg
		= __real_out_mem_bus_guard__req_read__data;
	assign __real_in_mem_acc_write_fifo__data__from_mbg
		= __real_out_mem_bus_guard__req_write__data;


	`ifdef FORMAL
	// Ports of this module
	wire __formal__in_read_fifo__instr__req_read__req
		= in_mem_acc_read_fifo__instr__req_read.req;
	wire `ADDRDIM __formal__in_read_fifo__instr__req_read__addr
		= in_mem_acc_read_fifo__instr__req_read.addr;

	wire __formal__in_read_fifo__data__req_read__req
		= in_mem_acc_read_fifo__data__req_read.req;
	wire `ADDRDIM __formal__in_read_fifo__data__req_read__addr
		= in_mem_acc_read_fifo__data__req_read.addr;

	wire __formal__in_write_fifo__data__req_write__req
		= in_mem_acc_write_fifo__data__req_write.req;
	wire `ADDRDIM __formal__in_write_fifo__data__req_write__addr
		= in_mem_acc_write_fifo__data__req_write.addr;
	wire `DATADIM __formal__in_write_fifo__data__req_write__data
		= in_mem_acc_write_fifo__data__req_write.data;

	wire __formal__in_mem_bus_guard__mem_access__valid
		= in_mem_bus_guard__mem_access.valid;
	wire `DATADIM __formal__in_mem_bus_guard__mem_access__data
		= in_mem_bus_guard__mem_access.data;


	wire __formal__out_mem_bus_guard__mem_access__req
		= out_mem_bus_guard__mem_access.req;
	wire `ADDRDIM __formal__out_mem_bus_guard__mem_access__addr
		= out_mem_bus_guard__mem_access.addr;
	wire `DATADIM __formal__out_mem_bus_guard__mem_access__data
		= out_mem_bus_guard__mem_access.data;
	wire __formal__out_mem_bus_guard__mem_access__mem_acc_type
		= out_mem_bus_guard__mem_access.mem_acc_type;



	// Connections between the Snow64MemoryBusGuard and the FIFOs
	wire __formal__read_instr_fifo_to_mbg__req
		= __real_in_mem_bus_guard__req_read__instr.req;
	wire `ADDRDIM __formal__read_instr_fifo_to_mbg__addr
		= __real_in_mem_bus_guard__req_read__instr.addr;
		
	wire __formal__read_data_fifo_to_mbg__req
		= __real_in_mem_bus_guard__req_read__data.req;
	wire `ADDRDIM __formal__read_data_fifo_to_mbg__addr
		= __real_in_mem_bus_guard__req_read__data.addr;

	wire __formal__write_data_fifo_to_mbg__req
		= __real_in_mem_bus_guard__req_write__data.req;
	wire `ADDRDIM __formal__write_data_fifo_to_mbg__addr
		= __real_in_mem_bus_guard__req_write__data.addr;
	wire `DATADIM __formal__write_data_fifo_to_mbg__data
		= __real_in_mem_bus_guard__req_write__data.data;


	wire __formal__mbg_to_read_instr_fifo__valid
		= __real_out_mem_bus_guard__req_read__instr.valid;
	wire __formal__mbg_to_read_instr_fifo__cmd_accepted
		= __real_out_mem_bus_guard__req_read__instr.cmd_accepted;
	wire `DATADIM __formal__mbg_to_read_instr_fifo__data
		= __real_out_mem_bus_guard__req_read__instr.data;

	wire __formal__mbg_to_read_data_fifo__valid
		= __real_out_mem_bus_guard__req_read__data.valid;
	wire __formal__mbg_to_read_data_fifo__cmd_accepted
		= __real_out_mem_bus_guard__req_read__data.cmd_accepted;
	wire `DATADIM __formal__mbg_to_read_data_fifo__data
		= __real_out_mem_bus_guard__req_read__data.data;

	wire __formal__mbg_to_write_data_fifo__valid
		= __real_out_mem_bus_guard__req_write__data.valid;
	wire __formal__mbg_to_write_data_fifo__cmd_accepted
		= __real_out_mem_bus_guard__req_write__data.cmd_accepted;
	`endif		// FORMAL



endmodule

`undef ADDRDIM
`undef DATADIM

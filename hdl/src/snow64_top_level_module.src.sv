`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

`ifndef FORMAL
module Snow64TopLevel;
	logic __clk;

	initial
	begin
		__clk = 0;
	end

	always
	begin
		#1
		__clk = !__clk;
	end

	PkgSnow64Cpu::PortIn_Cpu __in_inst_cpu;
	PkgSnow64Cpu::PortOut_Cpu __out_inst_cpu;
	Snow64Cpu __inst_cpu(.clk(__clk), .in(__in_inst_cpu),
		.out(__out_inst_cpu));

	PkgSnow64Cpu::PartialPortIn_Cpu_Interrupt __in_inst_cpu_interrupt;
	PkgSnow64Cpu::PartialPortIn_Cpu_ExtDataAccess
		__in_inst_cpu_ext_data_acc_mem,
		__in_inst_cpu_ext_data_acc_io;
	assign __in_inst_cpu = {__in_inst_cpu_interrupt,
		__in_inst_cpu_ext_data_acc_mem,
		__in_inst_cpu_ext_data_acc_io};

	PkgSnow64Cpu::PartialPortOut_Cpu_Interrupt __out_inst_cpu_interrupt;
	PkgSnow64Cpu::PartialPortOut_Cpu_ExtDataAccess
		__out_inst_cpu_ext_data_acc_mem,
		__out_inst_cpu_ext_data_acc_io;
	assign {__out_inst_cpu_interrupt,
		__out_inst_cpu_ext_data_acc_mem,
		__out_inst_cpu_ext_data_acc_io} = __out_inst_cpu;

	// Temporary!
	assign __in_inst_cpu_interrupt = 0;

	assign __in_inst_cpu_ext_data_acc_io.valid = 1'b1;
	assign __in_inst_cpu_ext_data_acc_io.data = 0;




	wire __in_main_mem_req_wr
		= (__out_inst_cpu_ext_data_acc_mem.req
		&& __out_inst_cpu_ext_data_acc_mem.access_type);

	wire [PkgSnow64MainMem::MSB_POS__MEM_ADDRESS:0] __in_main_mem_addr
		= __out_inst_cpu_ext_data_acc_mem.addr;
	wire [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0]
		__in_main_mem_data, __out_main_mem_data;
	assign __in_main_mem_data = __out_inst_cpu_ext_data_acc_mem.data;

	Snow64MainMem __inst_main_mem(.clk(clk),
		.in_req_wr(__in_main_mem_req_wr), .in_addr(__in_main_mem_addr),
		.in_data(__in_main_mem_data), .out_data(__out_main_mem_data));

	assign __in_inst_cpu_ext_data_acc_mem.valid = 1'b1;
	assign __in_inst_cpu_ext_data_acc_mem.data = __out_main_mem_data;

endmodule
`endif		// FORMAL

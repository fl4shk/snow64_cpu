`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


module Snow64Cpu(input logic clk,
	input PkgSnow64Cpu::PortIn_Cpu in,
	output PkgSnow64Cpu::PortOut_Cpu out);


	PkgSnow64Cpu::PartialPortIn_Cpu_Interrupt real_in_interrupt;
	PkgSnow64Cpu::PartialPortIn_Cpu_ExtDataAccess
		real_in_ext_dat_acc_mem, real_in_ext_dat_acc_io;
	assign {real_in_interrupt, real_in_ext_dat_acc_mem,
		real_in_ext_dat_acc_io} = in;


	PkgSnow64Cpu::PartialPortOut_Cpu_ExtDataAccess
		real_out_ext_dat_acc_mem, real_out_ext_dat_acc_io;
	assign out = {real_out_ext_dat_acc_mem, real_out_ext_dat_acc_io};

	`ifdef FORMAL
	wire __formal__in_interrupt__req = real_in_interrupt.req;

	wire __formal__in_ext_dat_acc_mem__valid
		= real_in_ext_dat_acc_mem.valid,
		__formal__in_ext_dat_acc_io__valid
		= real_in_ext_dat_acc_io.valid;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__in_ext_dat_acc_mem__data = real_in_ext_dat_acc_mem.data,
		__formal__in_ext_dat_acc_io__data = real_in_ext_dat_acc_io.data;

	wire __formal__out_ext_dat_acc_mem__req = real_out_ext_dat_acc_mem.req,
		__formal__out_ext_dat_acc_io__req = real_out_ext_dat_acc_io.req;
	wire __formal__out_ext_dat_acc_mem__access_type
		= real_out_ext_dat_acc_mem.access_type,
		__formal__out_ext_dat_acc_io__access_type
		= real_out_ext_dat_acc_io.access_type;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__out_ext_dat_acc_mem__addr
		= real_out_ext_dat_acc_mem.addr,
		__formal__out_ext_dat_acc_io__addr
		= real_out_ext_dat_acc_io.addr;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_ext_dat_acc_mem__data
		= real_out_ext_dat_acc_mem.data,
		__formal__out_ext_dat_acc_io__data
		= real_out_ext_dat_acc_io.data;
	`endif		// FORMAL

endmodule

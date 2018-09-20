`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


module Snow64Cpu(input logic clk,
	input PkgSnow64Cpu::PortIn_Cpu in,
	output PkgSnow64Cpu::PortOut_Cpu out);


	// Ports of Snow64Cpu
	PkgSnow64Cpu::PartialPortIn_Cpu_Interrupt real_in_interrupt;
	PkgSnow64Cpu::PartialPortIn_Cpu_ExtDataAccess
		real_in_ext_dat_acc_mem, real_in_ext_dat_acc_io;
	assign {real_in_interrupt, real_in_ext_dat_acc_mem,
		real_in_ext_dat_acc_io} = in;


	PkgSnow64Cpu::PartialPortOut_Cpu_Interrupt real_out_interrupt;
	PkgSnow64Cpu::PartialPortOut_Cpu_ExtDataAccess
		real_out_ext_dat_acc_mem, real_out_ext_dat_acc_io;
	assign out = {real_out_interrupt, real_out_ext_dat_acc_mem,
		real_out_ext_dat_acc_io};






	//// Locals
	//PkgSnow64InstrDecoder::PortOut_InstrDecoder
	//	__stage_execute__decoded_instr, __stage_write_back__decoded_instr;

	//struct packed
	//{
	//	logic ie;
	//	logic [`MSB_POS__SNOW64_CPU_ADDR:0] ireta, idsta, pc;
	//} __stage_instr_fetch__spec_regs, __stage_instr_decode__spec_regs,
	//	__stage_execute__spec_regs, __stage_write_back__spec_regs;


	//PkgSnow64LarFile::PartialPortOut_LarFile_ReadMetadata
	//	__stage_execute__lar_file__rd_metadata_a,
	//	__stage_execute__lar_file__rd_metadata_b,
	//	__stage_execute__lar_file__rd_metadata_c,

	//	__stage_write_back__lar_file__rd_metadata_a,
	//	__stage_write_back__lar_file__rd_metadata_b,
	//	__stage_write_back__lar_file__rd_metadata_c;

	//assign {__stage_execute__lar_file__rd_metadata_a,
	//	__stage_execute__lar_file__rd_metadata_b,
	//	__stage_execute__lar_file__rd_metadata_c}
	//	= {__out_inst_lar_file__rd_metadata_a,
	//	__out_inst_lar_file__rd_metadata_b,
	//	__out_inst_lar_file__rd_metadata_c};


	//struct packed
	//{
	//	logic valid;
	//	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] data;

	//	logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0] base_addr;
	//} __stage_execute__lar_file__curr_data_a,
	//	__stage_execute__lar_file__curr_data_b,
	//	__stage_execute__lar_file__curr_data_c,

	//	// Stuff for operand forwarding.
	//	__stage_execute__lar_file__past_computed_data,
	//	__stage_write_back__lar_file__past_computed_data,
	//	__stage_write_back_past__lar_file__past_computed_data;


	//`define ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA(sel, which) \
	//	sel: __stage_execute__lar_file__curr_data_``which \
	//		= __stage_execute__lar_file__past_computed_data;
	//`define ASSIGN_FROM_STAGE_WRITE_BACK__PAST_DATA(sel, which) \
	//	sel: __stage_execute__lar_file__curr_data_``which \
	//		= __stage_write_back__lar_file__past_computed_data;
	//`define ASSIGN_FROM_STAGE_WRITE_BACK_PAST__PAST_DATA(sel, which) \
	//	sel: __stage_execute__lar_file__curr_data_``which \
	//		= __stage_write_back_past__lar_file__past_computed_data;

	//// Operand forwarding
	//`define ASSIGN_TO_STAGE_EXECUTE__LAR_FILE__CURR_DATA(which) \
	//always @(*) \
	//begin \
	//	case ({__stage_execute__lar_file__past_computed_data.valid, \
	//		__stage_write_back__lar_file__past_computed_data.valid, \
	//		__stage_write_back_past__lar_file__past_computed_data.valid, \
	//		(__stage_execute__lar_file__rd_metadata_``which.tag != 0)}) \
	//	`ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA(4'b1111, which) \
	//	`ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA(4'b1110, which) \
	//	`ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA(4'b1101, which) \
	//	`ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA(4'b1100, which) \
	//	`ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA(4'b1011, which) \
	//	`ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA(4'b1010, which) \
	//	`ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA(4'b1001, which) \
	//	`ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA(4'b1000, which) \
	//	`ASSIGN_FROM_STAGE_WRITE_BACK__PAST_DATA(4'b0111, which) \
	//	`ASSIGN_FROM_STAGE_WRITE_BACK__PAST_DATA(4'b0110, which) \
	//	`ASSIGN_FROM_STAGE_WRITE_BACK__PAST_DATA(4'b0101, which) \
	//	`ASSIGN_FROM_STAGE_WRITE_BACK__PAST_DATA(4'b0100, which) \
	//	`ASSIGN_FROM_STAGE_WRITE_BACK_PAST__PAST_DATA(4'b0011, which) \
	//	`ASSIGN_FROM_STAGE_WRITE_BACK_PAST__PAST_DATA(4'b0010, which) \
	//	4'b0001: __stage_execute__lar_file__curr_data_``which \
	//		= {1'b1, __out_inst_lar_file__rd_shareddata_``which}; \
	//	4'b0000: __stage_execute__lar_file__curr_data_``which = 0; \
	//	endcase \
	//end

	//`ASSIGN_TO_STAGE_EXECUTE__LAR_FILE__CURR_DATA(a)
	//`ASSIGN_TO_STAGE_EXECUTE__LAR_FILE__CURR_DATA(b)
	//`ASSIGN_TO_STAGE_EXECUTE__LAR_FILE__CURR_DATA(c)
	//`undef ASSIGN_TO_STAGE_EXECUTE__LAR_FILE__CURR_DATA
	//`undef ASSIGN_FROM_STAGE_EXECUTE__PAST_DATA
	//`undef ASSIGN_FROM_STAGE_WRITE_BACK__PAST_DATA
	//`undef ASSIGN_FROM_STAGE_WRITE_BACK_PAST__PAST_DATA




	`include "src/snow64_formal_instr_opcodes.header.sv"



	//initial
	//begin
	//	real_out_interrupt = 0;
	//	real_out_ext_dat_acc_mem = 0;
	//	real_out_ext_dat_acc_io = 0;

	//	{__stage_execute__decoded_instr, __stage_write_back__decoded_instr}
	//		= 0;

	//	{__stage_instr_fetch__spec_regs, __stage_instr_decode__spec_regs,
	//		__stage_execute__spec_regs, __stage_write_back__spec_regs}
	//		= 0;

	//	{__stage_write_back__lar_file__rd_metadata_a,
	//		__stage_write_back__lar_file__rd_metadata_b,
	//		__stage_write_back__lar_file__rd_metadata_c} = 0;

	//	{__stage_execute__lar_file__curr_data_a,
	//		__stage_execute__lar_file__curr_data_b,
	//		__stage_execute__lar_file__curr_data_c,

	//		// Stuff for operand forwarding.
	//		__stage_execute__lar_file__past_computed_data,
	//		__stage_write_back__lar_file__past_computed_data,
	//		__stage_write_back_past__lar_file__past_computed_data} = 0;
	//end


	//// Instruction fetch stage.
	//always @(posedge clk)
	//begin
	//	
	//end


	//// Instruction decode/register read stage
	//always @(posedge clk)
	//begin
	//	
	//end


	//// Execute stage
	//always @(posedge clk)
	//begin
	//	
	//end



endmodule

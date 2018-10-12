`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

//`define INSTR_0(word_addr) __mem[word_addr][0 * 32 +: 32]
//`define INSTR_1(word_addr) __mem[word_addr][1 * 32 +: 32]
//`define INSTR_2(word_addr) __mem[word_addr][2 * 32 +: 32]
//`define INSTR_3(word_addr) __mem[word_addr][3 * 32 +: 32]
//`define INSTR_4(word_addr) __mem[word_addr][4 * 32 +: 32]
//`define INSTR_5(word_addr) __mem[word_addr][5 * 32 +: 32]
//`define INSTR_6(word_addr) __mem[word_addr][6 * 32 +: 32]
//`define INSTR_7(word_addr) __mem[word_addr][7 * 32 +: 32]



module Snow64MainMem(input logic clk,
	input logic in_req_wr,
	input logic [PkgSnow64MainMem::MSB_POS__MEM_ADDRESS:0] in_addr,
	input logic [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0] in_data,
	output logic [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0] out_data);



	logic [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0]
		__mem[PkgSnow64MainMem::ARR_SIZE__MEM];

	integer i;

	initial
	begin
		for (i=0; i<PkgSnow64MainMem::ARR_SIZE__MEM; i=i+1)
		begin
			__mem[i] = 0;
		end

		//`INSTR_0(0) = 'h4f00_4010;
		//`INSTR_1(0) = 'h4f0f_0000;
		//`INSTR_2(0) = 'h0f00_e000;
		//`INSTR_3(0) = 'h0000_e001;
		//`INSTR_4(0) = 'h0001_0000;

		//`INSTR_0('h1000) = 'h0f00_e000;
		//`INSTR_1('h1000) = 'h0000_e001;

		`include "initial_mem_contents.txt.ignore"
	end


	always @(posedge clk)
	begin
		//$display("Snow64MainMem clocked logic");
		if (in_req_wr)
		begin
			__mem[in_addr] <= in_data;
		end

		//else // if (!in_req_wr)
		begin
			//$display("Snow64MainMem data read:  %h %h", in_addr,
			//	__mem[in_addr]);
			out_data <= __mem[in_addr];
		end
	end


endmodule


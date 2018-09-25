`include "src/snow64_alu_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"

//module DebugSnow64Alu
//	(input logic [`MSB_POS__SNOW64_SIZE_64:0] in_a, in_b,
//	input logic [`MSB_POS__SNOW64_ALU_OPER:0] in_oper,
//	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_int_type_size,
//	input logic in_signedness,
//
//	output logic [`MSB_POS__SNOW64_SIZE_64:0] out_data);
//
//	PkgSnow64ArithLog::PortIn_Alu __in_alu;
//	PkgSnow64ArithLog::PortOut_Alu __out_alu;
//
//	Snow64Alu __inst_alu(.in(__in_alu), .out(__out_alu));
//
//	always @(*) __in_alu.a = in_a;
//	always @(*) __in_alu.b = in_b;
//	always @(*) __in_alu.oper = in_oper;
//	always @(*) __in_alu.int_type_size = in_int_type_size;
//	always @(*) __in_alu.type_signedness = in_signedness;
//
//	always @(*) out_data = __out_alu.data;
//endmodule

module DebugSnow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
	output PkgSnow64ArithLog::PortOut_Alu out);

	Snow64Alu __inst_alu(.in(in), .out(out));
endmodule


module __Snow64SubAlu(input PkgSnow64ArithLog::PortIn_SubAlu in,
	output PkgSnow64ArithLog::PortOut_SubAlu out);

	localparam __MSB_0 = (0 * 8) + 7;
	localparam __MSB_1 = (1 * 8) + 7;
	localparam __MSB_2 = (2 * 8) + 7;
	localparam __MSB_3 = (3 * 8) + 7;
	localparam __MSB_4 = (4 * 8) + 7;
	localparam __MSB_5 = (5 * 8) + 7;
	localparam __MSB_6 = (6 * 8) + 7;
	localparam __MSB_7 = (7 * 8) + 7;

	wire [`WIDTH__SNOW64_SIZE_64:0] __adc_result
		= {1'b0, in.a} + {1'b0, in.b} + in.carry;
	wire [`MSB_POS__SNOW64_SIZE_64:0] __t0
		= __adc_result[`WIDTH__SNOW64_SIZE_64:1];

	wire [`MSB_POS__SNOW64_SUB_ALU_OUT_SLT:0] __a_msb
		= {in.a[__MSB_7], in.a[__MSB_6], in.a[__MSB_5], in.a[__MSB_4],
		in.a[__MSB_3], in.a[__MSB_2], in.a[__MSB_1], in.a[__MSB_0]};
	wire [`MSB_POS__SNOW64_SUB_ALU_OUT_SLT:0] __b_msb
		= {in.b[__MSB_7], in.b[__MSB_6], in.b[__MSB_5], in.b[__MSB_4],
		in.b[__MSB_3], in.b[__MSB_2], in.b[__MSB_1], in.b[__MSB_0]};
	wire [`MSB_POS__SNOW64_SUB_ALU_OUT_SLT:0] __last_carry_in
		= {__t0[__MSB_7], __t0[__MSB_6], __t0[__MSB_5], __t0[__MSB_4],
		__t0[__MSB_3], __t0[__MSB_2], __t0[__MSB_1], __t0[__MSB_0]};

	wire [`MSB_POS__SNOW64_SUB_ALU_OUT_SLT:0] __carry_out
		= (((__a_msb ^ __b_msb) & __last_carry_in) | (__a_msb & __b_msb));

	assign out.data = __t0;
	assign out.slt = ~__carry_out;

endmodule

module Snow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
	output PkgSnow64ArithLog::PortOut_Alu out);

endmodule


module Snow64VectorAlu(input PkgSnow64ArithLog::PortIn_VectorAlu in,
	output PkgSnow64ArithLog::PortOut_VectorAlu out);

	PkgSnow64ArithLog::PortIn_Alu __in_inst_alu_0, __in_inst_alu_1,
		__in_inst_alu_2, __in_inst_alu_3;
	PkgSnow64ArithLog::PortOut_Alu __out_inst_alu_0, __out_inst_alu_1,
		__out_inst_alu_2, __out_inst_alu_3;
	Snow64Alu __inst_alu_0(.in(__in_inst_alu_0), .out(__out_inst_alu_0));
	Snow64Alu __inst_alu_1(.in(__in_inst_alu_1), .out(__out_inst_alu_1));
	Snow64Alu __inst_alu_2(.in(__in_inst_alu_2), .out(__out_inst_alu_2));
	Snow64Alu __inst_alu_3(.in(__in_inst_alu_3), .out(__out_inst_alu_3));

	assign __in_inst_alu_0 = {in.a[0 * 64 +: 64], in.b[0 * 64 +: 64],
		in.oper, in.int_type_size, in.type_signedness};
	assign __in_inst_alu_1 = {in.a[1 * 64 +: 64], in.b[1 * 64 +: 64],
		in.oper, in.int_type_size, in.type_signedness};
	assign __in_inst_alu_2 = {in.a[2 * 64 +: 64], in.b[2 * 64 +: 64],
		in.oper, in.int_type_size, in.type_signedness};
	assign __in_inst_alu_3 = {in.a[3 * 64 +: 64], in.b[3 * 64 +: 64],
		in.oper, in.int_type_size, in.type_signedness};


	assign out.data = {__out_inst_alu_3.data, __out_inst_alu_2.data,
		__out_inst_alu_1.data, __out_inst_alu_0.data};

endmodule

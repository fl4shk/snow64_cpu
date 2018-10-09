`include "src/snow64_alu_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"

module DebugSnow64Alu
	(input logic [`MSB_POS__SNOW64_SIZE_64:0] in_a, in_b,
	input logic [`MSB_POS__SNOW64_ALU_OPER:0] in_oper,
	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_int_type_size,
	input logic in_signedness,

	output logic [`MSB_POS__SNOW64_SIZE_64:0] out_data);

	PkgSnow64ArithLog::PortIn_Alu __in_alu;
	PkgSnow64ArithLog::PortOut_Alu __out_alu;

	Snow64Alu __inst_alu(.in(__in_alu), .out(__out_alu));

	always @(*) __in_alu.a = in_a;
	always @(*) __in_alu.b = in_b;
	always @(*) __in_alu.oper = in_oper;
	always @(*) __in_alu.int_type_size = in_int_type_size;
	always @(*) __in_alu.type_signedness = in_signedness;

	always @(*) out_data = __out_alu.data;

	`ifdef FORMAL
	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;


	localparam __ENUM__OP_ADD = PkgSnow64ArithLog::OpAdd;
	localparam __ENUM__OP_SUB = PkgSnow64ArithLog::OpSub;
	localparam __ENUM__OP_SLT = PkgSnow64ArithLog::OpSlt;
	localparam __ENUM__OP_DUMMY_0 = PkgSnow64ArithLog::OpDummy0;

	localparam __ENUM__OP_DUMMY_1 = PkgSnow64ArithLog::OpDummy1;
	localparam __ENUM__OP_AND = PkgSnow64ArithLog::OpAnd;
	localparam __ENUM__OP_ORR = PkgSnow64ArithLog::OpOrr;
	localparam __ENUM__OP_XOR = PkgSnow64ArithLog::OpXor;

	localparam __ENUM__OP_SHL = PkgSnow64ArithLog::OpShl;
	localparam __ENUM__OP_SHR = PkgSnow64ArithLog::OpShr;
	localparam __ENUM__OP_INV = PkgSnow64ArithLog::OpInv;
	localparam __ENUM__OP_NOT = PkgSnow64ArithLog::OpNot;

	localparam __ENUM__OP_ADD_AGAIN = PkgSnow64ArithLog::OpAddAgain;
	localparam __ENUM__OP_ADD_AGAIN_2 = PkgSnow64ArithLog::OpAddAgain2;
	localparam __ENUM__OP_DUMMY_2 = PkgSnow64ArithLog::OpDummy2;
	localparam __ENUM__OP_DUMMY_3 = PkgSnow64ArithLog::OpDummy3;

	wire [`MSB_POS__SLICE_64_TO_8:0][`MSB_POS__SNOW64_SIZE_8:0]
		__in_a_sliced_8 = in_a,
		__in_b_sliced_8 = in_b,
		__out_data_sliced_8 = out_data;
	wire [`MSB_POS__SLICE_64_TO_16:0][`MSB_POS__SNOW64_SIZE_16:0]
		__in_a_sliced_16 = in_a,
		__in_b_sliced_16 = in_b,
		__out_data_sliced_16 = out_data;
	wire [`MSB_POS__SLICE_64_TO_32:0][`MSB_POS__SNOW64_SIZE_32:0]
		__in_a_sliced_32 = in_a,
		__in_b_sliced_32 = in_b,
		__out_data_sliced_32 = out_data;
	wire [`MSB_POS__SLICE_64_TO_64:0][`MSB_POS__SNOW64_SIZE_64:0]
		__in_a_sliced_64 = in_a,
		__in_b_sliced_64 = in_b,
		__out_data_sliced_64 = out_data;

	wire [`MSB_POS__SNOW64_SIZE_8:0] 
		__formal__in_a_sliced_8__7 = __in_a_sliced_8[7],
		__formal__in_a_sliced_8__6 = __in_a_sliced_8[6],
		__formal__in_a_sliced_8__5 = __in_a_sliced_8[5],
		__formal__in_a_sliced_8__4 = __in_a_sliced_8[4],
		__formal__in_a_sliced_8__3 = __in_a_sliced_8[3],
		__formal__in_a_sliced_8__2 = __in_a_sliced_8[2],
		__formal__in_a_sliced_8__1 = __in_a_sliced_8[1],
		__formal__in_a_sliced_8__0 = __in_a_sliced_8[0],

		__formal__in_b_sliced_8__7 = __in_b_sliced_8[7],
		__formal__in_b_sliced_8__6 = __in_b_sliced_8[6],
		__formal__in_b_sliced_8__5 = __in_b_sliced_8[5],
		__formal__in_b_sliced_8__4 = __in_b_sliced_8[4],
		__formal__in_b_sliced_8__3 = __in_b_sliced_8[3],
		__formal__in_b_sliced_8__2 = __in_b_sliced_8[2],
		__formal__in_b_sliced_8__1 = __in_b_sliced_8[1],
		__formal__in_b_sliced_8__0 = __in_b_sliced_8[0],

		__formal__out_data_sliced_8__7 = __out_data_sliced_8[7],
		__formal__out_data_sliced_8__6 = __out_data_sliced_8[6],
		__formal__out_data_sliced_8__5 = __out_data_sliced_8[5],
		__formal__out_data_sliced_8__4 = __out_data_sliced_8[4],
		__formal__out_data_sliced_8__3 = __out_data_sliced_8[3],
		__formal__out_data_sliced_8__2 = __out_data_sliced_8[2],
		__formal__out_data_sliced_8__1 = __out_data_sliced_8[1],
		__formal__out_data_sliced_8__0 = __out_data_sliced_8[0];

	wire [`MSB_POS__SNOW64_SIZE_16:0]
		__formal__in_a_sliced_16__3 = __in_a_sliced_16[3],
		__formal__in_a_sliced_16__2 = __in_a_sliced_16[2],
		__formal__in_a_sliced_16__1 = __in_a_sliced_16[1],
		__formal__in_a_sliced_16__0 = __in_a_sliced_16[0],

		__formal__in_b_sliced_16__3 = __in_b_sliced_16[3],
		__formal__in_b_sliced_16__2 = __in_b_sliced_16[2],
		__formal__in_b_sliced_16__1 = __in_b_sliced_16[1],
		__formal__in_b_sliced_16__0 = __in_b_sliced_16[0],

		__formal__out_data_sliced_16__3 = __out_data_sliced_16[3],
		__formal__out_data_sliced_16__2 = __out_data_sliced_16[2],
		__formal__out_data_sliced_16__1 = __out_data_sliced_16[1],
		__formal__out_data_sliced_16__0 = __out_data_sliced_16[0];

	wire [`MSB_POS__SNOW64_SIZE_32:0]
		__formal__in_a_sliced_32__1 = __in_a_sliced_32[1],
		__formal__in_a_sliced_32__0 = __in_a_sliced_32[0],

		__formal__in_b_sliced_32__1 = __in_b_sliced_32[1],
		__formal__in_b_sliced_32__0 = __in_b_sliced_32[0],

		__formal__out_data_sliced_32__1 = __out_data_sliced_32[1],
		__formal__out_data_sliced_32__0 = __out_data_sliced_32[0];

	wire [`MSB_POS__SNOW64_SIZE_64:0]
		__formal__in_a_sliced_64__0 = __in_a_sliced_64[0],
		__formal__in_b_sliced_64__0 = __in_b_sliced_64[0],
		__formal__out_data_sliced_64__0 = __out_data_sliced_64[0];

	`endif		// FORMAL

endmodule

//module DebugSnow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
//	output PkgSnow64ArithLog::PortOut_Alu out);
//
//	Snow64Alu __inst_alu(.in(in), .out(out));
//endmodule



module Snow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
	output PkgSnow64ArithLog::PortOut_Alu out);

	localparam __ADD_8_MASK = `WIDTH__SNOW64_SIZE_64'h7f7f_7f7f_7f7f_7f7f;
	localparam __ADD_16_MASK = `WIDTH__SNOW64_SIZE_64'h7fff_7fff_7fff_7fff;
	localparam __ADD_32_MASK = `WIDTH__SNOW64_SIZE_64'h7fff_ffff_7fff_ffff;
	localparam __ADD_64_MASK = `WIDTH__SNOW64_SIZE_64'h7fff_ffff_ffff_ffff;

	localparam __SUB_8_BIT_SETTER_THING = ~__ADD_8_MASK;
	localparam __SUB_16_BIT_SETTER_THING = ~__ADD_16_MASK;
	localparam __SUB_32_BIT_SETTER_THING = ~__ADD_32_MASK;
	localparam __SUB_64_BIT_SETTER_THING = ~__ADD_64_MASK;

	localparam __MSB_POS__SLICE_64_TO_8 = `MSB_POS__SLICE_64_TO_8;
	localparam __MSB_POS__SLICE_64_TO_16 = `MSB_POS__SLICE_64_TO_16;
	localparam __MSB_POS__SLICE_64_TO_32 = `MSB_POS__SLICE_64_TO_32;
	localparam __MSB_POS__SLICE_64_TO_64 = `MSB_POS__SLICE_64_TO_64;

	localparam __WIDTH__SIZE_8 = `WIDTH__SNOW64_SIZE_8;
	localparam __MSB_POS__SIZE_8 = `WIDTH2MP(__WIDTH__SIZE_8);
	localparam __WIDTH__SIZE_16 = `WIDTH__SNOW64_SIZE_16;
	localparam __MSB_POS__SIZE_16 = `WIDTH2MP(__WIDTH__SIZE_16);
	localparam __WIDTH__SIZE_32 = `WIDTH__SNOW64_SIZE_32;
	localparam __MSB_POS__SIZE_32 = `WIDTH2MP(__WIDTH__SIZE_32);
	localparam __WIDTH__SIZE_64 = `WIDTH__SNOW64_SIZE_64;
	localparam __MSB_POS__SIZE_64 = `WIDTH2MP(__WIDTH__SIZE_64);




	wire [__MSB_POS__SIZE_64:0]
		__to_add_8_a, __to_add_8_b, __to_add_16_a, __to_add_16_b,
		__to_add_32_a, __to_add_32_b, __to_add_64_a, __to_add_64_b,
		__to_sub_8_a, __to_sub_8_b, __to_sub_16_a, __to_sub_16_b,
		__to_sub_32_a, __to_sub_32_b, __to_sub_64_a, __to_sub_64_b;

	assign __to_add_8_a = (in.a & __ADD_8_MASK);
	assign __to_add_8_b = (in.b & __ADD_8_MASK);
	assign __to_add_16_a = (in.a & __ADD_16_MASK);
	assign __to_add_16_b = (in.b & __ADD_16_MASK);
	assign __to_add_32_a = (in.a & __ADD_32_MASK);
	assign __to_add_32_b = (in.b & __ADD_32_MASK);
	assign __to_add_64_a = (in.a & __ADD_64_MASK);
	assign __to_add_64_b = (in.b & __ADD_64_MASK);

	assign __to_sub_8_a
		= ((in.a & __ADD_8_MASK) | __SUB_8_BIT_SETTER_THING);
	assign __to_sub_8_b
		= (((~in.b) & __ADD_8_MASK) | __SUB_8_BIT_SETTER_THING);
	assign __to_sub_16_a
		= ((in.a & __ADD_16_MASK) | __SUB_16_BIT_SETTER_THING);
	assign __to_sub_16_b
		= (((~in.b) & __ADD_16_MASK) | __SUB_16_BIT_SETTER_THING);
	assign __to_sub_32_a
		= ((in.a & __ADD_32_MASK) | __SUB_32_BIT_SETTER_THING);
	assign __to_sub_32_b
		= (((~in.b) & __ADD_32_MASK) | __SUB_32_BIT_SETTER_THING);
	assign __to_sub_64_a
		= ((in.a & __ADD_64_MASK) | __SUB_64_BIT_SETTER_THING);
	assign __to_sub_64_b
		= (((~in.b) & __ADD_64_MASK) | __SUB_64_BIT_SETTER_THING);


	logic [__MSB_POS__SIZE_64:0]
		__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
		__addsub_msbs_mask;

	wire [__MSB_POS__SIZE_64:0] __add_result
		= (__to_add_a + __to_add_b) ^ ((in.a ^ in.b) & __addsub_msbs_mask);

	wire [__MSB_POS__SIZE_64:0] __sub_t0 = __to_sub_a + __to_sub_b + 1'b1;

	wire [__MSB_POS__SIZE_64:0] __sub_result
		= __sub_t0 ^ ((in.a ^ (~in.b)) & __addsub_msbs_mask);


	wire [__MSB_POS__SIZE_64:0] __raw_sltu_result
		= ((~(((in.a ^ (~in.b)) & __sub_t0) | (in.a & (~in.b))))
		& __addsub_msbs_mask);
	wire [__MSB_POS__SIZE_64:0] __raw_slts_result
		= ((~((((~in.a) ^ in.b) & __sub_t0) | ((~in.a) & in.b)))
		& __addsub_msbs_mask);


	wire [__MSB_POS__SIZE_64:0]
		__out_inst_lsl64__data, __out_inst_lsr64__data,
		__out_inst_asr64__data;
	LogicalShiftLeft64 __inst_lsl64(.in_to_shift(in.a), .in_amount(in.b),
		.out_data(__out_inst_lsl64__data));
	LogicalShiftRight64 __inst_lsr64(.in_to_shift(in.a), .in_amount(in.b),
		.out_data(__out_inst_lsr64__data));
	ArithmeticShiftRight64 __inst_asr64(.in_to_shift(in.a),
		.in_amount(in.b), .out_data(__out_inst_asr64__data));

	always @(*)
	begin
		case (in.int_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			{__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
				__addsub_msbs_mask}
				= {__to_add_8_a, __to_add_8_b,
				__to_sub_8_a, __to_sub_8_b,
				__SUB_8_BIT_SETTER_THING};
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			{__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
				__addsub_msbs_mask}
				= {__to_add_16_a, __to_add_16_b,
				__to_sub_16_a, __to_sub_16_b,
				__SUB_16_BIT_SETTER_THING};
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			{__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
				__addsub_msbs_mask}
				= {__to_add_32_a, __to_add_32_b,
				__to_sub_32_a, __to_sub_32_b,
				__SUB_32_BIT_SETTER_THING};
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			{__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
				__addsub_msbs_mask}
				= {__to_add_64_a, __to_add_64_b,
				__to_sub_64_a, __to_sub_64_b,
				__SUB_64_BIT_SETTER_THING};
		end
		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64ArithLog::OpAdd:
		begin
			out.data = __add_result;
		end

		PkgSnow64ArithLog::OpSub:
		begin
			out.data = __sub_result;
		end

		PkgSnow64ArithLog::OpSlt:
		begin
			case (in.int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				case (in.type_signedness)
				1'b0:
				begin
					out.data = __raw_sltu_result[63:7];
				end

				1'b1:
				begin
					out.data = __raw_slts_result[63:7];
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				case (in.type_signedness)
				1'b0:
				begin
					out.data = __raw_sltu_result[63:15];
				end

				1'b1:
				begin
					out.data = __raw_slts_result[63:15];
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (in.type_signedness)
				1'b0:
				begin
					out.data = __raw_sltu_result[63:31];
				end

				1'b1:
				begin
					out.data = __raw_slts_result[63:31];
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (in.type_signedness)
				1'b0:
				begin
					out.data = __raw_sltu_result[63:63];
				end

				1'b1:
				begin
					out.data = __raw_slts_result[63:63];
				end
				endcase
			end
			endcase
		end

		PkgSnow64ArithLog::OpAnd:
		begin
			out.data = in.a & in.b;
		end

		PkgSnow64ArithLog::OpOrr:
		begin
			out.data = in.a | in.b;
		end

		PkgSnow64ArithLog::OpXor:
		begin
			out.data = in.a ^ in.b;
		end

		PkgSnow64ArithLog::OpShl:
		begin
			//out.data = in.a << in.b;
			out.data = __out_inst_lsl64__data;
		end

		PkgSnow64ArithLog::OpShr:
		begin
			//out.data = in.a >> in.b;
			case (in.type_signedness)
			1'b0:
			begin
				out.data = __out_inst_lsr64__data;
			end

			1'b1:
			begin
				out.data = __out_inst_asr64__data;
			end
			endcase
		end

		PkgSnow64ArithLog::OpInv:
		begin
			out.data = ~in.a;
		end

		PkgSnow64ArithLog::OpNot:
		begin
			out.data = !in.a;
		end

		PkgSnow64ArithLog::OpAddAgain:
		begin
			out.data = __add_result;
		end

		PkgSnow64ArithLog::OpAddAgain2:
		begin
			out.data = __add_result;
		end

		default:
		begin
			out.data = 0;
		end
		endcase
	end

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

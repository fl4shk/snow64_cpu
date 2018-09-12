`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_bfloat16_defines.header.sv"




// Integer casting module.
// 
// Used by the EX stage of the CPU pipeline to cast from one integer type
// to another.
// 
// Note that casting to/from BFloat16s is NOT done with this module.
module Snow64IntCaster(input logic clk,
	input PkgSnow64IntCaster::PortIn_IntCaster in,
	output PkgSnow64IntCaster::PortOut_IntCaster out);


	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_to_cast = in.to_cast;
	wire __in_src_signedness = in.src_signedness;

	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__in_src_int_type_size = in.src_int_type_size,
		__in_dst_int_type_size = in.dst_int_type_size;


	`ifdef FORMAL
	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;

	`endif		// FORMAL
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __real_out_data;

	wire [`MSB_POS__SNOW64_SIZE_8:0]
		__sliced_8__in_to_cast__data_0 = __in_to_cast[0 * 8 +: 8],
		__sliced_8__in_to_cast__data_1 = __in_to_cast[1 * 8 +: 8],
		__sliced_8__in_to_cast__data_2 = __in_to_cast[2 * 8 +: 8],
		__sliced_8__in_to_cast__data_3 = __in_to_cast[3 * 8 +: 8],
		__sliced_8__in_to_cast__data_4 = __in_to_cast[4 * 8 +: 8],
		__sliced_8__in_to_cast__data_5 = __in_to_cast[5 * 8 +: 8],
		__sliced_8__in_to_cast__data_6 = __in_to_cast[6 * 8 +: 8],
		__sliced_8__in_to_cast__data_7 = __in_to_cast[7 * 8 +: 8],
		__sliced_8__in_to_cast__data_8 = __in_to_cast[8 * 8 +: 8],
		__sliced_8__in_to_cast__data_9 = __in_to_cast[9 * 8 +: 8],
		__sliced_8__in_to_cast__data_10 = __in_to_cast[10 * 8 +: 8],
		__sliced_8__in_to_cast__data_11 = __in_to_cast[11 * 8 +: 8],
		__sliced_8__in_to_cast__data_12 = __in_to_cast[12 * 8 +: 8],
		__sliced_8__in_to_cast__data_13 = __in_to_cast[13 * 8 +: 8],
		__sliced_8__in_to_cast__data_14 = __in_to_cast[14 * 8 +: 8],
		__sliced_8__in_to_cast__data_15 = __in_to_cast[15 * 8 +: 8],
		__sliced_8__in_to_cast__data_16 = __in_to_cast[16 * 8 +: 8],
		__sliced_8__in_to_cast__data_17 = __in_to_cast[17 * 8 +: 8],
		__sliced_8__in_to_cast__data_18 = __in_to_cast[18 * 8 +: 8],
		__sliced_8__in_to_cast__data_19 = __in_to_cast[19 * 8 +: 8],
		__sliced_8__in_to_cast__data_20 = __in_to_cast[20 * 8 +: 8],
		__sliced_8__in_to_cast__data_21 = __in_to_cast[21 * 8 +: 8],
		__sliced_8__in_to_cast__data_22 = __in_to_cast[22 * 8 +: 8],
		__sliced_8__in_to_cast__data_23 = __in_to_cast[23 * 8 +: 8],
		__sliced_8__in_to_cast__data_24 = __in_to_cast[24 * 8 +: 8],
		__sliced_8__in_to_cast__data_25 = __in_to_cast[25 * 8 +: 8],
		__sliced_8__in_to_cast__data_26 = __in_to_cast[26 * 8 +: 8],
		__sliced_8__in_to_cast__data_27 = __in_to_cast[27 * 8 +: 8],
		__sliced_8__in_to_cast__data_28 = __in_to_cast[28 * 8 +: 8],
		__sliced_8__in_to_cast__data_29 = __in_to_cast[29 * 8 +: 8],
		__sliced_8__in_to_cast__data_30 = __in_to_cast[30 * 8 +: 8],
		__sliced_8__in_to_cast__data_31 = __in_to_cast[31 * 8 +: 8];

	wire [`MSB_POS__SNOW64_SIZE_16:0]
		__sliced_16__in_to_cast__data_0 = __in_to_cast[0 * 16 +: 16],
		__sliced_16__in_to_cast__data_1 = __in_to_cast[1 * 16 +: 16],
		__sliced_16__in_to_cast__data_2 = __in_to_cast[2 * 16 +: 16],
		__sliced_16__in_to_cast__data_3 = __in_to_cast[3 * 16 +: 16],
		__sliced_16__in_to_cast__data_4 = __in_to_cast[4 * 16 +: 16],
		__sliced_16__in_to_cast__data_5 = __in_to_cast[5 * 16 +: 16],
		__sliced_16__in_to_cast__data_6 = __in_to_cast[6 * 16 +: 16],
		__sliced_16__in_to_cast__data_7 = __in_to_cast[7 * 16 +: 16],
		__sliced_16__in_to_cast__data_8 = __in_to_cast[8 * 16 +: 16],
		__sliced_16__in_to_cast__data_9 = __in_to_cast[9 * 16 +: 16],
		__sliced_16__in_to_cast__data_10 = __in_to_cast[10 * 16 +: 16],
		__sliced_16__in_to_cast__data_11 = __in_to_cast[11 * 16 +: 16],
		__sliced_16__in_to_cast__data_12 = __in_to_cast[12 * 16 +: 16],
		__sliced_16__in_to_cast__data_13 = __in_to_cast[13 * 16 +: 16],
		__sliced_16__in_to_cast__data_14 = __in_to_cast[14 * 16 +: 16],
		__sliced_16__in_to_cast__data_15 = __in_to_cast[15 * 16 +: 16];

	wire [`MSB_POS__SNOW64_SIZE_32:0]
		__sliced_32__in_to_cast__data_0 = __in_to_cast[0 * 32 +: 32],
		__sliced_32__in_to_cast__data_1 = __in_to_cast[1 * 32 +: 32],
		__sliced_32__in_to_cast__data_2 = __in_to_cast[2 * 32 +: 32],
		__sliced_32__in_to_cast__data_3 = __in_to_cast[3 * 32 +: 32],
		__sliced_32__in_to_cast__data_4 = __in_to_cast[4 * 32 +: 32],
		__sliced_32__in_to_cast__data_5 = __in_to_cast[5 * 32 +: 32],
		__sliced_32__in_to_cast__data_6 = __in_to_cast[6 * 32 +: 32],
		__sliced_32__in_to_cast__data_7 = __in_to_cast[7 * 32 +: 32];

	wire [`MSB_POS__SNOW64_SIZE_64:0]
		__sliced_64__in_to_cast__data_0 = __in_to_cast[0 * 64 +: 64],
		__sliced_64__in_to_cast__data_1 = __in_to_cast[1 * 64 +: 64],
		__sliced_64__in_to_cast__data_2 = __in_to_cast[2 * 64 +: 64],
		__sliced_64__in_to_cast__data_3 = __in_to_cast[3 * 64 +: 64];

	initial
	begin
		__real_out_data = 0;
	end

	assign out.data = __real_out_data;

	always_ff @(posedge clk)
	begin
		case (__in_src_int_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			case (__in_dst_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				__real_out_data <= __in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				case (__in_src_signedness)
				0:
				begin
					__real_out_data[0 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_0);
					__real_out_data[1 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_1);
					__real_out_data[2 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_2);
					__real_out_data[3 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_3);
					__real_out_data[4 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_4);
					__real_out_data[5 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_5);
					__real_out_data[6 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_6);
					__real_out_data[7 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_7);
					__real_out_data[8 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_8);
					__real_out_data[9 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_9);
					__real_out_data[10 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_10);
					__real_out_data[11 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_11);
					__real_out_data[12 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_12);
					__real_out_data[13 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_13);
					__real_out_data[14 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_14);
					__real_out_data[15 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_15);
				end

				1:
				begin
					__real_out_data[0 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_0);
					__real_out_data[1 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_1);
					__real_out_data[2 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_2);
					__real_out_data[3 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_3);
					__real_out_data[4 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_4);
					__real_out_data[5 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_5);
					__real_out_data[6 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_6);
					__real_out_data[7 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_7);
					__real_out_data[8 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_8);
					__real_out_data[9 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_9);
					__real_out_data[10 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_10);
					__real_out_data[11 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_11);
					__real_out_data[12 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_12);
					__real_out_data[13 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_13);
					__real_out_data[14 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_14);
					__real_out_data[15 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast__data_15);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (__in_src_signedness)
				0:
				begin
					__real_out_data[0 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_0);
					__real_out_data[1 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_1);
					__real_out_data[2 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_2);
					__real_out_data[3 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_3);
					__real_out_data[4 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_4);
					__real_out_data[5 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_5);
					__real_out_data[6 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_6);
					__real_out_data[7 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_7);
				end

				1:
				begin
					__real_out_data[0 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_0);
					__real_out_data[1 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_1);
					__real_out_data[2 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_2);
					__real_out_data[3 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_3);
					__real_out_data[4 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_4);
					__real_out_data[5 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_5);
					__real_out_data[6 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_6);
					__real_out_data[7 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast__data_7);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_signedness)
				0:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `ZERO_EXTEND(64, 8,
						__sliced_8__in_to_cast__data_0);
					__real_out_data[1 * 64 +: 64]
						<= `ZERO_EXTEND(64, 8,
						__sliced_8__in_to_cast__data_1);
					__real_out_data[2 * 64 +: 64]
						<= `ZERO_EXTEND(64, 8,
						__sliced_8__in_to_cast__data_2);
					__real_out_data[3 * 64 +: 64]
						<= `ZERO_EXTEND(64, 8,
						__sliced_8__in_to_cast__data_3);
				end

				1:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `SIGN_EXTEND(64, 8,
						__sliced_8__in_to_cast__data_0);
					__real_out_data[1 * 64 +: 64]
						<= `SIGN_EXTEND(64, 8,
						__sliced_8__in_to_cast__data_1);
					__real_out_data[2 * 64 +: 64]
						<= `SIGN_EXTEND(64, 8,
						__sliced_8__in_to_cast__data_2);
					__real_out_data[3 * 64 +: 64]
						<= `SIGN_EXTEND(64, 8,
						__sliced_8__in_to_cast__data_3);
				end
				endcase
			end
			endcase
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			case (__in_dst_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				__real_out_data[0 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_0[`WIDTH2MP(8):0];
				__real_out_data[1 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_1[`WIDTH2MP(8):0];
				__real_out_data[2 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_2[`WIDTH2MP(8):0];
				__real_out_data[3 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_3[`WIDTH2MP(8):0];
				__real_out_data[4 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_4[`WIDTH2MP(8):0];
				__real_out_data[5 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_5[`WIDTH2MP(8):0];
				__real_out_data[6 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_6[`WIDTH2MP(8):0];
				__real_out_data[7 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_7[`WIDTH2MP(8):0];
				__real_out_data[8 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_8[`WIDTH2MP(8):0];
				__real_out_data[9 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_9[`WIDTH2MP(8):0];
				__real_out_data[10 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_10[`WIDTH2MP(8):0];
				__real_out_data[11 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_11[`WIDTH2MP(8):0];
				__real_out_data[12 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_12[`WIDTH2MP(8):0];
				__real_out_data[13 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_13[`WIDTH2MP(8):0];
				__real_out_data[14 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_14[`WIDTH2MP(8):0];
				__real_out_data[15 * 8 +: 8]
					<= __sliced_16__in_to_cast__data_15[`WIDTH2MP(8):0];
				__real_out_data[16 * 8 +: 8] <= 0;
				__real_out_data[17 * 8 +: 8] <= 0;
				__real_out_data[18 * 8 +: 8] <= 0;
				__real_out_data[19 * 8 +: 8] <= 0;
				__real_out_data[20 * 8 +: 8] <= 0;
				__real_out_data[21 * 8 +: 8] <= 0;
				__real_out_data[22 * 8 +: 8] <= 0;
				__real_out_data[23 * 8 +: 8] <= 0;
				__real_out_data[24 * 8 +: 8] <= 0;
				__real_out_data[25 * 8 +: 8] <= 0;
				__real_out_data[26 * 8 +: 8] <= 0;
				__real_out_data[27 * 8 +: 8] <= 0;
				__real_out_data[28 * 8 +: 8] <= 0;
				__real_out_data[29 * 8 +: 8] <= 0;
				__real_out_data[30 * 8 +: 8] <= 0;
				__real_out_data[31 * 8 +: 8] <= 0;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__real_out_data <= __in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (__in_src_signedness)
				0:
				begin
					__real_out_data[0 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_0);
					__real_out_data[1 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_1);
					__real_out_data[2 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_2);
					__real_out_data[3 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_3);
					__real_out_data[4 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_4);
					__real_out_data[5 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_5);
					__real_out_data[6 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_6);
					__real_out_data[7 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_7);
				end

				1:
				begin
					__real_out_data[0 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_0);
					__real_out_data[1 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_1);
					__real_out_data[2 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_2);
					__real_out_data[3 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_3);
					__real_out_data[4 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_4);
					__real_out_data[5 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_5);
					__real_out_data[6 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_6);
					__real_out_data[7 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast__data_7);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_signedness)
				0:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `ZERO_EXTEND(64, 16,
						__sliced_16__in_to_cast__data_0);
					__real_out_data[1 * 64 +: 64]
						<= `ZERO_EXTEND(64, 16,
						__sliced_16__in_to_cast__data_1);
					__real_out_data[2 * 64 +: 64]
						<= `ZERO_EXTEND(64, 16,
						__sliced_16__in_to_cast__data_2);
					__real_out_data[3 * 64 +: 64]
						<= `ZERO_EXTEND(64, 16,
						__sliced_16__in_to_cast__data_3);
				end

				1:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `SIGN_EXTEND(64, 16,
						__sliced_16__in_to_cast__data_0);
					__real_out_data[1 * 64 +: 64]
						<= `SIGN_EXTEND(64, 16,
						__sliced_16__in_to_cast__data_1);
					__real_out_data[2 * 64 +: 64]
						<= `SIGN_EXTEND(64, 16,
						__sliced_16__in_to_cast__data_2);
					__real_out_data[3 * 64 +: 64]
						<= `SIGN_EXTEND(64, 16,
						__sliced_16__in_to_cast__data_3);
				end
				endcase
			end
			endcase
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			case (__in_dst_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				__real_out_data[0 * 8 +: 8]
					<= __sliced_32__in_to_cast__data_0[`WIDTH2MP(8):0];
				__real_out_data[1 * 8 +: 8]
					<= __sliced_32__in_to_cast__data_1[`WIDTH2MP(8):0];
				__real_out_data[2 * 8 +: 8]
					<= __sliced_32__in_to_cast__data_2[`WIDTH2MP(8):0];
				__real_out_data[3 * 8 +: 8]
					<= __sliced_32__in_to_cast__data_3[`WIDTH2MP(8):0];
				__real_out_data[4 * 8 +: 8]
					<= __sliced_32__in_to_cast__data_4[`WIDTH2MP(8):0];
				__real_out_data[5 * 8 +: 8]
					<= __sliced_32__in_to_cast__data_5[`WIDTH2MP(8):0];
				__real_out_data[6 * 8 +: 8]
					<= __sliced_32__in_to_cast__data_6[`WIDTH2MP(8):0];
				__real_out_data[7 * 8 +: 8]
					<= __sliced_32__in_to_cast__data_7[`WIDTH2MP(8):0];
				__real_out_data[8 * 8 +: 8] <= 0;
				__real_out_data[9 * 8 +: 8] <= 0;
				__real_out_data[10 * 8 +: 8] <= 0;
				__real_out_data[11 * 8 +: 8] <= 0;
				__real_out_data[12 * 8 +: 8] <= 0;
				__real_out_data[13 * 8 +: 8] <= 0;
				__real_out_data[14 * 8 +: 8] <= 0;
				__real_out_data[15 * 8 +: 8] <= 0;
				__real_out_data[16 * 8 +: 8] <= 0;
				__real_out_data[17 * 8 +: 8] <= 0;
				__real_out_data[18 * 8 +: 8] <= 0;
				__real_out_data[19 * 8 +: 8] <= 0;
				__real_out_data[20 * 8 +: 8] <= 0;
				__real_out_data[21 * 8 +: 8] <= 0;
				__real_out_data[22 * 8 +: 8] <= 0;
				__real_out_data[23 * 8 +: 8] <= 0;
				__real_out_data[24 * 8 +: 8] <= 0;
				__real_out_data[25 * 8 +: 8] <= 0;
				__real_out_data[26 * 8 +: 8] <= 0;
				__real_out_data[27 * 8 +: 8] <= 0;
				__real_out_data[28 * 8 +: 8] <= 0;
				__real_out_data[29 * 8 +: 8] <= 0;
				__real_out_data[30 * 8 +: 8] <= 0;
				__real_out_data[31 * 8 +: 8] <= 0;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__real_out_data[0 * 16 +: 16]
					<= __sliced_32__in_to_cast__data_0[`WIDTH2MP(16):0];
				__real_out_data[1 * 16 +: 16]
					<= __sliced_32__in_to_cast__data_1[`WIDTH2MP(16):0];
				__real_out_data[2 * 16 +: 16]
					<= __sliced_32__in_to_cast__data_2[`WIDTH2MP(16):0];
				__real_out_data[3 * 16 +: 16]
					<= __sliced_32__in_to_cast__data_3[`WIDTH2MP(16):0];
				__real_out_data[4 * 16 +: 16]
					<= __sliced_32__in_to_cast__data_4[`WIDTH2MP(16):0];
				__real_out_data[5 * 16 +: 16]
					<= __sliced_32__in_to_cast__data_5[`WIDTH2MP(16):0];
				__real_out_data[6 * 16 +: 16]
					<= __sliced_32__in_to_cast__data_6[`WIDTH2MP(16):0];
				__real_out_data[7 * 16 +: 16]
					<= __sliced_32__in_to_cast__data_7[`WIDTH2MP(16):0];
				__real_out_data[8 * 16 +: 16] <= 0;
				__real_out_data[9 * 16 +: 16] <= 0;
				__real_out_data[10 * 16 +: 16] <= 0;
				__real_out_data[11 * 16 +: 16] <= 0;
				__real_out_data[12 * 16 +: 16] <= 0;
				__real_out_data[13 * 16 +: 16] <= 0;
				__real_out_data[14 * 16 +: 16] <= 0;
				__real_out_data[15 * 16 +: 16] <= 0;
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__real_out_data <= __in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_signedness)
				0:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `ZERO_EXTEND(64, 32,
						__sliced_32__in_to_cast__data_0);
					__real_out_data[1 * 64 +: 64]
						<= `ZERO_EXTEND(64, 32,
						__sliced_32__in_to_cast__data_1);
					__real_out_data[2 * 64 +: 64]
						<= `ZERO_EXTEND(64, 32,
						__sliced_32__in_to_cast__data_2);
					__real_out_data[3 * 64 +: 64]
						<= `ZERO_EXTEND(64, 32,
						__sliced_32__in_to_cast__data_3);
				end

				1:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `SIGN_EXTEND(64, 32,
						__sliced_32__in_to_cast__data_0);
					__real_out_data[1 * 64 +: 64]
						<= `SIGN_EXTEND(64, 32,
						__sliced_32__in_to_cast__data_1);
					__real_out_data[2 * 64 +: 64]
						<= `SIGN_EXTEND(64, 32,
						__sliced_32__in_to_cast__data_2);
					__real_out_data[3 * 64 +: 64]
						<= `SIGN_EXTEND(64, 32,
						__sliced_32__in_to_cast__data_3);
				end
				endcase
			end
			endcase
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			case (__in_dst_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				__real_out_data[0 * 8 +: 8]
					<= __sliced_64__in_to_cast__data_0[`WIDTH2MP(8):0];
				__real_out_data[1 * 8 +: 8]
					<= __sliced_64__in_to_cast__data_1[`WIDTH2MP(8):0];
				__real_out_data[2 * 8 +: 8]
					<= __sliced_64__in_to_cast__data_2[`WIDTH2MP(8):0];
				__real_out_data[3 * 8 +: 8]
					<= __sliced_64__in_to_cast__data_3[`WIDTH2MP(8):0];
				__real_out_data[4 * 8 +: 8] <= 0;
				__real_out_data[5 * 8 +: 8] <= 0;
				__real_out_data[6 * 8 +: 8] <= 0;
				__real_out_data[7 * 8 +: 8] <= 0;
				__real_out_data[8 * 8 +: 8] <= 0;
				__real_out_data[9 * 8 +: 8] <= 0;
				__real_out_data[10 * 8 +: 8] <= 0;
				__real_out_data[11 * 8 +: 8] <= 0;
				__real_out_data[12 * 8 +: 8] <= 0;
				__real_out_data[13 * 8 +: 8] <= 0;
				__real_out_data[14 * 8 +: 8] <= 0;
				__real_out_data[15 * 8 +: 8] <= 0;
				__real_out_data[16 * 8 +: 8] <= 0;
				__real_out_data[17 * 8 +: 8] <= 0;
				__real_out_data[18 * 8 +: 8] <= 0;
				__real_out_data[19 * 8 +: 8] <= 0;
				__real_out_data[20 * 8 +: 8] <= 0;
				__real_out_data[21 * 8 +: 8] <= 0;
				__real_out_data[22 * 8 +: 8] <= 0;
				__real_out_data[23 * 8 +: 8] <= 0;
				__real_out_data[24 * 8 +: 8] <= 0;
				__real_out_data[25 * 8 +: 8] <= 0;
				__real_out_data[26 * 8 +: 8] <= 0;
				__real_out_data[27 * 8 +: 8] <= 0;
				__real_out_data[28 * 8 +: 8] <= 0;
				__real_out_data[29 * 8 +: 8] <= 0;
				__real_out_data[30 * 8 +: 8] <= 0;
				__real_out_data[31 * 8 +: 8] <= 0;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__real_out_data[0 * 16 +: 16]
					<= __sliced_64__in_to_cast__data_0[`WIDTH2MP(16):0];
				__real_out_data[1 * 16 +: 16]
					<= __sliced_64__in_to_cast__data_1[`WIDTH2MP(16):0];
				__real_out_data[2 * 16 +: 16]
					<= __sliced_64__in_to_cast__data_2[`WIDTH2MP(16):0];
				__real_out_data[3 * 16 +: 16]
					<= __sliced_64__in_to_cast__data_3[`WIDTH2MP(16):0];
				__real_out_data[4 * 16 +: 16] <= 0;
				__real_out_data[5 * 16 +: 16] <= 0;
				__real_out_data[6 * 16 +: 16] <= 0;
				__real_out_data[7 * 16 +: 16] <= 0;
				__real_out_data[8 * 16 +: 16] <= 0;
				__real_out_data[9 * 16 +: 16] <= 0;
				__real_out_data[10 * 16 +: 16] <= 0;
				__real_out_data[11 * 16 +: 16] <= 0;
				__real_out_data[12 * 16 +: 16] <= 0;
				__real_out_data[13 * 16 +: 16] <= 0;
				__real_out_data[14 * 16 +: 16] <= 0;
				__real_out_data[15 * 16 +: 16] <= 0;
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__real_out_data[0 * 32 +: 32]
					<= __sliced_64__in_to_cast__data_0[`WIDTH2MP(32):0];
				__real_out_data[1 * 32 +: 32]
					<= __sliced_64__in_to_cast__data_1[`WIDTH2MP(32):0];
				__real_out_data[2 * 32 +: 32]
					<= __sliced_64__in_to_cast__data_2[`WIDTH2MP(32):0];
				__real_out_data[3 * 32 +: 32]
					<= __sliced_64__in_to_cast__data_3[`WIDTH2MP(32):0];
				__real_out_data[4 * 32 +: 32] <= 0;
				__real_out_data[5 * 32 +: 32] <= 0;
				__real_out_data[6 * 32 +: 32] <= 0;
				__real_out_data[7 * 32 +: 32] <= 0;
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				__real_out_data <= __in_to_cast;
			end
			endcase
		end
		endcase
	end

endmodule

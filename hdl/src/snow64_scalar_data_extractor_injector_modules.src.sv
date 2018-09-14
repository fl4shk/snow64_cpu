`include "src/snow64_scalar_data_extractor_injector_defines.header.sv"

// Note:  this module does NOT perform casting!
module Snow64ScalarDataExtractor
	(input PkgSnow64ScalarDataExtractorInjector::PortIn_ScalarDataExtractor
		in,
	output PkgSnow64ScalarDataExtractorInjector::PortOut_ScalarDataExtractor
		out);

	localparam __MSB_POS__DATA_OFFSET
		= `MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET;


	`ifdef FORMAL
	localparam __ENUM__DATA_TYPE__UNSGN_INT
		= PkgSnow64Cpu::DataTypUnsgnInt;
	localparam __ENUM__DATA_TYPE__SGN_INT = PkgSnow64Cpu::DataTypSgnInt;
	localparam __ENUM__DATA_TYPE__BFLOAT16 = PkgSnow64Cpu::DataTypBFloat16;
	localparam __ENUM__DATA_TYPE__RESERVED = PkgSnow64Cpu::DataTypReserved;

	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;

	wire [`MSB_POS__SNOW64_SCALAR_DATA:0] __formal__out_data = out.data;
	`endif		// FORMAL

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_to_shift = in.to_shift;
	wire [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] __in_data_type = in.data_type;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__in_int_type_size = in.int_type_size;
	wire [__MSB_POS__DATA_OFFSET:0] __in_data_offset = in.data_offset;


	always @(*)
	begin
		case(__in_data_type)
		PkgSnow64Cpu::DataTypBFloat16:
		begin
			case (`EXTRACT_DATA_INDEX_TYPE_2__16
				(__MSB_POS__DATA_OFFSET, __in_data_offset))
				`define X(which) \
					which: out.data = __in_to_shift[which * 16 +: 16];
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`undef X
			endcase
		end

		PkgSnow64Cpu::DataTypReserved:
		begin
			// We don't really care about this case.
			out.data = 0;
		end

		default:
		begin
			case (__in_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				case (`EXTRACT_DATA_INDEX_TYPE_2__8
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				`define X(which) \
					which: out.data = __in_to_shift[which * 8 +: 8];
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`X(16) `X(17) `X(18) `X(19)
				`X(20) `X(21) `X(22) `X(23)
				`X(24) `X(25) `X(26) `X(27)
				`X(28) `X(29) `X(30) `X(31)
				`undef X
				endcase
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				case (`EXTRACT_DATA_INDEX_TYPE_2__16
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				`define X(which) \
					which: out.data = __in_to_shift[which * 16 +: 16];
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`undef X
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (`EXTRACT_DATA_INDEX_TYPE_2__32
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				`define X(which) \
					which: out.data = __in_to_shift[which * 32 +: 32];
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`undef X
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (`EXTRACT_DATA_INDEX_TYPE_2__64
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				`define X(which) \
					which: out.data = __in_to_shift[which * 64 +: 64];
				`X(0) `X(1) `X(2) `X(3)
				endcase
			end
			endcase
		end
		endcase
	end


endmodule

module Snow64ScalarDataInjector
	(input PkgSnow64ScalarDataExtractorInjector::PortIn_ScalarDataInjector
		in,
	output PkgSnow64ScalarDataExtractorInjector::PortOut_ScalarDataInjector
		out);

	localparam __MSB_POS__DATA_OFFSET
		= `MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_to_modify = in.to_modify;
	wire [`MSB_POS__SNOW64_SCALAR_DATA:0] __in_to_shift = in.to_shift;
	wire [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] __in_data_type = in.data_type;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__in_int_type_size = in.int_type_size;
	wire [__MSB_POS__DATA_OFFSET:0] __in_data_offset = in.data_offset;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __real_out_data;
	assign out.data = __real_out_data;

	`ifdef FORMAL
	localparam __ENUM__DATA_TYPE__UNSGN_INT
		= PkgSnow64Cpu::DataTypUnsgnInt;
	localparam __ENUM__DATA_TYPE__SGN_INT = PkgSnow64Cpu::DataTypSgnInt;
	localparam __ENUM__DATA_TYPE__BFLOAT16 = PkgSnow64Cpu::DataTypBFloat16;
	localparam __ENUM__DATA_TYPE__RESERVED = PkgSnow64Cpu::DataTypReserved;

	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __formal__out_data = out.data;
	`endif		// FORMAL



	always @(*)
	begin
		__real_out_data = __in_to_modify;

		case (__in_data_type)
		PkgSnow64Cpu::DataTypBFloat16:
		begin
			case (`EXTRACT_DATA_INDEX_TYPE_2__16
				(__MSB_POS__DATA_OFFSET, __in_data_offset))
			`define X(which) \
				which: __real_out_data[which * 16 +: 16] \
					= __in_to_shift[`WIDTH2MP(16):0]; 
			`X(0) `X(1) `X(2) `X(3)
			`X(4) `X(5) `X(6) `X(7)
			`X(8) `X(9) `X(10) `X(11)
			`X(12) `X(13) `X(14) `X(15)
			`undef X
			endcase
		end

		PkgSnow64Cpu::DataTypReserved:
		begin
			// We don't really care about this case.
			__real_out_data = 0;
		end

		default:
		begin
			case (__in_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				case (`EXTRACT_DATA_INDEX_TYPE_2__8
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				`define X(which) \
					which: __real_out_data[which * 8 +: 8] \
						= __in_to_shift[`WIDTH2MP(8):0]; 
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`X(16) `X(17) `X(18) `X(19)
				`X(20) `X(21) `X(22) `X(23)
				`X(24) `X(25) `X(26) `X(27)
				`X(28) `X(29) `X(30) `X(31)
				`undef X
				endcase
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				case (`EXTRACT_DATA_INDEX_TYPE_2__16
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				`define X(which) \
					which: __real_out_data[which * 16 +: 16] \
						= __in_to_shift[`WIDTH2MP(16):0]; 
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`undef X
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (`EXTRACT_DATA_INDEX_TYPE_2__32
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				`define X(which) \
					which: __real_out_data[which * 32 +: 32] \
						= __in_to_shift[`WIDTH2MP(32):0]; 
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`undef X
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (`EXTRACT_DATA_INDEX_TYPE_2__64
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				`define X(which) \
					which: __real_out_data[which * 64 +: 64] \
						= __in_to_shift[`WIDTH2MP(64):0]; 
				`X(0) `X(1) `X(2) `X(3)
				`undef X
				endcase
			end
			endcase
		end
		endcase
	end

endmodule

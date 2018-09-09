`include "src/snow64_scalar_data_shifter_defines.header.sv"

// Note:  this module does NOT perform casting!
module Snow64ScalarDataShifterForRead
	(input PkgSnow64ScalarDataShifter::PortIn_ScalarDataShifterForRead in,
	output PkgSnow64ScalarDataShifter::PortOut_ScalarDataShifterForRead
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

	wire [`MSB_POS__SNOW64_SCALAR_DATA:0]
		__formal__out_data = out.data;
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
			////`ifdef GEN_VERILOG
			//out.data = `GET_BITS(__in_to_shift, (`WIDTH2MP(1 << 16)
			//	<< (`EXTRACT_DATA_INDEX_TYPE_2__16
			//	(__MSB_POS__DATA_OFFSET,
			//	__in_data_offset) * 16)),
			//	(`EXTRACT_DATA_INDEX_TYPE_2__16
			//	(__MSB_POS__DATA_OFFSET,
			//	__in_data_offset) * 16));
			////`else // if (!defined(GEN_VERILOG))
			////out.data = __in_to_shift[`EXTRACT_DATA_INDEX_TYPE_2__16
			////	(__MSB_POS__DATA_OFFSET, __in_data_offset) * 16 +: 16];
			////`endif		// GEN_VERILOG

			case (`EXTRACT_DATA_INDEX_TYPE_2__16
				(__MSB_POS__DATA_OFFSET, __in_data_offset))
			0: out.data = __in_to_shift[0 * 16 +: 16]; 
			1: out.data = __in_to_shift[1 * 16 +: 16]; 
			2: out.data = __in_to_shift[2 * 16 +: 16]; 
			3: out.data = __in_to_shift[3 * 16 +: 16]; 
			4: out.data = __in_to_shift[4 * 16 +: 16]; 
			5: out.data = __in_to_shift[5 * 16 +: 16]; 
			6: out.data = __in_to_shift[6 * 16 +: 16]; 
			7: out.data = __in_to_shift[7 * 16 +: 16]; 
			8: out.data = __in_to_shift[8 * 16 +: 16]; 
			9: out.data = __in_to_shift[9 * 16 +: 16]; 
			10: out.data = __in_to_shift[10 * 16 +: 16]; 
			11: out.data = __in_to_shift[11 * 16 +: 16]; 
			12: out.data = __in_to_shift[12 * 16 +: 16]; 
			13: out.data = __in_to_shift[13 * 16 +: 16]; 
			14: out.data = __in_to_shift[14 * 16 +: 16]; 
			15: out.data = __in_to_shift[15 * 16 +: 16];
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
				////`ifdef GEN_VERILOG
				//out.data = `GET_BITS(__in_to_shift, 
				//	(`WIDTH2MP(1 << 8)
				//	<< (`EXTRACT_DATA_INDEX_TYPE_2__8
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 8)),
				//	(`EXTRACT_DATA_INDEX_TYPE_2__8
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 8));
				////`else // if (!defined(GEN_VERILOG))
				////out.data = __in_to_shift[`EXTRACT_DATA_INDEX_TYPE_2__8
				////	(__MSB_POS__DATA_OFFSET, __in_data_offset) * 8 +: 8];
				////`endif		// GEN_VERILOG
				case (`EXTRACT_DATA_INDEX_TYPE_2__8
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				0: out.data = __in_to_shift[0 * 8 +: 8]; 
				1: out.data = __in_to_shift[1 * 8 +: 8]; 
				2: out.data = __in_to_shift[2 * 8 +: 8]; 
				3: out.data = __in_to_shift[3 * 8 +: 8]; 
				4: out.data = __in_to_shift[4 * 8 +: 8]; 
				5: out.data = __in_to_shift[5 * 8 +: 8]; 
				6: out.data = __in_to_shift[6 * 8 +: 8]; 
				7: out.data = __in_to_shift[7 * 8 +: 8]; 
				8: out.data = __in_to_shift[8 * 8 +: 8]; 
				9: out.data = __in_to_shift[9 * 8 +: 8]; 
				10: out.data = __in_to_shift[10 * 8 +: 8]; 
				11: out.data = __in_to_shift[11 * 8 +: 8]; 
				12: out.data = __in_to_shift[12 * 8 +: 8]; 
				13: out.data = __in_to_shift[13 * 8 +: 8]; 
				14: out.data = __in_to_shift[14 * 8 +: 8]; 
				15: out.data = __in_to_shift[15 * 8 +: 8]; 
				16: out.data = __in_to_shift[16 * 8 +: 8]; 
				17: out.data = __in_to_shift[17 * 8 +: 8]; 
				18: out.data = __in_to_shift[18 * 8 +: 8]; 
				19: out.data = __in_to_shift[19 * 8 +: 8]; 
				20: out.data = __in_to_shift[20 * 8 +: 8]; 
				21: out.data = __in_to_shift[21 * 8 +: 8]; 
				22: out.data = __in_to_shift[22 * 8 +: 8]; 
				23: out.data = __in_to_shift[23 * 8 +: 8]; 
				24: out.data = __in_to_shift[24 * 8 +: 8]; 
				25: out.data = __in_to_shift[25 * 8 +: 8]; 
				26: out.data = __in_to_shift[26 * 8 +: 8]; 
				27: out.data = __in_to_shift[27 * 8 +: 8]; 
				28: out.data = __in_to_shift[28 * 8 +: 8]; 
				29: out.data = __in_to_shift[29 * 8 +: 8]; 
				30: out.data = __in_to_shift[30 * 8 +: 8]; 
				31: out.data = __in_to_shift[31 * 8 +: 8];
				endcase
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				////`ifdef GEN_VERILOG
				//out.data = `GET_BITS(__in_to_shift, 
				//	(`WIDTH2MP(1 << 16)
				//	<< (`EXTRACT_DATA_INDEX_TYPE_2__16
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 16)),
				//	(`EXTRACT_DATA_INDEX_TYPE_2__16
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 16));
				////`else // if (!defined(GEN_VERILOG))
				////out.data = __in_to_shift[`EXTRACT_DATA_INDEX_TYPE_2__16
				////	(__MSB_POS__DATA_OFFSET, __in_data_offset) * 16 +: 16];
				////`endif		// GEN_VERILOG
				case (`EXTRACT_DATA_INDEX_TYPE_2__16
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				0: out.data = __in_to_shift[0 * 16 +: 16]; 
				1: out.data = __in_to_shift[1 * 16 +: 16]; 
				2: out.data = __in_to_shift[2 * 16 +: 16]; 
				3: out.data = __in_to_shift[3 * 16 +: 16]; 
				4: out.data = __in_to_shift[4 * 16 +: 16]; 
				5: out.data = __in_to_shift[5 * 16 +: 16]; 
				6: out.data = __in_to_shift[6 * 16 +: 16]; 
				7: out.data = __in_to_shift[7 * 16 +: 16]; 
				8: out.data = __in_to_shift[8 * 16 +: 16]; 
				9: out.data = __in_to_shift[9 * 16 +: 16]; 
				10: out.data = __in_to_shift[10 * 16 +: 16]; 
				11: out.data = __in_to_shift[11 * 16 +: 16]; 
				12: out.data = __in_to_shift[12 * 16 +: 16]; 
				13: out.data = __in_to_shift[13 * 16 +: 16]; 
				14: out.data = __in_to_shift[14 * 16 +: 16]; 
				15: out.data = __in_to_shift[15 * 16 +: 16];
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				////`ifdef GEN_VERILOG
				//out.data = `GET_BITS(__in_to_shift, 
				//	(`WIDTH2MP(1 << 32)
				//	<< (`EXTRACT_DATA_INDEX_TYPE_2__32
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 32)),
				//	(`EXTRACT_DATA_INDEX_TYPE_2__32
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 32));
				////`else // if (!defined(GEN_VERILOG))
				////out.data = __in_to_shift[`EXTRACT_DATA_INDEX_TYPE_2__32
				////	(__MSB_POS__DATA_OFFSET, __in_data_offset) * 32 +: 32];
				////`endif		// GEN_VERILOG
				case (`EXTRACT_DATA_INDEX_TYPE_2__32
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				0: out.data = __in_to_shift[0 * 32 +: 32];
				1: out.data = __in_to_shift[1 * 32 +: 32];
				2: out.data = __in_to_shift[2 * 32 +: 32];
				3: out.data = __in_to_shift[3 * 32 +: 32];
				4: out.data = __in_to_shift[4 * 32 +: 32];
				5: out.data = __in_to_shift[5 * 32 +: 32];
				6: out.data = __in_to_shift[6 * 32 +: 32];
				7: out.data = __in_to_shift[7 * 32 +: 32];
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				////`ifdef GEN_VERILOG
				//out.data = `GET_BITS(__in_to_shift, 
				//	(`WIDTH2MP(1 << 64)
				//	<< (`EXTRACT_DATA_INDEX_TYPE_2__64
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 64)),
				//	(`EXTRACT_DATA_INDEX_TYPE_2__64
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 64));
				////`else // if (!defined(GEN_VERILOG))
				////out.data = __in_to_shift[`EXTRACT_DATA_INDEX_TYPE_2__64
				////	(__MSB_POS__DATA_OFFSET, __in_data_offset) * 64 +: 64];
				////`endif		// GEN_VERILOG
				case (`EXTRACT_DATA_INDEX_TYPE_2__64
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				0: out.data = __in_to_shift[0 * 64 +: 64];
				1: out.data = __in_to_shift[1 * 64 +: 64];
				2: out.data = __in_to_shift[2 * 64 +: 64];
				3: out.data = __in_to_shift[3 * 64 +: 64];
				endcase
			end
			endcase
		end
		endcase
	end


endmodule

module Snow64ScalarDataShifterForWrite
	(input PkgSnow64ScalarDataShifter::PortIn_ScalarDataShifterForWrite in,
	output PkgSnow64ScalarDataShifter::PortOut_ScalarDataShifterForWrite
		out);

	localparam __MSB_POS__DATA_OFFSET
		= `MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_to_modify = in.to_modify;
	wire [`MSB_POS__SNOW64_SCALAR_DATA:0] __in_to_shift = in.to_shift;
	wire [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] __in_data_type = in.data_type;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__in_int_type_size = in.int_type_size;
	wire [__MSB_POS__DATA_OFFSET:0] __in_data_offset = in.data_offset;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __temp[2];


	always @(*)
	begin
		case(__in_data_type)
		PkgSnow64Cpu::DataTypBFloat16:
		begin
			out.data = `GET_SET_BITS(`GET_CLEARED_BITS(__in_to_modify,
				(`WIDTH2MP(1 << 16)
				<< (`EXTRACT_DATA_INDEX_TYPE_2__16
				(__MSB_POS__DATA_OFFSET, __in_data_offset) * 16))),
				(__in_to_shift[`WIDTH2MP(16):0]
				<< (`EXTRACT_DATA_INDEX_TYPE_2__16
				(__MSB_POS__DATA_OFFSET, __in_data_offset) * 16)));
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
				out.data = `GET_SET_BITS(`GET_CLEARED_BITS(__in_to_modify,
					(`WIDTH2MP(1 << 8)
					<< (`EXTRACT_DATA_INDEX_TYPE_2__8
					(__MSB_POS__DATA_OFFSET, __in_data_offset) * 8))),
					(__in_to_shift[`WIDTH2MP(8):0]
					<< (`EXTRACT_DATA_INDEX_TYPE_2__8
					(__MSB_POS__DATA_OFFSET, __in_data_offset) * 8)));
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				out.data = `GET_SET_BITS(`GET_CLEARED_BITS(__in_to_modify,
					(`WIDTH2MP(1 << 16)
					<< (`EXTRACT_DATA_INDEX_TYPE_2__16
					(__MSB_POS__DATA_OFFSET, __in_data_offset) * 16))),
					(__in_to_shift[`WIDTH2MP(16):0]
					<< (`EXTRACT_DATA_INDEX_TYPE_2__16
					(__MSB_POS__DATA_OFFSET, __in_data_offset) * 16)));
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				out.data = `GET_SET_BITS(`GET_CLEARED_BITS(__in_to_modify,
					(`WIDTH2MP(1 << 32)
					<< (`EXTRACT_DATA_INDEX_TYPE_2__32
					(__MSB_POS__DATA_OFFSET, __in_data_offset) * 32))),
					(__in_to_shift[`WIDTH2MP(32):0]
					<< (`EXTRACT_DATA_INDEX_TYPE_2__32
					(__MSB_POS__DATA_OFFSET, __in_data_offset) * 32)));
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				out.data = `GET_SET_BITS(`GET_CLEARED_BITS(__in_to_modify,
					(`WIDTH2MP(1 << 64)
					<< (`EXTRACT_DATA_INDEX_TYPE_2__64
					(__MSB_POS__DATA_OFFSET, __in_data_offset) * 64))),
					(__in_to_shift[`WIDTH2MP(64):0]
					<< (`EXTRACT_DATA_INDEX_TYPE_2__64
					(__MSB_POS__DATA_OFFSET, __in_data_offset) * 64)));
			end
			endcase
		end
		endcase
	end

endmodule

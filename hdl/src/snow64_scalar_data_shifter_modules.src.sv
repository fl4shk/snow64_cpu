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
			//out.data = `GET_BITS(__in_to_shift, 
			//	(`WIDTH2MP(1 << 16)
			//	<< (`EXTRACT_DATA_INDEX_TYPE_2__16(__MSB_POS__DATA_OFFSET,
			//	__in_data_offset) * 16)),
			//	(`EXTRACT_DATA_INDEX_TYPE_2__16(__MSB_POS__DATA_OFFSET,
			//	__in_data_offset) * 16));
			//out.data = ((__in_to_shift & (16'hffff
			//	<< (__in_data_offset[4:1] * 16)))
			//	>> (__in_data_offset[4:1] * 16));
			case (`EXTRACT_DATA_INDEX_TYPE_2__16(__MSB_POS__DATA_OFFSET,
				__in_data_offset))
			0: out.data = __in_to_shift[15:0];
			1: out.data = __in_to_shift[31:16];
			2: out.data = __in_to_shift[47:32];
			3: out.data = __in_to_shift[63:48];
			4: out.data = __in_to_shift[79:64];
			5: out.data = __in_to_shift[95:80];
			6: out.data = __in_to_shift[111:96];
			7: out.data = __in_to_shift[127:112];
			8: out.data = __in_to_shift[143:128];
			9: out.data = __in_to_shift[159:144];
			10: out.data = __in_to_shift[175:160];
			11: out.data = __in_to_shift[191:176];
			12: out.data = __in_to_shift[207:192];
			13: out.data = __in_to_shift[223:208];
			14: out.data = __in_to_shift[239:224];
			15: out.data = __in_to_shift[255:240];
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
				//out.data = `GET_BITS(__in_to_shift, 
				//	(`WIDTH2MP(1 << 8)
				//	<< (`EXTRACT_DATA_INDEX_TYPE_2__8
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 8)),
				//	(`EXTRACT_DATA_INDEX_TYPE_2__8(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 8));
				case (`EXTRACT_DATA_INDEX_TYPE_2__8(__MSB_POS__DATA_OFFSET,
					__in_data_offset))
				0: out.data = __in_to_shift[7:0];
				1: out.data = __in_to_shift[15:8];
				2: out.data = __in_to_shift[23:16];
				3: out.data = __in_to_shift[31:24];
				4: out.data = __in_to_shift[39:32];
				5: out.data = __in_to_shift[47:40];
				6: out.data = __in_to_shift[55:48];
				7: out.data = __in_to_shift[63:56];
				8: out.data = __in_to_shift[71:64];
				9: out.data = __in_to_shift[79:72];
				10: out.data = __in_to_shift[87:80];
				11: out.data = __in_to_shift[95:88];
				12: out.data = __in_to_shift[103:96];
				13: out.data = __in_to_shift[111:104];
				14: out.data = __in_to_shift[119:112];
				15: out.data = __in_to_shift[127:120];
				16: out.data = __in_to_shift[135:128];
				17: out.data = __in_to_shift[143:136];
				18: out.data = __in_to_shift[151:144];
				19: out.data = __in_to_shift[159:152];
				20: out.data = __in_to_shift[167:160];
				21: out.data = __in_to_shift[175:168];
				22: out.data = __in_to_shift[183:176];
				23: out.data = __in_to_shift[191:184];
				24: out.data = __in_to_shift[199:192];
				25: out.data = __in_to_shift[207:200];
				26: out.data = __in_to_shift[215:208];
				27: out.data = __in_to_shift[223:216];
				28: out.data = __in_to_shift[231:224];
				29: out.data = __in_to_shift[239:232];
				30: out.data = __in_to_shift[247:240];
				31: out.data = __in_to_shift[255:248];
				endcase
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				//out.data = `GET_BITS(__in_to_shift, 
				//	(`WIDTH2MP(1 << 16)
				//	<< (`EXTRACT_DATA_INDEX_TYPE_2__16
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 16)),
				//	(`EXTRACT_DATA_INDEX_TYPE_2__16(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 16));
				case (`EXTRACT_DATA_INDEX_TYPE_2__16
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				0: out.data = __in_to_shift[15:0];
				1: out.data = __in_to_shift[31:16];
				2: out.data = __in_to_shift[47:32];
				3: out.data = __in_to_shift[63:48];
				4: out.data = __in_to_shift[79:64];
				5: out.data = __in_to_shift[95:80];
				6: out.data = __in_to_shift[111:96];
				7: out.data = __in_to_shift[127:112];
				8: out.data = __in_to_shift[143:128];
				9: out.data = __in_to_shift[159:144];
				10: out.data = __in_to_shift[175:160];
				11: out.data = __in_to_shift[191:176];
				12: out.data = __in_to_shift[207:192];
				13: out.data = __in_to_shift[223:208];
				14: out.data = __in_to_shift[239:224];
				15: out.data = __in_to_shift[255:240];
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				//out.data = `GET_BITS(__in_to_shift, 
				//	(`WIDTH2MP(1 << 32)
				//	<< (`EXTRACT_DATA_INDEX_TYPE_2__32
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 32)),
				//	(`EXTRACT_DATA_INDEX_TYPE_2__32
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 32));
				case (`EXTRACT_DATA_INDEX_TYPE_2__32
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				0: out.data = __in_to_shift[31:0];
				1: out.data = __in_to_shift[63:32];
				2: out.data = __in_to_shift[95:64];
				3: out.data = __in_to_shift[127:96];
				4: out.data = __in_to_shift[159:128];
				5: out.data = __in_to_shift[191:160];
				6: out.data = __in_to_shift[223:192];
				7: out.data = __in_to_shift[255:224];
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				//out.data = `GET_BITS(__in_to_shift, 
				//	(`WIDTH2MP(1 << 64)
				//	<< (`EXTRACT_DATA_INDEX_TYPE_2__64
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 64)),
				//	(`EXTRACT_DATA_INDEX_TYPE_2__64
				//	(__MSB_POS__DATA_OFFSET,
				//	__in_data_offset) * 64));

				case (`EXTRACT_DATA_INDEX_TYPE_2__64
					(__MSB_POS__DATA_OFFSET, __in_data_offset))
				0: out.data = __in_to_shift[63:0];
				1: out.data = __in_to_shift[127:64];
				2: out.data = __in_to_shift[191:128];
				3: out.data = __in_to_shift[255:192];
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


	always @(*)
	begin
		case(__in_data_type)
		PkgSnow64Cpu::DataTypBFloat16:
		begin
			//out.data = `GET_SET_BITS(`GET_CLEARED_BITS(__in_to_modify,
			//	`WIDTH2MP(1 << 16)
			//	<< (`EXTRACT_DATA_INDEX_TYPE_2__16
			//	(__MSB_POS__DATA_OFFSET,
			//	__in_data_offset) * 16)),
			//	(__in_to_shift[`WIDTH2MP(16):0]
			//	<< (`EXTRACT_DATA_INDEX_TYPE_2__16
			//	(__MSB_POS__DATA_OFFSET,
			//	__in_data_offset) * 16)));
			out.data = `GET_SET_BITS(`GET_CLEARED_BITS(__in_to_modify,
				(`WIDTH2MP(1 << 16)
				<< (`EXTRACT_DATA_INDEX_TYPE_2__16(__MSB_POS__DATA_OFFSET,
				__in_data_offset) * 16))),
				(__in_to_shift[15:0] << (`EXTRACT_DATA_INDEX_TYPE_2__16
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
				out.data = 0;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				out.data = 0;
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				out.data = 0;
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				out.data = 0;
			end
			endcase
		end
		endcase
	end

endmodule

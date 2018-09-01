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
	wire [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
		__in_data_offset = in.data_offset;


	always @(*)
	begin
		case(__in_data_type)
		PkgSnow64Cpu::DataTypBFloat16:
		begin
			//out.data = `GET_BITS(__in_to_shift, 
			//	(`WIDTH2MP(1 << 16)
			//	<< (`EXTRACT_DATA_INDEX__16(__MSB_POS__DATA_OFFSET,
			//	__in_data_offset) * 16)),
			//	(`EXTRACT_DATA_INDEX__16(__MSB_POS__DATA_OFFSET,
			//	__in_data_offset) * 16));
			out.data = `GET_BITS(__in_to_shift, 
				(`WIDTH2MP(1 << 16)
				<< (`EXTRACT_DATA_INDEX_TYPE_2__16(__MSB_POS__DATA_OFFSET,
				__in_data_offset) * 16)),
				(`EXTRACT_DATA_INDEX_TYPE_2__16(__MSB_POS__DATA_OFFSET,
				__in_data_offset) * 16));
			//out.data = ((__in_to_shift & (16'hffff
			//	<< (__in_data_offset[4:1] * 16)))
			//	>> (__in_data_offset[4:1] * 16));
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
				out.data = `GET_BITS(__in_to_shift, 
					(`WIDTH2MP(1 << 8)
					<< (`EXTRACT_DATA_INDEX_TYPE_2__8(
					__MSB_POS__DATA_OFFSET,
					__in_data_offset) * 8)),
					(`EXTRACT_DATA_INDEX_TYPE_2__8(__MSB_POS__DATA_OFFSET,
					__in_data_offset) * 8));
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				out.data = `GET_BITS(__in_to_shift, 
					(`WIDTH2MP(1 << 16)
					<< (`EXTRACT_DATA_INDEX_TYPE_2__16(
					__MSB_POS__DATA_OFFSET,
					__in_data_offset) * 16)),
					(`EXTRACT_DATA_INDEX_TYPE_2__16(__MSB_POS__DATA_OFFSET,
					__in_data_offset) * 16));
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				out.data = `GET_BITS(__in_to_shift, 
					(`WIDTH2MP(1 << 32)
					<< (`EXTRACT_DATA_INDEX_TYPE_2__32(
					__MSB_POS__DATA_OFFSET,
					__in_data_offset) * 32)),
					(`EXTRACT_DATA_INDEX_TYPE_2__32(
					__MSB_POS__DATA_OFFSET,
					__in_data_offset) * 32));
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				out.data = `GET_BITS(__in_to_shift, 
					(`WIDTH2MP(1 << 64)
					<< (`EXTRACT_DATA_INDEX_TYPE_2__64(
					__MSB_POS__DATA_OFFSET,
					__in_data_offset) * 64)),
					(`EXTRACT_DATA_INDEX_TYPE_2__64(
					__MSB_POS__DATA_OFFSET,
					__in_data_offset) * 64));
			end
			endcase
		end
		endcase
	end


endmodule

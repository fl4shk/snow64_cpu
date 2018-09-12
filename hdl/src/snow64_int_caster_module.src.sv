`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_bfloat16_defines.header.sv"


// An individual IntCaster
module __Snow64SubIntCaster
	(input PkgSnow64IntCaster::PortIn_SubIntCaster in,
	output PkgSnow64IntCaster::PortOut_SubIntCaster out);

	wire [`MSB_POS__SNOW64_SCALAR_DATA:0] __in_to_cast = in.to_cast;
	wire __in_src_signedness = in.src_signedness;

	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__in_src_int_type_size = in.src_int_type_size,
		__in_dst_int_type_size = in.dst_int_type_size;

	`ifdef FORMAL
	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;

	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] __formal__out_data
		= out.data;
	`endif		// FORMAL

	always @(*)
	begin
		case (__in_src_int_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			case (__in_dst_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				out.data = __in_to_cast[`WIDTH2MP(8):0];
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				case (__in_src_signedness)
				0:
				begin
					out.data = __in_to_cast[`WIDTH2MP(8):0];
				end

				1:
				begin
					out.data = `SIGN_EXTEND_TYPE_2(16, 8,
						__in_to_cast[`WIDTH2MP(8)],
						__in_to_cast[`WIDTH2MP(8):0]);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (__in_src_signedness)
				0:
				begin
					out.data = __in_to_cast[`WIDTH2MP(8):0];
				end

				1:
				begin
					out.data = `SIGN_EXTEND_TYPE_2(32, 8,
						__in_to_cast[`WIDTH2MP(8)],
						__in_to_cast[`WIDTH2MP(8):0]);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_signedness)
				0:
				begin
					out.data = __in_to_cast[`WIDTH2MP(8):0];
				end

				1:
				begin
					out.data = `SIGN_EXTEND_TYPE_2(64, 8,
						__in_to_cast[`WIDTH2MP(8)],
						__in_to_cast[`WIDTH2MP(8):0]);
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
				out.data = __in_to_cast[`WIDTH2MP(8):0];
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				out.data = __in_to_cast[`WIDTH2MP(16):0];
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (__in_src_signedness)
				0:
				begin
					out.data = __in_to_cast[`WIDTH2MP(16):0];
				end

				1:
				begin
					out.data = `SIGN_EXTEND_TYPE_2(32, 16,
						__in_to_cast[`WIDTH2MP(16)],
						__in_to_cast[`WIDTH2MP(16):0]);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_signedness)
				0:
				begin
					out.data = __in_to_cast[`WIDTH2MP(16):0];
				end

				1:
				begin
					out.data = `SIGN_EXTEND_TYPE_2(64, 16,
						__in_to_cast[`WIDTH2MP(16)],
						__in_to_cast[`WIDTH2MP(16):0]);
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
				out.data = __in_to_cast[`WIDTH2MP(8):0];
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				out.data = __in_to_cast[`WIDTH2MP(16):0];
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				out.data = __in_to_cast[`WIDTH2MP(32):0];
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_signedness)
				0:
				begin
					out.data = __in_to_cast[`WIDTH2MP(32):0];
				end

				1:
				begin
					out.data = `SIGN_EXTEND_TYPE_2(64, 32,
						__in_to_cast[`WIDTH2MP(32)],
						__in_to_cast[`WIDTH2MP(32):0]);
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
				out.data = __in_to_cast[`WIDTH2MP(8):0];
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				out.data = __in_to_cast[`WIDTH2MP(16):0];
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				out.data = __in_to_cast[`WIDTH2MP(32):0];
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				out.data = __in_to_cast;
			end
			endcase
		end
		endcase
	end

endmodule



// Integer casting module.
// 
// Used by the EX stage of the CPU pipeline to cast from one integer type
// to another.
// 
// Note that casting to/from BFloat16s is NOT done with this module.
module Snow64IntCaster(input logic clk,
	input PkgSnow64IntCaster::PortIn_IntCaster in,
	output PkgSnow64IntCaster::PortOut_IntCaster out);


	wire __in_int_cast_type = in.int_cast_type;
	wire [`MSB_POS__SNOW64_SCALAR_DATA:0] __in_scalar_data
		= in.scalar_data;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_vector_data
		= in.vector_data;
	wire __in_src_signedness = in.src_signedness;

	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__in_src_int_type_size = in.src_int_type_size,
		__in_dst_int_type_size = in.dst_int_type_size;


	`ifdef FORMAL
	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;

	wire [`MSB_POS__SNOW64_SCALAR_DATA:0]
		__formal__out_scalar_data = out.scalar_data;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_vector_data = out.vector_data;
	`endif		// FORMAL


endmodule

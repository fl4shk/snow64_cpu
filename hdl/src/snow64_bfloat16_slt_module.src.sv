`include "src/snow64_bfloat16_defines.header.sv"


// The "slt" instruction should *definitely* actually always be
// single-cycle.
// To keep from changing the test bench, this module TEMPORARILY has an
// interface that the test bench knows about.  That will change later!
module Snow64BFloat16Slt(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_BinOp out);

	localparam __WIDTH__DATA_NO_SIGN = `WIDTH__SNOW64_BFLOAT16_ITSELF - 1;
	localparam __MSB_POS__DATA_NO_SIGN = `WIDTH2MP(__WIDTH__DATA_NO_SIGN);

	PkgSnow64BFloat16::BFloat16 __in_a, __in_b;
	assign __in_a = in.a;
	assign __in_b = in.b;


	logic [__MSB_POS__DATA_NO_SIGN:0] __in_a_no_sign, __in_b_no_sign;
	assign __in_a_no_sign = {__in_a.enc_exp, __in_a.enc_mantissa};
	assign __in_b_no_sign = {__in_b.enc_exp, __in_b.enc_mantissa};


	logic [`MSB_POS__SNOW64_BFLOAT16_FRAC:0] __in_a_frac, __in_b_frac;
	assign __in_a_frac = `SNOW64_BFLOAT16_FRAC(__in_a);
	assign __in_b_frac = `SNOW64_BFLOAT16_FRAC(__in_b);

	initial
	begin
		out.valid = 0;
		out.can_accept_cmd = 1;
		out.data = 0;
	end

	//// Combinational logic
	//always @(*)
	always_ff @(posedge clk)
	begin
		if (in.start)
		begin
			case ({__in_a.sign, __in_b.sign})
			2'b00:
			begin
				// Equal signs, both non-negative
				out.data <= (__in_a_no_sign < __in_b_no_sign);
			end

			2'b01:
			begin
				out.data <= 0;
			end

			2'b10:
			begin
				// The only time opposite signs allows "<" to return false
				// is when ((__in_a == 0.0f) && (__in_b == -0.0f))
				out.data <= (!((__in_a_frac == 0) && (__in_b_frac == 0)));
			end

			2'b11:
			begin
				// Equal signs, both non-positive
				out.data <= (__in_b_no_sign < __in_a_no_sign);
			end
			endcase

			out.valid <= 1;
		end
	end

endmodule

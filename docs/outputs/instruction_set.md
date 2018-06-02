# Snow64 Instruction Set
* Notes
	* There are no Instruction LARs (the typical instruction fetch of most
	computer processors is used instead).
	* Addresses are 64-bit.
	* Interrupts are supported (this may be a first for a LARs
	architecture)
<br><br>
* Data LARs:
<br><br>
	typedef struct packed
	<br>
	{

		// Data field
		union packed
		{
			// This is possibly not valid SystemVerilog because of arrays
			// inside a packed struct, but it makes for nice pseudocode
			logic [7:0] data_8[0:31];

			logic [15:0] data_16[0:15];

			struct packed
			{
				// sign bit, 1 means negative
				logic sign;

				// Exponent, +bias
				logic [7:0] exp;

				// Mantissa; normalized implies 1 MSB
				logic [6:0] mant;
			} data_float_16[0:15];

			logic [31:0] data_32[0:7];
			logic [63:0] data_64[0:3];
		} data;

		// Note that this is a 64-bit structure
		union packed
		{
			struct packed
			{
				logic [31 - 5 : 0] base_ptr;

				logic [4:0] offset;
			} addr_8;

			// Used for both 16-bit integers and the half floats
			struct packed
			{
				logic [31 - 4 : 0] base_ptr;

				logic [3:0] offset;
			} addr_16;

			struct packed
			{
				logic [31 - 3 : 0] base_ptr;

				logic [2:0] offset;
			} addr_32;

			struct packed
			{
				logic [31 - 2 : 0] base_ptr;

				logic [1:0] offset;
			} addr_64;
		} addr;

		// Integer Type (used when "is_float_16" is 1'b0):
		// 2'b00:  8-bit
		// 2'b01:  16-bit
		// 2'b10:  32-bit
		// 2'b11:  64-bit
		logic [1:0] type_of_int;

		// These are actually packed 16-bit floats, the implementing the
		// high 16 bits of 32-bit IEEE float.
		// "type_of_int" is ignored when "is_float_16" is 1'b1.
		logic is_float_16;

		// Unsigned:  1'b0
		// Signed:  1'b1
		// Note:  unsgn_or_sgn is ignored for floats
		logic unsgn_or_sgn;

		// Data should be lazily stored to memory if this is 1'b1
		// Otherwise, when this is 1'b0, data in this LAR is up to date
		// with memory.
		logic dirty;

	} DataLar;
<br><br>
* Registers
	* The DLARs themselves (there are 16, but this may be changed later):
		* `d0` (always zero), `d1`, `d2`, `d3`,
		`d4`, ..., `d15`
	* Other registers:
		* `pc` (the program counter, 64-bit)
		* `ie` (whether or not interrupts are enabled, 1-bit)
		* `ireta` (the interrupt return address, 64-bit)
		* `idsta` (the interrupt destination address, 64-bit;
		upon an interrupt, the program counter is set to the value in this
		register)
<br><br>
## Instruction Set
* Note:  All invalid instructions are treated as NOPs.
* ALU Instructions:  Opcode Group:  0b000
	* Encoding:  `000t aaaa bbbb cccc  oooo iiii iiii iiii`
		* `a`:  dDest
		* `b`:  dSrc0
		* `c`:  dSrc1
		* `o`:  opcode
		* `t`:  operation type:  
		* `i`:  12-bit signed immediate
		if 0b0:  scalar operation; 
		else: vector operation
	* Note:  For ALU instructions, any result that doesn't fit in the
	destination will be truncated to fit into the destination.  This
	affects both scalar and vector operations.
	* Note:  also, for each of these instructions, the address field is not
	used as an operand, just the data field.
	* Instructions:
		* <b>add</b> dDest, dSrc0, dSrc1
			* Opcode:  0x0
			* Scalar Mnemonic:  s.<code>add</code>
			* Vector Mnemonic:  v.<code>add</code>
		* <b>sub</b> dDest, dSrc0, dSrc1
			* Opcode:  0x1
			* Scalar Mnemonic:  s.<code>sub</code>
			* Vector Mnemonic:  v.<code>sub</code>
		* <b>slt</b> dDest, dSrc0, dSrc1
			* Opcode:  0x2
			* Scalar Mnemonic:  s.<code>slt</code>
			* Vector Mnemonic:  v.<code>slt</code>
			* Note:  set less than
			* Note:  The signedness of dDest will be used for the operation
		* <b>mul</b> dDest, dSrc0, dSrc1
			* Opcode:  0x3
			* Scalar Mnemonic:  s.<code>mul</code>
			* Vector Mnemonic:  v.<code>mul</code>
			* Note:  If dDest has a larger size than both dSrc0 and dSrc1,
			then the signedness used for the operation will be that of dDest
			* Note:  This operation
is not guaranteed to be single cycle, and thus pipeline stalls will be used
		* <b>div</b> dDest, dSrc0, dSrc1
			* Opcode:  0x4
			* Scalar Mnemonic:  s.<code>div</code>
			* Vector Mnemonic:  v.<code>div</code>
			* Note:  This operation
is not guaranteed to be single cycle, and thus pipeline stalls will be used
		* <b>and</b> dDest, dSrc0, dSrc1
			* Opcode:  0x5
			* Scalar Mnemonic:  s.<code>and</code>
			* Vector Mnemonic:  v.<code>and</code>
			* Note:  For floats, this operation treats all operands as
			16-bit signed integers.
		* <b>orr</b> dDest, dSrc0, dSrc1
			* Opcode:  0x6
			* Scalar Mnemonic:  s.<code>orr</code>
			* Vector Mnemonic:  v.<code>orr</code>
			* Note:  For floats, this operation treats all operands as
			16-bit signed integers.
		* <b>xor</b> dDest, dSrc0, dSrc1
			* Opcode:  0x7
			* Scalar Mnemonic:  s.<code>xor</code>
			* Vector Mnemonic:  v.<code>xor</code>
			* Note:  For floats, this operation treats all operands as
			16-bit signed integers.
		* <b>shl</b> dDest, dSrc0, dSrc1
			* Opcode:  0x8
			* Scalar Mnemonic:  s.<code>shl</code>
			* Vector Mnemonic:  v.<code>shl</code>
			* Note:  Shift left
			* Note:  For floats, this operation treats all operands as
			16-bit signed integers.
		* <b>shr</b> dDest, dSrc0, dSrc1
			* Opcode:  0x9
			* Scalar Mnemonic:  s.<code>shr</code>
			* Vector Mnemonic:  v.<code>shr</code>
			* Note:  Shift right
			* Note:  dSrc0's signedness is used to determine the type of
			right shift:  
				* If dSrc0 is unsigned, a logic right shift is performed
				* If dSrc0 is signed, an arithmetic right shift is
				performed
			* Note:  dSrc1 is always treated as unsigned (due to being a
			number of bits to shift by)
			* Note:  For floats, this operation treats all operands as
			16-bit signed integers.
		* <b>inv</b> dDest, dSrc0
			* Opcode:  0xa
			* Scalar Mnemonic:  s.<code>inv</code>
			* Vector Mnemonic:  v.<code>inv</code>
			* Note:  Bitwise invert
			* Note:  For floats, this operation treats all operands as
			16-bit signed integers.
		* <b>not</b> dDest, dSrc0
			* Opcode:  0xb
			* Scalar Mnemonic:  s.<code>not</code>
			* Vector Mnemonic:  v.<code>not</code>
			* Note:  Logical not
		* <b>add</b> dDest, pc, simm12
			* Opcode:  0xc
			* Scalar Mnemonic:  s.<code>add</code>
			* Vector Mnemonic:  v.<code>add</code>
			* Note:  This is useful for pc-relative loads, relative
			branches, and for getting the return address of a subroutine
			call into a LAR before jumping to a subroutine.
<br><br>
* Instructions for interacting with special-purpose registers:  
Opcode Group:  0b001
	* Encoding:  `0010 aaaa bbbb cccc  oooo iiii iiii iiii`
		* `a`:  dA
		* `b`:  dB
		* `c`:  dC
		* `o`:  opcode
		* `i`:  12-bit signed immediate
	* Note:  all instructions in group 0b001 are scalar operations.
	* Note:  `dX.sdata` is simply the current scalar portion of the
	data LAR called `dX`
	* Instructions:
		* <b>bne</b> dA, dB, simm12
			* Opcode:  0x0
			* Effect:  <code>if (dA.sdata != dB.sdata) 
				pc <= pc + sign_extend_to_64(simm12);</code>
			* Note:  It is suggested to have .sdata be at least as 
			large as the largest memory address (which might not be 64-bit
			if there isnt enough physical memory for that')
		* <b>beq</b> dA, dB, simm12
			* Opcode:  0x1
			* Effect:  <code>if (dA.sdata == dB.sdata) 
				pc <= pc + sign_extend_to_64(simm12);</code>
			* Note:  It is suggested to have .sdata be at least as 
			large as the largest memory address (which might not be 64-bit
			if there isnt enough physical memory for that')
		* <b>jne</b> dA, dB, dC
			* Opcode:  0x2
			* Effect:  <code>if (dA.sdata != dB.sdata) pc <= dC.sdata;</code>
			* Note:  It is suggested to have dC.sdata be at least as 
			large as the largest memory address (which might not be 64-bit
			if there isnt enough physical memory for that')
		* <b>jeq</b> dA, dB, dC
			* Opcode:  0x3
			* Effect:  <code>if (dA.sdata == dB.sdata) pc <= dC.sdata;</code>
			* Note:  It is suggested to have dC.sdata be at least as 
			large as the largest memory address (which might not be 64-bit
			if there isnt enough physical memory for that')
		* <b>cpy</b> dA, ie
			* Opcode:  0x4
			* Effect:  <code>dA.sdata <= ie; // acts differently if dA is
			tagged as a float</code>
		* <b>cpy</b> ie, dA
			* Opcode:  0x5
			* Effect:  <code>ie <= (dA.sdata != 0);</code>
		* <b>ei</b>
			* Opcode:  0x6
			* Effect:  <code>ie <= 1'b1;</code>
			* Note:  Enable interrupts
		* <b>di</b>
			* Opcode:  0x7
			* Effect:  <code>ie <= 1'b0;</code>
			* Note:  Disable interrupts
		* <b>cpy</b> dA, ireta
			* Opcode:  0x8
			* Effect:  <code>dA.sdata <= ireta;</code>
			* Note:  It is suggested to have dA.sdata be at least as 
			large as the largest memory address (which might not be 64-bit
			if there isnt enough physical memory for that')
		* <b>cpy</b> ireta, dA
			* Opcode:  0x9
			* Effect:  <code>ireta <= dA.sdata;</code>
			* Note:  It is suggested to have dA.sdata be at least as 
			large as the largest memory address (which might not be 64-bit
			if there isnt enough physical memory for that')
		* <b>cpy</b> dA, idsta
			* Opcode:  0xa
			* Effect:  <code>dA.sdata <= idsta;</code>
			* Note:  It is suggested to have dA.sdata be at least as 
			large as the largest memory address (which might not be 64-bit
			if there isnt enough physical memory for that')
		* <b>cpy</b> idsta, dA
			* Opcode:  0xc
			* Effect:  <code>idsta <= dA.sdata;</code>
			* Note:  It is suggested to have dA.sdata be at least as 
			large as the largest memory address (which might not be 64-bit
			if there isnt enough physical memory for that')
		* <b>reti</b>
			* Opcode:  0xd
			* Effect:  <code>ie <= 1'b1; pc <= ireta;</code>
			* Note:  Return from an interrupt
<br><br>
* Load Instructions:
Opcode Group:  0b010
	* Encoding:  `0100 aaaa bbbb cccc  oooo iiii iiii iiii`
		* `a`:  dDest
		* `b`:  dSrc0
		* `c`:  dSrc1
		* `o`:  opcode
		* `i`:  12-bit signed immediate
	* Instructions:
		* <b>ldu8</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x0
			* Note:  unsigned 8-bit integer(s)
		* <b>lds8</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x1
			* Note:  signed 8-bit integer(s)
		* <b>ldu16</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x2
			* Note:  unsigned 16-bit integer(s)
		* <b>lds16</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x3
			* Note:  signed 16-bit integer(s)
		* <b>ldu32</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x4
			* Note:  unsigned 32-bit integer(s)
		* <b>lds32</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x5
			* Note:  signed 32-bit integer(s)
		* <b>ldu64</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x6
			* Note:  unsigned 64-bit integer(s)
		* <b>lds64</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x7
			* Note:  signed 64-bit integer(s)
		* <b>ldf16</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x8
			* Note:  16-bit floating point number(s), the top 16 bits of a
			standard 32-bit IEEE float.
<br><br>
* Store Instructions:
Opcode Group:  0b011
	* Encoding:  `0110 aaaa bbbb cccc  oooo iiii iiii iiii`
		* `a`:  dDest
		* `b`:  dSrc0
		* `c`:  dSrc1
		* `o`:  opcode
		* `i`:  12-bit signed immediate
	* Instructions:
		* <b>stu8</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x0
			* Note:  unsigned 8-bit integer(s)
		* <b>sts8</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x1
			* Note:  signed 8-bit integer(s)
		* <b>stu16</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x2
			* Note:  unsigned 16-bit integer(s)
		* <b>sts16</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x3
			* Note:  signed 16-bit integer(s)
		* <b>stu32</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x4
			* Note:  unsigned 32-bit integer(s)
		* <b>sts32</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x5
			* Note:  signed 32-bit integer(s)
		* <b>stu64</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x6
			* Note:  unsigned 64-bit integer(s)
		* <b>sts64</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x7
			* Note:  signed 64-bit integer(s)
		* <b>stf16</b> dDest, dSrc0, dSrc1, simm12
			* Opcode:  0x8
			* Note:  16-bit floating point number(s), the top 16 bits of a
			standard 32-bit IEEE float.

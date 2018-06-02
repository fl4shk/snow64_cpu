include(src/include/misc_defines.m4)dnl
define(`CODE',CONCAT3(`<code>',$1,`</code>'))dnl
define(`BOLD',CONCAT3(`<b>',$1,`</b>'))dnl
define(`ITALIC',CONCAT3(`<i>',$1,`</i>'))dnl
define(`UNDERLINE',CONCAT3(`<u>',$1,`</u>'))dnl
define(`OPCODE_GROUP',CONCAT(`Opcode Group:  ',$1))dnl
dnl define(`OP_IMMFIELD',CONCAT(`Opcode (Immediate Field):  ',$1))dnl
dnl define(`OP_RC',CONCAT(`Opcode (rC Field):  ',$1))dnl
define(`OPCODE',CONCAT(`Opcode:  ',$1))dnl
define(`NEWLINE',`<br>')dnl
define(`SCALAR_MNEMONIC',CONCAT(`Scalar Mnemonic:  s.',CODE($1)))dnl
define(`VECTOR_MNEMONIC',CONCAT(`Vector Mnemonic:  v.',CODE($1)))dnl
define(`BOTH_MNEMONICS',SCALAR_MNEMONIC(`$1')
			* VECTOR_MNEMONIC(`$1'))dnl
define(`NOTE_SIGNEDNESS_IF_DDEST_LARGER',`Note:  If dDest has a larger size than both dSrc0 and dSrc1,
			then the signedness used for the operation will be that of dDest')dnl
define(`NOTE_SIGNEDNESS_USED',`Note:  The signedness of dDest will be used for the operation')dnl
define(`NOTE_FLOATS_TREATED_AS_16_BIT_INT',`Note:  For floats, this operation treats all operands as
			16-bit signed integers.')dnl
define(`NOTE_OPERATION_MAY_TAKE_MORE_THAN_ONE_CYCLE',`Note:  This operation
is not guaranteed to be single cycle, and thus pipeline stalls will be used')dnl
define(`NOTE_SUGGEST_LARGEST_MEMORY_ADDR',CONCAT3(`Note:  It is suggested to have ',$1,`.sdata be at least as 
			large as the largest memory address (which might not be 64-bit
			if there isn't enough physical memory for that)'))dnl
# Snow64 Instruction Set
* Notes
	* There are no Instruction LARs (the typical instruction fetch of most
	computer processors is used instead).
	* Addresses are 64-bit.
	* Interrupts are supported (this may be a first for a LARs
	architecture)
NEWLINE()NEWLINE()
* Data LARs:
NEWLINE()NEWLINE()
	typedef struct packed
	NEWLINE()
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
NEWLINE()NEWLINE()
* Registers
	* The DLARs themselves (there are 16, but this may be changed later):
		* MDCODE(d0) (always zero), MDCODE(d1), MDCODE(d2), MDCODE(d3),
		MDCODE(d4), ..., MDCODE(d15)
	* Other registers:
		* MDCODE(pc) (the program counter, 64-bit)
		* MDCODE(ie) (whether or not interrupts are enabled, 1-bit)
		* MDCODE(ireta) (the interrupt return address, 64-bit)
		* MDCODE(idsta) (the interrupt destination address, 64-bit;
		upon an interrupt, the program counter is set to the value in this
		register)
NEWLINE()NEWLINE()
## Instruction Set
* Note:  All invalid instructions are treated as NOPs.
* ALU Instructions:  OPCODE_GROUP(0b000)
	* Encoding:  MDCODE(000t aaaa bbbb cccc  oooo iiii iiii iiii)
		* MDCODE(a):  dDest
		* MDCODE(b):  dSrc0
		* MDCODE(c):  dSrc1
		* MDCODE(o):  opcode
		* MDCODE(t):  operation type:  
		* MDCODE(i):  12-bit signed immediate
		if 0b0:  scalar operation; 
		else: vector operation
	* Note:  For ALU instructions, any result that doesn't fit in the
	destination will be truncated to fit into the destination.  This
	affects both scalar and vector operations.
	* Note:  also, for each of these instructions, the address field is not
	used as an operand, just the data field.
	* Instructions:
		* BOLD(add) dDest, dSrc0, dSrc1
			* OPCODE(0x0)
			* BOTH_MNEMONICS(add)
		* BOLD(sub) dDest, dSrc0, dSrc1
			* OPCODE(0x1)
			* BOTH_MNEMONICS(sub)
		* BOLD(slt) dDest, dSrc0, dSrc1
			* OPCODE(0x2)
			* BOTH_MNEMONICS(slt)
			* Note:  set less than
			* NOTE_SIGNEDNESS_USED()
		* BOLD(mul) dDest, dSrc0, dSrc1
			* OPCODE(0x3)
			* BOTH_MNEMONICS(mul)
			* NOTE_SIGNEDNESS_IF_DDEST_LARGER()
			* NOTE_OPERATION_MAY_TAKE_MORE_THAN_ONE_CYCLE()
		* BOLD(div) dDest, dSrc0, dSrc1
			* OPCODE(0x4)
			* BOTH_MNEMONICS(div)
			* NOTE_OPERATION_MAY_TAKE_MORE_THAN_ONE_CYCLE()
		* BOLD(and) dDest, dSrc0, dSrc1
			* OPCODE(0x5)
			* BOTH_MNEMONICS(and)
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* BOLD(orr) dDest, dSrc0, dSrc1
			* OPCODE(0x6)
			* BOTH_MNEMONICS(orr)
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* BOLD(xor) dDest, dSrc0, dSrc1
			* OPCODE(0x7)
			* BOTH_MNEMONICS(xor)
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* BOLD(shl) dDest, dSrc0, dSrc1
			* OPCODE(0x8)
			* BOTH_MNEMONICS(shl)
			* Note:  Shift left
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* BOLD(shr) dDest, dSrc0, dSrc1
			* OPCODE(0x9)
			* BOTH_MNEMONICS(shr)
			* Note:  Shift right
			* Note:  dSrc0's signedness is used to determine the type of
			right shift:  
				* If dSrc0 is unsigned, a logic right shift is performed
				* If dSrc0 is signed, an arithmetic right shift is
				performed
			* Note:  dSrc1 is always treated as unsigned (due to being a
			number of bits to shift by)
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* BOLD(inv) dDest, dSrc0
			* OPCODE(0xa)
			* BOTH_MNEMONICS(inv)
			* Note:  Bitwise invert
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* BOLD(not) dDest, dSrc0
			* OPCODE(0xb)
			* BOTH_MNEMONICS(not)
			* Note:  Logical not
		* BOLD(add) dDest, pc, simm12
			* OPCODE(0xc)
			* BOTH_MNEMONICS(add)
			* Note:  This is useful for pc-relative loads, relative
			branches, and for getting the return address of a subroutine
			call into a LAR before jumping to a subroutine.
NEWLINE()NEWLINE()
* Instructions for interacting with special-purpose registers:  
OPCODE_GROUP(0b001)
	* Encoding:  MDCODE(0010 aaaa bbbb cccc  oooo iiii iiii iiii)
		* MDCODE(a):  dA
		* MDCODE(b):  dB
		* MDCODE(c):  dC
		* MDCODE(o):  opcode
		* MDCODE(i):  12-bit signed immediate
	* Note:  all instructions in group 0b001 are scalar operations.
	* Note:  MDCODE(dX.sdata) is simply the current scalar portion of the
	data LAR called MDCODE(dX)
	* Instructions:
		* BOLD(bne) dA, dB, simm12
			* OPCODE(0x0)
			* Effect:  CODE(if (dA.sdata != dB.sdata) 
				pc <= pc + sign_extend_to_64(simm12);)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR()
		* BOLD(beq) dA, dB, simm12
			* OPCODE(0x1)
			* Effect:  CODE(if (dA.sdata == dB.sdata) 
				pc <= pc + sign_extend_to_64(simm12);)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR()
		* BOLD(jne) dA, dB, dC
			* OPCODE(0x2)
			* Effect:  CODE(if (dA.sdata != dB.sdata) pc <= dC.sdata;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dC)
		* BOLD(jeq) dA, dB, dC
			* OPCODE(0x3)
			* Effect:  CODE(if (dA.sdata == dB.sdata) pc <= dC.sdata;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dC)
		* BOLD(cpy) dA, ie
			* OPCODE(0x4)
			* Effect:  CODE(dA.sdata <= ie; // acts differently if dA is
			tagged as a float)
		* BOLD(cpy) ie, dA
			* OPCODE(0x5)
			* Effect:  CODE(ie <= (dA.sdata != 0);)
		* BOLD(ei)
			* OPCODE(0x6)
			* Effect:  CODE(ie <= 1'b1;)
			* Note:  Enable interrupts
		* BOLD(di)
			* OPCODE(0x7)
			* Effect:  CODE(ie <= 1'b0;)
			* Note:  Disable interrupts
		* BOLD(cpy) dA, ireta
			* OPCODE(0x8)
			* Effect:  CODE(dA.sdata <= ireta;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		* BOLD(cpy) ireta, dA
			* OPCODE(0x9)
			* Effect:  CODE(ireta <= dA.sdata;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		* BOLD(cpy) dA, idsta
			* OPCODE(0xa)
			* Effect:  CODE(dA.sdata <= idsta;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		* BOLD(cpy) idsta, dA
			* OPCODE(0xc)
			* Effect:  CODE(idsta <= dA.sdata;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		* BOLD(reti)
			* OPCODE(0xd)
			* Effect:  CODE(ie <= 1'b1; pc <= ireta;)
			* Note:  Return from an interrupt
NEWLINE()NEWLINE()
* Load Instructions:
OPCODE_GROUP(0b010)
	* Encoding:  MDCODE(0100 aaaa bbbb cccc  oooo iiii iiii iiii)
		* MDCODE(a):  dDest
		* MDCODE(b):  dSrc0
		* MDCODE(c):  dSrc1
		* MDCODE(o):  opcode
		* MDCODE(i):  12-bit signed immediate
	* Instructions:
		* BOLD(ldu8) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x0)
			* Note:  unsigned 8-bit integer(s)
		* BOLD(lds8) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x1)
			* Note:  signed 8-bit integer(s)
		* BOLD(ldu16) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x2)
			* Note:  unsigned 16-bit integer(s)
		* BOLD(lds16) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x3)
			* Note:  signed 16-bit integer(s)
		* BOLD(ldu32) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x4)
			* Note:  unsigned 32-bit integer(s)
		* BOLD(lds32) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x5)
			* Note:  signed 32-bit integer(s)
		* BOLD(ldu64) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x6)
			* Note:  unsigned 64-bit integer(s)
		* BOLD(lds64) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x7)
			* Note:  signed 64-bit integer(s)
		* BOLD(ldf16) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x8)
			* Note:  16-bit floating point number(s), the top 16 bits of a
			standard 32-bit IEEE float.
NEWLINE()NEWLINE()
* Store Instructions:
OPCODE_GROUP(0b011)
	* Encoding:  MDCODE(0110 aaaa bbbb cccc  oooo iiii iiii iiii)
		* MDCODE(a):  dDest
		* MDCODE(b):  dSrc0
		* MDCODE(c):  dSrc1
		* MDCODE(o):  opcode
		* MDCODE(i):  12-bit signed immediate
	* Instructions:
		* BOLD(stu8) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x0)
			* Note:  unsigned 8-bit integer(s)
		* BOLD(sts8) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x1)
			* Note:  signed 8-bit integer(s)
		* BOLD(stu16) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x2)
			* Note:  unsigned 16-bit integer(s)
		* BOLD(sts16) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x3)
			* Note:  signed 16-bit integer(s)
		* BOLD(stu32) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x4)
			* Note:  unsigned 32-bit integer(s)
		* BOLD(sts32) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x5)
			* Note:  signed 32-bit integer(s)
		* BOLD(stu64) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x6)
			* Note:  unsigned 64-bit integer(s)
		* BOLD(sts64) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x7)
			* Note:  signed 64-bit integer(s)
		* BOLD(stf16) dDest, dSrc0, dSrc1, simm12
			* OPCODE(0x8)
			* Note:  16-bit floating point number(s), the top 16 bits of a
			standard 32-bit IEEE float.

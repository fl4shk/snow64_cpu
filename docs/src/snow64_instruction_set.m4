include(src/include/misc_defines.m4)dnl
define(`OPCODE_GROUP',_CONCAT(`Opcode Group:  ',$1))dnl
dnl define(`OP_IMMFIELD',_CONCAT(`Opcode (Immediate Field):  ',$1))dnl
dnl define(`OP_RC',_CONCAT(`Opcode (rC Field):  ',$1))dnl
define(`OPCODE',_CONCAT(`Opcode:  ',$1))dnl
define(`SCALAR_MNEMONIC',_CONCAT(`Scalar Mnemonic:  ',_CODE(_CONCAT($1,s))))dnl
define(`VECTOR_MNEMONIC',_CONCAT(`Vector Mnemonic:  ',_CODE(_CONCAT($1,v))))dnl
define(`BOTH_MNEMONICS',SCALAR_MNEMONIC(`$1')
			* VECTOR_MNEMONIC(`$1'))dnl
define(`NOTE_SIGNEDNESS_IF_DDEST_LARGER',`Note:  If dDest has a larger size
than both dSrc0 and dSrc1, then the signedness used for the operation will
be that of dDest')dnl
define(`NOTE_SIGNEDNESS_USED',`Note:  The signedness of dDest will be used
for the operation')dnl
define(`NOTE_FLOATS_TREATED_AS_16_BIT_INT',`Note:  For floats, this
operation treats all operands as 16-bit signed integers.')dnl
define(`NOTE_OPERATION_MAY_TAKE_MORE_THAN_ONE_CYCLE',`Note:  This operation
is not guaranteed to be single cycle, and thus pipeline stalls will be
used')dnl
define(`NOTE_SUGGEST_LARGEST_MEMORY_ADDR',_CONCAT3(`Note:  It is suggested
to have ',$1,`.sdata be at least as'
			large as the largest memory address (which might not be
			64-bit if there isn't enough physical memory for that)))dnl
define(`NOTE_SDATA',`Note:  _MDCODE(dX.sdata) is simply the current scalar portion of the
	data LAR called _MDCODE(dX)')dnl
define(`DESCRIBE_SV_OPERATION_TYPE',`operation type:  if _CODE(0b0):  scalar
operation; 
		else: vector operation')dnl
define(`NOTE_U8',`Note:  unsigned 8-bit integer(s)')dnl
define(`NOTE_S8',`Note:  signed 8-bit integer(s)')dnl
define(`NOTE_U16',`Note:  unsigned 16-bit integer(s)')dnl
define(`NOTE_S16',`Note:  signed 16-bit integer(s)')dnl
define(`NOTE_U32',`Note:  unsigned 32-bit integer(s)')dnl
define(`NOTE_S32',`Note:  signed 32-bit integer(s)')dnl
define(`NOTE_U64',`Note:  unsigned 64-bit integer(s)')dnl
define(`NOTE_S64',`Note:  signed 64-bit integer(s)')dnl
define(`NOTE_BFLOAT16',`Note:  BFloat16 format floating point number.')dnl
define(`CAST_TO_TYPE_OF',`cast\_to\_type\_of\_$1($2)')dnl

# Snow64 Instruction Set
* Notes
	* There are no Instruction LARs (the typical instruction fetch of most
	computer processors is used instead).
	* Addresses are 64-bit.
	* Interrupts are supported (this may be a first for a LARs
	architecture)
	* Port-mapped I/O is supported (this may be a first for a LARs
	architecture)
_NEWLINE()_NEWLINE()
* Data LARs:

		typedef struct packed
		{
			// Data field
			union packed
			{
				// This is possibly not valid SystemVerilog because of
				// arrays inside a packed struct, but it makes for nice
				// pseudocode
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
					logic [63 - 5 : 0] base_ptr;

					logic [4:0] offset;
				} addr_8;

				// Used for both 16-bit integers and the half floats
				struct packed
				{
					logic [63 - 4 : 0] base_ptr;

					logic [3:0] offset;
				} addr_16;

				struct packed
				{
					logic [63 - 3 : 0] base_ptr;

					logic [2:0] offset;
				} addr_32;

				struct packed
				{
					logic [63 - 2 : 0] base_ptr;

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
_NEWLINE()
* Registers
	* The DLARs themselves (there are 16, but this may be changed later):
		* _MDCODE(dzero) (always zero), 
		* _MDCODE(du0), _MDCODE(du1), _MDCODE(du2), _MDCODE(du3)
		_MDCODE(du4), _MDCODE(du5), _MDCODE(du6), _MDCODE(du7),
		_MDCODE(du8), _MDCODE(du9), _MDCODE(du10), _MDCODE(du11)
		(user registers)
		* _MDCODE(dlr) (standard link register (hardware does not enforce
		this))
		* _MDCODE(dfp) (standard frame pointer (hardware does not enforce
		this))
		* _MDCODE(dsp) (standard stack pointer (hardware does not enforce
		this))
	* Other registers:
		* _MDCODE(pc) (the program counter, 64-bit)
		* _MDCODE(ie) (whether or not interrupts are enabled, 1-bit)
		* _MDCODE(ireta) (the interrupt return address, 64-bit)
		* _MDCODE(idsta) (the interrupt destination address, 64-bit;
		upon an interrupt, the program counter is set to the value in this
		register)
_NEWLINE()_NEWLINE()
## Instruction Set
* Note:  All invalid instructions are treated as NOPs.
* ALU Instructions:  OPCODE_GROUP(0b000)
	* Encoding:  _MDCODE(000t aaaa bbbb cccc  oooo iiii iiii iiii)
		* _MDCODE(t):  DESCRIBE_SV_OPERATION_TYPE()
		* _MDCODE(a):  dDest
		* _MDCODE(b):  dSrc0
		* _MDCODE(c):  dSrc1
		* _MDCODE(o):  opcode
		* _MDCODE(i):  12-bit signed immediate
	* Note:  For ALU instructions, any result that doesn't fit in the
	destination will be truncated to fit into the destination.  This
	affects both scalar and vector operations.
	* Note:  also, for each of these instructions, the address field is not
	used as an operand, just the data field.
		* Example:  _CODE(`adds d1, d2, d3')
			* Effect:  _CODE(d1.sdata <= CAST_TO_TYPE_OF(d1,d2.sdata)
			\+ CAST_TO_TYPE_OF(d1,d3.sdata))
	* Instructions:
		* _BOLD(add) dDest, dSrc0, dSrc1
			* OPCODE(0x0)
			* BOTH_MNEMONICS(add)
		* _BOLD(sub) dDest, dSrc0, dSrc1
			* OPCODE(0x1)
			* BOTH_MNEMONICS(sub)
		* _BOLD(slt) dDest, dSrc0, dSrc1
			* OPCODE(0x2)
			* BOTH_MNEMONICS(slt)
			* Note:  set less than
			* NOTE_SIGNEDNESS_USED()
		* _BOLD(mul) dDest, dSrc0, dSrc1
			* OPCODE(0x3)
			* BOTH_MNEMONICS(mul)
			* NOTE_SIGNEDNESS_IF_DDEST_LARGER()
			* NOTE_OPERATION_MAY_TAKE_MORE_THAN_ONE_CYCLE()
		* _BOLD(div) dDest, dSrc0, dSrc1
			* OPCODE(0x4)
			* BOTH_MNEMONICS(div)
			* NOTE_OPERATION_MAY_TAKE_MORE_THAN_ONE_CYCLE()
		* _BOLD(and) dDest, dSrc0, dSrc1
			* OPCODE(0x5)
			* BOTH_MNEMONICS(and)
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* _BOLD(orr) dDest, dSrc0, dSrc1
			* OPCODE(0x6)
			* BOTH_MNEMONICS(orr)
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* _BOLD(xor) dDest, dSrc0, dSrc1
			* OPCODE(0x7)
			* BOTH_MNEMONICS(xor)
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* _BOLD(shl) dDest, dSrc0, dSrc1
			* OPCODE(0x8)
			* BOTH_MNEMONICS(shl)
			* Note:  Shift left
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* _BOLD(shr) dDest, dSrc0, dSrc1
			* OPCODE(0x9)
			* BOTH_MNEMONICS(shr)
			* Note:  Shift right
			* Note:  dSrc0's signedness is used to determine the type of
			right shift:  
				* If dSrc0 is unsigned, a logical right shift is performed
				* If dSrc0 is signed, an arithmetic right shift is
				performed
			* Note:  dSrc1 is always treated as unsigned (due to being a
			number of bits to shift by)
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* _BOLD(inv) dDest, dSrc0
			* OPCODE(0xa)
			* BOTH_MNEMONICS(inv)
			* Note:  Bitwise invert
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* _BOLD(not) dDest, dSrc0
			* OPCODE(0xb)
			* BOTH_MNEMONICS(not)
			* Note:  Logical not
		* _BOLD(add) dDest, pc, simm12
			* OPCODE(0xc)
			* BOTH_MNEMONICS(add)
			* Note:  This is useful for pc-relative loads, relative
			branches, and for getting the return address of a subroutine
			call into a LAR before jumping to a subroutine.
_NEWLINE()_NEWLINE()
* Instructions for interacting with special-purpose registers:  
OPCODE_GROUP(0b001)
	* Encoding:  _MDCODE(0010 aaaa oooo iiii  iiii iiii iiii iiii)
		* _MDCODE(a):  dA
		* _MDCODE(o):  opcode
		* _MDCODE(i):  20-bit signed immediate
	* Note:  all instructions in group 0b001 are scalar operations.
	* NOTE_SDATA()
	* Instructions:
		* _BOLD(btru) dA, simm20
			* OPCODE(0x0)
			* Effect:  _CODE(if (dA.sdata != 0) 
				pc <= pc + _SIGN_EXTEND_TO_64(simm20);)
		* _BOLD(bfal) dA, simm20
			* OPCODE(0x1)
			* Effect:  _CODE(if (dA.sdata == 0) 
				pc <= pc + _SIGN_EXTEND_TO_64(simm20);)
		* _BOLD(jmp) dA
			* OPCODE(0x2)
			* Effect:  _CODE(pc <= dA.sdata;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		* _BOLD(ei)
			* OPCODE(0x3)
			* Effect:  _CODE(ie <= 1'b1;)
			* Note:  Enable interrupts
		* _BOLD(di)
			* OPCODE(0x4)
			* Effect:  _CODE(ie <= 1'b0;)
			* Note:  Disable interrupts
		* _BOLD(reti)
			* OPCODE(0x5)
			* Effect:  _CODE(ie <= 1'b1; pc <= ireta;)
			* Note:  Return from an interrupt
		* _BOLD(cpy) dA, ie
			* OPCODE(0x6)
			* Effect:  _CODE(dA.sdata <= ie; // acts differently if dA is
			tagged as a float)
		* _BOLD(cpy) dA, ireta
			* OPCODE(0x7)
			* Effect:  _CODE(dA.sdata <= ireta;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		* _BOLD(cpy) dA, idsta
			* OPCODE(0x8)
			* Effect:  _CODE(dA.sdata <= idsta;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		* _BOLD(cpy) ie, dA
			* OPCODE(0x9)
			* Effect:  _CODE(ie <= (dA.sdata != 0);)
		* _BOLD(cpy) ireta, dA
			* OPCODE(0xa)
			* Effect:  _CODE(ireta <= dA.sdata;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		* _BOLD(cpy) idsta, dA
			* OPCODE(0xb)
			* Effect:  _CODE(idsta <= dA.sdata;)
			* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
_NEWLINE()_NEWLINE()
* Load Instructions:
OPCODE_GROUP(0b010)
	* Encoding:  _MDCODE(0100 aaaa bbbb cccc  oooo iiii iiii iiii)
		* _MDCODE(a):  dDest
		* _MDCODE(b):  dSrc0
		* _MDCODE(c):  dSrc1
		* _MDCODE(o):  opcode
		* _MDCODE(i):  12-bit signed immediate
	* Effect:  
		* Load LAR-sized data from 64-bit address computed as follows:
		_CODE((dB.address + _EXTEND_TO_64(dC.sdata) 
		\+ (_SIGN_EXTEND_TO_64(simm12))))
			* This 64-bit address is referred to as the "effective
			address".
		* The type of extension of the _CODE(_EXTEND_TO_64(dC.sdata))
		expression is based upon the type of _CODE(dC).  
			* If _CODE(dC) is tagged as an unsigned integer, zero-extension
			is performed.
			* If _CODE(dC) is tagged as a signed integer, sign-extension is
			performed.
			* If _CODE(dC) is tagged as a BFloat16, _CODE(dC.sdata) is
			casted to a 64-bit signed integer.  (This one is weird...
			normally, addressing isn't done with floating point numbers!).
		* Due to associativity of the LARs, these instructions will not
		actually load from memory if the effective address's data already
		loaded into a LAR.
	* Instructions:
		* _BOLD(ldu8) dA, dB, dC, simm12
			* OPCODE(0x0)
			* NOTE_U8()
		* _BOLD(lds8) dA, dB, dC, simm12
			* OPCODE(0x1)
			* NOTE_S8()
		* _BOLD(ldu16) dA, dB, dC, simm12
			* OPCODE(0x2)
			* NOTE_U16()
		* _BOLD(lds16) dA, dB, dC, simm12
			* OPCODE(0x3)
			* NOTE_S16()
		* _BOLD(ldu32) dA, dB, dC, simm12
			* OPCODE(0x4)
			* NOTE_U32()
		* _BOLD(lds32) dA, dB, dC, simm12
			* OPCODE(0x5)
			* NOTE_S32()
		* _BOLD(ldu64) dA, dB, dC, simm12
			* OPCODE(0x6)
			* NOTE_U64()
		* _BOLD(lds64) dA, dB, dC, simm12
			* OPCODE(0x7)
			* NOTE_S64()
		* _BOLD(ldf16) dA, dB, dC, simm12
			* OPCODE(0x8)
			* NOTE_BFLOAT16()
_NEWLINE()_NEWLINE()
* Store Instructions:
OPCODE_GROUP(0b011)
	* Encoding:  _MDCODE(0110 aaaa bbbb cccc  oooo iiii iiii iiii)
		* _MDCODE(a):  dA
		* _MDCODE(b):  dB
		* _MDCODE(c):  dC
		* _MDCODE(o):  opcode
		* _MDCODE(i):  12-bit signed immediate
	* Note:  These are actually type conversion instructions as actual
	writes to memory are done lazily
	* Effect:
		* These instructions mark _CODE(dA) as dirty, change its address to
		the effective address (see next bullet), and sets its type.
		* The 64-bit effective address is computed as follows:
			_CODE((dB.address + _EXTEND_TO_64(dC.sdata) 
			\+ (_SIGN_EXTEND_TO_64(simm12))))
		* The type of extension of the _CODE(_EXTEND_TO_64(dC.sdata))
			expression is based upon the type of _CODE(dC).  
			* If _CODE(dC) is tagged as an unsigned integer, zero-extension
			is performed.
			* If _CODE(dC) is tagged as a signed integer, sign-extension is
			performed.
			* If _CODE(dC) is tagged as a BFloat16, _CODE(dC.sdata) is
			casted to a 64-bit signed integer.  (This one is weird...
			normally, addressing isn't done with floating point numbers!).
	* Instructions:
		* _BOLD(stu8) dA, dB, dC, simm12
			* OPCODE(0x0)
			* NOTE_U8()
		* _BOLD(sts8) dA, dB, dC, simm12
			* OPCODE(0x1)
			* NOTE_S8()
		* _BOLD(stu16) dA, dB, dC, simm12
			* OPCODE(0x2)
			* NOTE_U16()
		* _BOLD(sts16) dA, dB, dC, simm12
			* OPCODE(0x3)
			* NOTE_S16()
		* _BOLD(stu32) dA, dB, dC, simm12
			* OPCODE(0x4)
			* NOTE_U32()
		* _BOLD(sts32) dA, dB, dC, simm12
			* OPCODE(0x5)
			* NOTE_S32()
		* _BOLD(stu64) dA, dB, dC, simm12
			* OPCODE(0x6)
			* NOTE_U64()
		* _BOLD(sts64) dA, dB, dC, simm12
			* OPCODE(0x7)
			* NOTE_S64()
		* _BOLD(stf16) dA, dB, dC, simm12
			* OPCODE(0x8)
			* NOTE_BFLOAT16()
_NEWLINE()_NEWLINE()
* Port-mapped Input/Output Instructions:
OPCODE_GROUP(0b100)
	* Encoding:  _MDCODE(100t aaaa bbbb oooo  iiii iiii iiii iiii)
		* _MDCODE(t):  DESCRIBE_SV_OPERATION_TYPE()
		* _MDCODE(a):  dA
		* _MDCODE(b):  dB
		* _MDCODE(o):  opcode
		* _MDCODE(i):  16-bit signed immediate
	* NOTE_SDATA()
	* Note:  For the _CODE(in...) instructions, the entirety of
	_CODE(dA.data) is set to the received data.  The type of _CODE(dA) is set
	based upon the instruction opcode.
	* Note:  For _CODE(outs), _CODE(dA.sdata) is sent to the output port,
	along with the type of data (in case the particular I/O port cares).
	* Note:  For _CODE(outv), the entirety of _CODE(dA.data) is sent to the
	output port, along with the type of data (in case the particular I/O
	port cares).
	* Note:  For each of these instructions, the I/O address used is
	computed by the formula
	_CODE(_CAST_TO_64(dB.sdata) + _SIGN_EXTEND_TO_64(simm16))
	* Instructions:
		* _BOLD(inu8) dA, dB, simm16
			* OPCODE(0x0)
			* NOTE_U8()
		* _BOLD(ins8) dA, dB, simm16
			* OPCODE(0x1)
			* NOTE_S8()
		* _BOLD(inu16) dA, dB, simm16
			* OPCODE(0x2)
			* NOTE_U16()
		* _BOLD(ins16) dA, dB, simm16
			* OPCODE(0x3)
			* NOTE_S16()
		* _BOLD(inu32) dA, dB, simm16
			* OPCODE(0x4)
			* NOTE_U32()
		* _BOLD(ins32) dA, dB, simm16
			* OPCODE(0x5)
			* NOTE_S32()
		* _BOLD(inu64) dA, dB, simm16
			* OPCODE(0x6)
			* NOTE_U64()
		* _BOLD(ins64) dA, dB, simm16
			* OPCODE(0x7)
			* NOTE_S64()
		* _BOLD(inf16) dA, dB, simm16
			* OPCODE(0x8)
			* NOTE_BFLOAT16()
		* _BOLD(out) (actual mnemonics below)
			* OPCODE(0x9)
				* _BOLD(outs) dA, dB, simm16
					* _MDCODE(t):  0
					* Note:  _CODE(dA.sdata) is simply sent to the output
					data bus.
				* _BOLD(outv) dA, dB, simm16
					* _MDCODE(t):  1
					* Note:  The type of _CODE(dA) is ignored for this
					operation as the entirety of the LAR is sent to the
					port.

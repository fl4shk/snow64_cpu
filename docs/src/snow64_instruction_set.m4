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
define(`NOTE_OPERANDS_OF_SHIFT_NOT',`Note:  this operation always uses 64-bit components of the input register(s) (no casting is performed), and saves the result to the destination register as if the destination register was tagged as 64-bit')dnl
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
	dnl * Interrupts are supported (this may be a first for a LARs
	dnl architecture)
	dnl * Port-mapped I/O is supported (this may be a first for a LARs
	dnl architecture)
_NEWLINE()_NEWLINE()
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
		dnl * _MDCODE(ie) (whether or not interrupts are enabled, 1-bit)
		dnl * _MDCODE(ireta) (the interrupt return address, 64-bit)
		dnl * _MDCODE(idsta) (the interrupt destination address, 64-bit;
		dnl upon an interrupt, the program counter is set to the value in this
		dnl register)
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
			* NOTE_OPERANDS_OF_SHIFT_NOT()
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
			* NOTE_OPERANDS_OF_SHIFT_NOT()
		* _BOLD(inv) dDest, dSrc0
			* OPCODE(0xa)
			* BOTH_MNEMONICS(inv)
			* Note:  Bitwise invert
			* NOTE_FLOATS_TREATED_AS_16_BIT_INT()
		* _BOLD(not) dDest, dSrc0
			* OPCODE(0xb)
			* BOTH_MNEMONICS(not)
			* Note:  Logical not
			* NOTE_OPERANDS_OF_SHIFT_NOT()
		* _BOLD(addi) dDest, pc, simm12
			* OPCODE(0xc)
			* BOTH_MNEMONICS(addi)
			* Note:  This is useful for pc-relative loads, relative
			branches, and for getting the return address of a subroutine
			call into a LAR before jumping to a subroutine.
		* _BOLD(addi) dDest, dSrc0, simm12
			* OPCODE(0xd)
			* BOTH_MNEMONICS(addi)
			* Note:  This instruction can operate as "load immediate" by
			using _MDCODE(dzero) as _MDCODE(dSrc0), but note that this
			instruction does not affect the _MDCODE(dDest.address) field.
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
		dnl * _BOLD(ei)
		dnl 	* OPCODE(0x3)
		dnl 	* Effect:  _CODE(ie <= 1'b1;)
		dnl 	* Note:  Enable interrupts
		dnl * _BOLD(di)
		dnl 	* OPCODE(0x4)
		dnl 	* Effect:  _CODE(ie <= 1'b0;)
		dnl 	* Note:  Disable interrupts
		dnl * _BOLD(reti)
		dnl 	* OPCODE(0x5)
		dnl 	* Effect:  _CODE(ie <= 1'b1; pc <= ireta;)
		dnl 	* Note:  Return from an interrupt
		dnl * _BOLD(cpy) dA, ie
		dnl 	* OPCODE(0x6)
		dnl 	* Effect:  _CODE(dA.sdata <= ie; // acts differently if dA is
		dnl 	tagged as a float)
		dnl * _BOLD(cpy) dA, ireta
		dnl 	* OPCODE(0x7)
		dnl 	* Effect:  _CODE(dA.sdata <= ireta;)
		dnl 	* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		dnl * _BOLD(cpy) dA, idsta
		dnl 	* OPCODE(0x8)
		dnl 	* Effect:  _CODE(dA.sdata <= idsta;)
		dnl 	* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		dnl * _BOLD(cpy) ie, dA
		dnl 	* OPCODE(0x9)
		dnl 	* Effect:  _CODE(ie <= (dA.sdata != 0);)
		dnl * _BOLD(cpy) ireta, dA
		dnl 	* OPCODE(0xa)
		dnl 	* Effect:  _CODE(ireta <= dA.sdata;)
		dnl 	* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
		dnl * _BOLD(cpy) idsta, dA
		dnl 	* OPCODE(0xb)
		dnl 	* Effect:  _CODE(idsta <= dA.sdata;)
		dnl 	* NOTE_SUGGEST_LARGEST_MEMORY_ADDR(dA)
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
dnl * Port-mapped Input/Output Instructions:
dnl OPCODE_GROUP(0b100)
dnl 	* Encoding:  _MDCODE(100t aaaa bbbb oooo  iiii iiii iiii iiii)
dnl 		* _MDCODE(t):  DESCRIBE_SV_OPERATION_TYPE()
dnl 		* _MDCODE(a):  dA
dnl 		* _MDCODE(b):  dB
dnl 		* _MDCODE(o):  opcode
dnl 		* _MDCODE(i):  16-bit signed immediate
dnl 	* NOTE_SDATA()
dnl 	* Note:  For the _CODE(in...) instructions, the entirety of
dnl 	_CODE(dA.data) is set to the received data.  The type of _CODE(dA) is set
dnl 	based upon the instruction opcode.
dnl 	* Note:  For _CODE(outs), _CODE(dA.sdata) is sent to the output port,
dnl 	along with the type of data (in case the particular I/O port cares).
dnl 	* Note:  For _CODE(outv), the entirety of _CODE(dA.data) is sent to the
dnl 	output port, along with the type of data (in case the particular I/O
dnl 	port cares).
dnl 	* Note:  For each of these instructions, the I/O address used is
dnl 	computed by the formula
dnl 	_CODE(_CAST_TO_64(dB.sdata) + _SIGN_EXTEND_TO_64(simm16))
dnl 	* Instructions:
dnl 		* _BOLD(inu8) dA, dB, simm16
dnl 			* OPCODE(0x0)
dnl 			* NOTE_U8()
dnl 		* _BOLD(ins8) dA, dB, simm16
dnl 			* OPCODE(0x1)
dnl 			* NOTE_S8()
dnl 		* _BOLD(inu16) dA, dB, simm16
dnl 			* OPCODE(0x2)
dnl 			* NOTE_U16()
dnl 		* _BOLD(ins16) dA, dB, simm16
dnl 			* OPCODE(0x3)
dnl 			* NOTE_S16()
dnl 		* _BOLD(inu32) dA, dB, simm16
dnl 			* OPCODE(0x4)
dnl 			* NOTE_U32()
dnl 		* _BOLD(ins32) dA, dB, simm16
dnl 			* OPCODE(0x5)
dnl 			* NOTE_S32()
dnl 		* _BOLD(inu64) dA, dB, simm16
dnl 			* OPCODE(0x6)
dnl 			* NOTE_U64()
dnl 		* _BOLD(ins64) dA, dB, simm16
dnl 			* OPCODE(0x7)
dnl 			* NOTE_S64()
dnl 		* _BOLD(inf16) dA, dB, simm16
dnl 			* OPCODE(0x8)
dnl 			* NOTE_BFLOAT16()
dnl 		* _BOLD(out) (actual mnemonics below)
dnl 			* OPCODE(0x9)
dnl 				* _BOLD(outs) dA, dB, simm16
dnl 					* _MDCODE(t):  0
dnl 					* Note:  _CODE(dA.sdata) is simply sent to the output
dnl 					data bus.
dnl 				* _BOLD(outv) dA, dB, simm16
dnl 					* _MDCODE(t):  1
dnl 					* Note:  The type of _CODE(dA) is ignored for this
dnl 					operation as the entirety of the LAR is sent to the
dnl 					port.

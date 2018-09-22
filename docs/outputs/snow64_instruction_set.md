 
# Snow64 Instruction Set
* Notes
	* There are no Instruction LARs (the typical instruction fetch of most
	computer processors is used instead).
	* Addresses are 64-bit.
	* Interrupts are supported (this may be a first for a LARs
	architecture)
	* Port-mapped I/O is supported (this may be a first for a LARs
	architecture)
<br><br>
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
<br>
* Registers
	* The DLARs themselves (there are 16, but this may be changed later):
		* `dzero` (always zero), 
		* `du0`, `du1`, `du2`, `du3`
		`du4`, `du5`, `du6`, `du7`,
		`du8`, `du9`, `du10`, `du11`
		(user registers)
		* `dlr` (standard link register (hardware does not enforce
		this))
		* `dfp` (standard frame pointer (hardware does not enforce
		this))
		* `dsp` (standard stack pointer (hardware does not enforce
		this))
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
		* `t`:  operation type:  if <code>0b0</code>:  scalar
operation; 
		else: vector operation
		* `a`:  dDest
		* `b`:  dSrc0
		* `c`:  dSrc1
		* `o`:  opcode
		* `i`:  12-bit signed immediate
	* Note:  For ALU instructions, any result that doesn't fit in the
	destination will be truncated to fit into the destination.  This
	affects both scalar and vector operations.
	* Note:  also, for each of these instructions, the address field is not
	used as an operand, just the data field.
		* Example:  <code>adds d1, d2, d3</code>
			* Effect:  <code>d1.sdata <= cast\_to\_type\_of\_d1(d2.sdata)
			\+ cast\_to\_type\_of\_d1(d3.sdata)</code>
	* Instructions:
		* <b>add</b> dDest, dSrc0, dSrc1
			* Opcode:  0x0
			* Scalar Mnemonic:  <code>adds</code>
			* Vector Mnemonic:  <code>addv</code>
		* <b>sub</b> dDest, dSrc0, dSrc1
			* Opcode:  0x1
			* Scalar Mnemonic:  <code>subs</code>
			* Vector Mnemonic:  <code>subv</code>
		* <b>slt</b> dDest, dSrc0, dSrc1
			* Opcode:  0x2
			* Scalar Mnemonic:  <code>slts</code>
			* Vector Mnemonic:  <code>sltv</code>
			* Note:  set less than
			* Note:  The signedness of dDest will be used
for the operation
		* <b>mul</b> dDest, dSrc0, dSrc1
			* Opcode:  0x3
			* Scalar Mnemonic:  <code>muls</code>
			* Vector Mnemonic:  <code>mulv</code>
			* Note:  If dDest has a larger size
than both dSrc0 and dSrc1, then the signedness used for the operation will
be that of dDest
			* Note:  This operation
is not guaranteed to be single cycle, and thus pipeline stalls will be
used
		* <b>div</b> dDest, dSrc0, dSrc1
			* Opcode:  0x4
			* Scalar Mnemonic:  <code>divs</code>
			* Vector Mnemonic:  <code>divv</code>
			* Note:  This operation
is not guaranteed to be single cycle, and thus pipeline stalls will be
used
		* <b>and</b> dDest, dSrc0, dSrc1
			* Opcode:  0x5
			* Scalar Mnemonic:  <code>ands</code>
			* Vector Mnemonic:  <code>andv</code>
			* Note:  For floats, this
operation treats all operands as 16-bit signed integers.
		* <b>orr</b> dDest, dSrc0, dSrc1
			* Opcode:  0x6
			* Scalar Mnemonic:  <code>orrs</code>
			* Vector Mnemonic:  <code>orrv</code>
			* Note:  For floats, this
operation treats all operands as 16-bit signed integers.
		* <b>xor</b> dDest, dSrc0, dSrc1
			* Opcode:  0x7
			* Scalar Mnemonic:  <code>xors</code>
			* Vector Mnemonic:  <code>xorv</code>
			* Note:  For floats, this
operation treats all operands as 16-bit signed integers.
		* <b>shl</b> dDest, dSrc0, dSrc1
			* Opcode:  0x8
			* Scalar Mnemonic:  <code>shls</code>
			* Vector Mnemonic:  <code>shlv</code>
			* Note:  Shift left
			* Note:  For floats, this
operation treats all operands as 16-bit signed integers.
		* <b>shr</b> dDest, dSrc0, dSrc1
			* Opcode:  0x9
			* Scalar Mnemonic:  <code>shrs</code>
			* Vector Mnemonic:  <code>shrv</code>
			* Note:  Shift right
			* Note:  dSrc0's signedness is used to determine the type of
			right shift:  
				* If dSrc0 is unsigned, a logical right shift is performed
				* If dSrc0 is signed, an arithmetic right shift is
				performed
			* Note:  dSrc1 is always treated as unsigned (due to being a
			number of bits to shift by)
			* Note:  For floats, this
operation treats all operands as 16-bit signed integers.
		* <b>inv</b> dDest, dSrc0
			* Opcode:  0xa
			* Scalar Mnemonic:  <code>invs</code>
			* Vector Mnemonic:  <code>invv</code>
			* Note:  Bitwise invert
			* Note:  For floats, this
operation treats all operands as 16-bit signed integers.
		* <b>not</b> dDest, dSrc0
			* Opcode:  0xb
			* Scalar Mnemonic:  <code>nots</code>
			* Vector Mnemonic:  <code>notv</code>
			* Note:  Logical not
		* <b>add</b> dDest, pc, simm12
			* Opcode:  0xc
			* Scalar Mnemonic:  <code>adds</code>
			* Vector Mnemonic:  <code>addv</code>
			* Note:  This is useful for pc-relative loads, relative
			branches, and for getting the return address of a subroutine
			call into a LAR before jumping to a subroutine.
<br><br>
* Instructions for interacting with special-purpose registers:  
Opcode Group:  0b001
	* Encoding:  `0010 aaaa oooo iiii  iiii iiii iiii iiii`
		* `a`:  dA
		* `o`:  opcode
		* `i`:  20-bit signed immediate
	* Note:  all instructions in group 0b001 are scalar operations.
	* Note:  `dX.sdata` is simply the current scalar portion of the
	data LAR called `dX`
	* Instructions:
		* <b>btru</b> dA, simm20
			* Opcode:  0x0
			* Effect:  <code>if (dA.sdata != 0) 
				pc <= pc + sign\_extend\_to\_64(simm20);</code>
		* <b>bfal</b> dA, simm20
			* Opcode:  0x1
			* Effect:  <code>if (dA.sdata == 0) 
				pc <= pc + sign\_extend\_to\_64(simm20);</code>
		* <b>jmp</b> dA
			* Opcode:  0x2
			* Effect:  <code>pc <= dA.sdata;</code>
			* Note:  It is suggested
to have dA.sdata be at least as
			large as the largest memory address (which might not be
			64-bit if there isn't enough physical memory for that)
		* <b>ei</b>
			* Opcode:  0x3
			* Effect:  <code>ie <= 1'b1;</code>
			* Note:  Enable interrupts
		* <b>di</b>
			* Opcode:  0x4
			* Effect:  <code>ie <= 1'b0;</code>
			* Note:  Disable interrupts
		* <b>reti</b>
			* Opcode:  0x5
			* Effect:  <code>ie <= 1'b1; pc <= ireta;</code>
			* Note:  Return from an interrupt
		* <b>cpy</b> dA, ie
			* Opcode:  0x6
			* Effect:  <code>dA.sdata <= ie; // acts differently if dA is
			tagged as a float</code>
		* <b>cpy</b> dA, ireta
			* Opcode:  0x7
			* Effect:  <code>dA.sdata <= ireta;</code>
			* Note:  It is suggested
to have dA.sdata be at least as
			large as the largest memory address (which might not be
			64-bit if there isn't enough physical memory for that)
		* <b>cpy</b> dA, idsta
			* Opcode:  0x8
			* Effect:  <code>dA.sdata <= idsta;</code>
			* Note:  It is suggested
to have dA.sdata be at least as
			large as the largest memory address (which might not be
			64-bit if there isn't enough physical memory for that)
		* <b>cpy</b> ie, dA
			* Opcode:  0x9
			* Effect:  <code>ie <= (dA.sdata != 0);</code>
		* <b>cpy</b> ireta, dA
			* Opcode:  0xa
			* Effect:  <code>ireta <= dA.sdata;</code>
			* Note:  It is suggested
to have dA.sdata be at least as
			large as the largest memory address (which might not be
			64-bit if there isn't enough physical memory for that)
		* <b>cpy</b> idsta, dA
			* Opcode:  0xb
			* Effect:  <code>idsta <= dA.sdata;</code>
			* Note:  It is suggested
to have dA.sdata be at least as
			large as the largest memory address (which might not be
			64-bit if there isn't enough physical memory for that)
<br><br>
* Load Instructions:
Opcode Group:  0b010
	* Encoding:  `0100 aaaa bbbb cccc  oooo iiii iiii iiii`
		* `a`:  dDest
		* `b`:  dSrc0
		* `c`:  dSrc1
		* `o`:  opcode
		* `i`:  12-bit signed immediate
	* Effect:  
		* Load LAR-sized data from 64-bit address computed as follows:
		<code>(dB.address + extend\_to\_64(dC.sdata) 
		\+ (sign\_extend\_to\_64(simm12)))</code>
			* This 64-bit address is referred to as the "effective
			address".
		* The type of extension of the <code>extend\_to\_64(dC.sdata)</code>
		expression is based upon the type of <code>dC</code>.  
			* If <code>dC</code> is tagged as an unsigned integer, zero-extension
			is performed.
			* If <code>dC</code> is tagged as a signed integer, sign-extension is
			performed.
			* If <code>dC</code> is tagged as a BFloat16, <code>dC.sdata</code> is
			casted to a 64-bit signed integer.  (This one is weird...
			normally, addressing isn't done with floating point numbers!).
		* Due to associativity of the LARs, these instructions will not
		actually load from memory if the effective address's data already
		loaded into a LAR.
	* Instructions:
		* <b>ldu8</b> dA, dB, dC, simm12
			* Opcode:  0x0
			* Note:  unsigned 8-bit integer(s)
		* <b>lds8</b> dA, dB, dC, simm12
			* Opcode:  0x1
			* Note:  signed 8-bit integer(s)
		* <b>ldu16</b> dA, dB, dC, simm12
			* Opcode:  0x2
			* Note:  unsigned 16-bit integer(s)
		* <b>lds16</b> dA, dB, dC, simm12
			* Opcode:  0x3
			* Note:  signed 16-bit integer(s)
		* <b>ldu32</b> dA, dB, dC, simm12
			* Opcode:  0x4
			* Note:  unsigned 32-bit integer(s)
		* <b>lds32</b> dA, dB, dC, simm12
			* Opcode:  0x5
			* Note:  signed 32-bit integer(s)
		* <b>ldu64</b> dA, dB, dC, simm12
			* Opcode:  0x6
			* Note:  unsigned 64-bit integer(s)
		* <b>lds64</b> dA, dB, dC, simm12
			* Opcode:  0x7
			* Note:  signed 64-bit integer(s)
		* <b>ldf16</b> dA, dB, dC, simm12
			* Opcode:  0x8
			* Note:  BFloat16 format floating point number.
<br><br>
* Store Instructions:
Opcode Group:  0b011
	* Encoding:  `0110 aaaa bbbb cccc  oooo iiii iiii iiii`
		* `a`:  dA
		* `b`:  dB
		* `c`:  dC
		* `o`:  opcode
		* `i`:  12-bit signed immediate
	* Note:  These are actually type conversion instructions as actual
	writes to memory are done lazily
	* Effect:
		* These instructions mark <code>dA</code> as dirty, change its address to
		the effective address (see next bullet), and sets its type.
		* The 64-bit effective address is computed as follows:
			<code>(dB.address + extend\_to\_64(dC.sdata) 
			\+ (sign\_extend\_to\_64(simm12)))</code>
		* The type of extension of the <code>extend\_to\_64(dC.sdata)</code>
			expression is based upon the type of <code>dC</code>.  
			* If <code>dC</code> is tagged as an unsigned integer, zero-extension
			is performed.
			* If <code>dC</code> is tagged as a signed integer, sign-extension is
			performed.
			* If <code>dC</code> is tagged as a BFloat16, <code>dC.sdata</code> is
			casted to a 64-bit signed integer.  (This one is weird...
			normally, addressing isn't done with floating point numbers!).
	* Instructions:
		* <b>stu8</b> dA, dB, dC, simm12
			* Opcode:  0x0
			* Note:  unsigned 8-bit integer(s)
		* <b>sts8</b> dA, dB, dC, simm12
			* Opcode:  0x1
			* Note:  signed 8-bit integer(s)
		* <b>stu16</b> dA, dB, dC, simm12
			* Opcode:  0x2
			* Note:  unsigned 16-bit integer(s)
		* <b>sts16</b> dA, dB, dC, simm12
			* Opcode:  0x3
			* Note:  signed 16-bit integer(s)
		* <b>stu32</b> dA, dB, dC, simm12
			* Opcode:  0x4
			* Note:  unsigned 32-bit integer(s)
		* <b>sts32</b> dA, dB, dC, simm12
			* Opcode:  0x5
			* Note:  signed 32-bit integer(s)
		* <b>stu64</b> dA, dB, dC, simm12
			* Opcode:  0x6
			* Note:  unsigned 64-bit integer(s)
		* <b>sts64</b> dA, dB, dC, simm12
			* Opcode:  0x7
			* Note:  signed 64-bit integer(s)
		* <b>stf16</b> dA, dB, dC, simm12
			* Opcode:  0x8
			* Note:  BFloat16 format floating point number.
<br><br>
* Port-mapped Input/Output Instructions:
Opcode Group:  0b100
	* Encoding:  `100t aaaa bbbb oooo  iiii iiii iiii iiii`
		* `t`:  operation type:  if <code>0b0</code>:  scalar
operation; 
		else: vector operation
		* `a`:  dA
		* `b`:  dB
		* `o`:  opcode
		* `i`:  16-bit signed immediate
	* Note:  `dX.sdata` is simply the current scalar portion of the
	data LAR called `dX`
	* Note:  For the <code>in...</code> instructions, the entirety of
	<code>dA.data</code> is set to the received data.  The type of <code>dA</code> is set
	based upon the instruction opcode.
	* Note:  For <code>outs</code>, <code>dA.sdata</code> is sent to the output port,
	along with the type of data (in case the particular I/O port cares).
	* Note:  For <code>outv</code>, the entirety of <code>dA.data</code> is sent to the
	output port, along with the type of data (in case the particular I/O
	port cares).
	* Note:  For each of these instructions, the I/O address used is
	computed by the formula
	<code>cast\_to\_64(dB.sdata) + sign\_extend\_to\_64(simm16)</code>
	* Instructions:
		* <b>inu8</b> dA, dB, simm16
			* Opcode:  0x0
			* Note:  unsigned 8-bit integer(s)
		* <b>ins8</b> dA, dB, simm16
			* Opcode:  0x1
			* Note:  signed 8-bit integer(s)
		* <b>inu16</b> dA, dB, simm16
			* Opcode:  0x2
			* Note:  unsigned 16-bit integer(s)
		* <b>ins16</b> dA, dB, simm16
			* Opcode:  0x3
			* Note:  signed 16-bit integer(s)
		* <b>inu32</b> dA, dB, simm16
			* Opcode:  0x4
			* Note:  unsigned 32-bit integer(s)
		* <b>ins32</b> dA, dB, simm16
			* Opcode:  0x5
			* Note:  signed 32-bit integer(s)
		* <b>inu64</b> dA, dB, simm16
			* Opcode:  0x6
			* Note:  unsigned 64-bit integer(s)
		* <b>ins64</b> dA, dB, simm16
			* Opcode:  0x7
			* Note:  signed 64-bit integer(s)
		* <b>inf16</b> dA, dB, simm16
			* Opcode:  0x8
			* Note:  BFloat16 format floating point number.
		* <b>out</b> (actual mnemonics below)
			* Opcode:  0x9
				* <b>outs</b> dA, dB, simm16
					* `t`:  0
					* Note:  <code>dA.sdata</code> is simply sent to the output
					data bus.
				* <b>outv</b> dA, dB, simm16
					* `t`:  1
					* Note:  The type of <code>dA</code> is ignored for this
					operation as the entirety of the LAR is sent to the
					port.

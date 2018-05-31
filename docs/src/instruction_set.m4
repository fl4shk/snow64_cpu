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
# Snow32 Instruction Set
<!-- Vim Note:  Use @g to update notes.pdf -->
<!-- Vim Note:  Use @h to update notes.html -->
<!-- Vim Note:  Use @j to update notes.pdf and notes.html -->
<!-- How To Make A Tab:  &emsp; -->
<!--
&epsilon; &Epsilon;   &lambda; &Lambda;   &alpha; &Alpha;
&beta; &Beta;   &pi; &Pi; &#0960;   &sigma; &Sigma;
&omega; &Omega;   &mu; &Mu;  &gamma; &Gamma;
&prod;  &sum;  &int;  &part;  &infin;
&amp;  &ast;  &sdot;
&lt; &le;  &gt; &ge;  &equals; &ne;
-->


* Notes
    * There are no Instruction LARs.
    * Addresses are 32-bit.
* Data LARs:
NEWLINE()NEWLINE()
	typedef struct packed
	NEWLINE()
	{

		// Stuffs
		union packed
		{
			logic [7:0] data_8[0:32];
			logic [15:0] data_16[0:15];
			logic [31:0] data_32[0:7];
			logic [63:0] data_64[0:3];
		} data;

		// Note that this is a 32-bit structure
		union packed
		{
			struct packed
			{
				logic [31 - 3 : 0] base_pt;

				logic [2:0] offset;
			} addr_32;

			struct packed
			{
				logic [31 - 4 : 0] base_pt;

				logic [3:0] offset;
			} addr_16;

			struct packed
			{
				logic [31 - 5 : 0] base_pt;

				logic [4:0] offset;
			} addr_8;
		} addr;

		// Types:
		// 2'b00:  Byte
		// 2'b01:  Half word
		// 2'b10:  Word
		// 2'b11:  Half float:  The high 16 bits of an IEEE 32-bit float
		logic [1:0] type;

		// Unsigned:  1'b0
		// Signed:  1'b1
		// Note:  unsgn_or_sgn is only relevant for integers
		logic unsgn_or_sgn;
		logic dirty;

	} DataLar;

	* Names:  CODE(d0) (always zero), CODE(d1), CODE(d2), CODE(d3),
	CODE(d4), ..., CODE(d31)



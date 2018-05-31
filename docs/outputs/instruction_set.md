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
<br><br>
	typedef struct packed
	<br>
	{

		// Stuffs
		union packed
		{
			logic [31:0] data_32[0:7];
			logic [15:0] data_16[0:15];
			logic [7:0] data_8[0:32];
			logic [15:0] data_float[0:15];
		} data;

		struct packed
		{
			logic [31 - 3 : 0] base_pt;
			logic [2:0] offset;
		} addr;

		// Types:
		// 2'b00:  Byte
		// 2'b01:  Half word
		// 2'b10:  Word
		// 2'b11:  Half float:	The high 16 bits of an IEEE 32-bit float
		logic [1:0] type;
		// Unsigned:  1'b0
		// Signed:	1'b1
		logic unsgn_or_sgn;
		logic dirty;

	} DataLar;

	* Names:  <code>d0</code> (always zero), <code>d1</code>, <code>d2</code>, <code>d3</code>,
	<code>d4</code>, <code>...</code>, <code>d31</code>


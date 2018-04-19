# Snow32 CPU
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




* General Purpose Registers (32-bit)
    * ``r0``, ``r1``, ``r2``, ..., ``r13``, ``r14`` (aka ``lr``), 
    ``r15`` (aka ``sp``)
* Special Purpose Registers (32-bit)
    * ``s0`` (always zero), ``s1`` (aka ``pc``), ``s2`` (aka ``flags``),
    ``s3`` (aka ``intstat``), ``s4`` (aka ``hi``), ``s5`` (aka ``lo``), 
    ``s6``, ``s7``, ... ``s13``, ``s14``, ``s15``
<br>
<br>
* Group 0 Instructions
    * Encoding:  ``0ooo aaaa``
    * ``o``:  Opcode
    * ``a``:  <code>rA</code> &emsp; &emsp; // register number "A"
* <b>add</b> r0, rA
    * Opcode:  0b000
    * Effect:  <code>r0 <= r0 + rA;</code>
    * Doesn't affect ``flags``.
* <b>sub</b> r0, rA
    * Opcode:  0b001
    * Effect:  <code>r0 <= r0 - rA;</code>
    * Doesn't affect ``flags``.
* <b>cmp</b> r0, rA
    * Opcode:  0b010
    * Effect:  <code>&lt;discard&gt; <= r0 - rA;</code>
    * Doesn't affect ``flags``.
* <b>and</b> r0, rA
    * Opcode:  0b011
    * Effect:  <code>r0 <= r0 &amp; rA;</code>
    * Doesn't affect ``flags``.
* <b>orr</b> r0, rA
    * Opcode:  0b100
    * Effect:  <code>r0 <= r0 | rA;</code>
    * Doesn't affect ``flags``.
* <b>xor</b> r0, rA
    * Opcode:  0b101
    * Effect:  <code>r0 <= r0 ^ rA;</code>
    * Doesn't affect ``flags``.
* <b>ldr</b> r0, [rA]
    * Opcode:  0b110
    * Effect:  <code>r0 <= four\_bytes\_in\_mem\_at(rA);</code>
    * Doesn't affect ``flags``.
* <b>str</b> r0, [rA]
    * Opcode:  0b111
    * Effect:  <code>four\_bytes\_in\_mem\_at(rA) <= r0;</code>
    * Doesn't affect ``flags``.
<br>
<br>
* Group 1 Instructions
    * Encoding:  ``1000 ooof  aaaa bbbb``
    * ``o``:  Opcode
    * ``f``:  if 0, no flags affected.  1 otherwise.
    * ``a``:  <code>rA</code> &emsp; &emsp; // register number "A"
    * ``b``:  <code>rB</code> &emsp; &emsp; // register number "B"
* <b>add</b> rA, rB
    * Opcode:  0b000
    * Effect:  <code>rA <= rA + rB;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>sub</b> rA, rB
    * Opcode:  0b001
    * Effect:  <code>rA <= rA - rB;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>cmp</b> rA, rB
    * Opcode:  0b010
    * Effect:  <code>&lt;discard&gt; <= rA - rB;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>and</b> rA, rB
    * Opcode:  0b011
    * Effect:  <code>rA <= rA &amp; rB;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>orr</b> rA, rB
    * Opcode:  0b100
    * Effect:  <code>rA <= rA | rB;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>xor</b> rA, rB
    * Opcode:  0b101
    * Effect:  <code>rA <= rA ^ rB;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>ldr</b> rA, [rB]
    * Opcode:  0b110
    * Effect:  <code>rA <= four\_bytes\_in\_mem\_at(rB);</code>
    * Doesn't affect ``flags``.
* <b>str</b> rA, [rB]
    * Opcode:  0b111
    * Effect:  <code>four\_bytes\_in\_mem\_at(rB) <= rA;</code>
    * Doesn't affect ``flags``.
<br>
<br>
* Group 2 Instructions
    * Encoding:  ``1001 ooof  aaaa bbbb``
    * ``o``:  Opcode
    * ``f``:  if 0, no flags affected.  1 otherwise.
    * ``a``:  (<code>rA</code> &emsp; &emsp; // register number "A") &emsp; **or** &emsp; (<code>sA</code> &emsp; &emsp; // special register number "A")
    * ``b``:  (<code>rB</code> &emsp; &emsp; // register number "B") &emsp; **or** &emsp; (<code>sB</code> &emsp; &emsp; // special register number "B")
* <b>adc</b> rA, rB
    * Opcode:  0b000
    * Effect:  <code>rA <= rA + rB + flags<sub>c</sub>;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>sbc</b> rA, rB
    * Opcode:  0b001
    * Effect:  <code>rA <= rA + (~rB) + flags<sub>c</sub>;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>lsl</b> rA, rB
    * Opcode:  0b010
    * Effect:  <code>rA <= rA << rB;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>lsr</b> rA, rB
    * Opcode:  0b011
    * Effect:  <code>rA <= rA logically right shifted by rB;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>asr</b> rA, rB
    * Opcode:  0b100
    * Effect:  <code>rA <= rA arithmetic right shifted by rB;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>mul</b> rA, rB
    * Opcode:  0b101
    * Effect:  <code>rA <= rA &ast; rB;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>cpy</b> rA, rB
    * Opcode:  0b110
    * Effect:  <code>rA <= rB;</code>
    * Doesn't affect ``flags``.
* <b>cpy</b> sA, sB
    * Opcode:  0b111
    * Effect:  <code>sA <= sB;</code>
    * Can affect ``nvzc`` ``flags`` fi ``f`` encoding bit == 1 **and** ``flags`` is the destination special register.
<br>
<br>
* Group 3 Instructions
    * Encoding:  ``1010 ooof  aaaa bbbb  iiii iiii iiii iiii``
    * ``o``:  Opcode
    * ``f``:  if 0, no flags affected.  1 otherwise.
    * ``a``:  <code>rA</code> &emsp; &emsp; // register number "A"
    * ``b``:  <code>rB</code> &emsp; &emsp; // register number "B"
    * ``i``:  16-bit immediate value
* <b>addi</b> rA, rB, imm16
    * Opcode:  0b000
    * Effect:  <code>rA <= rB + zero\_extend\_to\_32(imm16);</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>subi</b> rA, rB, imm16
    * Opcode:  0b001
    * Effect:  <code>rA <= rB - zero\_extend\_to\_32(imm16);</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>cmpi</b> rA, imm16
    * Opcode:  0b010
    * Effect:  <code>&lt;discard&gt; <= rA - zero\_extend\_to\_32(imm16);</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>andi</b> rA, rB, imm16
    * Opcode:  0b011
    * Effect:  <code>rA <= rB &amp; zero\_extend\_to\_32(imm16);</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>orri</b> rA, rB, imm16
    * Opcode:  0b100
    * Effect:  <code>rA <= rB | zero\_extend\_to\_32(imm16);</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>xori</b> rA, rB, imm16
    * Opcode:  0b101
    * Effect:  <code>rA <= rB ^ zero\_extend\_to\_32(imm16);</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>ldrxi</b> rA, [rB, imm16]
    * Opcode:  0b110
    * Effect:  <code>rA <= four\_bytes\_in\_mem\_at(rB + zero\_extend\_to\_32(imm16));</code>
    * Doesn't affect ``flags``.
* <b>strxi</b> rA, [rB, imm16]
    * Opcode:  0b111
    * Effect:  <code>four\_bytes\_in\_mem\_at(rB + zero\_extend\_to\_32(imm16)) <= rA;</code>
    * Doesn't affect ``flags``.
<br>
<br>
* Group 4 Instructions
    * Encoding:  ``1011 ooof  aaaa bbbb  iiii iiii iiii iiii``
    * ``o``:  Opcode
    * ``f``:  if 0, no flags affected.  1 otherwise.
    * ``a``:  <code>rA</code> &emsp; &emsp; // register number "A"
    * ``b``:  (<code>rB</code> &emsp; &emsp; // register number "B") &emsp; **or** &emsp; (<code>sB</code> &emsp; &emsp; // special register number "B")
    * ``i``:  16-bit immediate value
* <b>adci</b> rA, rB, imm16
    * Opcode:  0b000
    * Effect:  <code>rA <= rB + zero\_extend\_to\_32(imm16) + flags<sub>c</sub>;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>sbci</b> rA, rB, imm16
    * Opcode:  0b001
    * Effect:  <code>rA <= rB + (~zero\_extend\_to\_32(imm16)) + flags<sub>c</sub>;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>lsli</b> rA, rB, imm16
    * Opcode:  0b010
    * Effect:  <code>rA <= rB << imm16;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>lsri</b> rA, rB, imm16
    * Opcode:  0b011
    * Effect:  <code>rA <= rB logically right shifted by imm16;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>asri</b> rA, rB, imm16
    * Opcode:  0b100
    * Effect:  <code>rA <= rB arithmetic right shifted by imm16;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>addsi</b> rA, sB, imm16
    * Opcode:  0b101
    * Effect:  <code>rA <= sB + sign\_extend\_to\_32(imm16);</code>
    * Doesn't affect ``flags``.
* <b>cpysi</b> rA, imm16
    * Opcode:  0b110
    * Effect:  <code>rA <= sign\_extend\_to\_32(imm16;)</code>
    * Doesn't affect ``flags``.
* <b>cpyihi</b> rA, imm16
    * Opcode:  0b111
    * Effect:  <code>rA[31:16] <= imm16;</code>
    * Doesn't affect ``flags``.
<br>
<br>
* Group 5 Instructions
    * Encoding:  ``1100 oooo  iiii iiii``
    * ``o``:  Opcode
    * ``i``:  8-bit immediate value
* <b>bra</b> imm8
    * Opcode:  0b0000
    * Effect:  <code>pc <= pc + sign\_extend\_to\_32(imm8;)</code>
    * Doesn't affect ``flags``.
* <b>bnv</b> imm8
    * Opcode:  0b0001
    * Effect:  <code>pc <= pc + 0;</code>
    * Doesn't affect ``flags``.
* <b>bne</b> imm8
    * Opcode:  0b0010
    * Effect:  <code>if (flags<sub>z</sub> == 0) begin pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Doesn't affect ``flags``.
* <b>beq</b> imm8
    * Opcode:  0b0011
    * Effect:  <code>if (flags<sub>z</sub> == 1) begin pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Doesn't affect ``flags``.
* <b>bcc</b> imm8
    * Opcode:  0b0100
    * Effect:  <code>if (flags<sub>c</sub> == 0) begin pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Note:  unsigned less than
    * Doesn't affect ``flags``.
* <b>bcs</b> imm8
    * Opcode:  0b0101
    * Effect:  <code>if (flags<sub>c</sub> == 1) begin pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Note:  unsigned greater than or equal
    * Doesn't affect ``flags``.
* <b>bls</b> imm8
    * Opcode:  0b0110
    * Effect:  <code>if ((flags<sub>c</sub> == 0) || (flags<sub>z</sub> == 1))
    begin 
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Note:  unsigned less than or equal
    * Doesn't affect ``flags``.
* <b>bhi</b> imm8
    * Opcode:  0b0111
    * Effect:  <code>if (flags<sub>c</sub> == 1) &amp;&amp; flags<sub>z</sub> == 0) 
    begin 
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Note:  unsigned greater than
    * Doesn't affect ``flags``.
* <b>bvc</b> imm8
    * Opcode:  0b1000
    * Effect:  <code>if (flags<sub>v</sub> == 0) 
    begin 
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Doesn't affect ``flags``.
* <b>bvs</b> imm8
    * Opcode:  0b1001
    * Effect:  <code>if (flags<sub>v</sub> == 1) 
    begin 
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Doesn't affect ``flags``.
* <b>bpl</b> imm8
    * Opcode:  0b1010
    * Effect:  <code>if (flags<sub>n</sub> == 0) 
    begin 
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Doesn't affect ``flags``.
* <b>bmi</b> imm8
    * Opcode:  0b1011
    * Effect:  <code>if (flags<sub>n</sub> == 1) 
    begin 
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Doesn't affect ``flags``.
* <b>blt</b> imm8
    * Opcode:  0b1100
    * Effect:  <code>if (flags<sub>n</sub> != flags<sub>v</sub>)
    begin
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Note:  signed less than
    * Doesn't affect ``flags``.
* <b>bge</b> imm8
    * Opcode:  0b1101
    * Effect:  <code>if (flags<sub>n</sub> == flags<sub>v</sub>)
    begin
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Note:  signed greater than or equal
    * Doesn't affect ``flags``.
* <b>ble</b> imm8
    * Opcode:  0b1110
    * Effect:  <code>if ((flags<sub>n</sub> != flags<sub>v</sub>) && (flags<sub>Z</sub> == 0))
    begin
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Note:  signed less than
    * Doesn't affect ``flags``.
* <b>bgt</b> imm8
    * Opcode:  0b1111
    * Effect:  <code>if ((flags<sub>n</sub> == flags<sub>v</sub>) || (flags<sub>Z</sub> == 1))
    begin
        pc <= pc + sign\_extend\_to\_32(imm8);
    end</code>
    * Note:  signed greater than or equal
    * Doesn't affect ``flags``.
<br>
<br>
* Group 6 Instructions
    * Encoding:  ``1101 oooo  aaaa bbbb``
    * ``o``:  Opcode
    * ``a``:  (<code>rA</code> &emsp; &emsp; // register number "A") &emsp; **or** &emsp; (<code>sA</code> &emsp; &emsp; // special register number "A")
    * ``b``:  (<code>rB</code> &emsp; &emsp; // register number "B") &emsp; **or** &emsp; (<code>sB</code> &emsp; &emsp; // special register number "B")
* <b>ei</b>
    * Opcode:  0b0000
    * Effect:  intstat <= intstat | 0x80000000
    * Doesn't affect ``flags``.
* <b>di</b>
    * Opcode:  0b0001
    * Effect:  intstat <= intstat | 0x80000000
    * Doesn't affect ``flags``.
* <b>push</b> rA, [rB]
    * Opcode:  0b0010
    * Effect:  <code>four\_bytes\_in\_mem\_at(rB) = rA; rB = rB - 4; </code>
    * Doesn't affect ``flags``.
* <b>pop</b> rA, [rB]
    * Opcode:  0b0011
    * Effect:  <code>rB = rB + 4; rA = four\_bytes\_in\_mem\_at(rB);</code>
    * Doesn't affect ``flags``.
* <b>push</b> sA, [rB]
    * Opcode:  0b0100
    * Effect:  <code>four\_bytes\_in\_mem\_at(rB) = sA; rB = rB - 4; </code>
    * Doesn't affect ``flags``.
* <b>pop</b> sA, [rB]
    * Opcode:  0b0101
    * Effect:  <code>rB = rB + 4; sA = four\_bytes\_in\_mem\_at(rB);</code>
    * Doesn't affect ``flags``.
* <b>ldb</b> rA, [rB]
    * Opcode:  0b0110
    * Effect:  <code>rA <= zero\_extend\_to\_32(byte\_in\_mem\_at(rB));</code>
    * Doesn't affect ``flags``.
* <b>ldsb</b> rA, [rB]
    * Opcode:  0b0111
    * Effect:  <code>rA <= sign\_extend\_to\_32(byte\_in\_mem\_at(rB));</code>
    * Doesn't affect ``flags``.
* <b>stb</b> rA, [rB]
    * Opcode:  0b1000
    * Effect:  <code>byte\_in\_mem\_at(rB) <= (rA[7:0]);</code>
    * Doesn't affect ``flags``.
* <b>ldh</b> rA, [rB]
    * Opcode:  0b1001
    * Effect:  <code>rA <= zero\_extend\_to\_32(two\_bytes\_in\_mem\_at(rB));</code>
    * Doesn't affect ``flags``.
* <b>ldsh</b> rA, [rB]
    * Opcode:  0b1010
    * Effect:  <code>rA <= sign\_extend\_to\_32(two\_bytes\_in\_mem\_at(rB));</code>
    * Doesn't affect ``flags``.
* <b>sth</b> rA, [rB]
    * Opcode:  0b1011
    * Effect:  <code>two\_bytes\_in\_mem\_at(rB) <= (rA[15:0]);</code>
    * Doesn't affect ``flags``.
* <b>ldr</b> rA, [sB]
    * Opcode:  0b1100
    * Effect:  <code>rA <= four\_bytes\_in\_mem\_at(sB);</code>
    * Doesn't affect ``flags``.
* <b>str</b> rA, [sB]
    * Opcode:  0b1101
    * Effect:  <code>four\_bytes\_in\_mem\_at(sB) <= rA;</code>
    * Doesn't affect ``flags``.
* <b>call</b> rA
    * Opcode:  0b1110
    * Effect:  <code>lr <= pc + 2; pc <= rA;</code>
    * Doesn't affect ``flags``.
* <b>add</b> pc, rA, rB
    * Opcode:  0b1111
    * Effect:  <code>pc <= rA + rB;</code>
    * Note:  Shorter encoding for equivalent Group 8 instruction
    * Doesn't affect ``flags``.
<br>
<br>
* Group 7 Instruction
    * Encoding:  ``1110 iiii  iiii iiii  iiii iiii  iiii iiii``
    * ``i``:  28-bit immediate value
* <b>callr</b> 
    * Effect:  <code>lr <= pc + 2; pc <= pc + sign\_extend\_to\_32(imm28);</code>
    * Doesn't affect ``flags``.
<br>
<br>
* Group 8 Instructions
    * Encoding:  ``1111 0000  dddf aaaa  bbbb cccc  xyzo oooo``
    * ``o``:  Opcode
    * ``d``:  ALU instruction addressing mode
    * ``f``:  if 0, no flags affected.  1 otherwise.
    * ``a``:  (<code>rA</code> &emsp; &emsp; // register number "A") &emsp; **or** &emsp; (<code>sA</code> &emsp; &emsp; // special register number "A")
    * ``b``:  (<code>rB</code> &emsp; &emsp; // register number "B") &emsp; **or** &emsp; (<code>sB</code> &emsp; &emsp; // special register number "B")
    * ``c``:  (<code>rC</code> &emsp; &emsp; // register number "C") &emsp; **or** &emsp; (<code>sC</code> &emsp; &emsp; // special register number "C")
    * ``x``:  0 if ``a`` is for rA; 1 if ``a`` is for rA
    * ``y``:  0 if ``b`` is for rB; 1 if ``b`` is for rB
    * ``z``:  0 if ``c`` is for rC; 1 if ``c`` is for rC
* ALU Instruction Addressing Modes:
    * ALU Instr Addressing Mode bits:  0b000
        * <b>&lt;aluop\_non\_cmp&gt;</b> rsA, rsB, rsC
            * Arguments:  dst:  rsA, Arg1:  rsB, Arg2:  rsC
        * <b>&lt;cmp&gt;</b> rsB, rsC
            * Arguments:  Arg1:  rsB, Arg2:  rsC
    * ALU Instr Addressing Mode bits:  0b001
        * <b>&lt;aluop&gt;</b> rsA, [rsB, rsC]
            * Arguments:  dst:  rsA, Arg1:  rsA, Arg2:  byte\_in\_mem\_at(rsB + rsB)
* Note:  "rsX" means "rX" **or** "sX"
* Note:  If dst is ``flags``, then ``flags`` won't be written.
* <b>add</b> alu\_addressing\_mode
    * Opcode:  0b00000
    * Effect:  <code>dst <= Arg1 + Arg2;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>sub</b> alu\_addressing\_mode
    * Opcode:  0b00001
    * Effect:  <code>dst <= Arg1 - Arg2;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>cmp</b> alu\_addressing\_mode
    * Opcode:  0b00010
    * Effect:  <code>&lt;discard&gt; <= Arg1 - Arg2;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>and</b> alu\_addressing\_mode
    * Opcode:  0b00011
    * Effect:  <code>dst <= Arg1 &amp; Arg2;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>orr</b> alu\_addressing\_mode
    * Opcode:  0b00100
    * Effect:  <code>dst <= Arg1 | Arg2;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>xor</b> alu\_addressing\_mode
    * Opcode:  0b00101
    * Effect:  <code>dst <= Arg1 ^ Arg2;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>ldrx</b> rsA, [rsB, rsC]
    * Opcode:  0b00110
    * Effect:  <code>rsA <= four\_bytes\_in\_mem\_at(rsB + rsC);</code>
    * Doesn't affect ``flags``.
* <b>strx</b> rsA, [rsB, rsC]
    * Opcode:  0b00111
    * Effect:  <code>four\_bytes\_in\_mem\_at(rsB + rsC) <= rsA;</code>
    * Doesn't affect ``flags``.
* <b>adc</b> alu\_addressing\_mode
    * Opcode:  0b01000
    * Effect:  <code>dst <= Arg1 + Arg2 + flags<sub>C</sub>;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>sbc</b> alu\_addressing\_mode
    * Opcode:  0b01001
    * Effect:  <code>dst <= Arg1 + (~Arg2) + flags<sub>C</sub>;</code>
    * Can affect ``nvzc`` ``flags`` if ``f`` encoding bit == 1.
* <b>lsl</b> alu\_addressing\_mode
    * Opcode:  0b01010
    * Effect:  <code>dst <= Arg1 << Arg2;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>lsr</b> alu\_addressing\_mode
    * Opcode:  0b01011
    * Effect:  <code>dst <= Arg1 logically right shifted by Arg2;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>asr</b> alu\_addressing\_mode
    * Opcode:  0b01100
    * Effect:  <code>dst <= Arg1 arithmetic right shifted by Arg2;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>rol</b> alu\_addressing\_mode
    * Opcode:  0b01101
    * Effect:  <code>dst <= Arg1 rotated left by Arg2;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>ror</b> alu\_addressing\_mode
    * Opcode:  0b01110
    * Effect:  <code>dst <= Arg1 rotated right by Arg2;</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>umull</b> rsA, rsB
    * Opcode:  0b01111
    * Effect:  <code>{hi, lo} <= zero\_extend\_to\_64(rsA)
    &ast; zero\_extend\_to\_64(rsB);</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>smull</b> rsA, rsB
    * Opcode:  0b01111
    * Effect:  <code>{hi, lo} <= sign\_extend\_to\_64(rsA) 
    &ast; sign\_extend\_to\_64(rsB);</code>
    * Can affect ``nz`` ``flags`` if ``f`` encoding bit == 1.
* <b>ldbx</b> rsA, [rsB, rsC]
    * Opcode:  0b10001
    * Effect:  <code>rsA <= zero\_extend\_to\_32(byte\_in\_mem\_at(rsB + rsC));</code>
    * Doesn't affect ``flags``.
* <b>ldsbx</b> rsA, [rsB, rsC]
    * Opcode:  0b10010
    * Effect:  <code>rsA <= sign\_extend\_to\_32(byte\_in\_mem\_at(rsB + rsC));</code>
    * Doesn't affect ``flags``.
* <b>stbx</b> rsA, [rsB, rsC]
    * Opcode:  0b10011
    * Effect:  <code>byte\_in\_mem\_at(rsB + rsC) <= (rsA[7:0]);</code>
    * Doesn't affect ``flags``.
* <b>ldhx</b> rsA, [rsB, rsC]
    * Opcode:  0b10100
    * Effect:  <code>rsA <= zero\_extend\_to\_32(two\_bytes\_in\_mem\_at(rsB + rsC));</code>
    * Doesn't affect ``flags``.
* <b>ldshx</b> rsA, [rsB, rsC]
    * Opcode:  0b10101
    * Effect:  <code>rsA <= sign\_extend\_to\_32(two\_bytes\_in\_mem\_at(rsB + rsC));</code>
    * Doesn't affect ``flags``.
* <b>sthx</b> rsA, [rsB, rsC]
    * Opcode:  0b10110
    * Effect:  <code>two\_bytes\_in\_mem\_at(rsB + rsC) <= (rsA[15:0]);</code>
    * Doesn't affect ``flags``.

	`ifdef FORMAL
	localparam __ENUM__IG0OPER__ADD_THREEREGS
		= PkgSnow64InstrDecoder::Add_ThreeRegs;
	localparam __ENUM__IOG0OPER__SUB_THREEREGS
		= PkgSnow64InstrDecoder::Sub_ThreeRegs;
	localparam __ENUM__IOG0OPER__SLT_THREEREGS
		= PkgSnow64InstrDecoder::Slt_ThreeRegs;
	localparam __ENUM__IOG0OPER__MUL_THREEREGS
		= PkgSnow64InstrDecoder::Mul_ThreeRegs;

	localparam __ENUM__IOG0OPER__DIV_THREEREGS
		= PkgSnow64InstrDecoder::Div_ThreeRegs;
	localparam __ENUM__IOG0OPER__AND_THREEREGS
		= PkgSnow64InstrDecoder::And_ThreeRegs;
	localparam __ENUM__IOG0OPER__ORR_THREEREGS
		= PkgSnow64InstrDecoder::Orr_ThreeRegs;
	localparam __ENUM__IOG0OPER__XOR_THREEREGS
		= PkgSnow64InstrDecoder::Xor_ThreeRegs;

	localparam __ENUM__IOG0OPER__SHL_THREEREGS
		= PkgSnow64InstrDecoder::Shl_ThreeRegs;
	localparam __ENUM__IOG0OPER__SHR_THREEREGS
		= PkgSnow64InstrDecoder::Shr_ThreeRegs;
	localparam __ENUM__IOG0OPER__INV_THREEREGS
		= PkgSnow64InstrDecoder::Inv_ThreeRegs;
	localparam __ENUM__IOG0OPER__NOT_THREEREGS
		= PkgSnow64InstrDecoder::Not_ThreeRegs;

	localparam __ENUM__IOG0OPER__ADD_ONEREGONEPCONESIMM12
		= PkgSnow64InstrDecoder::Add_OneRegOnePcOneSimm12;
	localparam __ENUM__IOG0OPER__BAD0_IOG0
		= PkgSnow64InstrDecoder::Bad0_Iog0;
	localparam __ENUM__IOG0OPER__BAD1_IOG0
		= PkgSnow64InstrDecoder::Bad1_Iog0;
	localparam __ENUM__IOG0OPER__BAD2_IOG0
		= PkgSnow64InstrDecoder::Bad2_Iog0;

	localparam __ENUM__IOG1OPER__BTRU_ONEREGONESIMM20
		= PkgSnow64InstrDecoder::Btru_OneRegOneSimm20;
	localparam __ENUM__IOG1OPER__BFAL_ONEREGONESIMM20
		= PkgSnow64InstrDecoder::Bfal_OneRegOneSimm20;
	localparam __ENUM__IOG1OPER__JMP_ONEREG
		= PkgSnow64InstrDecoder::Jmp_OneReg;
	localparam __ENUM__IOG1OPER__EI_NOARGS
		= PkgSnow64InstrDecoder::Ei_NoArgs;

	localparam __ENUM__IOG1OPER__DI_NOARGS
		= PkgSnow64InstrDecoder::Di_NoArgs;
	localparam __ENUM__IOG1OPER__RETI_NOARGS
		= PkgSnow64InstrDecoder::Reti_NoArgs;
	localparam __ENUM__IOG1OPER__CPY_ONEREGONEIE
		= PkgSnow64InstrDecoder::Cpy_OneRegOneIe;
	localparam __ENUM__IOG1OPER__CPY_ONEREGONEIRETA
		= PkgSnow64InstrDecoder::Cpy_OneRegOneIreta;

	localparam __ENUM__IOG1OPER__CPY_ONEREGONEIDSTA
		= PkgSnow64InstrDecoder::Cpy_OneRegOneIdsta;
	localparam __ENUM__IOG1OPER__CPY_ONEIEONEREG
		= PkgSnow64InstrDecoder::Cpy_OneIeOneReg;
	localparam __ENUM__IOG1OPER__CPY_ONEIRETAONEREG
		= PkgSnow64InstrDecoder::Cpy_OneIretaOneReg;
	localparam __ENUM__IOG1OPER__CPY_ONEIDSTAONEREG
		= PkgSnow64InstrDecoder::Cpy_OneIdstaOneReg;

	localparam __ENUM__IOG1OPER__BAD0_IOG1
		= PkgSnow64InstrDecoder::Bad0_Iog1;
	localparam __ENUM__IOG1OPER__BAD1_IOG1
		= PkgSnow64InstrDecoder::Bad1_Iog1;
	localparam __ENUM__IOG1OPER__BAD2_IOG1
		= PkgSnow64InstrDecoder::Bad2_Iog1;
	localparam __ENUM__IOG1OPER__BAD3_IOG1
		= PkgSnow64InstrDecoder::Bad3_Iog1;

	localparam __ENUM__IOG2OPER__LDU8_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdU8_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDS8_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdS8_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDU16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdU16_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDS16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdS16_ThreeRegsOneSimm12;

	localparam __ENUM__IOG2OPER__LDU32_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdU32_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDS32_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdS32_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDU64_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdU64_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDS64_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdS64_ThreeRegsOneSimm12;

	localparam __ENUM__IOG2OPER__LDF16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdF16_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__BAD0_IOG2
		= PkgSnow64InstrDecoder::Bad0_Iog2;
	localparam __ENUM__IOG2OPER__BAD1_IOG2
		= PkgSnow64InstrDecoder::Bad1_Iog2;
	localparam __ENUM__IOG2OPER__BAD2_IOG2
		= PkgSnow64InstrDecoder::Bad2_Iog2;

	localparam __ENUM__IOG2OPER__BAD3_IOG2
		= PkgSnow64InstrDecoder::Bad3_Iog2;
	localparam __ENUM__IOG2OPER__BAD4_IOG2
		= PkgSnow64InstrDecoder::Bad4_Iog2;
	localparam __ENUM__IOG2OPER__BAD5_IOG2
		= PkgSnow64InstrDecoder::Bad5_Iog2;
	localparam __ENUM__IOG2OPER__BAD6_IOG2
		= PkgSnow64InstrDecoder::Bad6_Iog2;

	localparam __ENUM__IOG3OPER__STU8_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StU8_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STS8_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StS8_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STU16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StU16_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STS16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StS16_ThreeRegsOneSimm12;

	localparam __ENUM__IOG3OPER__STU32_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StU32_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STS32_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StS32_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STU64_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StU64_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STS64_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StS64_ThreeRegsOneSimm12;

	localparam __ENUM__IOG3OPER__STF16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StF16_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__BAD0_IOG3
		= PkgSnow64InstrDecoder::Bad0_Iog3;
	localparam __ENUM__IOG3OPER__BAD1_IOG3
		= PkgSnow64InstrDecoder::Bad1_Iog3;
	localparam __ENUM__IOG3OPER__BAD2_IOG3
		= PkgSnow64InstrDecoder::Bad2_Iog3;

	localparam __ENUM__IOG3OPER__BAD3_IOG3
		= PkgSnow64InstrDecoder::Bad3_Iog3;
	localparam __ENUM__IOG3OPER__BAD4_IOG3
		= PkgSnow64InstrDecoder::Bad4_Iog3;
	localparam __ENUM__IOG3OPER__BAD5_IOG3
		= PkgSnow64InstrDecoder::Bad5_Iog3;
	localparam __ENUM__IOG3OPER__BAD6_IOG3
		= PkgSnow64InstrDecoder::Bad6_Iog3;

	localparam __ENUM__IOG4OPER__INU8_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InU8_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INS8_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InS8_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INU16_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InU16_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INS16_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InS16_TwoRegsOneSimm16;

	localparam __ENUM__IOG4OPER__INU32_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InU32_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INS32_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InS32_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INU64_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InU64_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INS64_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InS64_TwoRegsOneSimm16;

	localparam __ENUM__IOG4OPER__OUT_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::Out_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__BAD0_IOG4
		= PkgSnow64InstrDecoder::Bad0_Iog4;
	localparam __ENUM__IOG4OPER__BAD1_IOG4
		= PkgSnow64InstrDecoder::Bad1_Iog4;
	localparam __ENUM__IOG4OPER__BAD2_IOG4
		= PkgSnow64InstrDecoder::Bad2_Iog4;

	localparam __ENUM__IOG4OPER__BAD3_IOG4
		= PkgSnow64InstrDecoder::Bad3_Iog4;
	localparam __ENUM__IOG4OPER__BAD4_IOG4
		= PkgSnow64InstrDecoder::Bad4_Iog4;
	localparam __ENUM__IOG4OPER__BAD5_IOG4
		= PkgSnow64InstrDecoder::Bad5_Iog4;
	localparam __ENUM__IOG4OPER__BAD6_IOG4
		= PkgSnow64InstrDecoder::Bad6_Iog4;
	`endif		// FORMAL

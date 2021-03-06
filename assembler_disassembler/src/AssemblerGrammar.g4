grammar AssemblerGrammar;

// Parser rules
program:
	line*
	;

line:
	scopedLines
	| label TokNewline
	| instruction TokNewline
	| pseudoInstruction TokNewline
	| directive TokNewline
	| TokNewline // Allow blank lines and lines with only a comment
	;

scopedLines:
	TokLBrace TokNewline
	line*
	TokRBrace TokNewline
	;

label: 
	identName TokColon
	;

instruction:
	instrOpGrp0ThreeRegsScalar
	| instrOpGrp0TwoRegsScalar
	| instrOpGrp0OneRegOnePcOneSimm12Scalar
	| instrOpGrp0TwoRegsOneSimm12Scalar

	| instrOpGrp0ThreeRegsVector
	| instrOpGrp0TwoRegsVector
	| instrOpGrp0OneRegOnePcOneSimm12Vector
	| instrOpGrp0TwoRegsOneSimm12Vector

	| instrOpGrp0ThreeRegsOneSimm12
	| instrOpGrp0SimSyscall

	| instrOpGrp1RelBranch
	| instrOpGrp1Jump

	| instrOpGrp2LdThreeRegsOneSimm12
	| instrOpGrp3StThreeRegsOneSimm12
	;


instrOpGrp0ThreeRegsScalar:
	(TokInstrNameAdds | TokInstrNameSubs
	| TokInstrNameSlts | TokInstrNameMuls

	| TokInstrNameDivs | TokInstrNameAnds
	| TokInstrNameOrrs | TokInstrNameXors

	| TokInstrNameShls | TokInstrNameShrs)
	regOrIdentName TokComma regOrIdentName TokComma regOrIdentName
	;
instrOpGrp0TwoRegsScalar:
	(TokInstrNameInvs | TokInstrNameNots)
	regOrIdentName TokComma regOrIdentName
	;
instrOpGrp0OneRegOnePcOneSimm12Scalar:
	//TokInstrNameAdds
	TokInstrNameAddis
	regOrIdentName TokComma TokPcReg TokComma expr
	;
instrOpGrp0TwoRegsOneSimm12Scalar:
	TokInstrNameAddis
	regOrIdentName TokComma regOrIdentName TokComma expr
	;

instrOpGrp0ThreeRegsVector:
	(TokInstrNameAddv | TokInstrNameSubv
	| TokInstrNameSltv | TokInstrNameMulv

	| TokInstrNameDivv | TokInstrNameAndv
	| TokInstrNameOrrv | TokInstrNameXorv

	| TokInstrNameShlv | TokInstrNameShrv)
	regOrIdentName TokComma regOrIdentName TokComma regOrIdentName
	;
instrOpGrp0TwoRegsVector:
	(TokInstrNameInvv | TokInstrNameNotv)
	regOrIdentName TokComma regOrIdentName
	;
instrOpGrp0OneRegOnePcOneSimm12Vector:
	//TokInstrNameAddv
	TokInstrNameAddiv
	regOrIdentName TokComma TokPcReg TokComma expr
	;
instrOpGrp0TwoRegsOneSimm12Vector:
	TokInstrNameAddiv
	regOrIdentName TokComma regOrIdentName TokComma expr
	;

instrOpGrp0ThreeRegsOneSimm12:
	TokInstrNameSimSyscall
	regOrIdentName TokComma regOrIdentName TokComma regOrIdentName TokComma
	expr
	;

instrOpGrp0SimSyscall:
	TokInstrNameSyscDispRegs regOrIdentName TokComma regOrIdentName
	TokComma regOrIdentName
	| TokInstrNameSyscDispDdestVectorData regOrIdentName
	| TokInstrNameSyscDispDdestScalarData regOrIdentName
	| TokInstrNameSyscDispDdestAddr regOrIdentName
	| TokInstrNameSyscFinish
	;


instrOpGrp1RelBranch:
	(TokInstrNameBnz | TokInstrNameBzo)
	regOrIdentName TokComma expr
	;
instrOpGrp1Jump:
	TokInstrNameJmp regOrIdentName
	;

instrOpGrp2LdThreeRegsOneSimm12:
	(TokInstrNameLdU8 | TokInstrNameLdS8
	| TokInstrNameLdU16 | TokInstrNameLdS16
	| TokInstrNameLdU32 | TokInstrNameLdS32
	| TokInstrNameLdU64 | TokInstrNameLdS64
	| TokInstrNameLdF16)
	regOrIdentName TokComma regOrIdentName TokComma regOrIdentName TokComma
	expr
	;
instrOpGrp3StThreeRegsOneSimm12:
	(TokInstrNameStU8 | TokInstrNameStS8
	| TokInstrNameStU16 | TokInstrNameStS16
	| TokInstrNameStU32 | TokInstrNameStS32
	| TokInstrNameStU64 | TokInstrNameStS64
	| TokInstrNameStF16)
	regOrIdentName TokComma regOrIdentName TokComma regOrIdentName TokComma
	expr
	;




pseudoInstruction:
	pseudoInstrBraOneSimm20
	| pseudoInstrBlOneSimm20
	| pseudoInstrJlOneReg
	| pseudoInstrPcrelOneRegOneSimm12Scalar
	| pseudoInstrPcrelOneRegOneSimm12Vector
	| pseudoInstrCpysTwoRegs
	| pseudoInstrCpyisOneRegOneSimm12
	;

pseudoInstrBraOneSimm20:
	TokPseudoInstrNameBra expr
	;

pseudoInstrBlOneSimm20:
	TokPseudoInstrNameBl expr
	;

pseudoInstrJlOneReg:
	TokPseudoInstrNameJl regOrIdentName
	;


pseudoInstrPcrelOneRegOneSimm12Scalar:
	TokPseudoInstrNamePcrels regOrIdentName TokComma expr
	;
pseudoInstrPcrelOneRegOneSimm12Vector:
	TokPseudoInstrNamePcrelv regOrIdentName TokComma expr
	;

pseudoInstrCpysTwoRegs:
	TokPseudoInstrNameCpys regOrIdentName TokComma regOrIdentName
	;

pseudoInstrCpyisOneRegOneSimm12:
	TokPseudoInstrNameCpyis regOrIdentName TokComma expr
	;


// Assembler directives 
directive:
	dotOrgDirective
	| dotSpaceDirective
	| dotEquDirective
	| dotDb64Directive
	| dotDb32Directive
	| dotDb16Directive
	| dotDb8Directive
	| dotCodeAlignDirective
	| dotDataAlignDirective
	;


// Change the program counter to the value of an expression
dotOrgDirective:
	TokDotOrg expr
	;

// Add the value of an expression to the program counter (allows allocating
// global variables)
dotSpaceDirective:
	TokDotSpace expr
	;

// Raw 64-bit constants
dotDb64Directive:
	TokDotDb64 expr ((TokComma expr)*)
	;

// Raw 32-bit constants
dotDb32Directive:
	TokDotDb32 expr ((TokComma expr)*)
	;

// Raw 16-bit constants
dotDb16Directive:
	TokDotDb16 expr ((TokComma expr)*)
	;

// Raw 8-bit constants
dotDb8Directive:
	TokDotDb8 expr ((TokComma expr)*)
	;


dotCodeAlignDirective:
	TokDotCodeAlign
	;
dotDataAlignDirective:
	TokDotDataAlign
	;

dotEquDirective:
	TokDotEqu identName expr
	;

expr:
	exprLogical
	| expr TokOpLogical exprLogical
	;

exprLogical:
	exprCompare
	| exprLogical TokOpCompare exprCompare
	;

//exprCompare:
//	exprAddSub
//	//| exprCompare TokOpAddSub exprAddSub
//	| exprJustAdd
//	| exprJustSub
//	;
//
//exprJustAdd: exprCompare TokPlus exprAddSub  ;
//exprJustSub: exprCompare TokMinus exprAddSub ;
exprCompare:
	exprAddSub
	| exprCompare TokPlus exprAddSub
	| exprCompare TokMinus exprAddSub
	;

exprAddSub:
	exprMulDivModEtc
	| exprAddSub TokOpMulDivMod exprMulDivModEtc
	| exprAddSub TokOpBitwise exprMulDivModEtc
	;

exprMulDivModEtc:
	exprUnary
	| numExpr
	| identName
	| currPc
	| exprDotAlign2Curr
	| exprDotAlign2Next
	| TokLParen expr TokRParen
	;

exprUnary:
	exprBitInvert
	| exprNegate
	| exprLogNot
	;

exprDotAlign2Curr:
	TokDotAlign2Curr TokLParen expr TokComma expr TokRParen
	;
exprDotAlign2Next:
	TokDotAlign2Next TokLParen expr TokComma expr TokRParen
	;

exprBitInvert: TokBitInvert expr ;
exprNegate: TokMinus expr ;
exprLogNot: TokExclamPoint expr ;

regOrIdentName:
	TokReg
	| identName
	;

// Instruction names, pseudo instruction names, register names, and
// TokRegPc are all valid identifiers, but they will **NOT** be caught by
// the TokIdent token in the lexer.  Thus, these things must be special
// cased to allow them to be used as identifiers.
identName: TokIdent | instrName | pseudoInstrName | TokReg | TokPcReg ;

instrName:
	// Group 0 Instructions
	// add dDest, dSrc0, dSrc1
	// add dDest, pc, simm12
	TokInstrNameAdds
	| TokInstrNameSubs
	| TokInstrNameSlts
	| TokInstrNameMuls

	| TokInstrNameDivs
	| TokInstrNameAnds
	| TokInstrNameOrrs
	| TokInstrNameXors

	| TokInstrNameShls
	| TokInstrNameShrs
	| TokInstrNameInvs
	| TokInstrNameNots

	| TokInstrNameAddis


	| TokInstrNameAddv
	| TokInstrNameSubv
	| TokInstrNameSltv
	| TokInstrNameMulv

	| TokInstrNameDivv
	| TokInstrNameAndv
	| TokInstrNameOrrv
	| TokInstrNameXorv

	| TokInstrNameShlv
	| TokInstrNameShrv
	| TokInstrNameInvv
	| TokInstrNameNotv

	| TokInstrNameAddiv

	| TokInstrNameSimSyscall

	| TokInstrNameSyscDispRegs
	| TokInstrNameSyscDispDdestVectorData
	| TokInstrNameSyscDispDdestScalarData
	| TokInstrNameSyscDispDdestAddr
	| TokInstrNameSyscFinish

	// Group 1 Instructions
	| TokInstrNameBnz
	| TokInstrNameBzo
	| TokInstrNameJmp

	// Group 2 Instructions
	| TokInstrNameLdU8
	| TokInstrNameLdS8
	| TokInstrNameLdU16
	| TokInstrNameLdS16
	| TokInstrNameLdU32
	| TokInstrNameLdS32
	| TokInstrNameLdU64
	| TokInstrNameLdS64
	| TokInstrNameLdF16

	// Group 3 Instructions
	| TokInstrNameStU8
	| TokInstrNameStS8
	| TokInstrNameStU16
	| TokInstrNameStS16
	| TokInstrNameStU32
	| TokInstrNameStS32
	| TokInstrNameStU64
	| TokInstrNameStS64
	| TokInstrNameStF16

	;

pseudoInstrName:
	TokPseudoInstrNameBra
	| TokPseudoInstrNameBl
	| TokPseudoInstrNameJl
	| TokPseudoInstrNamePcrels
	| TokPseudoInstrNamePcrelv
	| TokPseudoInstrNameCpys
	| TokPseudoInstrNameCpyis
	;

numExpr: TokDecNum | TokHexNum | TokBinNum;

currPc: TokPeriod ;

// Lexer rules
// ALL tokens get a lexer rule of some sort because it forces ANTLR to
// catch more (all?) syntax errors.
// So that means no raw '...' stuff in the parser rules.

LexWhitespace: (' ' | '\t' | '\\\n' ) -> skip ;
LexLineComment: ('//' | ';') (~ '\n')* -> skip ;

TokOpLogical: ('&&' | '||') ;
TokOpCompare: ('==' | '!=' | '<' | '>' | '<=' | '>=') ;
//TokOpAddSub: ('+' | '-') ;
TokPlus: '+' ;
TokMinus: '-' ;
TokOpMulDivMod: ('*' | '/' | '%') ;
TokOpBitwise: ('&' | '|' | '^' | '<<' | '>>' | '>>>') ;
TokBitInvert: '~' ;

TokDecNum: [0-9] ([0-9]*) ;
TokHexNum: '0x' ([0-9A-Fa-f]+) ;
TokBinNum: '0b' ([0-1]+) ;

// Group 0 Instructions
// add dDest, dSrc0, dSrc1
// add dDest, pc, simm12
TokInstrNameAdds: 'adds' ;
TokInstrNameSubs: 'subs' ;
TokInstrNameSlts: 'slts' ;
TokInstrNameMuls: 'muls' ;

TokInstrNameDivs: 'divs' ;
TokInstrNameAnds: 'ands' ;
TokInstrNameOrrs: 'orrs' ;
TokInstrNameXors: 'xors' ;

TokInstrNameShls: 'shls' ;
TokInstrNameShrs: 'shrs' ;

TokInstrNameInvs: 'invs' ;
TokInstrNameNots: 'nots' ;

TokInstrNameAddv: 'addv' ;
TokInstrNameSubv: 'subv' ;
TokInstrNameSltv: 'sltv' ;
TokInstrNameMulv: 'mulv' ;

TokInstrNameDivv: 'divv' ;
TokInstrNameAndv: 'andv' ;
TokInstrNameOrrv: 'orrv' ;
TokInstrNameXorv: 'xorv' ;

TokInstrNameShlv: 'shlv' ;
TokInstrNameShrv: 'shrv' ;

TokInstrNameInvv: 'invv' ;
TokInstrNameNotv: 'notv' ;

TokInstrNameAddis: 'addis' ;
TokInstrNameAddiv: 'addiv' ;

TokInstrNameSimSyscall: 'sim_syscall' ;

TokInstrNameSyscDispRegs: 'sysc_disp_regs' ;
TokInstrNameSyscDispDdestVectorData: 'sysc_disp_ddest_vector_data' ;
TokInstrNameSyscDispDdestScalarData: 'sysc_disp_ddest_scalar_data' ;
TokInstrNameSyscDispDdestAddr: 'sysc_disp_ddest_addr' ;
TokInstrNameSyscFinish: 'sysc_finish' ;

// Group 1 Instructions
TokInstrNameBnz: 'bnz' ;
TokInstrNameBzo: 'bzo' ;
TokInstrNameJmp: 'jmp' ;


// Group 2 Instructions
TokInstrNameLdU8: 'ldu8' ;
TokInstrNameLdS8: 'lds8' ;
TokInstrNameLdU16: 'ldu16' ;
TokInstrNameLdS16: 'lds16' ;
TokInstrNameLdU32: 'ldu32' ;
TokInstrNameLdS32: 'lds32' ;
TokInstrNameLdU64: 'ldu64' ;
TokInstrNameLdS64: 'lds64' ;
TokInstrNameLdF16: 'ldf16' ;

// Group 3 Instructions
TokInstrNameStU8: 'stu8' ;
TokInstrNameStS8: 'sts8' ;
TokInstrNameStU16: 'stu16' ;
TokInstrNameStS16: 'sts16' ;
TokInstrNameStU32: 'stu32' ;
TokInstrNameStS32: 'sts32' ;
TokInstrNameStU64: 'stu64' ;
TokInstrNameStS64: 'sts64' ;
TokInstrNameStF16: 'stf16' ;


// Pseudo Instructions
TokPseudoInstrNameBra: 'bra' ;
TokPseudoInstrNameBl: 'bl' ;
TokPseudoInstrNameJl: 'jl' ;
TokPseudoInstrNamePcrels: 'pcrels' ;
TokPseudoInstrNamePcrelv: 'pcrelv' ;
TokPseudoInstrNameCpys: 'cpys' ;
TokPseudoInstrNameCpyis: 'cpyis' ;


// Directives and stuff
TokDotOrg: '.org' ;
TokDotSpace: '.space' ;
TokDotEqu: '.equ' ;
TokDotDb64: '.db64' ;
TokDotDb32: '.db32' ;
TokDotDb16: '.db16' ;
TokDotDb8: '.db8' ;
TokDotAlign2Curr: '.align2curr' ;
TokDotAlign2Next: '.align2next' ;
TokDotCodeAlign: '.codealign' ;
TokDotDataAlign: '.dataalign' ;

// Punctuation, etc.
TokPeriod: '.' ;
TokComma: ',' ;
TokColon: ':' ;
TokExclamPoint: '!' ;
TokLParen: '(' ;
TokRParen: ')' ;
TokLBracket: '[' ;
TokRBracket: ']' ;
TokLBrace: '{' ;
TokRBrace: '}' ;
TokNewline: '\n' ;


TokReg:
	('dzero' | 'du0' | 'du1' | 'du2'
	| 'du3' | 'du4' | 'du5' | 'du6'
	| 'du7' | 'du8' | 'du9' | 'du10'
	| 'du11' | 'dlr' | 'dfp' | 'dsp')
	;


TokPcReg: 'pc' ;


TokIdent: [A-Za-z_] (([A-Za-z_] | [0-9])*) ;
TokOther: . ;

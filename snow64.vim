" Vim syntax file
" Language: Snow64 Assembly
" Maintainer: FL4SHK
" Latest Revision: 28 September 2018

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "snow64"

syn case match

"syn match snow64_identifier	"[a-zA-Z_][a-zA-Z_0-9]*"


syn match snow64_comment	"//.*"
syn match snow64_comment	";.*"

" Instructions
syn keyword snow64_iog0_instr	adds subs slts muls divs ands orrs xors shls shrs invs nots addis addv subv sltv mulv divv andv orrv xorv shlv shrv invv notv addiv sim_syscall
syn keyword snow64_iog1_instr	btru bfal jmp
syn keyword snow64_iog2_instr	ldu8 lds8 ldu16 lds16 ldu32 lds32 ldu64 lds64 ldf16
syn keyword snow64_iog3_instr	stu8 sts8 stu16 sts16 stu32 sts32 stu64 sts64 stf16
syn keyword snow64_pseudo_instr	bra pcrels pcrelv

syn keyword snow64_reg		dzero du0 du1 du2 du3 du4 du5 du6 du7 du8 du9 du10 du11 dlr dfp dsp pc

syn match snow64_directive	"\.org" 
syn match snow64_directive	"\.space"
syn match snow64_directive	"\.equ"
syn match snow64_directive	"\.db64"
syn match snow64_directive	"\.db32"
syn match snow64_directive	"\.db16"
syn match snow64_directive	"\.db8"
syn match snow64_directive	"\.align"
syn match snow64_directive	"\.align2next"

"syn match 

syn match snow64_number		"0\+[1-7]\=[\t\n$,; ]\|[1-9]\d*\|0[0-7][0-7]\+\|0[x][0-9a-fA-F]\+\|0[b][0-1]*"

" hi def link snow64_instr Identifier
"hi snow64_identifier ctermfg=darkcyan guifg=darkcyan
"hi snow64_comment ctermfg=darkblue guifg=darkblue
"hi snow64_instr cterm=bold ctermfg=darkgreen gui=bold guifg=darkgreen
"hi snow64_reg cterm=bold ctermfg=black gui=bold guifg=black
"hi snow64_directive ctermfg=darkyellow guifg=darkyellow
"hi snow64_number ctermfg=darkred guifg=darkred
hi def link snow64_identifier		Normal
hi def link snow64_iog0_instr		Identifier
hi def link snow64_iog1_instr		Identifier
hi def link snow64_iog2_instr		Identifier
hi def link snow64_iog3_instr		Identifier
hi def link snow64_pseudo_instr		Identifier
hi def link snow64_comment		Comment
hi def link snow64_directive		Special
hi def link snow64_reg			Structure
hi def link snow64_number		Number

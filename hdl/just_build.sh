#!/bin/bash
#../assembler_disassembler/full_assemble.sh ../assembler_disassembler/tests/first_test.snow64 >initial_mem_contents.txt.ignore
#set -e
#set -o pipefail
set -e
set -o pipefail
../assembler_disassembler/full_assemble.sh "$@" >initial_mem_contents.txt.ignore
if [ $? -ne 0 ]
then
	exit
fi

make


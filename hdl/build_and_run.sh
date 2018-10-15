#!/bin/bash
#../assembler_disassembler/full_assemble.sh ../assembler_disassembler/tests/first_test.snow64 >initial_mem_contents.txt.ignore
#set -e
#set -o pipefail
set -e
set -o pipefail
./just_build.sh "$@"

if [ $? -ne 0 ]
then
	exit
fi
#./snow64_cpu.vvp >thing.txt.ignore
./snow64_cpu.vvp

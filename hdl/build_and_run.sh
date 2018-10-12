#!/bin/bash
#../assembler_disassembler/full_assemble.sh ../assembler_disassembler/tests/first_test.snow64 >initial_mem_contents.txt.ignore
../assembler_disassembler/full_assemble.sh "$@" >initial_mem_contents.txt.ignore
make
#./snow64_cpu.vvp >thing.txt.ignore
./snow64_cpu.vvp

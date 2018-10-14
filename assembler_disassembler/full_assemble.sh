#!/bin/bash

set -e
set -o pipefail
./snow64_cpu_assembler_disassembler -b <"$@" | ./snow64_cpu_assembler_disassembler -w

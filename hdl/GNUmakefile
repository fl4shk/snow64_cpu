# systemverilog
# start stuff

# Edit these variables if more directories are needed.
SRC_DIRS := src

#end stuff

# Prefix for output file name (change this if needed!)
#PROJ := $(shell basename $(CURDIR))
PROJ := snow64_cpu

# (System)Verilog Compiler
VC := iverilog

EXTRA_IVERILOG_OPTIONS:=-g2009 -DICARUS
EXTRA_BUILD_VERILOG_OPTIONS:=-tvlog95
EXTRA_BUILD_NO_VECTOR_OPTIONS:=-DNO_VECTOR

OPTIONS_FOR_BUILD_VPP:=$(EXTRA_IVERILOG_OPTIONS)
OPTIONS_FOR_BUILD_VHDL:=$(EXTRA_IVERILOG_OPTIONS) -tvhdl
OPTIONS_FOR_BUILD_VERILOG:=$(EXTRA_IVERILOG_OPTIONS) $(EXTRA_BUILD_VERILOG_OPTIONS)
OPTIONS_FOR_BUILD_FORMAL:=$(EXTRA_IVERILOG_OPTIONS) $(EXTRA_BUILD_VERILOG_OPTIONS) -DFORMAL -DVFORMAL
OPTIONS_FOR_BUILD_SVFORMAL:=$(EXTRA_IVERILOG_OPTIONS) -E -DFORMAL -DSVFORMAL
OPTIONS_FOR_PREPROCESS:=$(EXTRA_IVERILOG_OPTIONS) -E

BUILD_VVP:=$(VC) $(OPTIONS_FOR_BUILD_VPP) -o $(PROJ).vvp
BUILD_VHDL:=$(VC) $(OPTIONS_FOR_BUILD_VHDL) -o generated_vhdl/$(PROJ).vhd
BUILD_VERILOG:=$(VC) $(OPTIONS_FOR_BUILD_VERILOG) -o generated_verilog/$(PROJ).v
BUILD_FORMAL:=$(VC) $(OPTIONS_FOR_BUILD_FORMAL) -o generated_verilog/$(PROJ).v
BUILD_SVFORMAL:=$(VC) $(OPTIONS_FOR_BUILD_SVFORMAL) -o generated_single_source_files/$(PROJ).sv
PREPROCESS:=$(VC) $(OPTIONS_FOR_PREPROCESS) -o generated_single_source_files/$(PROJ).sv


PKG_FILES := $(foreach DIR,$(SRC_DIRS),$(wildcard $(DIR)/*.pkg.sv))
SRC_FILES := $(foreach DIR,$(SRC_DIRS),$(wildcard $(DIR)/*.src.sv))

.PHONY : all
all: clean reminder
	$(BUILD_VVP) $(PKG_FILES) $(SRC_FILES)

.PHONY : vhdl
vhdl: clean reminder
	$(BUILD_VHDL) $(PKG_FILES) $(SRC_FILES)

.PHONY : verilog
verilog: clean reminder
	$(BUILD_VERILOG) $(PKG_FILES) $(SRC_FILES)

.PHONY : formal
formal: clean reminder
	$(BUILD_FORMAL) $(PKG_FILES) $(SRC_FILES)


.PHONY : svformal
svformal: clean reminder
	$(BUILD_SVFORMAL) $(PKG_FILES) $(SRC_FILES)

.PHONY : only_preprocess
only_preprocess: clean reminder
	$(PREPROCESS) $(PKG_FILES) $(SRC_FILES)


.PHONY : reminder
reminder:
	@echo "Reminder:  With Icarus Verilog, DON'T CAST BITS TO ENUMS!"

.PHONY : clean
clean:  
	rm -rf $(PROJ).vvp $(PROJ).vhd $(PROJ).v $(PROJ).sv

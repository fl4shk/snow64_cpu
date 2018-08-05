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
BUILD_VVP:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -o $(PROJ).vvp
BUILD_VHDL:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -tvhdl -o generated_vhdl/$(PROJ).vhd
BUILD_VERILOG:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -tvlog95 -o generated_verilog/$(PROJ).v
BUILD_FORMAL:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -DFORMAL -tvlog95 -o generated_verilog/$(PROJ).v
#BUILD_VERILOG:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -tverilog -o generated_verilog/$(PROJ).v
PREPROCESS:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -E -o generated_single_source_files/$(PROJ).sv


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


.PHONY : only_preprocess
only_preprocess: clean reminder
	$(PREPROCESS) $(PKG_FILES) $(SRC_FILES)


.PHONY : reminder
reminder:
	@echo "Reminder:  With Icarus Verilog, DON'T CAST BITS TO ENUMS!"

.PHONY : clean
clean:  
	rm -rf $(PROJ).vvp $(PROJ).vhd $(PROJ).v $(PROJ).sv

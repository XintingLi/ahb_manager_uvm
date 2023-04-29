TOP = tb_ahb_manager.sv
RUN_COMMON=tb_ahb_manager -L $(QUESTA_HOME)/uvm-1.2 -vopt -voptargs='+acc' -iterationlimit=100k -sv_seed random #2368276518
#add in the random seed!, look into the iterationLimit variable 
targets:
	@echo "Available Targets:"
	@echo "build : compile tb with vlog"
	@echo "run   : run tb with vsim"
	@echo "gui   : run tb with vsim in gui mode"
	
all: build run

# build:
# 	@echo "Building Project"
# 	vlog -L $(QUESTA_HOME)/uvm-1.2 tb_ahb_manager.sv

# run:
# 	@echo "Running Tests"
# 	vsim -c $(RUN_COMMON)

# gui:
# 	@echo "Running Tests with Gui"
# 	vsim -i $(RUN_COMMON)

clean:
	rm -rf work
	rm -f transcript
	rm -f *.log
	rm -f *.wlf

build: 
	vlog -L $$QUESTA_HOME/uvm-1.2 ahb_pkg.sv $(TOP) \
	-logfile tb_compile.log \
	-printinfilenames=file_search.log

run:
	vsim -c tb_ahb_manager -L \
	$$QUESTA_HOME/uvm-1.2 \
	-voptargs=+acc \
	-coverage \
	+UVM_TESTNAME="base_test" \
	+UVM_VERBOSITY=UVM_LOW \
	-do "run -all" &

run_gui:
	vsim -i tb_ahb_manager -L \
	$$QUESTA_HOME/uvm-1.2 \
	-voptargs=+acc \
	-coverage \
	+UVM_TESTNAME="base_test" \
	+UVM_VERBOSITY=UVM_LOW \
	-do "do wave.do" -do "run -all" &
COMPILER = iverilog
SIMULATOR = vvp
PYTHON = python3
.PHONY: all test clean
all: cpu.vvp test.bin
cpu.vvp: *.v
	$(COMPILER) -o $@ $^
test.bin: generate_program.py test_program.py
	$(PYTHON) generate_program.py $@
test: all
	$(SIMULATOR) cpu.vvp
clean:
	rm *.vvp *.vcd


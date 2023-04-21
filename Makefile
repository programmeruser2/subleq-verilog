COMPILER = iverilog
SIMULATOR = vvp
.PHONY: all clean
all: cpu.vvp
cpu.vvp: *.v
	$(COMPILER) -o $@ $^
clean:
	rm *.vvp *.vcd


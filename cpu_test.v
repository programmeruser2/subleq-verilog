module cpu_test;
	reg clk, reset;
	wire [63:0] mem_data;
	wire [63:0] mem_addr, mem_write_bytes;
	wire [1:0] mem_op;
	ram mem(
		.clk(clk),
		.reset(reset),
		.mem_op(mem_op),
		.mem_addr(mem_addr),
		.mem_write_bytes(mem_write_bytes),
		.mem_data(mem_data)
	);
	cpu uut(
		.clk(clk),
		.reset(reset),
		.mem_data(mem_data),
		.mem_addr(mem_addr),
		.mem_write_bytes(mem_write_bytes),
		.mem_op(mem_op)
	);
	integer i;
	initial begin
		// Dump waveforms
		`ifdef DUMP_WAVEFORM
		$dumpfile("cpu.vcd");
		$dumpvars(0, cpu_test);
		`endif
		reset = 1;
		#20;
		reset = 0;
	end
	always begin
		clk = 1;
		#10;
		clk = 0;
		#10;
	end
endmodule

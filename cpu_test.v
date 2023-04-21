module ram(
	input clk,
	input mem_op,
	input [63:0] mem_addr,
	input [63:0] mem_write_bytes,
	output reg [63:0] mem_data
);
	reg [63:0] memory[256];
	// store program (todo: don't hardcode this)
	integer i;
	initial begin
		memory[0] = 64'hff;
		memory[1] = 64'hff;
		memory[2] = 64'h00;
		// initialize memory
		for (i = 3; i < 256; i = i + 1) begin
			memory[i] = 64'h00;
		end
		for (i = 0; i < 256; i = i + 1) begin
			//$display("%h", memory[i]);
		end
	end
	always @(negedge clk) begin
		if (mem_op == 0) begin
			// read
			$display("read from 0x%h, val=0x%h", mem_addr, memory[mem_addr]);
			mem_data <= memory[mem_addr];
			//$display("mem_data=0x%h",mem_data);
		end else begin
			$display("write to 0x%h, val=0x%h", mem_addr, memory[mem_addr]);
			if (mem_addr == 8'hff) begin
				$display("console %x", memory[mem_addr]);;
			end
			memory[mem_addr] <= mem_write_bytes;
		end
	end
endmodule
module cpu_test;
	reg clk, reset;
	wire [63:0] mem_data;
	wire [63:0] mem_addr, mem_write_bytes;
	wire mem_op;
	ram mem(
		.clk(clk),
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
		for (i = 0; i < 30; i = i + 1) begin
		clk = 0;
		#10;
		clk = 1;
		#10;
		end
	end
endmodule

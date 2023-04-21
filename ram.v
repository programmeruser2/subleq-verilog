module ram(
	input clk,
	input reset,
	input [1:0] mem_op,
	input [63:0] mem_addr,
	input [63:0] mem_write_bytes,
	output reg [63:0] mem_data
);
	reg [63:0] memory[256];
	// store program (todo: don't hardcode this)
	integer i, id, len;
	always @(posedge reset) begin
		id = $fopen("test.bin", "rb");
		len = $fread(memory, id);
		for (i = len; i < 256; i = i + 1) begin
			memory[i] = 64'h00;
		end
	end
	always @(negedge clk) begin
		if (mem_op == 2'b00) begin
			// read
			//$display("read from 0x%h, val=0x%h", mem_addr, memory[mem_addr]);
			mem_data <= memory[mem_addr];
			//$display("mem_data=0x%h",mem_data);
		end else if (mem_op == 2'b01) begin
			//$display("write to 0x%h, val=0x%h", mem_addr, mem_write_bytes);
			if (mem_addr == 8'hff) begin
				$display("console %x", mem_write_bytes);
			end
			memory[mem_addr] <= mem_write_bytes;
		end
	end
endmodule


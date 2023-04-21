module cpu(
	input clk,
	input reset,
	input [63:0] mem_data,
	output reg [63:0] mem_addr,
	output reg [63:0] mem_write_bytes,
	output reg mem_op
);
	localparam state_fetch_a = 3'b000;
	localparam state_fetch_b = 3'b001;
	localparam state_fetch_c = 3'b010;
	localparam state_sub = 3'b011;
	localparam state_branch = 3'b100;
	localparam state_c_set_pc = 3'b101;
	localparam state_fetch_a_val = 3'b110;
	localparam state_fetch_b_val = 3'b111;
	

	localparam mem_write = 1;
	localparam mem_read = 0;
	reg [2:0] next_state = state_fetch_a;
	
	reg [63:0] a, b;
	reg [63:0] pc = 1'b0;

	reg signed [63:0] a_val, b_val, c_val;

	always @(posedge reset) begin
		next_state <= state_fetch_a;
		pc <= 1'b0;
	end
	always @(posedge clk) begin
		case (next_state)
			state_fetch_a: begin
				$display("pc=%h", pc);
				mem_op <= mem_read;
				mem_addr <= pc;
				next_state <= state_fetch_b;	
			end 
			state_fetch_b: begin
				a <= mem_data;
				mem_op <= mem_read;
				mem_addr <= pc+1;
				next_state <= state_fetch_a_val;
			end
			state_fetch_a_val: begin
				b <= mem_data;
				mem_op <= mem_read;
				mem_addr <= a;
				next_state <= state_fetch_b_val;
			end
			state_fetch_b_val: begin
				a_val <= mem_data;
				mem_op <= mem_read;
				mem_addr <= b;
				next_state <= state_sub;
				$display("fetch b val");
			end
			state_sub: begin
				//$display("old a_val=%h b_val=%h", a_val, mem_data);
				b_val <= mem_data - a_val;
				// doesn't work currently b/c of non blocking assignment
				//$display("new b_val=%h", b_val);
				// write to memory
				mem_op <= mem_write;
				mem_addr <= b;
				//mem_write_bytes <= b_val;
				mem_write_bytes <= mem_data - a_val;
				//$display("write %h to addr %h", b_val, b);
				next_state <= state_branch;
			end 
			state_branch: begin
				$display("branch, b_val=0x%h", b_val);
				if (b_val <= 0) begin 
					// fetch c_val
					next_state <= state_fetch_c;
				end else begin
					pc <= pc + 3;
					next_state <= state_fetch_a;
				end
			end
			state_fetch_c: begin
				mem_op <= mem_read;
				mem_addr <= pc+2;
				next_state <= state_c_set_pc;
			end
			state_c_set_pc: begin
				pc <= mem_data;
				next_state <= state_fetch_a;
			end
		endcase
	end
endmodule

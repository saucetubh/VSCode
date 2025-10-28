module seq_counter(input clk,rst, output [2:0]q); //0,2,3,5,6,0,2,...
	/*
	always @(posedge clk) begin
		if(rst) q <= 0;
		else begin
			case(q)
				0: q <= 2;
				2: q <= 3;
				3: q <= 5;
				5: q <= 6;
				6: q <= 0;
				default: q <= 0;
			endcase
		end
	end
	*/ //can simply do this also 
	assign t2 = q[2] ^ q[0];
	assign t1 = ~q[1]|(q[2] ^ q[0]);
	assign t0 = (q[2]&q[0])|(~q[2]&q[1]&~q[0]);
	t_ff t0(clk, rst, t0, q[0]);
	t_ff t1(clk, rst, t1, q[1]);
	t_ff t2(clk, rst, t2, q[2]);
endmodule

module t_ff(input clk,rst,t, output reg q);
	always @(posedge clk) begin
		if (rst) q <= 0;
		else if (t) q <= ~q;
	end
endmodule
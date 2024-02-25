module mux4_1 (
	input i0,
	input i1,
	input i2,
	input i3,
	input s0,
	input s1,	
	output out
);

wire out0;wire out1;

mux2_1 mux0 (i0,i1,s1,out0);
mux2_1 mux1 (i2,i3,s1,out1);

mux2_1 mux2 (out0,out1,s1,out);

endmodule
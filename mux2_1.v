module mux2_1 (
	input i0,
	input i1,
	input sel,
	output reg out
);
always@(sel, i0, i1)
	begin
		if(sel)
			out = i1;
		else
			out = i0;
	end
	
endmodule
	
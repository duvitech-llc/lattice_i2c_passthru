module i2c_transmitter (
    input clk,
    input rst,
    input [7:0] data,
	inout master_sda,
	input master_scl,
    inout slave_sda,
    output slave_scl,
	output sda_dir_tap,
	output start_stop_tap,
	output incycle_tap
);

// I2C state machine states
parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter TRANSMIT = 2'b10;
parameter STOP = 2'b11;

reg sda;
reg scl;
reg [1:0] state;
reg [7:0] data_reg;
reg bit_counter;

always @(posedge clk or posedge rst) begin
	if(rst) begin
        state <= IDLE;
        sda <= 1;
        scl <= 1;
        bit_counter <= 0;
    end else begin
		case(state)
			IDLE: begin
				
            end
            START: begin
				
            end
            TRANSMIT: begin
				
            end
            STOP: begin
				
            end
        endcase				
    end		
end

endmodule
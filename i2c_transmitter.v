module i2c_transmitter (
    input clk,
    input rst,
    inout master_sda,
    input master_scl,
    inout slave_sda,
    output reg slave_scl,
    output reg sda_dir_tap, // Direction of SDA: 1 for input (to FPGA), 0 for output (from FPGA)
    output reg start_stop_tap, // Tap for detecting start and stop conditions
    output reg incycle_tap // Indicates if currently in a transmission cycle
);

// I2C state machine states
parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter TRANSMIT = 2'b10;
parameter STOP = 2'b11;

reg [1:0] state = IDLE;
reg [7:0] data_reg;
reg [2:0] bit_counter; // 8 bits of data + ACK/NACK
reg sda_master_dir; // Direction control for master SDA line
reg sda_slave_dir;  // Direction control for slave SDA line


// Bidirectional SDA lines
wire sda_master_in, sda_slave_in;
assign master_sda = sda_master_dir ? 1'bz : data_reg[7]; // Drive SDA line based on direction and data bit
assign slave_sda = sda_slave_dir ? 1'bz : data_reg[7]; // Drive SDA line based on direction and data bit
assign sda_master_in = master_sda;
assign sda_slave_in = slave_sda;

always @(posedge clk or posedge rst) begin
	if(rst) begin
        state <= IDLE;
        sda_master_dir <= 1'b1; // Set SDA to input
        sda_slave_dir <= 1'b1;  // Set SDA to input
        bit_counter <= 0;
        slave_scl <= 1'b1; // Default SCL high
    end else begin
		case(state)
			IDLE: begin
                // Wait for a start condition
                if (master_scl && !sda_master_in) begin
                    state <= START;
                    start_stop_tap <= 1'b1;
                end				
            end
            START: begin
                if (!master_scl && sda_master_in) begin // Check for repeated start or stop condition
                    state <= TRANSMIT;
                    sda_master_dir <= 1'b0; // Set SDA to output to start transmission
                    //data_reg <= data; // Load data to be transmitted
                    bit_counter <= 0;
                end				
            end
            TRANSMIT: begin
                if (bit_counter < 8) begin
                    if (master_scl) begin
                        // Transmit data bit
                        data_reg <= data_reg << 1; // Shift data left
                        bit_counter <= bit_counter + 1;
                    end
                end else begin
                    sda_master_dir <= 1'b1; // Release SDA after transmission
                    state <= STOP;
                end				
            end
            STOP: begin
                if (master_scl && sda_master_in) begin
                    state <= IDLE;
                    start_stop_tap <= 1'b0;
                    incycle_tap <= 1'b0;
                end				
            end
        endcase				
    end		
end

endmodule
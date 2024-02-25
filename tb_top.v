module tb_top;

    // Inputs
    reg reset;
    reg system_clk;
    reg master_scl;
    reg master_sda;

    // Outputs
    wire slave_scl;
    wire slave_sda;
    wire sda_direction_tap;
    wire start_stop_tap;
    wire incycle_tap;

    // Instantiate the DUT
    top dut (
        .reset(reset),
        .system_clk(system_clk),
        .master_scl(master_scl),
        .master_sda(master_sda),
        .slave_scl(slave_scl),
        .slave_sda(slave_sda),
        .sda_direction_tap(sda_direction_tap),
        .start_stop_tap(start_stop_tap),
        .incycle_tap(incycle_tap)
    );

    // Clock generation
    always #5 system_clk = ~system_clk; // 100 MHz clock

    initial begin
        // Initialize inputs
        reset = 1;
        master_scl = 0;
        master_sda = 1;
        #10 reset = 0; // Deassert reset after 10 time units

        // Start condition
        master_scl = 1;
        #5 master_sda = 0;
        #5 master_scl = 0;

        // Send slave address (0x27) and write bit (0)
        for (integer i = 0; i < 8; i = i + 1) begin
            #5;
            master_scl = 1;
            master_sda = (i == 6) ? 0 : 1; // Set data bit (LSB to MSB)
            #5;
            master_scl = 0;
        end

        // Send data byte (0xAA)
        for (integer i = 0; i < 8; i = i + 1) begin
            #5;
            master_scl = 1;
            master_sda = (i == 7) ? 1 : 0; // Set data bit (LSB to MSB)
            #5;
            master_scl = 0;
        end

        // Restart condition
        master_scl = 1;
        #5 master_sda = 1;
        #5 master_sda = 0;
        #5 master_scl = 0;

        // Send slave address (0x27) and read bit (1)
        for (integer i = 0; i < 8; i = i + 1) begin
            #5;
            master_scl = 1;
            master_sda = (i == 6) ? 0 : 1; // Set data bit (LSB to MSB)
            #5;
            master_scl = 0;
        end

        // Read data byte (0x55) from slave
        for (integer i = 0; i < 8; i = i + 1) begin
            #5;
            master_scl = 1;
            #5;
            // Read data bit (LSB to MSB)
            $display("Read data bit: %d", slave_sda);
            master_scl = 0;
        end

        // Finish simulation after a certain time
        #1000;
        $finish;
    end

    // Add waveform dumping if needed
    // Example:
    // initial begin
    //     $dumpfile("waveform.vcd");
    //     $dumpvars(0, tb_top);
    //     #1000;
    // end

endmodule

`timescale 1ns / 1ps

module tb_mux2_1;

    // Parameters
    parameter PERIOD = 10; // Time period for clock
    parameter SIM_TIME = 100; // Simulation time
    
    // Signals
    reg i0, i1, sel;
    wire out;
    
    // Instantiate the module
    mux2_1 uut (
        .i0(i0),
        .i1(i1),
        .sel(sel),
        .out(out)
    );
    
    // Clock generation
    reg clk = 0;
    always #((PERIOD / 2)) clk = ~clk;
    
    // Test stimulus
    initial begin
        $dumpfile("tb_mux2_1.vcd"); // Dump waveform to VCD file
        $dumpvars(0, tb_mux2_1); // Dump all signals
        
        // Test case 1: sel = 0, i0 = 0, i1 = 0
        sel = 0; i0 = 0; i1 = 0;
        #20;
        if(out !== 0) $display("Test case 1 failed!");
        
        // Test case 2: sel = 0, i0 = 1, i1 = 0
        sel = 0; i0 = 1; i1 = 0;
        #20;
        if(out !== 1) $display("Test case 2 failed!");
        
        // Test case 3: sel = 1, i0 = 1, i1 = 0
        sel = 1; i0 = 1; i1 = 0;
        #20;
        if(out !== 0) $display("Test case 3 failed!");
        
        // Test case 4: sel = 1, i0 = 0, i1 = 1
        sel = 1; i0 = 0; i1 = 1;
        #20;
        if(out !== 1) $display("Test case 4 failed!");
        
        // Add more test cases as needed
        
        // End simulation
        #10;
        $finish;
    end

endmodule

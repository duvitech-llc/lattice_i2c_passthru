module top(
    input reset,
    input system_clk,
    inout master_sda,
    input master_scl,
    output slave_scl,
    inout slave_sda,
    output sda_direction_tap,
    output start_stop_tap,
    output incycle_tap
);

// Instantiate the i2crepeater module
i2crepeater i2c_repeater (
    .reset(reset),
    .system_clk(system_clk),
    .master_sda(master_sda),
    .master_scl(master_scl),
    .slave_scl(slave_scl),
    .slave_sda(slave_sda),
    .sda_direction_tap(sda_direction_tap),
    .start_stop_tap(start_stop_tap),
    .incycle_tap(incycle_tap)
);

endmodule

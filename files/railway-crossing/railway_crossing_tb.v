// Self-checking testbench for railway_crossing.
// Walks a train through every position, from both directions, then
// resets mid-crossing. Checks the gate, the flasher and the state
// after every step.

`timescale 1ns / 1ps

module railway_crossing_tb;

    reg  clk = 1'b0;
    reg  reset;
    reg  sensor_west, sensor_island, sensor_east;
    wire gate_closed, flasher_on;

    railway_crossing dut (
        .clk(clk), .reset(reset),
        .sensor_west(sensor_west), .sensor_island(sensor_island), .sensor_east(sensor_east),
        .gate_closed(gate_closed), .flasher_on(flasher_on)
    );

    localparam [1:0] FAR = 2'b00, APPROACHING = 2'b01, IN_CROSSING = 2'b10, LEAVING = 2'b11;

    always #5 clk = ~clk;   // 10 ns clock

    integer errors = 0;
    integer checks = 0;

    // Set the three sensors (west, island, east). Inputs change just
    // after a rising edge, the way synchronized sensor inputs would.
    task set_sensors(input w, input i, input e);
        begin
            @(posedge clk); #1;
            sensor_west = w; sensor_island = i; sensor_east = e;
        end
    endtask

    // Compare outputs and state with what we expect right now.
    task check(input exp_warn, input [1:0] exp_state, input [8*64-1:0] label);
        begin
            #1;
            checks = checks + 1;
            if (gate_closed !== exp_warn || flasher_on !== exp_warn || dut.state !== exp_state) begin
                errors = errors + 1;
                $display("FAIL %t  %0s: gate=%b flasher=%b state=%b, expected warn=%b state=%b",
                         $time, label, gate_closed, flasher_on, dut.state, exp_warn, exp_state);
            end else begin
                $display("ok   %t  %0s", $time, label);
            end
        end
    endtask

    // Wait for the next rising edge, then let the state settle.
    task step; begin @(posedge clk); #1; end endtask

    initial begin
        $timeformat(-9, 0, " ns", 7);
        $dumpfile("sim/railway_crossing.vcd");
        $dumpvars(0, railway_crossing_tb);

        // ---- Reset ---------------------------------------------------
        sensor_west = 0; sensor_island = 0; sensor_east = 0;
        reset = 1; #12; reset = 0;
        check(0, FAR, "after reset: gate open");

        // ---- Train 1: eastbound, west -> crossing -> east --------------
        set_sensors(1, 0, 0);
        check(1, FAR,         "eastbound: detected, gate closes same cycle (Mealy)");
        step; check(1, APPROACHING, "eastbound: approaching");
        set_sensors(1, 1, 0);
        step; check(1, IN_CROSSING, "eastbound: front on crossing");
        set_sensors(0, 1, 1);
        step; check(1, IN_CROSSING, "eastbound: spans crossing and east block");
        set_sensors(0, 0, 1);
        step; check(0, LEAVING,     "eastbound: crossing clear, gate opens");
        step; check(0, LEAVING,     "eastbound: tail on east block, gate stays open");
        set_sensors(0, 0, 0);
        step; check(0, FAR,         "eastbound: gone");

        // ---- Train 2: westbound, east -> crossing -> west --------------
        set_sensors(0, 0, 1);
        check(1, FAR,         "westbound: detected, gate closes same cycle (Mealy)");
        step; check(1, APPROACHING, "westbound: approaching");
        set_sensors(0, 1, 1);
        step; check(1, IN_CROSSING, "westbound: front on crossing");
        set_sensors(1, 1, 0);
        step; check(1, IN_CROSSING, "westbound: spans crossing and west block");
        set_sensors(1, 0, 0);
        step; check(0, LEAVING,     "westbound: crossing clear, gate opens");
        set_sensors(0, 0, 0);
        step; check(0, FAR,         "westbound: gone");

        // ---- Asynchronous reset while a train is on the crossing -------
        set_sensors(1, 0, 0); step;
        set_sensors(0, 1, 0);
        step; check(1, IN_CROSSING, "async reset: train on crossing, gate closed");
        #2; reset = 1;                       // between clock edges
        check(0, FAR,         "async reset: gate opens with no clock edge");
        #2; reset = 0;
        check(1, FAR,         "async reset: released, train still there, gate closes");
        step; check(1, APPROACHING, "async reset: recovering");
        step; check(1, IN_CROSSING, "async reset: back in crossing");
        set_sensors(0, 0, 1);
        step; check(0, LEAVING,     "async reset: crossing clear, gate opens");
        set_sensors(0, 0, 0);
        step; check(0, FAR,         "async reset: train gone");

        // ---- Summary ---------------------------------------------------
        #10;
        if (errors == 0) $display("\nPASS: all %0d checks passed", checks);
        else             $display("\nFAIL: %0d of %0d checks failed", errors, checks);
        $finish;
    end

endmodule

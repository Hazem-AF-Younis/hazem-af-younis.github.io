// Railway crossing controller: a four-state Mealy machine.
//
// Track layout (a train may come from either side):
//
//      sensor_west        sensor_island        sensor_east
//   ----[ west block ]----[  crossing  ]----[ east block ]----
//
// States follow the position of the train:
//   FAR          no train nearby                  gate open,   flasher off
//   APPROACHING  train detected, not yet across   gate closed, flasher on
//   IN_CROSSING  train on the crossing            gate closed, flasher on
//   LEAVING      train past the crossing,         gate open,   flasher off
//                tail still on an outer block
//
// Why Mealy: in FAR the outputs depend on the sensors directly, so the
// gate starts closing in the same clock cycle the train is detected,
// one cycle sooner than a Moore machine would react.
//
// Why LEAVING is its own state: an occupied outer block means "close
// the gate" when the train is arriving, but "do nothing" when it is the
// tail of a train that has already cleared the crossing. Only the
// state can tell the two apart.

`timescale 1ns / 1ps

module railway_crossing (
    input  wire clk,
    input  wire reset,          // asynchronous, active high
    input  wire sensor_west,    // train on the block west of the crossing
    input  wire sensor_island,  // train on the crossing itself
    input  wire sensor_east,    // train on the block east of the crossing
    output reg  gate_closed,    // 1 = gate down
    output reg  flasher_on      // 1 = warning lights flashing
);

    localparam [1:0] FAR         = 2'b00,
                     APPROACHING = 2'b01,
                     IN_CROSSING = 2'b10,
                     LEAVING     = 2'b11;

    reg  [1:0] state, next_state;
    reg        warn;   // close the gate and flash
    wire       train = sensor_west | sensor_island | sensor_east;  // any block occupied

    // State register with asynchronous reset.
    always @(posedge clk or posedge reset) begin
        if (reset) state <= FAR;
        else       state <= next_state;
    end

    // Next-state and output logic.
    always @(*) begin
        next_state = state;
        warn       = 1'b0;

        case (state)
            FAR: begin
                warn = train;                          // Mealy: react in the same cycle
                if (train) next_state = APPROACHING;
            end

            APPROACHING: begin
                warn = 1'b1;
                if (sensor_island) next_state = IN_CROSSING;
            end

            IN_CROSSING: begin
                warn = 1'b1;
                if (!sensor_island) next_state = LEAVING;
            end

            LEAVING: begin
                warn = 1'b0;
                if (!train) next_state = FAR;
            end
        endcase

        // Reset opens the gate and stops the flasher immediately,
        // without waiting for a clock edge.
        gate_closed = warn & ~reset;
        flasher_on  = warn & ~reset;
    end

endmodule

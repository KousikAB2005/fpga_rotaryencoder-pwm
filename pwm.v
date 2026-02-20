`timescale 1ns / 1ps

// =============================================================================
// Module: pwm
// Description: Static multi-channel PWM generator with 4 fixed duty cycles.
//              Uses an 8-bit counter (0-255) and combinational logic to produce
//              four simultaneous PWM outputs at 20%, 40%, 60%, and 80%.
// Author: Kousik A B
// =============================================================================

module pwm (
    input  wire       clk,       // System clock
    output reg  [3:0] pwm        // 4-channel PWM output
);

    reg [7:0] counter = 0;       // 8-bit counter (0 to 255)

    // -------------------------------------------------------------------------
    // Counter: increments every clock cycle, wraps at 255 -> 0
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        if (counter < 255)
            counter <= counter + 1;
        else
            counter <= 0;
    end

    // -------------------------------------------------------------------------
    // PWM Output: combinational comparison against fixed thresholds
    // -------------------------------------------------------------------------
    always @(*) begin
        pwm[0] = (counter < 51)  ? 1 : 0;   // 20% duty cycle  (51/256)
        pwm[1] = (counter < 102) ? 1 : 0;   // 40% duty cycle (102/256)
        pwm[2] = (counter < 153) ? 1 : 0;   // 60% duty cycle (153/256)
        pwm[3] = (counter < 204) ? 1 : 0;   // 80% duty cycle (204/256)
    end

endmodule

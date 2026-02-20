`timescale 1ns / 1ps

// =============================================================================
// Module: pwm_encoder_control
// Description: Variable PWM generator controlled by a quadrature rotary encoder.
//              Encoder channel A & B (Hall sensors) determine rotation direction.
//              Clockwise rotation increases duty cycle; CCW decreases it.
//              Initial duty cycle is 50% (127/255).
// Author: Kousik A B
// =============================================================================

module pwm_encoder_control (
    input  wire clk,            // System clock
    input  wire encoder_a,      // Encoder channel A (Hall sensor 1)
    input  wire encoder_b,      // Encoder channel B (Hall sensor 2)
    output reg  pwm_out         // PWM output signal
);

    reg [7:0] counter    = 0;   // 8-bit counter for PWM generation
    reg [7:0] duty_cycle = 127; // Duty cycle register — starts at 50%

    // -------------------------------------------------------------------------
    // Rotary Encoder Processing
    // Detects rising edge on encoder_a, then reads encoder_b for direction.
    // -------------------------------------------------------------------------
    reg encoder_a_prev;

    always @(posedge clk) begin
        encoder_a_prev <= encoder_a;            // Capture previous state of A

        // Rising edge detected on encoder A
        if (encoder_a_prev == 0 && encoder_a == 1) begin
            if (encoder_b == 1 && duty_cycle < 255)
                duty_cycle <= duty_cycle + 1;   // Clockwise  → increase duty cycle
            else if (encoder_b == 0 && duty_cycle > 0)
                duty_cycle <= duty_cycle - 1;   // Counter-CW → decrease duty cycle
        end

        counter <= counter + 1;                 // Free-running PWM counter (wraps at 255)
    end

    // -------------------------------------------------------------------------
    // PWM Output: HIGH while counter is below current duty cycle threshold
    // -------------------------------------------------------------------------
    always @(*) begin
        pwm_out = (counter < duty_cycle) ? 1 : 0;
    end

endmodule

`timescale 1ns / 1ps

// =============================================================================
// Testbench: tb_pwm_encoder_control
// Description: Simulates the rotary encoder PWM module.
//              Tests clockwise rotation (duty cycle increase) and
//              counter-clockwise rotation (duty cycle decrease).
// =============================================================================

module tb_pwm_encoder_control;

    reg clk;
    reg encoder_a;
    reg encoder_b;
    wire pwm_out;

    // Instantiate DUT
    pwm_encoder_control uut (
        .clk(clk),
        .encoder_a(encoder_a),
        .encoder_b(encoder_b),
        .pwm_out(pwm_out)
    );

    // Clock: 10ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Task: simulate one encoder tick
    task encoder_tick;
        input dir; // 1 = CW, 0 = CCW
        begin
            encoder_b = dir;
            encoder_a = 0; #20;
            encoder_a = 1; #20;
            encoder_a = 0; #20;
        end
    endtask

    initial begin
        $dumpfile("tb_pwm_encoder_control.vcd");
        $dumpvars(0, tb_pwm_encoder_control);

        encoder_a = 0;
        encoder_b = 0;
        #50;

        $display("Initial duty cycle: %0d", uut.duty_cycle);

        // Simulate 10 clockwise ticks (duty cycle should increase)
        repeat (10) encoder_tick(1);
        $display("After 10 CW ticks: duty_cycle = %0d", uut.duty_cycle);

        #500;

        // Simulate 5 counter-clockwise ticks (duty cycle should decrease)
        repeat (5) encoder_tick(0);
        $display("After 5 CCW ticks: duty_cycle = %0d", uut.duty_cycle);

        #500;
        $finish;
    end

endmodule

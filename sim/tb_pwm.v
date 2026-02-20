`timescale 1ns / 1ps

// =============================================================================
// Testbench: tb_pwm
// Description: Simulates the static multi-channel PWM module for 3 full cycles.
//              Check waveform output to verify 20/40/60/80% duty cycles.
// =============================================================================

module tb_pwm;

    reg clk;
    wire [3:0] pwm;

    // Instantiate DUT
    pwm uut (
        .clk(clk),
        .pwm(pwm)
    );

    // Clock: 10ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Run for 3 full counter cycles (256 * 10ns * 3 = 7680ns)
    initial begin
        $dumpfile("tb_pwm.vcd");
        $dumpvars(0, tb_pwm);
        #7680;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | counter=%0d | pwm=%b", $time, uut.counter, pwm);
    end

endmodule

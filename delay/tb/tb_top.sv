`timescale 1ns / 1ps

module tb_top();

    // Testbench signals
    logic clk;
    logic start;
    logic [31:0] delay_in;
    logic [31:0] done;
    
    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Instantiate DUT (Device Under Test)
    top dut (
        .clk(clk),
        .start(start),
        .delay_in(delay_in),
        .done(done)
    );
    
    // Test stimulus
    initial begin
        // Initialize signals
        start = 0;
        delay_in = 0;
        
        // Wait for a few cycles
        repeat(5) @(posedge clk);
        
        //==============================================
        // Test 1: Short delay (10 cycles)
        //==============================================
        $display("=== Test 1: delay_in = 10 ===");
        delay_in = 10;
        start = 1;
        
        // Wait for done signal
        wait(done == 32'hFFFFFFFF);
        $display("Time: %0t - Done asserted after delay of 10", $time);
        start = 0;
        @(posedge clk);
        
        
        //==============================================
        // Test 2: Longer delay (50 cycles)
        //==============================================
        $display("\n=== Test 2: delay_in = 50 ===");
        //start = 0;
        
        delay_in = 50;
        start = 1;
        @(posedge clk);
        
        wait(done == 32'hFFFFFFFF);
        $display("Time: %0t - Done asserted after delay of 50", $time);
        start = 0;
        repeat(10) @(posedge clk);
        
        $finish;
    end

endmodule
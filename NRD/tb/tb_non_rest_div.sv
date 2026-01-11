`timescale 1ns / 1ps

module tb_non_rest_div();

    parameter WIDTH = 256;
    
    logic clk, rst, start, ready;
    logic [WIDTH-1:0] dividend, divisor, remainder, quotient;
    
    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // DUT
    non_rest_div #(.WIDTH(WIDTH)) dut (.*);
    
    // Test
    initial begin
        // Reset
        rst = 0;
        start = 0;
        #50 rst = 1;
        #20;
        
        //===========================================
        // TEST 1: 100 / 10 = 10 remainder 0
        //===========================================
        $display("\nTest 1: 100 / 10");
        dividend = 100;
        divisor = 10;
        start = 1;
        @(posedge clk);
        start = 0;
        
        wait(ready);
        $display("Quotient: %0d, Remainder: %0d", quotient, remainder);
        $display("Expected: Quotient=10, Remainder=0");
        
        if (quotient == 10 && remainder == 0)
            $display("✓ PASS\n");
        else
            $display("✗ FAIL\n");
        
        #100;

        rst = 0;

        #100;

        rst = 1;
        
        //===========================================
        // TEST 2: 123 / 7 = 17 remainder 4
        //===========================================
        $display("Test 2: 123 / 7");
        dividend = 123;
        divisor = 7;
        start = 1;
        @(posedge clk);
        start = 0;
        
        wait(ready);
        $display("Quotient: %0d, Remainder: %0d", quotient, remainder);
        $display("Expected: Quotient=17, Remainder=4");
        
        if (quotient == 17 && remainder == 4)
            $display("✓ PASS\n");
        else
            $display("✗ FAIL\n");
        
        #100;
        $finish;
    end
    
    // Waveform
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_non_rest_div);
    end

endmodule
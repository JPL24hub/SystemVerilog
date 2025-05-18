`timescale 1ns / 1ps
module tb_dff;
    reg d;
    reg clk;
    reg rst;
    wire q;

    // UUT
    dff uut (
        .d(d),
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    always @() begin
        
    end



endmodule
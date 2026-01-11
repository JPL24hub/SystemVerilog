`timescale 1ns / 1ps

module mult_slave (
    input clk,
    input [31:0] a,
    input [31:0] b,
    output logic [31:0] y
);

always@(posedge clk)
begin
    y <= a * b;
end

endmodule
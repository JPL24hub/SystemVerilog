`timescale 1ns / 1ps

module top (
    input clk, start,
    input [31:0] delay_in,
    output logic [31:0] done
);

integer count = 0;

always@(posedge clk)
begin
    if (start == 1) begin
        if (count < delay_in) begin
            count <= count + 1;
            done <= 32'h00000000;
        end
        else begin
            count <= 0;
            done <= 32'hFFFFFFFF;
        end
    end

end
endmodule


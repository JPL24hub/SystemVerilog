module dut (input wire clk)
    // Signals
    wire w0, w1;
    reg r0, r1;

    // Combinatorial
    assign w0 = 1'b1;
    assign w1 = r0 & w0;

    // Sequential
    always @(posedge clk) begin
        r1 = r0 & w0;
    end

    // Initial block
    initial begin
        r0 = 1'b1;
    end

endmodule
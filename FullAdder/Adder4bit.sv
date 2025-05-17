module Adder4bit #(
    parameter WIDTH = 4
)(
    input logic [WIDTH - 1 : 0] A,
    input logic [WIDTH - 1 : 0] B,
    input logic Cin,
    output logic [WIDTH - 1 : 0] Sum,
    output logic    Cout
);

    logic [WIDTH : 0] carry; // Extra bit for initial Cin and final Cout
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin : full_adder_chain
            FullAdder FA (
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i]),
                .sum(Sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[WIDTH];
endmodule
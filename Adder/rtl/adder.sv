module adder (
    input logic [30:0] firstValue,
    input logic [30:0] secondValue,
    output logic [31:0] sum
);
    assign sum = firstValue + secondValue;
endmodule
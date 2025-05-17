
module FullAdder (
    input logic a,
    input logic b,
    input logic cin,
    output logic sum,
    output logic cout
);
    logic sum1, carry1, carry2;

    HalfAdder HA1 (.a(a), .b(b), .sum(sum1), .carry(carry1));
    HalfAdder HA2 (.a(sum1), .b(cin), .sum(sum), .carry(carry2));

    assign cout = carry1 | carry2;


endmodule;
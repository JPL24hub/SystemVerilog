`timescale 1ns / 1ps
module tb_Adder4bit;

    // Parameter to set the adder width
    parameter WIDTH = 4;

    // DUT Inputs
    logic [WIDTH - 1 : 0] A, B;
    logic Cin;

    // DUT Outputs
    logic [WIDTH - 1 : 0] Sum;
    logic Cout;

    // Intatiate the Adder
    Adder4bit #(.WIDTH(WIDTH)) uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    // Task for displaying results
    task print_result;
        input [WIDTH - 1 : 0] A_in, B_in;
        input Cin_in;
        input [WIDTH - 1 : 0] Sum_out;
        input Cout_out;
        begin
            $display("A = %0b, B = %0b, Cin = %0b, Sum = %0b, Cout = %0b", A_in, B_in, Cin_in, Sum_out, Cout_out);
        end
    endtask

    // Stimulus
    initial begin
        $display("============== N-bit Adder Testbench ==============");

        // Test case 1 : 0 + 0 + 0
        A = 'b0000; B = 'b0000; Cin = 'b0000;
        #10;
        print_result(A, B, Cin, Sum, Cout);

        // Test case 2 : 1 + 1 + 1
        A = 'b0001; B = 'b0001; Cin = 'b0001;
        #10;
        print_result(A, B, Cin, Sum, Cout);

        // Test case 3 : 10 + 2 + 0
        A = 'b1010; B = 'b0010; Cin = 'b0000;
        #10;
        print_result(A, B, Cin, Sum, Cout);

        // Finish simulation
        $finish;
        
    end
endmodule
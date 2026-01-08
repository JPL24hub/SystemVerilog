module adder_tb;
    // Signals
    logic [30:0] firstValue;
    logic [30:0] secondValue;
    logic [31:0] sum;
    // Expected output
    logic [31:0] expected_sum;
    // Test statistics
    int passed = 0;
    int failed = 0;
    // DUT instantiation
    adder dut (
        .firstValue(firstValue),
        .secondValue(secondValue),
        .sum(sum)
    );
    // Task to check results
    task check_output(input logic [31:0] exp);
        expected_sum = exp;
        #1; //Small delay for signal propagation
        if (sum === expected_sum) begin
            $display("PASS: firstValue=%d, secondValue=%d, sum=%d (expected=%d)", firstValue, secondValue, sum, expected_sum);
            passed++;
        end else begin
            $display("FAIL: firstValue=%d, secondValue=%d, sum=%d (expected=%d)", firstValue, secondValue, sum, expected_sum);
            failed++;
        end
    endtask

    // Main test sequence
    initial begin
        $display("===============================================================");
        $display("    Adder TB");
        $display("===============================================================");
        $display("\nStarting Test Cases...\n");

        // Test case 1
        firstValue = 15; secondValue = 10;
        check_output(25);
        #10;

        // Test case 2
        firstValue = 0; secondValue = 0;
        check_output(0);
        #10;

        // Test case 3
        firstValue = 31'h7FFFFFFF; secondValue = 1;
        check_output(32'h80000000);
        #10;

        // Test case 4
        firstValue = 100; secondValue = 200;
        check_output(300);
        #10;

        // Summary
        $display("\nTotal tests: %0d", passed + failed);
        $display("\nTest Summary: Passed=%0d, Failed=%0d", passed, failed);
        $finish;
    end
endmodule
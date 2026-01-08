module and_gate_tb;
    // tb signals
    logic a;
    logic b;
    logic y;
    // Expected output
    logic expected_y;
    // Test statistics
    int passed = 0;
    int failed = 0;
    // DUT instantiation
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );
    // Task to check results
    task check_output(input logic exp);
        expected_y = exp;
        #1; //Small delay for signal propagation
        if (y === expected_y) begin
            $display("PASS: a=%b, b=%b, y=%b (expected=%b)", a, b, y, expected_y);
            passed++;
        end else begin
            $display("FAIL: a=%b, b=%b, y=%b (expected=%b)", a, b, y, expected_y);
            failed++;
        end
    endtask
    // Main test sequence
    initial begin
        $display("===============================================================");
        $display("    AND Gate TB");
        $display("===============================================================");
        $display("\nStarting Test Cases...\n");

        // Test case 1: 0 & 0 = 0
        a = 0; b = 0;
        check_output(0);
        #10;

        // Test case 2: 0 & 1 = 0
        a = 0; b = 1;
        check_output(0);
        #10;

        // Test case 3: 1 & 0 = 0
        a = 1; b = 0;
        check_output(0);
        #10;

        // Test case 4: 1 & 1 = 1
        a = 1; b = 1;
        check_output(1);
        #10;

        // Additional test: verify with x and z
        a = 1'bx; b = 1;
        #10;
        $display("INFO: a=x, b=%b, y=%b (x propagation test)", b, y);
        
        a = 1'                                    bz; b = 0;
        #10;
        $display("INFO: a=z, b=%b, y=%b (z propagation test)", b, y);


        // Test summary
        $display("\n========================================");
        $display("   Test Summary");
        $display("========================================");
        $display("Total tests: %0d", passed + failed);
        $display("Passed:      %0d", passed);
        $display("Failed:      %0d", failed);
        
        if (failed == 0) begin
            $display("\nResult: ALL TESTS PASSED ✓");
        end else begin
            $display("\nResult: SOME TESTS FAILED ✗");
        end
        $display("========================================\n");
        
        $finish;
    end

    // Optional: Generate VCD waveform file for viewing
    initial begin
        $dumpfile("and_gate.vcd");
        $dumpvars(0, and_gate_tb);
    end

endmodule
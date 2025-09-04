module test();
    initial begin
        $display("Hello");
        #1 ns;
        $display("Hello again");
    end

    always #1 ns begin
        $display("Hi");
        
    end
endmodule
// Code your testbench here
// or browse Examples
module enum_typedef;
  typedef enum {GOOD, BAD} pkt_type;
  
  pkt_type pkt_a;
  pkt_type pkt_b;
  
  initial begin
    pkt_a = GOOD;
    pkt_b = BAD;
    
    if (pkt_a == GOOD)
    	$display("pkt_a is GOOD");
    else
      $display("pkt_a is BAD");
    
    if (pkt_b == GOOD)
      $display("pkt_b is GOOD");
    else
      $display("pkt_b is BAD");
  end
  
endmodule
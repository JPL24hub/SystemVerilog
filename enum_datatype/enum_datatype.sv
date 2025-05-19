//-------------------------------------------------------------------------
//				www.verificationguide.com - Enumeration Type [DataTypes]
//-------------------------------------------------------------------------
module enum_datatype;
  //declaration
  typedef enum { red=0, green, blue=4, yellow, white=10, black } colors;
  
  enum { a, b, c, d, e, f, g } alphabets;
  colors first_set;
  colors second_set;
  
  initial begin
    
    first_set = first_set.first();
    $display("first_set first color is \t %0s, \t Value = %0d", first_set.name(),first_set);
    first_set = first_set.last();
    $display("first_set last color is \t %0s, \t Value = %0d", first_set.name(),first_set);

    second_set = first_set;
    $display("second_set color is \t %0s, \t Value = %0d", second_set.name(),second_set);
    second_set =second_set.prev(2);
    $display("second_set color is \t %0s, \t Value = %0d", second_set.name(),second_set);
    second_set =second_set.next(2);
    $display("second_settttt color is \t %0s, \t Value = %0d", second_set.name(),second_set);
  
    $display("Number of members in alphabets is \t %0d",alphabets.num());
    $display("Default First members in alphabets is \t %0s , \t value is %0d",alphabets.name(),alphabets);
    alphabets=alphabets.next;
    $display("Next members in alphabets is \t %0s , \t value is %0d",alphabets.name(),alphabets);
    alphabets=alphabets.last;
    $display("Last members in alphabets is \t %0s , \t value is %0d",alphabets.name(),alphabets);
    alphabets=alphabets.prev(3);
    $display("3rd members from last in alphabets is \t %0s , \t value is %0d",alphabets.name(),alphabets);
  end
endmodule
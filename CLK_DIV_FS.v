
//-----------------------------------------------------------------------
//-- Module to divide the clock 
//-----------------------------------------------------------------------
module clk_div (  input clk,
                  output reg sclk=0);

  integer MAX_COUNT = 2000000; //Change to 1000000 to view testall blink;
  integer div_cnt =0;
   always @ (posedge clk)              
   begin
         if (div_cnt == MAX_COUNT) 
         begin 
            sclk = ~sclk;
            div_cnt = 0;
         end else
            div_cnt = div_cnt + 1;  
   end 
endmodule

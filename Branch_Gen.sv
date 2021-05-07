`timescale 1ns / 1ps

module Branch_Gen(
    input [31:0] RS1,RS2, 
    output logic BR_EQ, BR_LT, BR_LTU
    );
    
    always_comb
    begin
    
    if (RS1 == RS2)begin
       BR_EQ = 1'b1;end
       else
       begin
       BR_EQ = 1'b0;
       end
    
    if ($signed(RS1) < $signed(RS2))begin
       BR_LT = 1'b1; end
       else begin
       BR_LT = 1'b0;
       end
        
    if (RS1 < RS2)begin
       BR_LTU = 1'b1;
       end
       else begin
       BR_LTU = 1'b0;
       end
       
end       
endmodule

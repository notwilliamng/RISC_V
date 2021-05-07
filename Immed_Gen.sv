`timescale 1ns / 1ps

module Immed_Gen(
    input[31:0] DOUT1, 
    output logic [31:0] UTYPE, ITYPE, STYPE, JTYPE, BTYPE
    );
    
   assign ITYPE = {{21{DOUT1[31]}}, DOUT1[30:25], DOUT1[24:21], DOUT1[20]};
   assign STYPE = {{21{DOUT1[31]}}, DOUT1[30:25], DOUT1[11:8], DOUT1[7]};
   assign BTYPE = {{20{DOUT1[31]}},DOUT1[7],DOUT1[30:25],DOUT1[11:8],1'b0};
   assign UTYPE = {DOUT1[31],DOUT1[30:20],DOUT1[19:12],12'b0};
   assign JTYPE = {{12{DOUT1[31]}},DOUT1[19:12],DOUT1[20],DOUT1[30:25],DOUT1[24:21],1'b0};
          
endmodule

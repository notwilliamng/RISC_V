`timescale 1ns / 1ps

module Targ_Gen(
    input [31:0] JTYPE, BTYPE, ITYPE, UTYPE, RS1, PC_OUT,
    output logic [31:0] JALR, BRANCH, JAL
    );
    
   assign JALR = RS1 +ITYPE;
   assign JAL = PC_OUT + JTYPE;
   assign BRANCH = PC_OUT + BTYPE;
endmodule

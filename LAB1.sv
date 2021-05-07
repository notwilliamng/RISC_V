`timescale 1ns / 1ps
module LAB1(
    input [31:0] JALR, BRANCH, JUMP,
    input PC_WRITE, RESET, CLK, MEM_READ1,
    input [1:0] PC_SOURCE,
    output logic [31:0] DOUT
    );
    
    logic [31:0] PC_IN, PC_OUT, PC_4;
    
    mux4_1 PC_MUX (.ZERO(PC_4), .ONE(JALR), .TWO(BRANCH), .THREE(JUMP), .SEL(PC_SOURCE), .MUX_OUT(PC_IN));
    
    assign PC_4 = PC_OUT + 4;
    
    PC myPC (.CLK(CLK), .RESET(RESET), .PC_WRITE(PC_WRITE), .DOUT(PC_OUT), .DIN(PC_IN));
    
    OTTER_MEM_BYTE OTTER_MEM (.MEM_CLK(CLK), .MEM_ADDR1(PC_OUT), .MEM_READ1(MEM_READ1), .MEM_DOUT1(DOUT));
endmodule

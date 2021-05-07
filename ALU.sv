`timescale 1ns / 1ps

module ALU(
    input [31:0] A, B,
    input [3:0] ALU_FUN, 
    output logic [31:0] ALU_OUT
    );
    
    always_comb
    begin
        case(ALU_FUN)
        4'b0000: ALU_OUT = A+B;//add
        4'b1000: ALU_OUT = A-B;//sub
        4'b0110: ALU_OUT = A|B;//or
        4'b0111: ALU_OUT = A&B;//and
        4'b0100: ALU_OUT = A^B;//xor
        4'b0101: ALU_OUT = A>>B[4:0];//slr
        4'b0001: ALU_OUT = A<<B[4:0];//sll 
        4'b1101: ALU_OUT = $signed(A)>>>B[4:0];//sra
        4'b0010: ALU_OUT = ($signed(A)<$signed(B));//slt
        4'b0011: ALU_OUT = (A<B)?1:0;//sltu
        4'b1001: ALU_OUT = A;//copu(liu)
        default: ALU_OUT = 0;
        endcase
    end
endmodule

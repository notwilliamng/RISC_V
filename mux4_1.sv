`timescale 1ns / 1ps

module mux4_1(
    input [31:0] ZERO, ONE, TWO, THREE,
    input [1:0] SEL,
    output logic [31:0] MUX_OUT);
    
    always_comb
    begin
        case(SEL)
        0: MUX_OUT <= ZERO;
        1: MUX_OUT <= ONE; 
        2: MUX_OUT <= TWO;
        3: MUX_OUT <= THREE;
        default: MUX_OUT <= ZERO;
        endcase
    end
endmodule

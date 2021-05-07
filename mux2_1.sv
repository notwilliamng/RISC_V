`timescale 1ns / 1ps

module mux2_1(
    input [31:0] ZERO, ONE,
    input SEL,
    output logic [31:0] MUX_OUT);
    
    always_comb
    begin
        case(SEL)
        0: MUX_OUT <= ZERO;
        1: MUX_OUT <= ONE; 
        default: MUX_OUT <= ZERO;
        endcase
    end
endmodule

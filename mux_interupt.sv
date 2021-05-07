`timescale 1ns / 1ps

module mux_interupt(
    input [31:0] ZERO, ONE, TWO, THREE, FOUR, FIVE,
    input [2:0] SEL,
    output logic [31:0] MUX_OUT);
    
    always_comb
    begin
        case(SEL)
        0: MUX_OUT <= ZERO;
        1: MUX_OUT <= ONE; 
        2: MUX_OUT <= TWO;
        3: MUX_OUT <= THREE;
        4: MUX_OUT <= FOUR;//MTVEC
        5: MUX_OUT <= FIVE;//MEPC
        default: MUX_OUT <= ZERO;
        endcase
    end
endmodule

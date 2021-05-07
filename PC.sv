`timescale 1ns / 1ps

module PC(
    input [31:0] DIN,
    input RESET, CLK, PC_WRITE,
    output logic [31:0] DOUT = 0);
    
    always_ff @ (posedge CLK)
    begin
         if (RESET)
           DOUT <= 0;
         else if (PC_WRITE)
            DOUT <= DIN;         
    end
endmodule

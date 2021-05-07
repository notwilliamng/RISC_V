`timescale 1ns / 1ps

module RegisterFile(
    input [4:0] ADR1,ADR2, WA,
    input CLK, EN,
    input [31:0] WD,
    output logic [31:0] RS1,RS2);
    
    logic [31:0] mem [0:31];
    
    //initialize all memory to zero
    initial begin
        for (int i = 0; i< 32; i++) begin
            mem[i] = 0;
        end
    end
    
    //create synchronous write
    always_ff @(posedge CLK)
    begin
    if (EN==1 && WA !=0)
        mem[WA] <= WD;
    end
    
    //asynchronous read
    assign RS1 = mem[ADR1];
    assign RS2 = mem[ADR2];
endmodule

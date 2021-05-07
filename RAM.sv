`timescale 1ns / 1ps

module RAM(
    input [7:0] DIN,
    input [5:0] ADDRESS, 
    input WE, CLK,
    output logic [7:0] DOUT);
    logic [7:0] memory[0:63];
    initial 
    begin
        int i;
            for (i =0; i<64; i++)
            begin
                memory[i] = 0;
            end
    end
    
    always_ff @ (posedge CLK)
        begin
            if(WE)
            memory[ADDRESS] = DIN;
        end
//asynchronous read
    
endmodule

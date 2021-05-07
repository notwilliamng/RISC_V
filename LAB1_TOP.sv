`timescale 1ns / 1ps
module LAB1_TOP();

logic [31:0] JALR, BRANCH, JUMP, DOUT;
logic PC_WRITE, RESET, MEM_READ1, CLK;
logic [1:0] PC_SOURCE;

LAB1 MyLab1Top (.*);

initial
    CLK = 0;

always
begin   
    #5
    CLK = ~CLK;
end

initial
begin
    RESET = 1;
    #10;
    JALR = 341; BRANCH = 3; JUMP = 1028;
    PC_WRITE = 1; MEM_READ1 = 1; RESET = 0;
    PC_SOURCE = 0;
    #50;
    PC_SOURCE = 1;
    #10;
    PC_SOURCE = 2;
    #10;
    PC_SOURCE = 3;
    #10;
    RESET = 1;
    #10;
    RESET = 0; PC_WRITE = 0;
    #10
    PC_WRITE = 1; MEM_READ1 = 0;
end 
endmodule

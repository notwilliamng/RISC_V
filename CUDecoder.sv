`timescale 1ns / 1ps
module CUDecoder(
    input BR_EQ, BR_LT, BR_LTU,CLK,
    input [2:0] FUNC3,
    input [6:0] FUNC7, CU_OPCODE,
    input INT_TAKEN,
    output logic [3:0] ALU_FUN,
    output logic [2:0] PC_SOURCE,
    output logic [1:0] ALU_SRCB,
    output logic [1:0] RF_WR_SEL,
    output logic ALU_SRCA
    );
    
    
// Create enumberation data type for the opcode.
//Symbols tied to bit values
typedef enum logic [6:0] {
    LUI     = 7'b0110111,
    AUIPC   = 7'b0010111,
    JAL     = 7'b1101111,
    JALR    = 7'b1100111,
    BRANCH  = 7'b1100011,
    LOAD    = 7'b0000011,
    STORE   = 7'b0100011,
    OP_IMM  = 7'b0010011,
    OP      = 7'b0110011,
    SYSTEM  = 7'b1110011
} opcode_t;

opcode_t OPCODE;    //Define variable of 
                        //newly defined type
//Cast input bits as enum, for showing opcode 
    //names during simulation

assign OPCODE = opcode_t'(CU_OPCODE);
always@*

    if (OPCODE == 7'b0110111) //LIU
    begin
    ALU_FUN = 9; ALU_SRCA = 1; ALU_SRCB = 0; PC_SOURCE = 0;RF_WR_SEL = 3;
    end
    
    else if (OPCODE == 7'b0010111) //AUIPC
    begin 
    ALU_FUN = 0; ALU_SRCA = 1; ALU_SRCB = 3; PC_SOURCE = 0; RF_WR_SEL = 3;
    end
    
    else if (OPCODE == 7'b1101111) //JAL
    begin
    ALU_FUN = 0; ALU_SRCA = 0; ALU_SRCB = 0; PC_SOURCE = 3; RF_WR_SEL = 0;  
    end
    
    else if (OPCODE == 7'b1100111) //JALR
    begin
    ALU_FUN = 0; ALU_SRCA = 0; ALU_SRCB = 0; PC_SOURCE = 1; RF_WR_SEL = 0;
    end    
    
    else if (OPCODE == 7'b1100011) //BRANCH
    begin
    ALU_FUN = 0; ALU_SRCA = 0; ALU_SRCB = 0; RF_WR_SEL = 0;
    if (FUNC3 ==0 && BR_EQ ==1)
    PC_SOURCE = 2;
    else if
    (FUNC3 ==1 && BR_EQ ==0)
    PC_SOURCE = 2;
    else if
    (FUNC3 ==4 && BR_LT ==1)
    PC_SOURCE = 2;
    else if
    (FUNC3 ==5 && BR_LT ==0)
    PC_SOURCE = 2;
    else if
    (FUNC3 ==6 && BR_LTU ==1)
    PC_SOURCE = 2;
    else if
    (FUNC3 ==7 && BR_LTU ==0)
    PC_SOURCE = 2;
    else
    PC_SOURCE =0;
    end
    
    else if (OPCODE == 7'b0000011) //LOAD
    begin
    ALU_FUN = 0; ALU_SRCA = 0; ALU_SRCB = 1; PC_SOURCE = 0; RF_WR_SEL = 2;
    end
    
    else if (OPCODE == 7'b0100011) //STORE
    begin
    ALU_FUN = 0; ALU_SRCA = 0; ALU_SRCB = 2; PC_SOURCE = 0; RF_WR_SEL = 0;
    end
    
    else if (OPCODE == 7'b0010011) //OP_IMM
    begin
    ALU_SRCA = 0; ALU_SRCB = 1; PC_SOURCE = 0; RF_WR_SEL = 3;
        if (FUNC3 == 5)
        ALU_FUN = {FUNC7[5],FUNC3};
        else
        ALU_FUN = {1'b0,FUNC3};
    end
    
    else if (OPCODE == 7'b0110011) //OP
    begin
    ALU_FUN = {FUNC7[5],FUNC3}; ALU_SRCA = 0; ALU_SRCB = 0; PC_SOURCE = 0; RF_WR_SEL = 3;
    end 
    
    else if (OPCODE == 7'b1110011) //SYSTEM
    begin
    ALU_FUN = 9; ALU_SRCA = 0; ALU_SRCB = 0; RF_WR_SEL = 1;
    if (INT_TAKEN == 1)
    PC_SOURCE =4;
    else if (FUNC3 == 0)
    PC_SOURCE = 5;
    else 
    PC_SOURCE = 0;
    end 
    else //default
    begin
    ALU_FUN = 0; ALU_SRCA = 0; ALU_SRCB = 0; PC_SOURCE = 0; RF_WR_SEL =0; 
    end   
    
    
endmodule

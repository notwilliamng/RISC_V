`timescale 1ns / 1ps
module OTTER_MCU(
    input CLK, RST, INTR,
    input [31:0] IOBUS_IN,
    output logic [31:0] IOBUS_OUT, IOBUS_ADDR,
    output logic IOBUS_WR
    );
   
       
    logic [31:0] 
            BRANCH_PC,
            PC_IN, 
            PC_OUT,
            PC_4,
            RS1,
            RS2,
            JALR,
            JAL, 
            WD,
            BRANCH, 
            CSR_REG,
            DOUT1,
            DOUT2,
            A,B,
            ALU_OUT,
            UTYPE,
            ITYPE,
            STYPE, 
            JTYPE, 
            BTYPE,
            MTVEC,
            MEPC,
            CSR_RD;
           
    logic[4:0]  ADR1,
                ADR2;
            
    logic[3:0] ALU_FUN;
    
    logic [2:0] PC_SOURCE, FUNC3;
              
    logic [1:0]
            RF_WR_SEL,
            ALU_SRCB;
                        

    logic
        PC_WRITE,ALU_SRCA,REG_WRITE, MEM_WRITE, MEM_READ1, 
        MEM_READ2, BR_EQ, BR_LT, BR_LTU,WR_EN, CSR_WR, INT_TAKEN,
        CSR_MIE;

//    assign IR = DOUT1;
    assign PC_4 = PC_OUT + 4;
    assign IOBUS_ADDR = ALU_OUT;
    assign BRANCH_PC = PC_OUT + BTYPE;
    assign IOBUS_OUT = RS2;
    assign FUNC3 =DOUT1[14:12];

    OTTER_MEM_BYTE Mem2 (.MEM_ADDR1(PC_OUT), //32b instruction memory
                        .MEM_ADDR2(ALU_OUT), //32b data memory port
                        .MEM_CLK(CLK), //1
                        .MEM_DIN2(RS2), //32
                        .MEM_WRITE2(MEM_WRITE),//1
                        .MEM_READ1(MEM_READ1),//1
                        .MEM_READ2(MEM_READ2),//1
                        .IO_IN(IOBUS_IN),//32
                        //.ERR(),//1 we dont use this one yet
                        .MEM_SIZE(DOUT1[13:12]),//2
                        .MEM_SIGN(DOUT1[14]),//1
                        .MEM_DOUT1(DOUT1),//32
                        .MEM_DOUT2(DOUT2),//32
                        .IO_WR(IOBUS_WR));//1
    
    mux4_1 RegMux (.ZERO(PC_4), 
                   .ONE(CSR_RD), 
                   .TWO(DOUT2), 
                   .THREE(ALU_OUT), 
                   .SEL(RF_WR_SEL), //2
                   .MUX_OUT(WD)); //32
                   
    mux2_1 ALUMux_2(.ZERO(RS1), 
                    .ONE(UTYPE), 
                    .SEL(ALU_SRCA),//1 
                    .MUX_OUT(A));
                    
    mux4_1 ALUMux_4 (.ZERO(RS2), 
                     .ONE(ITYPE), 
                     .TWO(STYPE), 
                     .THREE(PC_OUT), 
                     .SEL(ALU_SRCB), 
                     .MUX_OUT(B));
                     
    ALU myALU(.A(A), //32
              .B(B), //32
              .ALU_FUN(ALU_FUN),//4
              .ALU_OUT(ALU_OUT));//32
    
    assign ADR1 = DOUT1[19:15];
    assign ADR2 = DOUT1[24:20];          
    RegisterFile RegFile (.ADR1(ADR1),
                          .ADR2(ADR2),
                          .WA(DOUT1[11:7]), //5
                          .CLK(CLK), //1
                          .EN(REG_WRITE), //1
                          .WD(WD), //32
                          .RS1(RS1), //32
                          .RS2(RS2)); //32 
        
    mux_interupt PC_MUX (.ZERO(PC_4), //32
                   .ONE(JALR), //32
                   .TWO(BRANCH), //32
                   .THREE(JAL),//32
                   .FOUR(MTVEC),//32
                   .FIVE(MEPC), //32
                   .SEL(PC_SOURCE), //3
                   .MUX_OUT(PC_IN)); //32
                   

        
    PC myPC (.CLK(CLK), //1
             .RESET(RST),//1 
             .PC_WRITE(PC_WRITE),//1 
             .DOUT(PC_OUT),//32
             .DIN(PC_IN));//32

    
    CUDecoder CUD (.BR_EQ(BR_EQ),
                    .BR_LT(BR_LT), 
                    .BR_LTU(BR_LTU),
                    .CLK(CLK),
                    .FUNC3(DOUT1[14:12]),//3
                    .FUNC7(DOUT1[31:25]), //7
                    .CU_OPCODE(DOUT1[6:0]),
                    .ALU_FUN(ALU_FUN),
                    .PC_SOURCE(PC_SOURCE),//2
                    .ALU_SRCB(ALU_SRCB),
                    .RF_WR_SEL(RF_WR_SEL),//2
                    .INT_TAKEN(INT_TAKEN),
                    .ALU_SRCA(ALU_SRCA));//1
                    
    CSU_FSM CUF (.CLK(CLK), 
                .RST(RST), 
                .FUNC3(FUNC3),
                .INTR(INTR & CSR_MIE),
                .CU_OPCODE(DOUT1[6:0]),//7
                .PC_WRITE(PC_WRITE),//1
                .REG_WRITE(REG_WRITE),//1
                .MEM_WRITE(MEM_WRITE),//1
                .MEM_READ1(MEM_READ1),//1
                .MEM_READ2(MEM_READ2),//1
                .INT_TAKEN(INT_TAKEN),//1
                .CSR_WR(CSR_WR)//1
                 );                
    
    Branch_Gen BG (.RS1(RS1),
                .RS2(RS2),
                .BR_EQ(BR_EQ),
                .BR_LT(BR_LT),
                .BR_LTU(BR_LTU));
              
    Immed_Gen IG (.DOUT1(DOUT1), 
                  .UTYPE(UTYPE), 
                  .ITYPE(ITYPE), 
                  .STYPE(STYPE), 
                  .JTYPE(JTYPE), 
                  .BTYPE(BTYPE));
    
    Targ_Gen TG (.JTYPE(JTYPE),
                 .RS1(RS1),
                 .PC_OUT(PC_OUT),
                 .BTYPE(BTYPE), 
                 .ITYPE(ITYPE), 
                 .UTYPE(UTYPE),
                 .JALR(JALR), 
                 .BRANCH(BRANCH), 
                 .JAL(JAL));
                          
     CSR intr_CSR (.CLK(CLK),
                   .RST(RST),
                   .INT_TAKEN(INT_TAKEN), //1bit input           
                   .ADDR(DOUT1[31:20]),//12
                   .PC(PC_OUT),//32
                   .WD(ALU_OUT),//32
                   .WR_EN(CSR_WR),//input 1bit
                   .RD(CSR_RD),//32
                   .CSR_MEPC(MEPC),//32  
                   .CSR_MTVEC(MTVEC), //32   
                   .CSR_MIE(CSR_MIE)); 
endmodule

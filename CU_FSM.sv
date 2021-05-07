module CSU_FSM(
    input CLK, RST, INTR,
    input [2:0] FUNC3,
    input [6:0] CU_OPCODE,
    output logic PC_WRITE, REG_WRITE, MEM_WRITE, MEM_READ1, MEM_READ2, 
                 CSR_WR, INT_TAKEN 
    );

//assign INTR = (INTR &&CSR_MIE);    
    
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


typedef enum {FETCH, EXECUTE, WB, INTERUPT} STATES;
 STATES NS, PS;
       
always_ff @ (posedge CLK)
begin
   if (RST)begin
       PS <= FETCH; end
  
   else begin
       PS <= NS; end
end

always_comb 
begin
    //initialize all outputs to zero
    PC_WRITE = 0; REG_WRITE = 0; MEM_WRITE = 0; MEM_READ1 =0; MEM_READ2 =0; CSR_WR =0;
    INT_TAKEN =0;
    case (PS)
        FETCH:
        begin
        MEM_READ1 = 1;
        NS = EXECUTE;    
        end
        
        EXECUTE:
        begin      
        case (OPCODE)
                LUI:
                begin
                PC_WRITE = 1;
                REG_WRITE = 1;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end 
                
                AUIPC:
                begin
                PC_WRITE = 1;
                REG_WRITE = 1;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end
                
                JAL:
                begin
                PC_WRITE = 1;
                REG_WRITE = 1;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end
                
                JALR:
                begin
                PC_WRITE = 1;
                REG_WRITE = 1;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end
                
                BRANCH:
                begin
                PC_WRITE = 1;
                REG_WRITE = 0;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end
                
                LOAD:
                begin
                PC_WRITE = 0;
                REG_WRITE = 0;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 1;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end
                
                STORE:
                begin
                PC_WRITE = 1;
                REG_WRITE = 0;
                MEM_WRITE = 1;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end
                
                OP_IMM:
                begin
                PC_WRITE = 1;
                REG_WRITE = 1;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end
                
                OP:
                begin
                PC_WRITE = 1;
                REG_WRITE = 1;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end
                
                SYSTEM://system is the opcode, intrupt is the state
                begin
                if (FUNC3 == 1)
                begin
                PC_WRITE = 1;
                REG_WRITE = 1;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 1;
                end
                else
                begin
                PC_WRITE = 1;
                REG_WRITE = 0;
                MEM_WRITE = 0;
                MEM_READ1 = 0;
                MEM_READ2 = 0;
                INT_TAKEN = 0;
                CSR_WR = 0;
                end
                end
                
                endcase         
       
        if (OPCODE == LOAD)
        NS = WB;
        else if (INTR ==1)
        NS = INTERUPT;
        else
        NS = FETCH;   
        end
                       
        WB:
        begin
        REG_WRITE = 1; 
        PC_WRITE =1;
        CSR_WR = 0; 
        if(INTR==0)
        begin        
        NS = FETCH; 
        end
        else
        NS = INTERUPT;
        end
        
        INTERUPT:
        begin
        PC_WRITE = 1;
        REG_WRITE = 0;
        MEM_WRITE = 0;
        MEM_READ1 = 0;
        MEM_READ2 = 0;
        INT_TAKEN = 1;
        CSR_WR = 0;        
        NS = FETCH;
        end
        endcase
        
end
endmodule
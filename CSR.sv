`timescale 1ns / 1ps
module CSR(input CLK,
           input RST,
           input INT_TAKEN,           
           input [11:0] ADDR,
           input [31:0] PC,
           input [31:0] WD,
           input WR_EN,
           output logic [31:0] RD,
           output logic [31:0] CSR_MEPC=0, //return ADDRess after handling trap-interrupt 
           output logic [31:0] CSR_MTVEC=0,  //trap handler ADDRess  
           output logic CSR_MIE = 0 //interrupt enable register
    );
    
    // CSR ADDResses
    typedef enum logic [11:0] {       
        MIE       = 12'h304,
        MTVEC     = 12'h305,
        MEPC      = 12'h341
    } csr_t;

    always_ff @ (posedge CLK)
    begin
        if(RST) begin
            CSR_MTVEC <=  0;
            CSR_MEPC  <= 0;
            CSR_MIE <= 1'b0;           
        end
        if(WR_EN)
            case(ADDR)
                MTVEC:  CSR_MTVEC <= WD;    // where to go on interrupt
                MEPC:   CSR_MEPC  <= WD;    // return ADDRess set by haRDware
                MIE:    CSR_MIE <= WD[0];   // enable interrupts               
            endcase
            
         if(INT_TAKEN)
         begin
            CSR_MEPC <= PC;
         end         
    end
    
    always_comb
       case(ADDR)
            MTVEC:  RD = CSR_MTVEC;
            MEPC:   RD = CSR_MEPC;
            MIE:    RD ={{31{1'b0}},CSR_MIE};            
            default:RD = 32'd0;
       endcase
    
endmodule
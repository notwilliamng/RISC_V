`timescale 1ns / 1ps

Description: OTTER Wrapper (with Debounce, Switches, LEDS, and SSEG
//////////////////////////////////////////////////////////////////////////////////

module OTTER_Wrapper(
   input CLK,
   input BTNL,
   input BTNC,
   input [15:0] SWITCHES,
   output logic [15:0] LEDS,
   output [7:0] CATHODES,
   output [3:0] ANODES
   );
       
   
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more MMIO, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_AD = 32'h11000000;
              
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more MMIO
    localparam LEDS_AD      = 32'h11080000;
    localparam SSEG_AD     = 32'h110C0000;
   
    
   // Signals for connecting OTTER_MCU to OTTER_wrapper /////////////////////////
   logic s_interrupt, btn_int;
   logic s_reset,s_load;
   logic sclk;// = 1'b0;   
   
 
   logic [15:0]  r_SSEG;// = 16'h0000;
     
   logic [31:0] IOBUS_out,IOBUS_in,IOBUS_addr;
   logic IOBUS_wr;

   
   assign s_interrupt = btn_int;
   
   
    // Declare OTTER_CPU ///////////////////////////////////////////////////////
   OTTER_MCU MCU (.RST(s_reset),.INTR(BTNL), .CLK(sclk), 
                   .IOBUS_OUT(IOBUS_out),.IOBUS_IN(IOBUS_in),.IOBUS_ADDR(IOBUS_addr),.IOBUS_WR(IOBUS_wr));

   // Declare Seven Segment Display /////////////////////////////////////////
   SevSegDisp SSG_DISP (.DATA_IN(r_SSEG), .CLK(CLK), .MODE(1'b0),
                       .CATHODES(CATHODES), .ANODES(ANODES));
   
   // Declare Debouncer One Shot  ///////////////////////////////////////////
   debounce_one_shot DB(.CLK(sclk), .BTN(BTNL), .DB_BTN(btn_int));
   
      
   clk_div clkDIv(CLK, sclk);
  
   assign s_reset = BTNC;
   
     // Connect Board peripherals (Memory Mapped IO devices) to IOBUS /////////////////////////////////////////
    //assign LEDS = IOBUS_out;
    always_ff @ (posedge sclk)
    begin
     
        if(IOBUS_wr)
            case(IOBUS_addr)
                LEDS_AD: LEDS <= IOBUS_out;    
                SSEG_AD: r_SSEG <= IOBUS_out[15:0];
             
            endcase
          
    end
   
    always_comb
    begin
        IOBUS_in=32'b0;
        case(IOBUS_addr)
            SWITCHES_AD: IOBUS_in[15:0] = SWITCHES;
          
            default: IOBUS_in=32'b0;
        endcase
    end
   endmodule


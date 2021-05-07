`timescale 1ns / 1ps

module ALARM(   input CLK,
                input DISTANCE, 
                output logic [15:0] LEDS,
                output [7:0] CATHODES,
                output [3:0] ANODES);

    localparam SWITCHES_AD = 32'h11000000;
    localparam LEDS_AD      = 32'h11080000;
    localparam SSEG_AD     = 32'h110C0000;

    SONAR SNR(.CLK(CLK), .DISTANCE(DISTANCE), 
              .TRIG(TRIG), .ECHO(ECHO));
    
    //assign distance to SSEG
    OTTER_Wrapper OWRPR(.CLK(CLK), .LEDS(LEDS), 
                        .CATHODES(CATHODES),
                        .ANODES(ANODES));
endmodule

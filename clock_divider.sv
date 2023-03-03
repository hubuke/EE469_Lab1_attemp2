`timescale 1ns / 1ps
//This module divides the on-board FPGA clock at 100Mhz to
//divided_clocks[0] = 50MHz, [1] = 25Mhz, ... [23] = 6Hz,
//[24] = 3Hz, [25] = 1.5Hz, ...and so on.

module clock_divider (clock, divided_clocks); 
    input logic clock;
//    input logic reset;
    output logic [31:0] divided_clocks;
      
      
    always_ff @(posedge clock) begin
        divided_clocks <= divided_clocks + 1;
    end
endmodule

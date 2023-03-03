`timescale 1ns / 1ps

module top(CLK100MHZ, BTNC, LED);
    input   logic               CLK100MHZ;
    input   logic               BTNC;
    output  logic [15:0]        LED;

    logic         [31:0]        divided_clocks;

    logic                       result_out;
    
    assign reset = BTNC;

    clock_divider clk_divider (.clock(CLK100MHZ), .divided_clocks);

    riscv32 cpu (.clk(divided_clocks[10]), .reset(BTNC), .result_out);

    assign LED[0] = result_out;

endmodule

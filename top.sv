`timescale 1ns / 1ps

module top(CLK100MHZ, BTNC, BTNU, BTNR, SW, LED);
    input   logic               CLK100MHZ;
    input   logic               BTNC, BTNU, BTNR;
    input   logic [15:0]        SW;
    output  logic [15:0]        LED;

    logic         [31:0]        divided_clocks;

    logic                       result_out;

    assign reset = BTNC;

    clock_divider clk_divider (.clock(CLK100MHZ), .reset(BTNU), .divided_clocks(divided_clocks));

    riscv32 cpu (.clk(divided_clocks[2]), .reset(BTNC), .result_out(result_out));

//    riscv32 cpu (.clk(CLK100MHZ), .reset(BTNC), .result_out(result_out));
    assign LED[0] = result_out;
    assign LED[1] = ~result_out;
    assign LED[2] = 1'b1;
    assign LED[3] = 1'b0;
    
    assign LED[12] = BTNR;
    
    assign LED[7] = SW[7];

endmodule

`timescale 1ns / 1ps

module top_testbench();
    logic               CLK100MHZ;
    logic               BTNC, BTNU, BTNR;
    logic [15:0]        LED;
    logic [15:0]        SW;
    
    parameter CLOCKPERIOD  = 10;
    initial begin
        CLK100MHZ <=0;
        forever #(CLOCKPERIOD/2) CLK100MHZ <= ~CLK100MHZ;
    end
    
    top dut (.CLK100MHZ, .SW, .BTNC, .BTNU, .BTNR, .LED);
    
    initial begin
        SW[15] <= 1; @(posedge CLK100MHZ);
        SW[15] <= 1; @(posedge CLK100MHZ);
        SW[15] <= 0; repeat(10) @(posedge CLK100MHZ);
        BTNC <= 1; repeat(100) @(posedge CLK100MHZ);
        BTNC <= 0; @(posedge CLK100MHZ);
        for (int i = 0; i < 50000; i = i + 1) @(posedge CLK100MHZ);
        $stop;
    end
endmodule 
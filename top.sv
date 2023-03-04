`timescale 1ns / 1ps

module top(CLK100MHZ, BTNC, LED);
    input   logic               CLK100MHZ;
    input   logic               BTNC;
    output  logic [15:0]        LED;

    logic         [31:0]        divided_clocks;

    logic                       result_out;
    
    assign reset = BTNC;

    clock_divider clk_divider (.clock(CLK100MHZ), .divided_clocks);

    riscv32 cpu (.clk(divided_clocks[1]), .reset(BTNC), .result_out);

//    riscv32 cpu (.clk(CLK100MHZ), .reset(BTNC), .result_out);
    assign LED[0] = result_out;
    assign LED[1] = ~result_out;
    assign LED[2] = 1'b1;
    assign LED[3] = 1'b0;

endmodule

`timescale 1ns / 1ps

module top_testbench();
    logic               CLK100MHZ;
    logic               BTNC;
    logic [15:0]        LED;

    logic         [31:0]        divided_clocks;

    logic                       result_out; 
    
    parameter CLOCKPERIOD  = 10;
    initial begin
        CLK100MHZ <=0;
        forever #(CLOCKPERIOD/2) CLK100MHZ <= ~CLK100MHZ;
    end
    
    top dut (.CLK100MHZ, .BTNC, .LED);
    
    initial begin
        BTNC <= 1; @(posedge CLK100MHZ);
        BTNC <= 0; @(posedge CLK100MHZ);
        for (int i = 0; i < 50000; i = i + 1) @(posedge CLK100MHZ);
        $stop;
    end
endmodule 
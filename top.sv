`timescale 1ns / 1ps

module top(CLK100MHZ, SW, LED);
    input   logic               CLK100MHZ;
    input   logic [15:0]        SW;
    output  logic [15:0]        LED;

    logic         [31:0]        divided_clocks, reg_10;
    logic                       result_out;
    logic         [31:0]        pc_out;

    clock_divider clk_divider (.clock(CLK100MHZ), .reset(SW[15]), .divided_clocks(divided_clocks));

    riscv32 cpu (.clk(divided_clocks[1]), .reset(SW[0]), .result_out(result_out), .reg_10, .pc_out);

    assign LED[0] = result_out;
    assign LED[1] = divided_clocks[1];

    assign LED[15:12] = reg_10[3:0]; // 4 LSBs of reg_10
    assign LED[11:8] = pc_out[7:4]; // 4 MSBs of reg_10
    assign LED[7:4] = pc_out[3:0]; // 4 LSBs of pc_out
    // assign LED[8]  = divided_clocks[2];

    // assign LED[7] = SW[7];

endmodule

`timescale 1ns / 1ps

module top_testbench();
    logic               CLK100MHZ;
    logic [15:0]        LED;
    logic [15:0]        SW;

    parameter CLOCKPERIOD  = 10;
    initial begin
        CLK100MHZ <=0;
        forever #(CLOCKPERIOD/2) CLK100MHZ <= ~CLK100MHZ;
    end

    top dut (.CLK100MHZ, .SW, .LED);

    initial begin
        SW[15] <= 1; @(posedge CLK100MHZ);
        SW[15] <= 1; @(posedge CLK100MHZ);
        SW[15] <= 0; repeat(10) @(posedge CLK100MHZ);
        SW[0] <= 1; repeat(2) @(posedge CLK100MHZ);
        SW[0] <= 0; @(posedge CLK100MHZ);
        for (int i = 0; i < 50000; i = i + 1) @(posedge CLK100MHZ);
        $stop;
    end
endmodule
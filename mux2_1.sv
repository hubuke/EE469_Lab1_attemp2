`timescale 1ns/1ps

/* verilator lint_off MULTITOP */
module mux2_1(out, i0, i1, sel);
    output logic [31:0] out;
    input  logic [31:0] i0, i1;
    input logic sel;
    always_comb begin
        if (sel) out = i1;
        else out = i0;
    end
endmodule
/* verilator lint_on MULTITOP */
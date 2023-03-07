`timescale 1ns / 1ps

module adder(current_pc, in, out);
    input logic     [31:0] current_pc;
    input logic     [31:0] in;
    output logic    [31:0] out;

    always_comb begin
        out = current_pc + in;
    end
endmodule


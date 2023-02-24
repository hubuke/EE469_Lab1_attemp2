`timescale 1ns/1ps

module mux4_1 (out, i0, i1, i2, i3, sel);
    input logic [31:0] i0, i1, i2, i3;
    input logic [1:0] sel;
    output logic [31:0] out;
    always_comb begin
        case (sel)
            2'b00: out = i0;
            2'b01: out = i1;
            2'b10: out = i2;
            2'b11: out = i3;
            default: out = 32'bx;
        endcase
    end
endmodule
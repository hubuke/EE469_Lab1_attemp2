`timescale 1ns/1ps

module comb_reg (in, out, en);
    input logic [31:0] in;
    input logic en;
    output logic [31:0] out;

    reg [31:0] data;


    always_comb begin
        if (en) begin
            data = in;
        end
        out <= data;
    end
endmodule
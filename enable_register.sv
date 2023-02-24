`timescale 1ns / 1ps

module enable_register (clk, EN, in, out);
    input logic clk;
    input logic EN;
    input logic [31:0] in;
    output logic [31:0] out;

    reg [31:0] single_reg;

    always_ff @(posedge clk) begin
        if (EN) begin
            single_reg <= in;
        end
        out <= single_reg;
    end
endmodule
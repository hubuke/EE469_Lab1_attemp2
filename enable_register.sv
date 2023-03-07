`timescale 1ns / 1ps

module enable_register (clk, reset, EN, in, out);
    input logic clk;
    input logic reset;
    input logic EN;
    input logic [31:0] in;
    output logic [31:0] out;

    // reg [31:0] single_reg;

    // always_ff @(posedge clk) begin
    //     if (EN) begin
    //         single_reg <= in;
    //     end
    //     out <= single_reg;
    // end
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 0;
        end else if (EN) begin
            out <= in;
        end
    end
endmodule
`timescale 1ns/1ps

module comb_reg (clk, in, out, en);
    input logic [31:0] in;
    input logic en, clk;
    output logic [31:0] out;

    logic [31:0] data_r, data_n;

    assign out = data_r;

    always_comb begin
        if (en) begin
            data_r = in;
        end else begin
            data_r = data_n;
        end
    end

    always_ff @(posedge clk) begin
        data_n <= data_r;
    end
endmodule
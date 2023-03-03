`timescale 1ns/1ps

module pc #(reset_pc = 32'h00000000) (clk, reset, pc_write, pc_in, pc_out);
    input logic clk, reset, pc_write;
    input logic [31:0] pc_in;
    output logic [31:0] pc_out;

    always_ff @(posedge clk) begin
        if (reset) begin
            pc_out <= reset_pc;
        end else begin
            if (pc_write) begin
                pc_out <= pc_in;
            end
        end
    end
endmodule
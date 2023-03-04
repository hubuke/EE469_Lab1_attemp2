`timescale 1ns / 1ps

module register_file (clk, A1, A2, A3, WD3, WE3, RD1, RD2, result_out);
    input logic clk;
    input logic [4:0] A1, A2, A3;
    input logic [31:0] WD3;
    input logic WE3;
    output logic [31:0] RD1, RD2;
    output logic result_out;

    reg [31:0] registers [0:31];

    localparam zero = 32'h00000000;
    assign registers[0] = zero;

    always_ff @(posedge clk) begin
        if (WE3 && A3 !=0 ) begin
            registers[A3] <= WD3;
        end else begin
            registers[A3] <= registers[A3];
        end
        RD1 <= registers[A1];
        RD2 <= registers[A2];

        if (registers[10] == 13) result_out <= 1;
        else result_out <= 0;
    end
    
    // always_comb begin
    //     RD1 = registers[A1];
    //     RD2 = registers[A2];
    //     if (registers[10] == 13) result_out = 1;
    //     else result_out = 0;
    // end
endmodule
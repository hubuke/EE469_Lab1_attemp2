`timescale 1ns / 1ps

module register_file (clk, reset, A1, A2, A3, WD3, WE3, RD1, RD2, result_out, registers, reg_10);
    input logic clk, reset;
    input logic [4:0] A1, A2, A3;
    input logic [31:0] WD3;
    input logic WE3;
    output logic [31:0] RD1, RD2;
    output logic result_out;
    output logic [31:0] reg_10;

    output reg [31:0] registers [0:31];

    localparam zero = 32'h00000000;
    assign registers[0] = zero;
    assign reg_10 = registers[10];

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // reset to zero
            registers[1] <= zero;
            registers[2] <= zero;
            registers[3] <= zero;
            registers[4] <= zero;
            registers[5] <= zero;
            registers[6] <= zero;
            registers[7] <= zero;
            registers[8] <= zero;
            registers[9] <= zero;
            registers[10] <= zero;
            registers[11] <= zero;
            registers[12] <= zero;
            registers[13] <= zero;
            registers[14] <= zero;
            registers[15] <= zero;
            registers[16] <= zero;
            registers[17] <= zero;
            registers[18] <= zero;
            registers[19] <= zero;
            registers[20] <= zero;
            registers[21] <= zero;
            registers[22] <= zero;
            registers[23] <= zero;
            registers[24] <= zero;
            registers[25] <= zero;
            registers[26] <= zero;
            registers[27] <= zero;
            registers[28] <= zero;
            registers[29] <= zero;
            registers[30] <= zero;
            registers[31] <= zero;

            RD1 <= zero;
            RD2 <= zero;
            result_out <= 0;
        end else begin
            if (WE3) begin
                if (A3 == 1) registers[1] <= WD3;
                if (A3 == 2) registers[2] <= WD3;
                if (A3 == 3) registers[3] <= WD3;
                if (A3 == 4) registers[4] <= WD3;
                if (A3 == 5) registers[5] <= WD3;
                if (A3 == 6) registers[6] <= WD3;
                if (A3 == 7) registers[7] <= WD3;
                if (A3 == 8) registers[8] <= WD3;
                if (A3 == 9) registers[9] <= WD3;
                if (A3 == 10) registers[10] <= WD3;
                if (A3 == 11) registers[11] <= WD3;
                if (A3 == 12) registers[12] <= WD3;
                if (A3 == 13) registers[13] <= WD3;
                if (A3 == 14) registers[14] <= WD3;
                if (A3 == 15) registers[15] <= WD3;
                if (A3 == 16) registers[16] <= WD3;
                if (A3 == 17) registers[17] <= WD3;
                if (A3 == 18) registers[18] <= WD3;
                if (A3 == 19) registers[19] <= WD3;
                if (A3 == 20) registers[20] <= WD3;
                if (A3 == 21) registers[21] <= WD3;
                if (A3 == 22) registers[22] <= WD3;
                if (A3 == 23) registers[23] <= WD3;
                if (A3 == 24) registers[24] <= WD3;
                if (A3 == 25) registers[25] <= WD3;
                if (A3 == 26) registers[26] <= WD3;
                if (A3 == 27) registers[27] <= WD3;
                if (A3 == 28) registers[28] <= WD3;
                if (A3 == 29) registers[29] <= WD3;
                if (A3 == 30) registers[30] <= WD3;
                if (A3 == 31) registers[31] <= WD3;
            end else begin
                registers[1] <= registers[1];
                registers[2] <= registers[2];
                registers[3] <= registers[3];
                registers[4] <= registers[4];
                registers[5] <= registers[5];
                registers[6] <= registers[6];
                registers[7] <= registers[7];
                registers[8] <= registers[8];
                registers[9] <= registers[9];
                registers[10] <= registers[10];
                registers[11] <= registers[11];
                registers[12] <= registers[12];
                registers[13] <= registers[13];
                registers[14] <= registers[14];
                registers[15] <= registers[15];
                registers[16] <= registers[16];
                registers[17] <= registers[17];
                registers[18] <= registers[18];
                registers[19] <= registers[19];
                registers[20] <= registers[20];
                registers[21] <= registers[21];
                registers[22] <= registers[22];
                registers[23] <= registers[23];
                registers[24] <= registers[24];
                registers[25] <= registers[25];
                registers[26] <= registers[26];
                registers[27] <= registers[27];
                registers[28] <= registers[28];
                registers[29] <= registers[29];
                registers[30] <= registers[30];
                registers[31] <= registers[31];
            end
            RD1 <= registers[A1];
            RD2 <= registers[A2];

            if (registers[10] == 13) result_out <= 1;
            else result_out <= 0;
        end
    end

    // always_comb begin
    //     RD1 = registers[A1];
    //     RD2 = registers[A2];
    //     if (registers[10] == 13) result_out = 1;
    //     else result_out = 0;
    // end
endmodule
`timescale 1ns / 1ps

module ALUDecoder (opb5, ALUop, funct3, funct7b5, ALUControl);
    input logic opb5;
    input logic [2:0] funct3;
    input logic funct7b5;
    input logic [1:0] ALUop;
    output logic [3:0] ALUControl;

    logic RtypeSub;
    assign RtypeSub = funct7b5 & opb5; // Ture if R-type

    always_comb begin
        case (ALUop)
            2'b00: ALUControl = 4'b0000; // ADD
            2'b01: ALUControl = 4'b0001; // SUB
            2'b11: ALUControl = 4'b1011; // SLT
            default: case(funct3)
                3'b000: if (RtypeSub) ALUControl = 4'b0001; // SUB
                        else ALUControl = 4'b0000; // ADD
                3'b010: ALUControl = 4'b1011; // SLT
                3'b110: ALUControl = 4'b0011; // OR
                3'b111: ALUControl = 4'b0010; // AND
                default: ALUControl = 4'bxxxx; // Error
            endcase
        endcase
    end
endmodule
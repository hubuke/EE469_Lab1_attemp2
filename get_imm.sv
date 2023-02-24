`timescale 1ns/1ps

// define all macros for rv32i instructions
`define LUI 7'b0110111
`define AUIPC 7'b0010111
`define JAL 7'b1101111
`define JALR 7'b1100111
`define BRANCH 7'b1100011
`define LOAD 7'b0000011
`define STORE 7'b0100011
`define OP_IMM 7'b0010011
`define OP 7'b0110011

module get_imm (instruction, imm);
    input  logic [31:0] instruction;
    output logic [31:0] imm;

    always_comb begin
        if (instruction[6:0] == `LUI) begin
            imm = {12'b0, instruction[31:12]};
        end else if (instruction[6:0] == `AUIPC) begin
            imm = {12'b0, instruction[31:12]};
        end else if (instruction[6:0] == `JAL) begin
            imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        end else if (instruction[6:0] == `JALR) begin
            imm = {{21{instruction[31]}}, instruction[30:20]};
        end else if (instruction[6:0] == `BRANCH) begin
            imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        end else if (instruction[6:0] == `LOAD) begin
            imm = {{21{instruction[31]}}, instruction[30:20]};
        end else if (instruction[6:0] == `STORE) begin
            imm = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};
        end else if (instruction[6:0] == `OP_IMM) begin
            if (instruction[14:12] == 3'b001 || instruction[14:12] == 3'b101) begin // shift instructions
                imm = {27'b0, instruction[24:20]};
            end else begin
                imm = {{21{instruction[31]}}, instruction[30:20]};
            end
        end else if (instruction[6:0] == `OP) begin
            imm = 32'b0;
        end
    end
endmodule

`timescale 1ns/1ps

module get_imm_testbench();
    logic [31:0] instruction;
    logic [19:0] imm;

    get_imm dut (instruction, imm);

    initial begin
        instruction = 32'h004D22B7; // lui t0, 1234
        #1;
        $display("imm = %h", imm);

        instruction = 32'h05BA0317; // auipc t1, 23456
        #1;
        $display("imm = %h", imm); 

        instruction = 32'h648190EF; // jal x0, 104004
        #1;
        $display("imm = %h", imm);

        instruction = 32'h40628063; // beq t0, t1, 1024
        #1;
        $display("imm = %h", imm);

        instruction = 32'h3C4EB283; // ld t0, 964(t4)
        #1;
        $display("imm = %h", imm);

        instruction = 32'h21D2A023; // sw t4, 512(t0)
        #1;
        $display("imm = %h", imm);

        instruction = 32'h02BF0F13; // addi t5, t5, 43
        #1;
        $display("imm = %h", imm);

        instruction = 32'h005F9F93; // slli t6, t6, 5
        #1;
        $display("imm = %h", imm);

        instruction = 32'h01C30333; // add t1, t1, t3
        #1;
        $display("imm = %h", imm);

        $stop;
    end
endmodule
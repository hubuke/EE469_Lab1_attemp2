`timescale 1ns / 1ps
module controller(clk, reset, instruction, pc_write, addrSrc, MemWrite, IRWrite, 
                  ResultSrc, ALUControl, ALUScrb, ALUSrca, RegWrite);

        input  logic   [31:0] instruction; //instruction register
        input  logic   clk, reset;
        input  logic   zero;
        output logic   pc_write, addrSrc, RegWrite, MemWrite, IRWrite;

        output logic [1:0] ResultSrc, ALUSrca, ALUScrb;
        output logic [3:0] ALUControl;
        output logic [1:0] ResultSrc;

        logic [6:0] opcode;
        logic [2:0] funct3;
        logic [6:0] funct7;

        assign  opcode[6:0] = instruction[6:0];
        assign  funct3[2:0] = instruction[14:12];
        assign  funct7[6:0] = instruction[31:25];

        enum {FETCH, DECODE, MEMORY_ADDRESS, MEMORY_READ, WRITEBACK, MEMORY_WRITE, EXECUTEI, EXECUTER, BRANCH, JUMP} ps, ns;

        ALUDecoder alu_decoder (opb5, ALUop, funct3, funct7b5, ALUControl);

        // FSM 
        always_comb begin
            case(ps)
                FETCH: begin
                    ns = DECODE;
                    addrSrc = 1'b0;
                    IRWrite = 1'b1;
                    ALUSrca = 2'b00;
                    ALUScrb = 2'b10;

                end

            endcase
        end

        always_ff @(posedge clk) begin
            if(reset) ps <= FETCH;
            else ps <= ns;
        end        
endmodule

// test bench
module controller_testbench();

endmodule

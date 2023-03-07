`timescale 1ns / 1ps

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

module controller(clk, reset, instruction, pc_write, AdrSrc, MemWrite, IRWrite, 
                  ResultSrc, ALUControl, ALUSrcb, ALUSrca, RegWrite, zero, 
                  negative, overflow, carry, state);


        input  logic   [31:0] instruction; //instruction register
        input  logic   clk, reset;
        input  logic   zero, negative, overflow, carry;

        output logic   pc_write, AdrSrc, RegWrite, MemWrite, IRWrite;
        output logic [1:0] ResultSrc, ALUSrca, ALUSrcb;
        output logic [3:0] ALUControl;

        output logic [3:0] state;

        logic PCUpdate, Branch_signal;

        logic [6:0] opcode;
        logic [2:0] funct3;
        logic [6:0] funct7;
        logic [1:0] ALUop;

        assign  opcode[6:0] = instruction[6:0];
        assign  funct3[2:0] = instruction[14:12];
        assign  funct7[6:0] = instruction[31:25];
        
//        enum {FETCH, DECODE, MEMORY_ADDRESS, MEMORY_READ, WRITEBACK, MEMORY_WRITE, EXECUTER, ALU_WB, EXECUTEI,JAL, BRANCH, START} ps, ns;
        enum {FETCH, DECODE, MEMORY_ADDRESS, MEMORY_READ, WRITEBACK, MEMORY_WRITE, EXECUTER, ALU_WB, EXECUTEI,JAL, BRANCH, JALR} ps, ns;
        assign state = ps;
        assign pc_write = PCUpdate | (Branch_signal);

        ALUDecoder alu_decoder (.opb5(opcode[5]), .ALUop, .funct3, .funct7b5(funct7[5]), .ALUControl);

        // FSM 
        always_comb begin
            ns = FETCH;
//            ns = START;
            PCUpdate = 1'b0;
            AdrSrc = 1'bx;
            RegWrite = 1'b0;
            MemWrite = 1'b0;
            IRWrite = 1'b0;
            ResultSrc = 2'bxx;
            ALUSrca = 2'bxx;
            ALUSrcb = 2'bxx;
            ALUop = 2'bxx;
            Branch_signal = 1'b0;
            case(ps)
                FETCH: begin
                    ns = DECODE;
                    PCUpdate = 1'b1;
                    AdrSrc = 1'b0;
                    ALUSrca = 2'b00;
                    ALUSrcb = 2'b10;
                    ALUop = 2'b00;
                    ResultSrc = 2'b10;
                end
                DECODE: begin
                    IRWrite = 1'b1;
                    ALUSrca = 2'b01;
                    ALUSrcb = 2'b01;
                    ALUop = 2'b00;
                    case (opcode)
                        `LOAD, `STORE: begin
                            ns = MEMORY_ADDRESS;
                        end
                        `OP: begin
                            ns = EXECUTER;
                        end
                        `OP_IMM: begin
                            ns = EXECUTEI;
                        end
                        `JAL: begin
                            ns = JAL;
                        end
                        `JALR: begin // might need to change
                            ns = JALR;
                            ALUSrca = 2'b01;
                            ALUSrcb = 2'b10;
                            ALUop = 2'b00;
                            ResultSrc = 2'b10;
                            RegWrite = 1'b1;
                        end
                        `BRANCH: begin
                            ns = BRANCH;
                        end
                        `AUIPC: begin
                            ns = ALU_WB;
                        end
                        default: begin
                            ns = FETCH;
                        end
                    endcase
                end
                MEMORY_ADDRESS: begin
                    ALUSrca = 2'b10;
                    ALUSrcb = 2'b01;
                    ALUop = 2'b00;
                    case (opcode)
                        `LOAD: begin
                            ns = MEMORY_READ;
                        end
                        `STORE: begin
                            ns = MEMORY_WRITE;
                        end
                        default: begin
                            ns = FETCH;
                        end
                    endcase
                end
                MEMORY_READ: begin
                    ns = WRITEBACK;
                    ResultSrc = 2'b00;
                    AdrSrc = 1'b1;
                end
                WRITEBACK: begin
                    ns = FETCH;
                    ResultSrc = 2'b01;
                    RegWrite = 1'b1;
                end
                MEMORY_WRITE: begin
                    ns = FETCH;
                    ResultSrc = 2'b00;
                    AdrSrc = 1'b1;
                    MemWrite = 1'b1;
                end
                EXECUTER: begin
                    ns = ALU_WB;
                    ALUSrca = 2'b10;
                    ALUSrcb = 2'b00;
                    ALUop = 2'b10;
                end
                EXECUTEI: begin
                    ns = ALU_WB;
                    ALUSrca = 2'b10;
                    ALUSrcb = 2'b01;
                    ALUop = 2'b10;
                end
                JAL: begin
                    ns = ALU_WB;
                    ALUSrca = 2'b01;
                    ALUSrcb = 2'b10;
                    ALUop = 2'b00;
                    ResultSrc = 2'b00;
                    PCUpdate = 1'b1;
                end
                JALR: begin
                    ns = FETCH;
                    ALUSrca = 2'b10;
                    ALUSrcb = 2'b01;
                    ALUop = 2'b00;
                    ResultSrc = 2'b10;
                    PCUpdate = 1'b1;
                end
                ALU_WB: begin
                    ns = FETCH;
                    ResultSrc = 2'b00;
                    RegWrite = 1'b1;
                end
                BRANCH: begin
                    ns = FETCH;
                    ALUSrca = 2'b10;
                    ALUSrcb = 2'b00;
                    ALUop = 2'b01;
                    ResultSrc = 2'b00;
                    Branch_signal = 1'b0;
                    case (funct3)
                        3'b000: begin // beq
                            if (zero) Branch_signal = 1'b1;
                        end
                        3'b001: begin // bne
                            if (!zero) Branch_signal = 1'b1;
                        end
                        3'b100: begin // blt
                            if (negative) Branch_signal = 1'b1;
                        end
                        3'b101: begin // bge
                            if (!negative) Branch_signal = 1'b1;
                        end
                        default: begin
                            Branch_signal = 1'b0;
                        end
                    endcase
                end
                // AUIPC: begin
                //     ns = ALU_WB;
                //     ALUSrca = 2'b01;
                //     ALUSrcb = 2'b01;
                //     ALUop = 2'b00;
                // end
            endcase
        end

        always_ff @(posedge clk or posedge reset) begin
//            if(reset) ps <= START;
            if(reset) ps <= FETCH;
            else ps <= ns;
        end        
endmodule

// test bench
// module controller_testbench();

// endmodule

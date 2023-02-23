`timescale 1ns / 1ps
module controller(clk, reset, pc_write, addrSrc, MemWrite, IRWrite, 
                  ResultSrc, ALUControl, ALUScrb, ALUSrca, RegWrite, instruction);

        input  logic   [31:0] instruction; //instruction register
        input  logic   clk, reset;
        input  logic   zero;
        output logic   pc_write, addrSrc, RegWrite, MemWrite, IRWrite;

        output logic [1:0] ResultSrc, ALUSrca, ALUScrb;
        output logic [3:0] ALUControl;
        output logic [1:0] ResultSrc;

        assign  opcode[6:0] = instruction[6:0];
        assign  funct3[2:0] = instruction[14:12];
        assign  funct7[6:0] = instruction[31:25];

        // controller states - 10 states
        parameter FETCH = 4'b0000; //state0 Instruction Fetch
        parameter DECODE = 4'b0001; //state1  Instruction Decode / Register Fetch
        parameter MEMORY_ADDRESS = 4'b0010; //state2 Memeory address computation
        parameter MEMORY_ACCESS_READ = 4'b0011; //state3 Memory access - read
        parameter WRITEBACK = 4'b0100; //state4 Writeback
        parameter MEMORY_ACCESS_WRITE = 4'b101; //state5 Memory access - write
        parameter EXECUTE = 4'b0110; //state6 Execute
        parameter Rtype = 4'b0111; //state7 R type
        parameter BRANCH = 4'b1000; //state8 Branch completion
        parameter JUMP = 4'b1001; //state9 Jump completion


        // FSM 
        logic [3:0] ps, ns; //present state, next state
        always_ff @(posedge clk) begin
                if (reset) begin
                    ps <= FETCH;
                end else begin
                    case (state)
                        FETCH: begin
                            // memread
                            ALUSrca <= 00;
                            ALUScrb <= 01;
                            ALUControl <= 0000;
                            pc_write;                            
                            addrSrc;
                            ns <= DECODE;
                        end
                        DECODE: begin
                            // if lw/sw
                            if (opcode == 0000011 || opcode == 0100011) begin
                                ns <= MEMORY_ADDRESS;
                            end
                            // if r-type
                            else if (opcode == 0110011) begin
                                ns <= Rtype;
                            end
                            // if branch
                            else if (opcode == 1100011) begin
                                ns <= BRANCH;
                            end
                            // if jal
                            else if (opcode == 1101111) begin
                                ns <= JUMP;
                            end
                        end
                        Memory_ADDRESS: begin
                            
                        end


                    endcase
                end
        end //end alwaysff
endmodule

// test bench
module controller_testbench();

endmodule

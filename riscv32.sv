`timescale 1ns/1ps

// riscv cpu, includes datapath and control
// 32 bit instruction set

/* verilator lint_off TIMESCALEMOD */

module riscv32 #(parameter reset_pc = 32'h00000000) (clk, reset, pc_out, mem_addr, 
        Result, ReadData, WriteData, Instr, OldPC, Rs1, Rs2, Rd, RD1, RD2, RD1_A, 
        srca, srcb, ImmExt, ALUResult, ALUOut, Data, zero, negative, carryout, 
        overflow, pc_write, AdrSrc, MemWrite, IRWrite, ResultSrc, ALUControl, 
        ALUSrcb, ALUSrca, RegWrite);

    input                clk; 
    input                reset; 


    // datapath signals
    output logic [31:0]  pc_out; // program counter output
    output logic [31:0]  mem_addr; // memory address
    output logic [31:0]  Result; // result of ALU operation
    output logic [31:0]  ReadData; // data read from memory
    output logic [31:0]  WriteData; // data to write to memory
    output logic [31:0]  Instr; // instruction
    output logic [31:0]  OldPC; // old program counter
    output logic [4:0]   Rs1;
    output logic [4:0]   Rs2;
    output logic [4:0]   Rd;
    output logic [31:0]  RD1;
    output logic [31:0]  RD2;
    output logic [31:0]  RD1_A;
    output logic [31:0]  srca;
    output logic [31:0]  srcb;
    output logic [31:0]  ImmExt; // extended immediate
    output logic [31:0]  ALUResult; // ALU result
    output logic [31:0]  ALUOut; // ALU output
    output logic [31:0]  Data; // data from memory
    output logic         zero, negative, carryout, overflow; // ALU flags



    // control signals
    output logic         pc_write; // write to program counter
    output logic         AdrSrc; // address source, 0 = pc, 1 = ALU result
    output logic         MemWrite; // write to memory
    output logic         IRWrite; // write to instruction register
    output logic [1:0]   ResultSrc; // result source, 00 = ALU, 01 = memory, 10 = pc
    output logic [3:0]   ALUControl; // ALU control
    output logic [1:0]   ALUSrcb; // ALU source b, 00 = register, 01 = immediate, 10 = 4 (means pc + 4)
    output logic [1:0]   ALUSrca; // ALU source a, 00 = new_pc, 01 = old_pc, 10 = register
    output logic         RegWrite; // write to register file

    // datapath
    assign Rs1 = Instr[19:15];
    assign Rs2 = Instr[24:20];
    assign Rd = Instr[11:7];

    localparam ZERO_32bit = 32'h00000000;
    localparam enable = 1'b1;
    localparam pc_increment = 32'h00000004;

    // all below are datapath signals
    pc #(.reset_pc) pc0 (.clk, .reset, .pc_write, .pc_in(Result), .pc_out);
    mux2_1 mem_addr_mux (.out(mem_addr), .i0(pc_out), .i1(Result), .sel(AdrSrc));
    // memory unified_memory (.clk, .A(mem_addr), .WD(WriteData), .MemWrite, .RD(ReadData)); // unified memory
    memory_single_reg unified_memory (.clk, .A(mem_addr), .WD(WriteData), .MemWrite, .RD(ReadData)); // unified memory
    enable_register PC_reg (.clk, .EN(IRWrite), .in(pc_out), .out(OldPC));
    enable_register RD_reg (.clk, .EN(IRWrite), .in(ReadData), .out(Instr));
    register_file reg_file (.clk, .A1(Rs1), .A2(Rs2), .A3(Rd), .WD3(Result), .WE3(RegWrite), .RD1, .RD2);
    get_imm get_imm0 (.instruction(Instr), .imm(ImmExt));
    enable_register RD1_reg (.clk, .EN(enable), .in(RD1), .out(RD1_A));
    enable_register RD2_reg (.clk, .EN(enable), .in(RD2), .out(WriteData));
    mux4_1 SrcA_mux (.out(srca), .i0(pc_out), .i1(OldPC), .i2(RD1_A), .i3(ZERO_32bit), .sel(ALUSrca));
    mux4_1 SrcB_mux (.out(srcb), .i0(WriteData), .i1(ImmExt), .i2(pc_increment), .i3(ZERO_32bit), .sel(ALUSrcb));
    alu alu0 (.srca, .srcb, .alu_op(ALUControl), .result(ALUResult), .zero, .negative, .carryout, .overflow);
    enable_register ALU_reg (.clk, .EN(enable), .in(ALUResult), .out(ALUOut));
    enable_register Data_reg (.clk, .EN(enable), .in(ReadData), .out(Data));
    mux4_1 Result_mux (.out(Result), .i0(ALUOut), .i1(Data), .i2(ALUResult), .i3(ZERO_32bit), .sel(ResultSrc));

    // control
    controller ctrl (.clk, .reset, .instruction(Instr), .pc_write, .AdrSrc, .MemWrite, .IRWrite, .ResultSrc, 
    .ALUControl, .ALUSrcb, .ALUSrca, .RegWrite, .zero, .negative, .overflow, .carry(carryout));

endmodule

// /* verilator lint_off MULTITOP */
// `timescale 1ns/1ps

// module riscv32_testbench();

// parameter CLOCK_PERIOD = 10;

//     initial begin
//         clk <= 0;
// 		forever #(CLOCK_PERIOD/2) clk <= ~clk;//toggle the clock indefinitely
//     end



//     initial begin
//         reset <=1; @(posedge clk); 
//         reset <=1; @(posedge clk);
//         reset <=0; @(posedge clk);
//         reset <=0; @(posedge clk); 
        
//         for (int i = 0; i < 1000; i = i + 1) @(posedge clk);
//         $stop;
//     end

// endmodule
// /* verilator lint_on MULTITOP */
`timescale 1ns/1ps

// riscv cpu, includes datapath and control
// 32 bit instruction set

/* verilator lint_off TIMESCALEMOD */

module riscv32 #(parameter reset_pc = 32'h00000000) (clk, reset);

    input                clk; 
    input                reset; 

    // datapath signals
    logic [31:0]  pc_out; // program counter output
    logic [31:0]  mem_addr; // memory address
    logic [31:0]  Result; // result of ALU operation
    logic [31:0]  ReadData; // data read from memory
    logic [31:0]  WriteData; // data to write to memory
    logic [31:0]  Instr; // instruction
    logic [31:0]  OldPC; // old program counter
    logic [4:0]   Rs1;
    logic [4:0]   Rs2;
    logic [4:0]   Rd;
    logic [31:0]  RD1;
    logic [31:0]  RD2;
    logic [31:0]  RD1_A;
    logic [31:0]  srca;
    logic [31:0]  srcb;
    logic [31:0]  ImmExt; // extended immediate
    logic [31:0]  ALUResult; // ALU result
    logic [31:0]  ALUOut; // ALU output
    logic [31:0]  Data; // data from memory
    logic         zero, negative, carryout, overflow; // ALU flags



    // control signals
    logic         pc_write; // write to program counter
    logic         AdrSrc; // address source, 0 = pc, 1 = ALU result
    logic         MemWrite; // write to memory
    logic         IRWrite; // write to instruction register
    logic [1:0]   ResultSrc; // result source, 00 = ALU, 01 = memory, 10 = pc
    logic [3:0]   ALUControl; // ALU control
    logic [1:0]   ALUSrcb; // ALU source b, 00 = register, 01 = immediate, 10 = 4 (means pc + 4)
    logic [1:0]   ALUSrca; // ALU source a, 00 = new_pc, 01 = old_pc, 10 = register
    logic         RegWrite; // write to register file

    logic [3:0]   state; // current state

    // datapath
    assign Rs1 = Instr[19:15];
    assign Rs2 = Instr[24:20];
    assign Rd = Instr[11:7];

    localparam ZERO_32bit = 32'h00000000;
    localparam enable = 1'b1;
    localparam pc_increment = 32'h00000004;

    // all below are datapath signals
    pc #(.reset_pc(reset_pc)) pc0 (.clk, .reset, .pc_write, .pc_in(Result), .pc_out);
    mux2_1 mem_addr_mux (.out(mem_addr), .i0(pc_out), .i1(Result), .sel(AdrSrc));
    // memory unified_memory (.clk, .A(mem_addr), .WD(WriteData), .MemWrite, .RD(ReadData)); // unified memory
    memory_single_reg unified_memory (.clk, .A(mem_addr), .WD(WriteData), .MemWrite, .RD(ReadData)); // unified memory
    enable_register PC_reg (.clk, .EN(IRWrite), .reset, .in(pc_out), .out(OldPC));
    // enable_register RD_reg (.clk, .EN(IRWrite), .reset, .in(ReadData), .out(Instr));
    comb_reg Instr_reg (.in(ReadData), .out(Instr), .en(IRWrite));
    register_file reg_file (.clk, .A1(Rs1), .A2(Rs2), .A3(Rd), .WD3(Result), .WE3(RegWrite), .RD1, .RD2);
    get_imm get_imm0 (.instruction(Instr), .imm(ImmExt));
    
//    enable_register RD1_reg (.clk, .EN(enable), .reset, .in(RD1), .out(RD1_A));
//    enable_register RD2_reg (.clk, .EN(enable), .reset, .in(RD2), .out(WriteData));
    comb_reg RD1_reg (.in(RD1), .out(RD1_A), .en(enable));
    comb_reg RD2_reg (.in(RD2), .out(WriteData), .en(enable));
    mux4_1 SrcA_mux (.out(srca), .i0(pc_out), .i1(OldPC), .i2(RD1_A), .i3(ZERO_32bit), .sel(ALUSrca));
    mux4_1 SrcB_mux (.out(srcb), .i0(WriteData), .i1(ImmExt), .i2(pc_increment), .i3(ZERO_32bit), .sel(ALUSrcb));
    // mux4_1 SrcA_mux (.out(srca), .i0(pc_out), .i1(OldPC), .i2(RD1), .i3(ZERO_32bit), .sel(ALUSrca));
    // mux4_1 SrcB_mux (.out(srcb), .i0(RD2), .i1(ImmExt), .i2(pc_increment), .i3(ZERO_32bit), .sel(ALUSrcb));
    alu alu0 (.srca, .srcb, .alu_op(ALUControl), .result(ALUResult), .zero, .negative, .carryout, .overflow);
    enable_register ALU_reg (.clk, .EN(enable), .reset, .in(ALUResult), .out(ALUOut));
    // enable_register Data_reg (.clk, .EN(enable), .reset, .in(ReadData), .out(Data));
    comb_reg Data_reg (.in(ReadData), .out(Data), .en(enable));
    mux4_1 Result_mux (.out(Result), .i0(ALUOut), .i1(Data), .i2(ALUResult), .i3(ZERO_32bit), .sel(ResultSrc));

    // control
    controller ctrl (.clk, .reset, .instruction(Instr), .pc_write, .AdrSrc, .MemWrite, .IRWrite, .ResultSrc, 
    .ALUControl, .ALUSrcb, .ALUSrca, .RegWrite, .zero, .negative, .overflow, .carry(carryout), .state);

endmodule

 /* verilator lint_off MULTITOP */
 `timescale 1ns/1ps

 module riscv32_testbench();
 
    logic clk, reset;

    parameter CLOCK_PERIOD = 10;

    initial begin
        clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;//toggle the clock indefinitely
    end
    
    riscv32 #(.reset_pc(32'h00000000)) riscv_cpu (clk, reset);

    initial begin
        reset <=1; @(posedge clk); 
        reset <=1; @(posedge clk);
        reset <=0; @(posedge clk);
        reset <=0; @(posedge clk); 
    
        for (int i = 0; i < 500000; i = i + 1) @(posedge clk);
        $stop;
    end

 endmodule
 /* verilator lint_on MULTITOP */
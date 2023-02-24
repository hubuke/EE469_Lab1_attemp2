`timescale 1ns / 1ps

module memory (clk, A, WD, MemWrite, RD); // , mem0, mem1, mem2, mem3
    input logic clk;
    input logic [31:0] A; // 32-bit address
    input logic [31:0] WD;
    input logic MemWrite;
    output logic [31:0] RD;

    localparam mem_size = 4096;
    localparam zero_byte = 8'b0;

    logic [31:0] addr; // 8-bit address
    
    assign addr = A >> 2; // 32-bit address to 8-bit address

    reg [7:0] mem0 [0:(mem_size/4 - 1)]; // LSByte
    reg [7:0] mem1 [0:(mem_size/4 - 1)];
    reg [7:0] mem2 [0:(mem_size/4 - 1)];
    reg [7:0] mem3 [0:(mem_size/4 - 1)]; // MSByte

    initial begin
        $readmemh("test0.mem", mem0);
        $readmemh("test1.mem", mem1);
        $readmemh("test2.mem", mem2);
        $readmemh("test3.mem", mem3);
    end

    always_ff @(posedge clk) begin
        if (MemWrite) begin
            mem0[addr] <= WD[7:0]; 
            mem1[addr] <= WD[15:8];
            mem2[addr] <= WD[23:16];
            mem3[addr] <= WD[31:24];
        end
        RD <= {mem3[addr], mem2[addr], mem1[addr], mem0[addr]};
    end

endmodule

// `timescale 1ns/1ps

// module memory_testbench ();
//     logic clk;
//     logic [31:0] A; // 32-bit address
//     logic [31:0] WD;
//     logic MemWrite;
//     logic [31:0] RD;

//     localparam mem_size = 2048;

//     logic [7:0] mem0 [0:(mem_size/4 - 1)]; // LSByte
//     logic [7:0] mem1 [0:(mem_size/4 - 1)];
//     logic [7:0] mem2 [0:(mem_size/4 - 1)];
//     logic [7:0] mem3 [0:(mem_size/4 - 1)]; // MSByte

//     initial begin
//         clk = 0;
//         /* verilator lint_off INFINITELOOP */
//         forever begin 
//         /* verilator lint_off STMTDLY */
//             #5 clk = ~clk;
//         /* verilator lint_on STMTDLY */
//         end
//         /* verilator lint_on INFINITELOOP */
//     end

//     memory dut (.clk, .A, .WD, .MemWrite, .RD); //, .mem0, .mem1, .mem2, .mem3);    
        
//     initial begin
//         /* verilator lint_off Unsupported */
//         for(integer i = 0; i < 100; i++) begin
//             A <= i;
//             WD <= i + 10000;
//             MemWrite <= 1; @(posedge clk);
//         end
//         for (integer i = 0; i < 100; i++) begin
//             A <= i;
//             WD <= $random;
//             MemWrite <= 0; @(posedge clk);
//         end
//         $stop;
//     end
// endmodule
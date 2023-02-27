`timescale 1ns/1ps

module memory_single_reg (clk, A, WD, MemWrite, RD); // , mem0, mem1, mem2, mem3
    input logic clk;
    input logic [31:0] A; // 32-bit address
    input logic [31:0] WD;
    input logic MemWrite;
    output logic [31:0] RD;

    localparam mem_size = 4096;
    localparam zero_byte = 8'b0;
    
    reg [7:0] mem [0:(mem_size/4 - 1)]; // LSByte

    initial begin
        $readmemh("test.mem", mem);
    end

    always_ff @(posedge clk) begin
        if (MemWrite) begin
            mem[A] <= WD[31:24];
            mem[A+1] <= WD[23:16];
            mem[A+2] <= WD[15:8];
            mem[A+3] <= WD[7:0];
        end
    end
    
    always_comb begin
        RD <= {mem[A], mem[A+1], mem[A+2], mem[A+3]};
    end
endmodule
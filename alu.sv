`timescale 1ns / 1ps

module alu (srca, srcb, alu_op, result, zero, negative, carryout, overflow);
    input [31:0]        srca;
    input [31:0]        srcb;
    input [3:0]         alu_op;

    output reg [31:0]   result;
    output reg          zero, negative, carryout, overflow;

    logic [32:0]        temp_result;
    localparam          ZERO_32bit = 32'h00000000;

    always_comb begin
        carryout = 1'bx;
        zero = 1'bx;
        negative = 1'bx;
        overflow = 1'bx;
        temp_result = 33'bx;
        
        case (alu_op)
            4'b0000: begin
                temp_result = srca + srcb; // add
                carryout = temp_result[32];
                result = temp_result[31:0];
            end
            4'b0001: begin
                temp_result = srca - srcb; // sub
                carryout = ~temp_result[32];
                result = temp_result[31:0];
            end
            4'b0010: result = srca & srcb; // and
            4'b0011: result = srca | srcb; // or
            4'b0100: result = srca ^ srcb; // xor
            4'b0101: result = srca << srcb[4:0]; // shift left
            4'b0110: result = srca >> srcb[4:0]; // shift right
            4'b0111: result = srcb; // move
            4'b1000: begin
                temp_result = srca * srcb; // multiply
                carryout = temp_result[32];
                result = temp_result[31:0];
            end
            4'b1001: begin
                // arithemtic right shift
                result = srca >>> srcb[4:0];
            end
            4'b1101: begin
                // arithemtic left shift
                result = srca <<< srcb[4:0];
            end
            4'b1010: begin
                // set less than unsigned
                if (srca < srcb) begin
                    result = srca;
                    negative = 1'b1;
                end else begin
                    result = ZERO_32bit;
                    negative = 1'b0;
                end
            end
            4'b1011: begin // set less than signed
                if (srca[31] == srcb[31]) begin
                    if (srca < srcb) begin
                        result = srca;
                    end else begin
                        result = ZERO_32bit;
                    end
                end else begin
                    if (srca[31]) begin
                        result = srca;
                    end else begin
                        result = ZERO_32bit;
                    end
                end
            end
            default: begin
                result = ZERO_32bit; // invalid
                carryout = 1'b0;
                overflow = 1'b0;
            end
        endcase
        if (result == ZERO_32bit) begin
            zero = 1'b1;
            negative = 1'b0;
        end else begin
            zero = 1'b0;
            negative = result[31];
        end
    end
endmodule

// `timescale 1ns/1ps

// module alu_testbench();
//     logic   [31:0]  srca;
//     logic   [31:0]  srcb;
//     logic   [2:0]   alu_op;
//     reg     [31:0]  result;
//     reg             zero, negative, carryout, overflow;
//     reg             error;

//     alu dut (srca, srcb, alu_op, result, zero, negative, carryout, overflow);

//     initial begin
//         // add
//         for (int i = 0; i < 100; i = i + 1) begin
//             srca = $random; srcb = $random; alu_op = 3'b000; #1;
//             if (result != srca + srcb) begin
                
//                 error = 1;
//             end else begin
//                 error = 0;
//             end
//         end
//         // sub
//         for (int i = 0; i < 100; i = i + 1) begin
//             srca = $random; srcb = $random; alu_op = 3'b001; #1;
//             if (result != srca - srcb) begin
//                 error = 1;
//             end else begin
//                 error = 0;
//             end
//         end
//         // and
//         for (int i = 0; i < 100; i = i + 1) begin
//             srca = $random; srcb = $random; alu_op = 3'b010; #1;
//             if (result != (srca & srcb)) begin
//                 error = 1;
//             end else begin
//                 error = 0;
//             end
//         end
//         // or
//         for (int i = 0; i < 100; i = i + 1) begin
//             srca = $random; srcb = $random; alu_op = 3'b011; #1;
//             if (result != (srca | srcb)) begin
//                 error = 1;
//             end else begin
//                 error = 0;
//             end
//         end
//         // xor
//         for (int i = 0; i < 100; i = i + 1) begin
//             srca = $random; srcb = $random; alu_op = 3'b100; #1;
//             if (result != (srca ^ srcb)) begin
//                 error = 1;
//             end else begin
//                 error = 0;
//             end
//         end
//         // shift left
//         for (int i = 0; i < 100; i = i + 1) begin
//             srca = $random; srcb = $random; alu_op = 3'b101; #1;
//             if (result != (srca << srcb[4:0])) begin
//                 error = 1;
//             end else begin
//                 error = 0;
//             end
//         end
//         // shift right
//         for (int i = 0; i < 100; i = i + 1) begin
//             srca = $random; srcb = $random; alu_op = 3'b110; #1;
//             if (result != (srca >> srcb[4:0])) begin
//                 error = 1;
//             end else begin
//                 error = 0;
//             end
//         end
//         // move
//         for (int i = 0; i < 100; i = i + 1) begin
//             srca = $random; srcb = $random; alu_op = 3'b111; #1;
//             if (result != srcb) begin
//                 error = 1;
//             end else begin
//                 error = 0;
//             end
//         end
//     end
// endmodule


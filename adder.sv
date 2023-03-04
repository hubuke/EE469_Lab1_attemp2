`timescale 1ns / 1ps

module adder(current_pc, in, out);
    input logic     [31:0] current_pc;
    input logic     [31:0] in;
    output logic    [31:0] out;

    always_comb begin
        out = current_pc + in;
    end
endmodule

`timescale 1ns/1ps

//module adder_testbench();
//    logic     [31:0] current_pc;
//    logic     [31:0] in;
//    logic    [31:0] out;

//    reg error;

//    // parameter CLOCK_PERIOD = 10; // 10ns clock period

//    // initial begin
//    //     clk <= 0;
//	// 	forever #(CLOCK_PERIOD/2) clk <= ~clk; //toggle the clock indefinitely
//    // end

//    adder dut (current_pc, in, out);

//    initial begin
//        for (int i = 0; i < 100; i = i + 1) begin
//            current_pc <= $random; 
//            in <= $random; #1;
//            //wait for 1 clock cycle
//            // $display("current_pc = %d, in = %d, out = %d", current_pc, in, out);
//            if (out != current_pc + in) begin
//                error = 1;
//            end else begin
//                error = 0;
//            end
//        end
//        $stop;

//    end // initial begin

//endmodule

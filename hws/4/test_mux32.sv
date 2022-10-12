`timescale 1ns/1ps
`default_nettype none

module test_mux32;
parameter N = 5;
logic [(N-1):0] in00, in01, in02, in03, in04, in05, in06, in07, in08, 
in09, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, 
in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
logic [4:0] select;
wire [(N-1):0] out;

mux32 #(.N(N)) UUT(
    .in00(in00), .in01(in01), .in02(in02), .in03(in03), .in04(in04), .in05(in05), .in06(in06), .in07(in07),
    .in08(in08), .in09(in09), .in10(in10), .in11(in11), .in12(in12), .in13(in13), .in14(in14), .in15(in15), 
    .in16(in16), .in17(in17), .in18(in18), .in19(in19), .in20(in20), .in21(in21), .in22(in22), .in23(in23), 
    .in24(in24), .in25(in25), .in26(in26), .in27(in27), .in28(in28), .in29(in29), .in30(in30), .in31(in31),
    .select(select), .out(out)
);

initial begin
    $dumpfile("mux32.fst");
    $dumpvars(0, UUT);
    in00 = 5'b00000;
    in01 = 5'b00001;
    in02 = 5'b00010;
    in03 = 5'b00011;
    in04 = 5'b00100;
    in05 = 5'b00101;
    in06 = 5'b00110;
    in07 = 5'b00111;
    in08 = 5'b01000;
    in09 = 5'b01001;
    in10 = 5'b01010;
    in11 = 5'b01011;
    in12 = 5'b01100;
    in13 = 5'b01101;
    in14 = 5'b01110;
    in15 = 5'b01111;
    in16 = 5'b10000;
    in17 = 5'b10001;
    in18 = 5'b10010;
    in19 = 5'b10011;
    in20 = 5'b10100;
    in21 = 5'b10101;
    in22 = 5'b10110;
    in23 = 5'b10111;
    in24 = 5'b11000;
    in25 = 5'b11001;
    in26 = 5'b11010;
    in27 = 5'b11011;
    in28 = 5'b11100;
    in29 = 5'b11101;
    in30 = 5'b11110;
    in31 = 5'b11111;
    $display("All inputs are set to their binary value.");
    $display("i | select | out");
    for (int i = 0; i < 32; i = i + 1) begin
        select = i[4:0];
        #1 $display("%d | %5b | %5b", i[4:0], select, out);
    end
        
    $finish;
end



endmodule

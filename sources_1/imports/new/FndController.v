`timescale 1ns / 1ps

module FndController(
    input clk,
    input reset,
    input [13:0] digit,
    output [3:0] fndCom,
    output [7:0] fndFont
    );
wire w_clk_1khz;
wire [1:0] w_select;
wire [3:0] w_digit,w_dig_1,w_dig_10,w_dig_100,w_dig_1000;


clkDiv U_ClkDiv(
    .clk(clk),
    .reset(reset),
    .o_clk(w_clk_1khz)
);

decoder_2x4 U_Decoder_2x4(
    .x(w_select),
    .y(fndCom)
);
counter U_Counter(
    .clk(w_clk_1khz),
    .reset(reset),
    .count(w_select)
);
mux_4x1 U_Mux_4x1(
    .sel(w_select),
    .x0(w_dig_1),
    .x1(w_dig_10),
    .x2(w_dig_100),
    .x3(w_dig_1000),
    .y(w_digit)
);
BCD2SEG U_Bcd2Seg(
    .bcd(w_digit),
    .seg(fndFont)
);

digitSplitter U_dig(
.i_digit     (digit),
.o_digit_1   (w_dig_1),
.o_digit_10  (w_dig_10),
.o_digit_100 (w_dig_100),
.o_digit_1000(w_dig_1000)
);

endmodule // end FndController

module counter(
    input           clk,
    input           reset,
    output [1:0]    count
);
    reg [1:0] r_counter;
    assign count = r_counter;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            r_counter <= 0;
        end else begin
            if(r_counter == 3) begin
                r_counter <= 0;
            end else begin
                r_counter <= r_counter + 1;
            end
        end
    end

endmodule

module BCD2SEG(
    input [3:0] bcd,
    output reg [7:0] seg
);

always @(bcd) begin
//When typing within an always statement, you must use the reg data type.
// you should use reg type when type in always
    case (bcd)
    4'h0: seg = 8'hc0;
    4'h1: seg = 8'hf9;
    4'h2: seg = 8'ha4;
    4'h3: seg = 8'hb0;
    4'h4: seg = 8'h99;
    4'h5: seg = 8'h92;
    4'h6: seg = 8'h82;
    4'h7: seg = 8'hf8;
    4'h8: seg = 8'h80;
    4'h9: seg = 8'h90;
    4'ha: seg = 8'h88;
    4'hb: seg = 8'h83;
    4'hc: seg = 8'hc6;
    4'hd: seg = 8'ha1;
    4'he: seg = 8'h86;
    4'hf: seg = 8'h8e;
    endcase
end
 
endmodule

module decoder_2x4(
    input [1:0] x,
    output reg [3:0] y
);
    always @(x) begin
        // watch x
        case(x)
            2'b00: y = 4'b1110;
            2'b01: y = 4'b1101;
            2'b10: y = 4'b1011;
            2'b11: y = 4'b0111;
        endcase
    end
endmodule

module digitSplitter(
    input [13:0] i_digit,
    output [3:0] o_digit_1,
    output [3:0] o_digit_10,
    output [3:0] o_digit_100,
    output [3:0] o_digit_1000
    );
    assign o_digit_1 = i_digit % 10; // 1의 자리 추출
    assign o_digit_10 = i_digit /10 % 10; // 10의 자리 추출
    assign o_digit_100 = i_digit / 100 % 10; // 100의 자리 추출
    assign o_digit_1000 = i_digit / 1000 % 10; // 1000의 자리 추출
endmodule

module mux_4x1(
    input [1:0] sel,
    input [3:0] x0,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    output reg [3:0] y
);
    // always @(sel,x0,x1,x2,x3) begin
    always @(*) begin
        case(sel)
            2'b00: y=x0;
            2'b01: y=x1;
            2'b10: y=x2;
            2'b11: y=x3;
        endcase
    end
endmodule

module clkDiv(
    input clk,
    input reset,
    output o_clk
);
reg [16:0] r_counter;
reg r_clk;
assign o_clk = r_clk;

// 100MHz to 1KHz
always @(posedge clk,posedge reset) begin
    if(reset) begin
        r_counter <= 0;
        r_clk <= 1'b0;
    end else begin
        if(r_counter == 100_000 -1) begin
            r_counter <= 0;
            r_clk <= 1'b1;
        end else begin
            r_counter <= r_counter + 1;
            r_clk <= 1'b0;
        end
    end
end

endmodule
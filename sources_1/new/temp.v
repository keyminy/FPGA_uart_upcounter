`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input a,
    input b
);

wire w_clk_1;
wire w_clk_100;
wire w_clk_1000;
wire w_count_100;
wire w_count_1000;

clk_div #(.HZ(1)) u_t_clk_div_1 (
    .clk(clk),
    .reset(reset),
    .o_clk(w_clk_1)
);

clk_div #(.HZ(100)) u_t_clk_div_100 (
    .clk(clk),
    .reset(reset),
    .o_clk(w_clk_100)
);

clk_div #(.HZ(1000)) u_t_clk_div_1000 (
    .clk(clk),
    .reset(reset),
    .o_clk(w_clk_1000)
);
clk_counter #(
    .CNT(100)
) u_t_clk_counter_100 (
    .clk(clk),
    .reset(reset),
    .count(w_count_100)
);
clk_counter #(
    .CNT(1000)
) u_t_clk_counter_1000 (
    .clk(clk),
    .reset(reset),
    .count(w_count_1000)
);
endmodule

module clk_div #(
    parameter HZ = 1000
)(
    input clk,
    input reset,
    output o_clk
);
    reg [$clog2(100_000_000/HZ)-1:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;

    always @(posedge clk , posedge reset) begin
        if(reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if(r_counter == 100_000_000/HZ-1) begin
                r_counter <= 0;
                r_clk <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end
endmodule

module clk_counter #(
    parameter CNT = 16
) (
    input clk,
    input reset,
    // output [3:0] count
    output [$clog2(CNT)-1:0] count
);
    reg [$clog2(CNT)-1:0] r_counter;
    assign count = r_counter;

    always @(posedge clk ,posedge reset) begin
        if(reset) begin
            r_counter <= 0;
        end else begin
            if(r_counter == CNT -1) begin
                r_counter <= 0;
            end else begin
                r_counter <= r_counter + 1;
            end
        end
    end
endmodule
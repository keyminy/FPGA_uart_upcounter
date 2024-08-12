`timescale 1ns / 1ps

module upcounter(
    input clk,
    input reset,
    input i_run_on,
    input i_clr_on,
    output [13:0] qout
    );
    wire w_clk_10hz;

   clockDivider U_ClkDiv10Hz(
    .clk(clk)      ,
    .reset(reset)    ,
    .o_clk(w_clk_10hz)
    );
    counter_for_upcnt U_counter_for_upcnt(
        .clk(clk),
        .reset(reset),
        .tick  (w_clk_10hz)  ,
        .i_run_on(i_run_on),
        .i_clr_on(i_clr_on),
        .count(qout)
    );
endmodule

module clockDivider (
    input clk,
    input reset,
    output o_clk
);
    reg [$clog2(10_000_000)-1:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;

    always @(posedge clk,posedge reset) begin
        if(reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if(r_counter == 10_000_000 -1) begin
                // 100_000_000는 1초, 10_000_000는 10Hz
                r_counter <= 0;
                r_clk <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end
endmodule

module counter_for_upcnt (
    input clk,
    input reset,
    input tick,
    input i_run_on,
    input i_clr_on,
    output [13:0] count
);
    reg [13:0] r_counter;
    assign count = r_counter;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            r_counter <= 0;
        end else begin
            if (i_run_on) begin
                if(tick) begin 
                    // tick : 10Hz clk
                    // enable되고, tick이 들어왔을때 counting시작한다.
                    if(r_counter == 10_000-1) begin
                        r_counter <= 0;
                    end else begin
                        r_counter <= r_counter + 1;
                    end
                end 
            end // else i_run_on
            else begin
                // r_counter <= r_counter;
                if(i_clr_on) begin
                    r_counter <= 0;
                end
                else begin
                    r_counter <= r_counter; // tick이 들어오지 않으면 자기 자신으로
                end
            end
        end
    end
endmodule
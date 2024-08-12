`timescale 1ns / 1ps

module top_upcnt_btn_FSM(
    input clk,
    input reset,
    input btnr,
    input btnu,
    output [3:0] fndCom,
    output [7:0] fndFont
    );

    wire [13:0] w_i_digit;
    wire w_run_on;
    wire w_clr_on;
    wire w_btn_run_stop,w_btn_clear;

    debounce u_btn_runstop(
    .clk(clk),
    .reset(reset),
    .i_btn(btnr),
    .o_btn(w_btn_run_stop)
    );
    debounce u_btn_clear(
    .clk(clk),
    .reset(reset),
    .i_btn(btnu),
    . o_btn(w_btn_clear)
    );

    fsm_btn U_fsm_wawtch(
        .clk(clk),
        .reset(reset),
        .btnr(w_btn_run_stop),
        .btnu(w_btn_clear),
        .o_run_on(w_run_on),
        .o_clr_on(w_clr_on)
    );

    upcounter U_upcounter(
        .clk(clk),
        .reset(reset),
        .i_run_on(w_run_on),
        .i_clr_on(w_clr_on),
        .qout(w_i_digit)
    );

    FndController U_fndController(
        .clk(clk),
        .reset(reset),
        .digit(w_i_digit),
        // output
        .fndCom(fndCom),
        .fndFont(fndFont)
    );


endmodule

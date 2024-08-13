`timescale 1ns / 1ps

module top_upcnt_btn_FSM(
    input clk,
    input reset,
    input [7:0] i_rx_data,
    input i_rx_done,
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

    uart u_uart_idk01(
        // globla signal
        .clk(clk),
        .reset(reset),
        // tx signal
        .start(w_rx_done),
        .tx_data(w_rx_data),
        .o_txd(tx),
        .o_tx_done(), // no connect
        // rx signal
        .rx(rx),
        .o_rx_data(w_rx_data),
        .o_rx_done(w_rx_done)
    );
    
    fsm_btn U_fsm_wawtch(
        .clk(clk),
        .reset(reset),
        .i_rx_data(i_rx_data),
        .i_rx_done(i_rx_done),
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

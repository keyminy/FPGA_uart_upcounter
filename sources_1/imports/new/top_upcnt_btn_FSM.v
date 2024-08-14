`timescale 1ns / 1ps

module top_upcnt_btn_FSM(
    input clk,
    input reset,
    // input [7:0] i_rx_data,
    // input i_rx_done,
    input btnr,
    input btnu,
    output [3:0] fndCom,
    output [7:0] fndFont,
    // uart
    input rx,
    output tx
    );

    wire [13:0] w_i_digit;
    wire w_run_on;
    wire w_clr_on;
    wire w_btn_run_stop,w_btn_clear;

    wire w_rx_done;
    wire [7:0] w_rx_data;
    //fifo
    wire w_rx_fifo_empty;
    wire [7:0] w_rx_fifo_data;
    wire w_rx_fifo_rd_en;
    

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
    //----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
    fifo_generator_0 u_Rx_FIFO (
    .clk(clk),      // input wire clk
    .srst(reset),    // input wire srst
    .din(w_rx_data),      // input wire [7 : 0] din
    .wr_en(w_rx_done),  // input wire wr_en
    // .rd_en(~w_rx_fifo_empty),  // input wire rd_en
    .rd_en(w_rx_fifo_rd_en),  // input wire rd_en, u_fsm_watch output으로부터 나온 rd_en신호 사용
    .dout(w_rx_fifo_data),    // output wire [7 : 0] dout
    .full(),    // output wire full
    .empty(w_rx_fifo_empty)  // output wire empty
    );
    // INST_TAG_END ------ End INSTANTIATION Template ---------
    fsm_btn U_fsm_wawtch(
        .clk(clk),
        .reset(reset),
        .i_rx_data(w_rx_fifo_data),
        .i_rx_done(~w_rx_fifo_empty),
        .btnr(w_btn_run_stop),
        .btnu(w_btn_clear),
        .rd_en(w_rx_fifo_rd_en), // output?
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

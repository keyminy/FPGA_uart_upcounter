`timescale 1ns / 1ps


module top_uart_fnd(
    input clk,
    input reset,
    input btnr,
    input btnu,
    output [3:0] fndCom,
    output [7:0] fndFont
    // uart
    // input rx,
    // output tx
    );

    // wire w_rx_done;
    // wire [7:0] w_rx_data;

//    top_upcnt_btn_FSM u_btn_fsm (
//        .clk(clk),
//        .reset(reset),
//        .i_rx_data(w_rx_data),
//        .i_rx_done(w_rx_done),
//        .btnr(btnr),
//        .btnu(btnu),
//        .fndCom(fndCom),
//        .fndFont(fndFont)
//    );

    // uart u_uart_idk01(
    //     // globla signal
    //     .clk(clk),
    //     .reset(reset),
    //     // tx signal
    //     .start(w_rx_done),
    //     .tx_data(w_rx_data),
    //     .o_txd(tx),
    //     .o_tx_done(), // no connect
    //     // rx signal
    //     .rx(rx),
    //     .o_rx_data(w_rx_data),
    //     .o_rx_done(w_rx_done)
    // );
    
endmodule

`timescale 1ns / 1ps

module fsm_btn(
    input clk,
    input reset,
    input [7:0] i_rx_data,
    input btnr,
    input btnu,
    output reg o_run_on,
    output reg o_clr_on
    );


    wire w_run_stop = btnr;
    wire w_clear = btnu;
    // wire [7:0] w_rx_data;
    // assign w_rx_data = i_rx_data;

     // state has 2 state
     // state,next_state bit수 안맞춰줫다;; 
    reg [1:0] state;
    reg [1:0] next_state; //상태를 저장하는 레지스터
    parameter STP_MD = 2'b00;
    parameter RUN_MD = 2'b01; 
    parameter CLR_MD = 2'b10;

    // state register
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= STP_MD;
        end else begin
            state <= next_state;
        end
    end

    // next state Combination logic
    always @(*) begin
        case(state)
        // 자기 자신으로 돌아가는 것을 안해줌
        STP_MD: begin
            if(btnr == 1 || i_rx_data == 8'h72) // 'r' 
                next_state = RUN_MD;
            else if(btnu==1 || i_rx_data == 8'h63) // 'c'
                // clear mode는 오직 stop상태만 가능하다..
                next_state = CLR_MD;
            else
                // 자기자신의 상태를 쭉 유지하게 해주어야함
                next_state = STP_MD;
        end
        RUN_MD: begin
            if(btnr == 1'b1 || i_rx_data == 8'h73 || i_rx_data == 8'h72) // 's' 혹은 'r'
                next_state = STP_MD;
            else
                // 자기자신의 상태를 쭉 유지하게 해주어야함
                next_state = RUN_MD;
        end
        CLR_MD: begin
            if(btnu == 1'b0)
                next_state = STP_MD;
            else 
                // 자기자신의 상태를 쭉 유지하게 해주어야함
                next_state = CLR_MD;
        end
        default: begin
            next_state = state; // default : 그냥 자기 자신이다..
        end
        endcase
    end
    
    // Output Combinational logic
    always @(*) begin
        case(state)
        STP_MD: begin
            o_run_on = 1'b0;
            o_clr_on = 1'b0;
        end
        RUN_MD: begin
            o_run_on = 1'b1;
            o_clr_on = 1'b0;
        end
        CLR_MD: begin
            o_clr_on = 1'b1;
            o_run_on = 1'b0;
        end
        // default이거 안하면 어떻게 될까요?? -> latch
        default: begin
            o_run_on = 1'b0;
            o_clr_on = 1'b0;
        end
        endcase
    end
endmodule
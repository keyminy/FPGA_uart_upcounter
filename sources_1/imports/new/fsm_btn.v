`timescale 1ns / 1ps

module fsm_btn(
    input clk,
    input reset,
    input [7:0] i_rx_data,
    input i_rx_done,
    output rd_en, // output?
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
    // reg [7:0] rx_data_reg,rx_data_next;
    //ADDED 240813
    // reg rx_done_reg,rx_done_next;
    
    // FIFO register
    reg fifo_state,fifo_state_next;
    reg [7:0] fifo_rx_data_reg;// FIFO temporary storage
    reg rd_en_reg, rd_en_next;

    assign rd_en = rd_en_reg;

    parameter STP_MD = 2'b00;
    parameter RUN_MD = 2'b01; 
    parameter CLR_MD = 2'b10;

    // FIFO
    parameter IDLE = 1'b0; 
    parameter DATA = 1'b1;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            fifo_state <= IDLE;
        end else begin
            fifo_state <= fifo_state_next;
        end
    end

    // Mealy Machine state dicision
    always @(*) begin
        fifo_state_next = fifo_state; // prevent latch
        case (fifo_state)
            IDLE: begin
                fifo_rx_data_reg = 0;
                rd_en_reg = 1'b0;
                if(i_rx_done) begin
                    fifo_state_next = DATA;
                    rd_en_reg = 1'b1;
                end
            end 
            DATA:begin
                fifo_rx_data_reg = i_rx_data;
                rd_en_reg = 1'b1;
                if(~i_rx_done) begin
                    // 자기자신으로
                    fifo_state_next = IDLE;
                    rd_en_reg = 1'b0;
                end
            end
        endcase
    end

    // state register
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= STP_MD;
            // rx_data_reg <= 0;
            // rx_done_reg <= 0;
        end else begin
            state <= next_state;
            // rx_data_reg <= rx_data_next;
            // rx_done_reg <= rx_done_next;
        end
    end

    // next state Combination logic
    always @(*) begin
        // rx_data_next = rx_data_reg;
        // rx_done_next = i_rx_done;
        // if(rx_done_reg==1'b1) begin
        //     rx_data_next = i_rx_data;
        // end
        case(state)
        // 자기 자신으로 돌아가는 것을 안해줌
        STP_MD: begin
            if(btnr == 1 || fifo_rx_data_reg == "r") // 'r'
            begin
                next_state = RUN_MD;
                // rx_data_next = 0;
            end 
            else if(btnu==1 || fifo_rx_data_reg == "c") // 'c' 
            begin
                // clear mode는 오직 stop상태만 가능하다..
                next_state = CLR_MD;
                // rx_data_next = 0; // race conditon
            end
            else
                // 자기자신의 상태를 쭉 유지하게 해주어야함
                next_state = STP_MD;
        end
        RUN_MD: begin
            if(btnr == 1'b1 || fifo_rx_data_reg == "s") // 's' 혹은 'r'
            begin
                next_state = STP_MD;
                // rx_data_next = 0;
            end
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
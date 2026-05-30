
module uart_rx #(
    parameter WIDTH = 8
) (
    input clk,
    input reset_n,
    input rx,

    //APB
    input wire [7:0] p_addr, 
    input wire p_write,
    input wire p_enable,
    input wire p_sel_uart,

    output reg [7:0] p_data_uart
    
);
    // Tao baud_tick voi bauraute 115200
    localparam SPEED = 100000000;   // toc do clk_100mhz
    localparam BAUD_RATE = 115200;  // toc do truyen rx
    localparam B_COUNT = SPEED / BAUD_RATE;   // 868
    localparam C_WIDTH = $clog2(B_COUNT);   // do rong bit dem

    reg [C_WIDTH -1 : 0] count_baud_tick;   // bien dem de tao baud_tick
  

    localparam IDLE = 3'd0;
    localparam START = 3'd1;
    localparam RECIVE = 3'd2;
    localparam STOP = 3'd3;
    localparam DONE = 3'd4;

    reg [3:0] count_8_bit;    // dem so bit nhan 8 bit
    reg [2:0] state, next_state;

    localparam RX_DONE_FLAG = 8'd0;
    localparam RX_DATA = 8'd4;
    // logic chuyen trang thai

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if(rx == 0) begin
                    next_state = START;
                end
            end
            START: begin
                if(count_baud_tick == (B_COUNT /2) )begin
                    if(rx == 0) begin
                        next_state = RECIVE;
                    end
                    else begin
                        next_state = IDLE;
                    end
                end
               
            end
            RECIVE:begin
                if(count_8_bit == 8)begin
                    next_state = STOP;
                end
            end
            STOP:begin
                if(rx == 1 && count_baud_tick == B_COUNT - 1)begin
                    next_state = DONE;
                end
            end
            DONE:begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    reg [WIDTH - 1 : 0] shift_reg;
    reg [7:0] rx_data;
    reg done_flag;

    // khoi tuan tu
    always @(posedge clk or negedge reset_n)begin
        if(!reset_n)begin
            state <= IDLE;
            count_8_bit <= 0;
            done_flag <= 0;
            rx_data <= 0;
            count_baud_tick <= 0;
            shift_reg <= 0;
        end
        else begin
                state <= next_state;
                case(state)
                    IDLE:begin
                        count_baud_tick <= 0;
                        count_8_bit <= 0;
                    end
                    START:begin
                        if(count_baud_tick == (B_COUNT /2))begin
                            count_baud_tick <= 0;
                        end
                        else begin
                            count_baud_tick <= count_baud_tick + 1;
                        end
                    end
                    RECIVE:begin
                        if(count_baud_tick == B_COUNT - 1) begin
                            count_baud_tick <= 0;
                            count_8_bit <= count_8_bit + 1;
                            shift_reg <= {rx, shift_reg[WIDTH-1 : 1]};
                        end
                        else begin
                                count_baud_tick <= count_baud_tick + 1;
                        end
                    end
                    STOP:begin
                        if(count_baud_tick == B_COUNT - 1) begin
                            count_baud_tick <= 0;
                        end
                        else begin
                            count_baud_tick <= count_baud_tick + 1; 
                            end
                    end
                    DONE:begin
                        done_flag <= 1;
                        rx_data <= shift_reg;
                    end
                endcase

                if(p_sel_uart && p_enable && !p_write && (p_addr == RX_DATA))begin
                    done_flag <= 0;
                end
            end
        end
    
    // logic data out to cpu
    always @(*)begin
        if(p_sel_uart && p_enable && !p_write)begin
            case(p_addr)
                RX_DONE_FLAG:begin
                    p_data_uart = {7'd0,done_flag};
                end
                RX_DATA:begin
                    p_data_uart = rx_data;
                end
                default: p_data_uart = 8'd0;
            endcase
        end
        else begin
            p_data_uart = 8'd0;
        end
    end

endmodule

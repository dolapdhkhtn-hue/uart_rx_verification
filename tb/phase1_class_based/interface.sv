interface face_uart (input bit clk);
    bit reset_n;
    bit rx;

    //APB
    bit [7:0] p_addr;
    bit p_write;
    bit p_enable;
    bit p_sel_uart;

    bit [7:0] p_data_uart;
endinterface
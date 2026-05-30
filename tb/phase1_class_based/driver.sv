class driver;
    transaction x;
    virtual face_uart itf;
    mailbox #(transaction) mb_gen_to_driver;

    function new(mailbox #(transaction) mb_input_1,
                virtual face_uart itf_input);
            this.mb_gen_to_driver = mb_input_1;
            this.itf = itf_input;
    endfunction

    task reset();
        itf.reset_n = 0;
        itf.rx = 1;
        repeat(10) @(posedge itf.clk);
        itf.reset_n = 1;
        repeat(5)  @(posedge itf.clk);
        itf.p_addr = 8'd0;
        itf.p_write = 0;
        itf.p_enable = 0;
    endtask

    task noise();
        itf.rx = 0;
        repeat(20) @(posedge itf.clk);
        itf.rx = 1;
    endtask
    task send_data (input [7:0] data);
        integer i;
        itf.rx = 0;
        repeat(868) @(posedge itf.clk);
        for(i = 0; i<8; i++)begin
            itf.rx = data[i];
            repeat (868) @(posedge itf.clk);
        end
        itf.rx = 1;
        repeat(868) @(posedge itf.clk);
    endtask

    task apb_done_flag();
        itf.p_addr = 8'd0;
        itf.p_write = 0;
        itf.p_enable = 1;
        itf.p_sel_uart = 1;
    endtask

    task apb_read_data ();
        itf.p_addr = 8'd4;
        itf.p_write = 0;
        itf.p_enable = 1;
        itf.p_sel_uart = 1;
    endtask

      task reset_mid (input [7:0] data);
        integer i;
        itf.rx = 0;
        repeat(868) @(posedge itf.clk);
        for(i = 0; i<4; i++)begin
            itf.rx = data[i];
            repeat (868) @(posedge itf.clk);
        end
        reset();
         for(i = 4; i<8; i++)begin
            itf.rx = data[i];
            repeat (868) @(posedge itf.clk);
        end
        itf.rx = 1;
        repeat(868) @(posedge itf.clk);
    endtask
    task run();
        itf.p_sel_uart = 8'd0;
        mb_gen_to_driver.get(x);
        // reset();
        // noise();
        send_data(x.data);
        apb_done_flag();
        repeat(200) @(posedge itf.clk);
        apb_read_data ();
        repeat(200) @(posedge itf.clk);
        apb_done_flag();
    endtask

    task run_reset_mid();
        itf.p_sel_uart = 8'd0;
        mb_gen_to_driver.get(x);
        // reset();
        // noise();
        reset_mid(x.data);
        apb_done_flag();
        repeat(200) @(posedge itf.clk);
        apb_read_data ();
        repeat(200) @(posedge itf.clk);
        apb_done_flag();
    endtask

    

endclass
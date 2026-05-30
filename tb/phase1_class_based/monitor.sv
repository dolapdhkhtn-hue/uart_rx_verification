class monitor;
    transaction x;
    mailbox #(transaction) monitor_to_scb; //mb_input_3
    virtual face_uart itf;

    function new (mailbox #(transaction) mb_input_3,
                //    mailbox #(transaction) mb_input_4,
                   virtual face_uart itf_input );
                this.monitor_to_scb = mb_input_3;
                // this.monitor_to_scb_data = mb_input_4;
                this.itf = itf_input;
    endfunction

    task run ();
        // forever begin
        x= new();
        repeat (20) @(posedge itf.clk);
        x.data_out = itf.p_data_uart;
        x.data = 8'd0;
        monitor_to_scb.put(x);
        repeat (8700) @(posedge itf.clk);
        // x2= new();
        x.data_out = itf.p_data_uart;
        x.data = 8'd0;
        monitor_to_scb.put(x);
        // $display("MON: data_out=0x%02X, data=0x%02X", x.data_out, x.data);

        repeat (210) @(posedge itf.clk);
        x.data_out = itf.p_data_uart;
        x.data = 8'd0;
        monitor_to_scb.put(x);

        repeat (300) @(posedge itf.clk);
        x.data_out = itf.p_data_uart;
        x.data = 8'd0;
        monitor_to_scb.put(x);
        // $display("MON: data_out=0x%02X, data=0x%02X", x.data_out, x.data);
         
    endtask
endclass
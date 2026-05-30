class scoreboard;
    transaction x1,x2;
    mailbox #(transaction) monitor_to_scb;
    mailbox #(transaction) mb_gen_to_scb;
    virtual face_uart itf;

    covergroup data_cg;
        cp_data: coverpoint x1.data_out {
            bins zero   = {8'h00};
            bins max    = {8'hFF};
            bins alt1   = {8'hAA};
            bins alt2   = {8'h55};
            bins others = default;
        }
    

        // cp_state: coverpoint state {
        //     bins idle    = {IDLE};
        //     bins start   = {START};
        //     bins receive = {RECIVE};
        //     bins stop    = {STOP};
        //     bins done    = {DONE};
        // }
        endgroup

    function new(mailbox #(transaction) mb_input_3,
                mailbox #(transaction) mb_input_2,
                virtual face_uart itf_input);
                this.monitor_to_scb = mb_input_3;
                this.mb_gen_to_scb = mb_input_2;
                this.itf = itf_input;
                data_cg = new();
    endfunction

     function void report();
        $display("============================================");
        $display("  COVERAGE: %.2f%%", data_cg.get_coverage());
        $display("============================================");
    endfunction

        task run();
        mb_gen_to_scb.get(x2);
        repeat(20) @(posedge itf.clk);
            monitor_to_scb.get(x1);
        if(x1.data_out == 8'd0) begin
            $display("============================================");
            $display("1. Kiem tra output khi chua co du lieu ");
            $display("  [PASS] Expected: 0x00 | Got: 0x%02X", x1.data_out);
        end else begin
            $display("============================================");
            $display("1. Kiem tra output khi chua co du lieu ");
            $display("  [FAIL] Expected: 0x00 | Got: 0x%02X", x1.data_out);

        end

        repeat(8700) @(posedge itf.clk);
            monitor_to_scb.get(x1);
        if(x1.data_out == 8'd1) begin
                
            $display("2. Kiem tra out khi da nhan du lieu - done flag ");
            $display("  [PASS] Expected: 0x01 | Got: 0x%02X", x1.data_out);
           
        end else begin
                  
            $display("2. Kiem tra output khi da nhan du lieu - done flag ");
            $display("  [FAIL] Expected: 0x01 | Got: 0x%02X", x1.data_out);
            
        end
        repeat(250) @(posedge itf.clk);
            monitor_to_scb.get(x1);
        if(x1.data_out == x2.data) begin
                
            $display("3. Kiem tra output so voi byte uart ");
            $display("  [PASS] Expected: 0x%02X  | Got: 0x%02X",x2.data, x1.data_out);
        end
        else  begin
            $display("3. Kiem tra output so voi byte uart ");
            $display("  [FAIL] Expected: 0x%02X  | Got: 0x%02X",x2.data, x1.data_out);
           
        end
        data_cg.sample();

        repeat(310) @(posedge itf.clk);
        monitor_to_scb.get(x1);
         if(x1.data_out == 8'd0) begin
            $display("4. Kiem tra done flag ve 0  ");
            $display("  [PASS] Expected: 0x00  | Got: 0x%02X", x1.data_out);
            $display("============================================");
        end else begin
            $display("4. Kiem tra done flag ve 0 sau khi nhan du lieu ");
            $display("  [FAIL] Expected: 0x00  | Got: 0x%02X", x1.data_out);
            $display("============================================");
        end
        endtask
endclass
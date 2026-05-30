class environment;
    mailbox #(transaction) mb_input_1;
    mailbox #(transaction) mb_input_2;
    mailbox #(transaction) mb_input_3;
    virtual face_uart itf;

    generator g1;
    driver dr1;
    monitor m1;
    scoreboard scb1;

    function new(virtual face_uart itf_input);
        this.itf = itf_input;
    endfunction

    function void build ();
        mb_input_1 = new();
        mb_input_2 = new();
        mb_input_3 = new();

        g1 = new(mb_input_1,mb_input_2);
        dr1 = new(mb_input_1, itf);
        m1  = new(mb_input_3, itf);
        scb1 = new(mb_input_3, mb_input_2,itf);
    endfunction

        task run_reset ();
            dr1.reset();
        endtask

        task run();
            fork
            g1.run();
            dr1.run();
            m1.run();
            scb1.run();
            join
        endtask

        task run_reset_mid ();
            fork
            g1.run();
            dr1.run_reset_mid();
            m1.run();
            scb1.run();
            join
        endtask

endclass
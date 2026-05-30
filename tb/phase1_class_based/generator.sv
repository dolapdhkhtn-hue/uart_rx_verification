class generator;
    transaction x;
    mailbox #(transaction) mb_gen_to_driver;  // mb_input_1
    mailbox #(transaction) mb_gen_to_scb;  // mb_input_2

    function new(mailbox #(transaction) mb_input_1,
                mailbox #(transaction) mb_input_2);
        this.mb_gen_to_driver = mb_input_1;
        this.mb_gen_to_scb = mb_input_2;
    endfunction

    task run();
        x = new();
        if(x.randomize()) begin 
            mb_gen_to_driver.put(x);
            mb_gen_to_scb.put(x);
        end else begin
            $display("Random Fail");
        end

    endtask
endclass
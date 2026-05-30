module top();
    bit clk;
     environment env1;

    initial clk = 0;
    always #5 clk = ~clk;
    int i = 0;

  
    face_uart itf_input(.clk(clk));

    uart_rx #(.WIDTH(8)) dut (
        .clk         (clk),
        .reset_n     (itf_input.reset_n),
        .rx          (itf_input.rx),
        .p_addr      (itf_input.p_addr),
        .p_write     (itf_input.p_write),
        .p_enable    (itf_input.p_enable),
        .p_sel_uart  (itf_input.p_sel_uart),
        .p_data_uart (itf_input.p_data_uart)
    );

    initial begin
        $display("============================================");
        $display("   UART RX    ");
        $display("============================================");
        env1 = new(itf_input);
        env1.build();
        env1.run_reset();
        repeat (1) begin
            $display(" Test time: %0d ", i);
            env1.run();
            i++;
        end
        // repeat (1) begin
        //     $display(" Test time: %0d ", i);
        //     env1.run_reset_mid();
        //     i++;
        // end
        env1.scb1.report();
        $finish;
    end

endmodule
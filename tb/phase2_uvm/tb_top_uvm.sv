module top;
    logic clk;

    initial clk = 1'b0;
    always #5 clk = ~clk; // 100MHz

    uart_if itf(.clk(clk));

    uart_rx #(.WIDTH(8)) dut (
        .clk         (clk),
        .reset_n     (itf.reset_n),
        .rx          (itf.rx),
        .p_addr      (itf.p_addr),
        .p_write     (itf.p_write),
        .p_enable    (itf.p_enable),
        .p_sel_uart  (itf.p_sel_uart),
        .p_data_uart (itf.p_data_uart)
    );

    initial begin
        uvm_config_db #(virtual uart_if)::set(uvm_root::get(), "*", "vif", itf);
        $dumpfile("uart_rx_uvm.vcd");
        $dumpvars(0, top);
    end

    initial begin
        run_test("base_test");
    end
endmodule

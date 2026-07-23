
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"


module tb_top;

    bit clk;
    
    always #5ns clk = ~clk;

    initial begin
        clk = 0;
    end

    
    // KHỞI TẠO CÁC INTERFACE
    
    uart_itf  uart_vif  (.clk(clk));
    apb_itf   apb_vif   (.clk(clk));
    reset_itf reset_vif (.clk(clk));

  
    uart_rx dut (
        .clk       (clk),
        .reset_n    (reset_vif.reset_n), 
        
        // APB Interface
        
        .p_addr      (apb_vif.p_addr),
        .p_sel_uart     (apb_vif.p_sel_uart),
        .p_enable    (apb_vif.p_enable),
        .p_write     (apb_vif.p_write),
        .p_data_uart  (apb_vif.p_data_uart),
        // UART Interface
        
        .rx         (uart_vif.rx)
    );


    initial begin
    
        uvm_config_db#(virtual uart_itf)::set(null, "*", "vif_uart", uart_vif);
        uvm_config_db#(virtual apb_itf)::set(null, "*", "vif_apb", apb_vif);
        uvm_config_db#(virtual reset_itf)::set(null, "*", "vif_reset", reset_vif);

        run_test("base_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_top);
    end

endmodule
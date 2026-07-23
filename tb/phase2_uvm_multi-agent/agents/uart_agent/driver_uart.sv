class driver_uart extends uvm_driver #(uart_item);
    `uvm_component_utils(driver_uart)
    virtual uart_itf rx_itf;

   function new(string name = "driver_uart", uvm_component parent = null);
        super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // Sửa "rx_itf" thành "vif_uart"
            if(!uvm_config_db #(virtual uart_itf)::get(this, "","vif_uart", rx_itf)) begin
                `uvm_fatal(get_type_name(), "Not set at top lever")     
            end
   endfunction

   task send_uart (input logic start_bit, input logic [7:0] data_rx, input logic stop_bit);
        //start bit
        @(posedge rx_itf.clk); 
        rx_itf.rx <= start_bit;
        repeat(868) @(posedge rx_itf.clk);
        //gui data
        for(int i=0; i<8; i++)begin
            rx_itf.rx <= data_rx[i];
            repeat(868) @(posedge rx_itf.clk);
        end
        //stop_bit
        rx_itf.rx <= stop_bit;
        repeat(868) @(posedge rx_itf.clk);
   endtask

    task run_phase(uvm_phase phase);
        forever begin
        seq_item_port.get_next_item(req);   //uart_reg item swquence tao ra
            send_uart(req.start_bit, req.data_rx, req.stop_bit);
        seq_item_port.item_done();
        end
    endtask

endclass
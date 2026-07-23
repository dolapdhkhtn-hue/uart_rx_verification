class monitor_uart extends uvm_monitor;
    `uvm_component_utils(monitor_uart)

    virtual uart_itf rx_itf;
    
    uvm_analysis_port #(uart_item) monitor_uart_collect_port;

    function new(string name = "monitor_uart", uvm_component parent = null);
            super.new(name,parent);
            
    endfunction 

    function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_uart_collect_port = new("monitor_uart_collect_port",this);
            // Sửa "rx_itf" thành "vif_uart"
            if(!uvm_config_db #(virtual uart_itf)::get(this, "","vif_uart", rx_itf))begin
               `uvm_fatal(get_type_name(),"Not set at top lever")
            end
    endfunction

    task run_phase(uvm_phase phase);
        uart_item monitor_item;
        forever begin
            
            monitor_item = uart_item::type_id::create("monitor_item");
            @(negedge rx_itf.rx);
            @(posedge rx_itf.clk);
            repeat(868 + 434) @(posedge rx_itf.clk);
            for (int i = 0; i<8; i++) begin
                monitor_item.data_rx[i] = rx_itf.rx;
                repeat(868) @(posedge rx_itf.clk );
            end

            monitor_uart_collect_port.write(monitor_item);
        end
    endtask
endclass
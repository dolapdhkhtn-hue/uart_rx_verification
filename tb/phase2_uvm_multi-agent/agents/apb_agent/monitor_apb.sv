class monitor_apb extends uvm_monitor;
    `uvm_component_utils(monitor_apb)
    virtual apb_itf apb_monitor_itf;
    uvm_analysis_port #(apb_item) monitor_apb_collect_port;
    

    function new (string name = "monitor_apb", uvm_component parent = null);
        super.new(name,parent);
        
    endfunction

    function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_apb_collect_port = new ("monitor_apb_collect_port", this);
            if(!uvm_config_db #(virtual apb_itf)::get(this,"","vif_apb", apb_monitor_itf)) begin
                `uvm_fatal(get_type_name(),"Not set at top level")
            end
    endfunction

    task run_phase(uvm_phase phase);
        apb_item monitor_item;
        forever begin
            
            monitor_item = apb_item::type_id::create("monitor_item");
            @(posedge apb_monitor_itf.clk iff apb_monitor_itf.p_enable == 1'b1);
            monitor_item.p_data_uart = apb_monitor_itf.p_data_uart;
            monitor_item.p_addr      = apb_monitor_itf.p_addr;
            
            monitor_apb_collect_port.write(monitor_item);
        end
    endtask
endclass
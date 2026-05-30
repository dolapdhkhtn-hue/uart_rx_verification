// ============================================================
// MONITOR
// ============================================================
class monitor extends uvm_monitor;
    virtual uart_if vif;
    uvm_analysis_port #(seq_item) item_collect_port;
    seq_item mon_item;

    `uvm_component_utils(monitor)

    function new(string name = "monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collect_port = new("item_collect_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("monitor build_phase");
        if (!uvm_config_db #(virtual uart_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "Not set at top level")
    endfunction

    task run_phase(uvm_phase phase);
        $display("monitor run_phase");
        forever begin
            mon_item = seq_item::type_id::create("mon_item");

            // Chờ APB read done_flag_before (addr=0x00, trước khi gửi)
            @(posedge vif.clk iff (vif.p_sel_uart && vif.p_enable
                                    && !vif.p_write && vif.p_addr == 8'h00));
            mon_item.done_flag_before = vif.p_data_uart;

            // Chờ APB read done_flag_after (addr=0x00, sau khi nhận)
            @(posedge vif.clk iff (vif.p_sel_uart && vif.p_enable
                                    && !vif.p_write && vif.p_addr == 8'h00));
            mon_item.done_flag_after = vif.p_data_uart;

            // Chờ APB read RX_DATA (addr=0x04)
            @(posedge vif.clk iff (vif.p_sel_uart && vif.p_enable
                                    && !vif.p_write && vif.p_addr == 8'h04));
            mon_item.rx_data_read = vif.p_data_uart;

            // Chờ APB read done_flag_cleared (addr=0x00, sau khi clear)
            @(posedge vif.clk iff (vif.p_sel_uart && vif.p_enable
                                    && !vif.p_write && vif.p_addr == 8'h00));
            mon_item.done_flag_cleared = vif.p_data_uart;

            `uvm_info(get_type_name(),
                $sformatf("MON: flag_before=0x%02X flag_after=0x%02X rx_data=0x%02X flag_cleared=0x%02X",
                mon_item.done_flag_before, mon_item.done_flag_after,
                mon_item.rx_data_read,     mon_item.done_flag_cleared),
                UVM_LOW)

            item_collect_port.write(mon_item);
        end
    endtask
endclass
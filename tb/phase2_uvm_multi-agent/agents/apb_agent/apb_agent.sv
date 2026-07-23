class agent_apb extends uvm_agent;
    `uvm_component_utils(agent_apb)

    sequencer_apb seq_apb;
    driver_apb    drv_apb;
    monitor_apb  mon_apb;

    function new (string name = "agent_apb", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            if(get_is_active() == UVM_ACTIVE) begin
                seq_apb = sequencer_apb::type_id::create("seq_apb", this);
                drv_apb = driver_apb::type_id::create("drv_apb", this);
            end

            mon_apb = monitor_apb::tyoe_id::create("mon_apb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        if(get_is_active() == UVM_ACTIVE) begin
            drv_apb.seq_item_port.connect(seq_apb.seq_item_export);
        end
    endfunction
endclass